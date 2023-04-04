;pro Drafts
;  RESTORE,'R:\PROject_practice\DATA_2csv\datav.sav'
;  RESTORE,'R:\PROject_practice\DATA_2csv\yandm.sav'
;  names=["小麦","水体","建筑"]
;  bandnames=["Gamma0_VH","Gamma0_VV","Sigma0_VH","Sigma0_VV","Gamma_diff","Gamma_ratio"]
;  csv_path='R:\PROject_practice\DATA_2csv\'
;  
;  timesnames=''
;  for fis = 0L, N_ELEMENTS(s)-1 do timesnames+=s[fis]+','
;  
;  
;  for shpi = 0L, 2L do begin
;    for bandi = 0L, 5L do begin
;      OPENw,lun,csv_path+names[shpi]+'-'+bandnames[bandi]+'.csv',/GET_LUN
;      FREE_LUN,lun
;      OPENw,lun,csv_path+names[shpi]+'-'+bandnames[bandi]+'.csv',/GET_LUN,/APPEND
;      fistline=bandnames[bandi]+','+timesnames
;      PRINTF,lun,fistline
;      for enti = 0L, N_ELEMENTS(datav[shpi,*,0,bandi])-1 do begin
;        sss=string(enti+1,FORMAT='(F0.5)')+','
;        for ti = 0L, N_ELEMENTS(datav[shpi,enti,*,bandi])-1 do begin
;          sss+=string(datav[shpi,enti,ti,bandi],FORMAT='(F0.5)')+','
;        endfor
;      PRINTF,lun,sss
;      endfor
;      FREE_LUN,lun
;    endfor
;  endfor
;  print,"over"
;end
;
PRO locateDN_HJ,latitude,longtude
  ;
  ;LOAD FUNCTIONS' MODULES OF ENVI
  COMPILE_OPT IDL2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT

  ;define the path
  imagePath = 'E:\temp\HJ1B-CCD1-451-76-20130926-L20001058628-1.TIF'
  ;open HJ image

  ENVI_OPEN_FILE,imagePath,r_fid = fid
  ENVI_FILE_QUERY, fid, dims=dims;some parameters will be used to get data
  ;get the projection information

  image_proj = ENVI_GET_PROJECTION(fid = fid)
  ;create a geographic projection, can express the latitude and longtitude

  geo_proj = ENVI_PROJ_CREATE(/geo)
  ;convert input lat and long to coordinate under image projection
  ;NOTED:In the WGS-84, X is longtude, Y is latitude.
  ENVI_CONVERT_PROJECTION_COORDINATES,longtude,latitude,geo_proj,image_x,image_y,image_proj
  ;read metadata from image
  mapinfo=ENVI_GET_MAP_INFO(fid=fid)

  ;help,mapinfo;query the mapinfo structure, understand the MC is corner coordinate,PS is pixel Size
  ;  print,mapinfo.MC
  ;  print,mapinfo.PS
  ;
  ;Geolocation of UpperLeft
  ;
  ULlat=mapinfo.MC(3);Y is latitude
  ULlon=mapinfo.MC(2);X is longtude

  ;2. Pixel Size
  Xsize=mapinfo.PS(0)
  Ysize=mapinfo.PS(1)
  ;calculate the row and column according to x,y
  sample = FIX(ABS((image_x- ULlon)/Xsize));abs is determin the positive value, fix is get integer number
  line = FIX(ABS((image_y - ULlat)/Ysize))
  ;print,thisRow,thisColumn
  ;get data via row and column
  DN_data= ENVI_GET_DATA(fid = fid,dims = dims,pos = 0)
  ;help,DN_data
  ;get_data
  dn = DN_data[sample,line]
  ;write to file
  PRINT,dn
  ;Exit ENVI
  ENVI_BATCH_EXIT
END