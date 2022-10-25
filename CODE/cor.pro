pro cor
  
  mod_4dir="R:\IDL\resource\MYD04_Aeronet_Compare\"
  lev="R:\IDL\resource\20180101_20181231_Beijing.lev20"
  READ_CSV(lev,N_TABLE_HEADER=6)
  
  mod4list=FILE_SEARCH(mod_4dir+'*.hdf',COUNT=fn)
  for index = 0L, fn-1 do begin
    aod_d=hdf4_data_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean')
    aod_sf=hdf4_attdata_get(mod4list[index],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    aod_conv=FLOAT(aod_d)*aod_sf[0]
    modis_lon_data=hdf4_data_get(file_list[file_i],'Longitude')
    modis_lat_data=hdf4_data_get(file_list[file_i],'Latitude')
  endfor

end