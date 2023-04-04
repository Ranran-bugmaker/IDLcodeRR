function hdf4_data_get,file_name,sds_name
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  hdf_sd_getdata,sds_id,data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,data
end

function modis_grid_geo_transform,modis_file,target_data
  ;输入参数：
  ;modis_file：待生成经纬度坐标的modis正弦投影文件名
  ;target_data：待做投影转换的目标数据
  ;返回值：文件每个像元的对应的经纬度坐标
  data_size=size(target_data)

  sd_id=hdf_sd_start(modis_file,/read)
  gindex=hdf_sd_attrfind(sd_id,'StructMetadata.0')
  hdf_sd_attrinfo,sd_id,gindex,data=metadata

  ul_start_pos=strpos(metadata,'UpperLeftPointMtrs')
  ul_end_pos=strpos(metadata,'LowerRightMtrs')
  ul_info=strmid(metadata,ul_start_pos,ul_end_pos-ul_start_pos)
  ul_info_spl=strsplit(ul_info,'=(,)',/extract)
  ul_prj_x=double(ul_info_spl[1])
  ul_prj_y=double(ul_info_spl[2])

  lr_start_pos=strpos(metadata,'LowerRightMtrs')
  lr_end_pos=strpos(metadata,'Projection')
  lr_info=strmid(metadata,lr_start_pos,lr_end_pos-lr_start_pos)
  lr_info_spl=strsplit(lr_info,'=(,)',/extract)
  lr_prj_x=double(lr_info_spl[1])
  lr_prj_y=double(lr_info_spl[2])

  sin_resolution=(lr_prj_x-ul_prj_x)/(data_size[1])
  proj_x=dblarr(data_size[1],data_size[2])
  proj_y=dblarr(data_size[1],data_size[2])
  for col_i=0,data_size[1]-1 do proj_x[col_i,*]=ul_prj_x+(sin_resolution*col_i)
  for line_i=0,data_size[2]-1 do proj_y[*,line_i]=ul_prj_y-(sin_resolution*line_i)

  sin_prj=map_proj_init('sinusoidal',/gctp,sphere_radius=6371007.181,center_longitude=0.0,false_easting=0.0,false_northing=0.0)
  geo_loc=map_proj_inverse(proj_x,proj_y,map_structure=sin_prj)
  return,geo_loc
end

pro data_warp,target_data,lon_data,lat_data,out_res,fit_degree,control_point_percent,warped_image,warped_geo_info
  ;输入参数：
  ;target_data：待重投影目标数据
  ;lon_data：待重投影数据经度（控制点）
  ;lat_data：待重投影数据纬度（控制点）
  ;out_res：输出结果分辨率（°为单位）
  ;fit_degree：重投影多项式系数
  ;control_point_percent：控制点使用百分比
  ;输出参数:
  ;warped_image：重投影后的影像数组
  ;warped_geo_info：重投影后影像的geotiff结构体
  data_size=size(target_data)
  col_ori=intarr(data_size[1],data_size[2])
  line_ori=intarr(data_size[1],data_size[2])
  for col_i=0,data_size[1]-1 do col_ori[col_i,*]=col_i
  for line_i=0,data_size[2]-1 do line_ori[*,line_i]=line_i

  out_col_num=ceil((max(lon_data)-min(lon_data))/out_res)
  out_line_num=ceil((max(lat_data)-min(lat_data))/out_res)
  col_out=floor((lon_data-min(lon_data))/out_res)
  line_out=floor((max(lat_data)-lat_data)/out_res)

  control_point_num=control_point_percent*n_elements(target_data)
  selected_pos=findgen(control_point_num)/float(control_point_num)
  pixel_pos=floor(selected_pos*n_elements(target_data))
  
  polywarp,col_ori[pixel_pos],line_ori[pixel_pos],col_out[pixel_pos],line_out[pixel_pos],fit_degree,coe_x,coe_y
  warped_image=poly_2d(target_data,coe_x,coe_y,0,out_col_num,out_line_num,missing=0.0)

  warped_geo_info={$
    MODELPIXELSCALETAG:[out_res,out_res,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,min(lon_data),max(lat_data),0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}
end

pro modis_grid_warp
  input_directory='A:\IDL\resource\MOD11B3\'
  output_directory='A:\IDL\resource\MOD11B3\warp_out\'
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory
  control_point_percent=0.1
  out_res=0.01
  degree=5
  file_list=file_search(input_directory+'*.hdf',count=file_n)
;  for file_i=0,file_n-1 do begin
;    start_time=systime(1)
;    print,file_list[file_i]
;    modis_lst_data=hdf4_data_get(file_list[file_i],"LST_Day_6km")
;    modis_lst_data=(modis_lst_data gt 0)*modis_lst_data*0.02
;    
;    modis_lon_lat_data=modis_grid_geo_transform(file_list[file_i],modis_lst_data)
;    modis_lon_data=modis_lon_lat_data[0,*]
;    modis_lat_data=modis_lon_lat_data[1,*]
;    
;    data_warp,modis_lst_data,modis_lon_data,modis_lat_data,out_res,degree,control_point_percent,result_image,geo_info
;
;    write_tiff,output_directory+file_basename(file_list[file_i],'.hdf')+'.tiff',result_image,/float,geotiff=geo_info
;    end_time=systime(1)
;    print,'Time consumption: '+string(end_time-start_time,format='(F0.4," s.")')
;  endfor
  file_list=file_search(output_directory+'*.*',count=file_n)
  geotiff_file_average,file_list,res,geoinfo0
  write_tiff,"A:\temp\0000"+'.tiff',res,/float,geotiff=geoinfo0
end