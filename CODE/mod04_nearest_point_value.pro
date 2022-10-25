pro mod04_nearest_point_value_extracting
  extract_lon=116.40
  extract_lat=39.90
  point_name='Beijing'
  data_path='O:/coarse_data/chapter_3/modis_swath/'
  file_list=file_search(data_path,'*.hdf')
  file_n=n_elements(file_list)   
  out_file=data_path+'point_value_'+point_name+'.txt'
  openw,1,out_file;,width=80000,/append

  for file_i=0,file_n-1 do begin
    modis_lon_data=hdf4_data_get(file_list[file_i],'Longitude')
    modis_lat_data=hdf4_data_get(file_list[file_i],'Latitude')
    modis_aod_data=hdf4_data_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    scale_factor=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    fill_value=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','_FillValue')
  endfor
  free_lun,1
end