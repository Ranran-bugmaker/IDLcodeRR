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
;PRO locateDN_HJ,latitude,longtude
;  ;
;  ;LOAD FUNCTIONS' MODULES OF ENVI
;  COMPILE_OPT IDL2
;  ENVI,/RESTORE_BASE_SAVE_FILES
;  ENVI_BATCH_INIT
;
;  ;define the path
;  imagePath = 'E:\temp\HJ1B-CCD1-451-76-20130926-L20001058628-1.TIF'
;  ;open HJ image
;
;  ENVI_OPEN_FILE,imagePath,r_fid = fid
;  ENVI_FILE_QUERY, fid, dims=dims;some parameters will be used to get data
;  ;get the projection information
;
;  image_proj = ENVI_GET_PROJECTION(fid = fid)
;  ;create a geographic projection, can express the latitude and longtitude
;
;  geo_proj = ENVI_PROJ_CREATE(/geo)
;  ;convert input lat and long to coordinate under image projection
;  ;NOTED:In the WGS-84, X is longtude, Y is latitude.
;  ENVI_CONVERT_PROJECTION_COORDINATES,longtude,latitude,geo_proj,image_x,image_y,image_proj
;  ;read metadata from image
;  mapinfo=ENVI_GET_MAP_INFO(fid=fid)
;
;  ;help,mapinfo;query the mapinfo structure, understand the MC is corner coordinate,PS is pixel Size
;  ;  print,mapinfo.MC
;  ;  print,mapinfo.PS
;  ;
;  ;Geolocation of UpperLeft
;  ;
;  ULlat=mapinfo.MC(3);Y is latitude
;  ULlon=mapinfo.MC(2);X is longtude
;
;  ;2. Pixel Size
;  Xsize=mapinfo.PS(0)
;  Ysize=mapinfo.PS(1)
;  ;calculate the row and column according to x,y
;  sample = FIX(ABS((image_x- ULlon)/Xsize));abs is determin the positive value, fix is get integer number
;  line = FIX(ABS((image_y - ULlat)/Ysize))
;  ;print,thisRow,thisColumn
;  ;get data via row and column
;  DN_data= ENVI_GET_DATA(fid = fid,dims = dims,pos = 0)
;  ;help,DN_data
;  ;get_data
;  dn = DN_data[sample,line]
;  ;write to file
;  PRINT,dn
;  ;Exit ENVI
;  ENVI_BATCH_EXIT
;END
;


url = 'https://www.example.com' ; 要请求的网址
httpclient = OBJ_NEW('IDLnetURL') ; 创建一个HTTP客户端对象
httpclient->SetProperty, URL_HOSTNAME="https://atmcorr.gsfc.nasa.gov/cgi-bin/atm_corr.pl"; 设置自动重定向到true
httpclient->Open, url ; 打开HTTP连接
httpclient->Send ; 发送HTTP请求
response = httpclient->GetResponse ; 获取HTTP响应对象
status = response->GetStatus ; 获取HTTP响应状态码
if status EQ 200 then begin ; 如果HTTP响应状态码为200，则表示请求成功
  body = response->GetBody ; 获取HTTP响应正文
  print, body ; 输出HTTP响应正文
endif



url = 'https://atmcorr.gsfc.nasa.gov/cgi-bin/atm_corr.pl?'  ; 要请求的网址

httpclient = OBJ_NEW('IDLnetURL')  ; 创建一个URL客户端对象

httpclient->Open, url  ; 打开URL连接

httpclient->Read, body  ; 获取URL响应正文

print, body  ; 输出URL响应正文



hostname="atmcorr.gsfc.nasa.gov"
hostpath="cgi-bin/atm_corr.pl"
paramas="year=2017&month=5&day=1&hour=3&minute=32&thelat=31.34961&thelong=103.3673&profile_option=2&stdatm_option=2&L57_option=8&altitude=&pressure=&temperature=&rel_humid=&user_email=mimitope%40126.com"


hostname="atmcorr.gsfc.nasa.gov"
hostpath="output/log.t2023.4.15.3.14.28.txt"

httpclient = OBJ_NEW('IDLnetURL')

httpclient->SetProperty, URL_HOSTNAME=hostname,URL_PATH=hostpath
ings = httpclient->Get(/STRING_ARRAY)
STRSPLIT(ings[16],':', /EXTRACT)


httpclient->SetProperty, URL_HOSTNAME=hostname,URL_PATH=hostpath,URL_QUERY=paramas
strings = httpclient->Get(/STRING_ARRAY)
data=STRSPLIT(strings[4],'>',/EXTRACT)
data=data[[WHERE(STRMATCH(data, '*.*', /FOLD_CASE) EQ 1)]]
datax=STREGEX(data,"[0-9]\.[0-9]*",/EXTRACT)
BAAT=float(datax[-3])
EBUR=float(datax[-2])
EBDR=float(datax[-1])

