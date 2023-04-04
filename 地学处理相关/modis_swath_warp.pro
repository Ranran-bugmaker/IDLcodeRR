pro modis_swath_warp
  input_directory='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\'
  output_directory='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\warp_out\'
  out='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\avr\'
  if ~file_test(out,/directory) then file_mkdir,out
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory
  out_res=0.03;分辨率
  degree=3
  search=[110.0,35.0]
  step=[10.0,10.0]
  file_list=file_search(input_directory+'*.hdf',count=file_n)

  
   start_time=systime(1)
   for file_i=0,file_n-1 do begin
    modis_lon=hdf4_data_get(file_list[file_i],'Longitude')
    modis_lat=hdf4_data_get(file_list[file_i],'Latitude')
    modis_aod=hdf4_data_get(file_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    modis_aod=(modis_aod gt 0)*modis_aod*0.001
    
    DIY_data_warp,modis_aod,modis_lon,modis_lat,out_res,5,0.01,result_image,geo_info
    write_tiff,output_directory+file_basename(file_list[file_i]$
      ,'.hdf')+'.tiff',result_image,/float,geotiff=geo_info
   endfor
   file_l=file_search(output_directory,'*.tiff')
   pingjie,out,file_l,"liuuu"
    end_time=systime(1)
    print,'Time consumption: '+string(end_time-start_time,format='(F0.4," s.")')
  
end