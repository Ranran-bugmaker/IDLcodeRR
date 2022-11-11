pro mod04_validation
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
  aeronet_aod_data=aeronet_aod_data*((500.0/550.0)^aeronet_ae_data)
  gr_result=list()
  st_result=list()
  
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
      gr_result.add,aeornet_aod_mean
      st_result.add,target_aod
    endif
  endfor
  x=gr_result.toarray()
  y=st_result.toarray()
  r=correlate(x,y)
  
  scplot=scatterplot(x,y,xrange=[0,2],yrange=[0,2],symbol='S',sym_size=2,sym_fill_color='DODGER BLUE',$
    sym_filled=1,xtitle='AERONET AOD (550 nm)',ytitle='Satellite AOD (550 nm)',dimension=[800,800],$
    name='N='+strtrim(string(n_elements(x)),2)+', r='+string(r,format='(F0.3)'))
  sdx=[0,2]
  sdy=[0,2]
  sdline=plot(sdx,sdy,/overplot,thick=3,name='1:1 line')
  ery1=sdx+0.05+0.15*sdx
  erline1=plot(sdx,ery1,/overplot,thick=3,linestyle=2,color='red',name='error line')
  ery2=sdx-0.05-0.15*sdx
  erline2=plot(sdx,ery2,/overplot,thick=3,linestyle=2,color='red',font_name='times',font_size=18)
  lg=legend(target=[scplot,sdline,erline1],/data,position=[1.7,0.7],font_name='times',font_size=18)
;  scplot.save,'O:\coarse_data\MYD04_Aeronet_Compare\validation.png',/border
;  scplot.close
end