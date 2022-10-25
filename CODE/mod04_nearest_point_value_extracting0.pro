pro mod04_nearest_point_value_extracting0
  extract_lon=116.40
  extract_lat=39.90
  point_name='Beijing'
  data_path='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\'
  file_list=file_search(data_path,'*.hdf')
  file_n=n_elements(file_list)   
  out_file=data_path+'point_value_'+point_name+'.txt'
  openw,1,out_file;,width=80000每一行,/append

  for file_i=0,file_n-1 do begin
    modis_lon_data=hdf4_data_get(file_list[file_i],'Longitude')
    modis_lat_data=hdf4_data_get(file_list[file_i],'Latitude')
    modis_aod_data=hdf4_data_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    scale_factor=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    fill_value=hdf4_attdata_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean','_FillValue')            
    
    modis_aod_data=(modis_aod_data ne fill_value[0])*modis_aod_data*scale_factor[0]
    distance=sqrt((extract_lon-modis_lon_data)^2.0+(extract_lat-modis_lat_data)^2.0)
    dis_min=min(distance)
    min_pos=where(distance eq dis_min)

    
    out_date=strmid(file_basename(file_list[file_i]),10,7);年积日获取
    date=fix(strmid(file_basename(file_list[file_i]),14,3))
    out_year_fix=fix(strmid(file_basename(file_list[file_i]),10,4))
    date_julian=imsl_datetodays(31,12,out_year_fix-1)
    imsl_daystodate,date_julian+date,day,month,year
    
    
    if modis_aod_data[min_pos[0]] eq 0.0 then continue
    print,year,month,day,modis_lon_data[min_pos[0]],modis_lat_data[min_pos[0]],modis_aod_data[min_pos[0]],format='(I0,"-",I02,"-",I02,",",3(F0.3,:,","))'
    printf,1,year,month,day,modis_lon_data[min_pos[0]],modis_lat_data[min_pos[0]],modis_aod_data[min_pos[0]],format='(I0,"-",I02,"-",I02,",",3(F0.3,:,","))'
  endfor
  free_lun,1
end