pro cor
;  extract_lon=116.40
;  extract_lat=39.90
;  mod_4dir="R:\IDL\resource\MYD04_Aeronet_Compare\"
;  lev="R:\IDL\resource\20180101_20181231_Beijing.lev20"
;  cord=READ_CSV(lev,N_TABLE_HEADER=6,HEADER=var_name)
;;  doy_pos=;
;;  aod_pos=
;;  aepos=;
;  ccordoy_d=cord.doy_pos
;  
;  mod4list=FILE_SEARCH(mod_4dir+'*.hdf',COUNT=fn)
;  for index = 0L, fn-1 do begin
;    aod_d=hdf4_data_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean')
;    aod_sf=hdf4_attdata_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
;    fill_value=hdf4_attdata_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean','_FillValue')
;    aod_conv=FLOAT(aod_d)*aod_sf[0]
;    modis_lon_data=hdf4_data_get(mod4list[index],'Longitude')
;    modis_lat_data=hdf4_data_get(mod4list[index],'Latitude')
;    aod_d=(aod_d ne fill_value[0])*aod_d*scale_factor[0]
;    distance=sqrt((extract_lon-modis_lon_data)^2.0+(extract_lat-modis_lat_data)^2.0)
;    dis_min=min(distance)
;    min_pos=where(distance eq dis_min)
;  endfor
  extract_lon=116.40
  extract_lat=39.90
  doyf_threshold=30.0/1440.0
  mod04_dir='R:\IDL\resource\MYD04_Aeronet_Compare\'
  aeronet_file= 'R:\IDL\resource\20180101_20181231_Beijing.lev20'
  aeronet_data=read_csv(aeronet_file,n_table_header=6,header=var_name)
  doy_pos=where(var_name eq 'Day_of_Year(Fraction)')
  aod_pos=where(var_name eq 'AOD_500nm')
  ae_pos=where(var_name eq '500-870_Angstrom_Exponent')
  aeronet_doyf_data=aeronet_data.(doy_pos)
  aeronet_aod_data=aeronet_data.(aod_pos)
  aeronet_ae_data=aeronet_data.(ae_pos)
  gr_res=list()
  sr_res=list()
  
  
  
  mod04_list=file_search(mod04_dir+'*.hdf',count=file_n)
  for file_i=0,file_n-1 do begin
    modis_doy=float(strmid(file_basename(mod04_list[file_i]),14,3))
    modis_fraction=(float(strmid(file_basename(mod04_list[file_i]),18,2))*60.0+$
      float(strmid(file_basename(mod04_list[file_i]),20,2)))/1440.0
    modis_doyf=modis_doy+modis_fraction
    doyf_dif=abs(modis_doyf-aeronet_doyf_data)
    doyf_pos=where(doyf_dif le doyf_threshold,pos_n)
    if pos_n le 1 then continue
    aeornet_aod_mean=mean(aeronet_aod_data[doyf_pos])
    aod_data=hdf4_data_get(mod04_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    aod_sf=hdf4_attdata_get(mod04_list[file_i],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    aod_data_conv=float(aod_data)*aod_sf[0]
    lon_data=hdf4_data_get(mod04_list[file_i],'Longitude')
    lat_data=hdf4_data_get(mod04_list[file_i],'Latitude')
    distance=sqrt((lon_data-extract_lon)^2.0+(lat_data-extract_lat)^2.0)
    pos=where(distance eq min(distance))
    target_aod=aod_data_conv[pos[0]]
    if (distance[pos[0]] le 0.1) and (target_aod gt 0.0) then begin
      print,aeornet_aod_mean,target_aod
      gr_res.add,aeornet_aod_mean
      sr_res.add,target_aod
    endif
  endfor
  x=gr_res.toarray()
  y=sr_res.toarray()
  r=CORRELATE(x,y)
  
  
  myplot=SCATTERPLOT(x,y,XRANGE=[0,1.5],YRANGE=[0,1.5],SYMBOL=23,SYM_SIZE=2$
    ,SYM_FILL_COLOR='CORAL',SYM_FILLED=1,TITLE='biubiubibu',$
    xtitle='AERONET AOD(550nm)',ytitle='Satellite AOD(550nm)',DIMENSIONS=[800,800],$
    name='point'+STRTRIM(STRING(N_ELEMENTS(x)),2)+STRING(r,FORMAT='(f0.3)'))
  a=[0,2]
  myline=plot(a,a,/overplot,thick=3)
  err11=plot(a,a+0.05+0.15*a,/overplot,thick=3,linestyle=2,color='red',name='error line')
  err11=plot(a,a-0.05-0.15*a,/overplot,thick=3,linestyle=2,color='red',font_name='times',font_size=18)
  lg=LEGEND(TARGET=[myline,myplot,err11],POSITION=[0.88940103,0.26660938])
;  myplot.Save,"R:\IDL\resource\MYD04_Aeronet_Compare\mm.png",/BORDER
;  myplot.Close
  PRINT,r
end