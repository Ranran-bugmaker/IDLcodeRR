pro cor
  extract_lon=116.40
  extract_lat=39.90
  mod_4dir="R:\IDL\resource\MYD04_Aeronet_Compare\"
  lev="R:\IDL\resource\20180101_20181231_Beijing.lev20"
  cord=READ_CSV(lev,N_TABLE_HEADER=6,HEADER=var_name)
;  doy_pos=;
;  aod_pos=
;  aepos=;
  ccordoy_d=cord.doy_pos
  
  mod4list=FILE_SEARCH(mod_4dir+'*.hdf',COUNT=fn)
  for index = 0L, fn-1 do begin
    aod_d=hdf4_data_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean')
    aod_sf=hdf4_attdata_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    fill_value=hdf4_attdata_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean','_FillValue')
    aod_conv=FLOAT(aod_d)*aod_sf[0]
    modis_lon_data=hdf4_data_get(mod4list[index],'Longitude')
    modis_lat_data=hdf4_data_get(mod4list[index],'Latitude')
    aod_d=(aod_d ne fill_value[0])*aod_d*scale_factor[0]
    distance=sqrt((extract_lon-modis_lon_data)^2.0+(extract_lat-modis_lat_data)^2.0)
    dis_min=min(distance)
    min_pos=where(distance eq dis_min)
  endfor


end