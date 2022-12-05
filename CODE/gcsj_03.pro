pro gcsj_03
  GVH=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma0_VH*.tif')
  GVV=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma0_VV*.tif')
  SVH=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Sigma0_VH*.tif')
  SVV=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Sigma0_VV*.tif')
  G_diff=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma_d*.tif')
  G_ratio=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma_r*.tif')
  all=[[gvh],[gvv],[svh],[svv],[G_diff],[G_ratio]]
  path_xm_pt='R:\PROject_practice\DATA_SHPorETC\ROI\xiaomai_merge.shp'
  path_water_pt='R:\PROject_practice\DATA_SHPorETC\ROI\shuiti.shp'
  path_bulid_pt='R:\PROject_practice\DATA_SHPorETC\ROI\building_point.shp'
  shp=[path_xm_pt,path_water_pt,path_bulid_pt]
  names=['xm','water','bulid']
  
  csv_path='R:\PROject_practice\DATA_2csv\'
  
  bandnames='time,'
  for fis = 0L, 5L do begin
    tmp=STRSPLIT(FILE_BASENAME(all[0,fis],'.tif'),'-',/EXTRACT)
    bandnames+=tmp[0]+','
  ENDFOR
  bandnamesave=bandnames
  oshpA=OBJ_NEW('IDLffShape',shp[0])
  oshpa->getproperty,n_entities=n_enta
  datav_a=FLTARR(n_enta,N_ELEMENTS(all[*,0]),6)
  oshpb=OBJ_NEW('IDLffShape',shp[1])
  oshpb->getproperty,n_entities=n_entb
  datav_b=FLTARR(n_entb,N_ELEMENTS(all[*,0]),6)
  oshpc=OBJ_NEW('IDLffShape',shp[2])
  oshpc->getproperty,n_entities=n_entc
  datav_c=FLTARR(n_entc,N_ELEMENTS(all[*,0]),6)
  oshp=[oshpa,oshpb,oshpc]
  entall=[n_enta,n_entb,n_entc]
  dataV=LIST(datav_a,datav_b,datav_c)
  
  
  
;  datav=data.ToArray()
;  data=!NULL
;  stra=STRSPLIT(FILE_BASENAME(all[fi,0],'.tif'),'-',/EXTRACT)
;  for si = 0L, 2L do begin
;    oshp=OBJ_NEW('IDLffShape',shp[si])
;    oshp->getproperty,n_entities=n_ent,Attribute_info=attr_info,n_attributes=n_attr,Entity_type=ent_type
;    datav=FLTARR(n_ent,N_ELEMENTS(all[*,0]),6)
;    
;    




;  for fi = 0L, N_ELEMENTS(all[*,0])-1 do begin
;    for fis = 0L, N_ELEMENTS(all[fi,*])-1 do begin
;      start_time=systime(1)
;      data=READ_TIFF(all[fi,fis],GEOTIFF=geo)
;      end_time=systime(1)
;      for si = 0L, 2L do begin
;        for ei = 0L, entall[si]-1 do begin
;          ent=oshp[si]->getEntity(ei)
;          pt_lon=ent.BOUNDS[0]
;          pt_lat=ent.BOUNDS[1]
;          unit_lon=geo.MODELPIXELSCALETAG[0]
;          unit_lat=geo.MODELPIXELSCALETAG[1]
;          min_lon=geo.MODELTIEPOINTTAG[3]
;          max_lat=geo.MODELTIEPOINTTAG[4]
;          path_lon=FLOOR((pt_lon-min_lon)/unit_lon)
;          path_lat=FLOOR((max_lat-pt_lat)/unit_lat)
;          value=data[path_lon,path_lat]
;          datav[si,ei,fi,fis]=value
;          ;PRINT,names[si]+'   '+all[fi,fis]+'   '+string(ei+1,FORMAT='(I04)')+'   '+$
;            ;string(path_lon,FORMAT='(I06)')+'    '+string(path_lat,FORMAT='(I06)')
;          ;sss+=string(value,FORMAT='(F0.5)')+','
;        endfor
;      endfor
;      print,'read_cost:'+strcompress(string(end_time-start_time))+' s.'
;    endfor
;  endfor





  RESTORE,'R:\PROject_practice\DATA_2csv\datav.sav'
;  save,datav,FILENAME='R:\PROject_practice\DATA_2csv\datav.sav'
  for si = 0L, 2L do begin
    OPENw,lun,csv_path+names[si]+'.csv',/GET_LUN,/APPEND
    for enti = 0L, entall[si]-1 do begin
;      OPENW,lun,csv_path+names[si]+'-'+string(enti+1,FORMAT='(I04)')+'.csv',/GET_LUN
      bandnames=bandnamesave
      ent=oshp[si]->getEntity(enti)
      bandnames+=string(ent.BOUNDS[0],FORMAT='(F0.4)')+','+string(ent.BOUNDS[1],FORMAT='(F0.4)')
      PRINTF,lun,bandnames
      for fi = 0L, N_ELEMENTS(all[*,0])-1 do begin
        stra=STRSPLIT(FILE_BASENAME(all[fi,0],'.tif'),'-',/EXTRACT)
        sss=stra[1]+','
        for dti = 0L, N_ELEMENTS(all[fi,*])-1 do begin
          sss+=string(datav[si,enti,fi,dti],FORMAT='(F0.5)')+','
        endfor
        PRINTF,lun,sss
      endfor
;      FREE_LUN,lun
    endfor
    FREE_LUN,lun
  endfor


;  endfor
;sss+=string(13B)
;PRINTF,lun,bandnames
;PRINTF,lun,sss
;FREE_LUN,lun
;sss=''
;  OBJ_DESTROY,oshp ;销毁一个shape对象
  for si = 0L, 2L do begin
    OBJ_DESTROY,oshp[si]
  endfor

;  OBJ_DESTROY,oshp ;销毁一个shape对象
  print,'---end----'
end