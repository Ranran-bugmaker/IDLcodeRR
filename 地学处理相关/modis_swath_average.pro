pro modis_swath_average
  input_directory='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\warp_out\'
  output_directory=input_directory+"res\"
  file_list=file_search(input_directory,'*.tiff')
  output_name=output_directory+'2018_jan_avr.tiff'
  DIY_joint,file_list,data_box_geo_avr,geoinfo
  write_tiff,output_name+".tif",data_box_geo_avr,geotiff=geo_info,/float
end