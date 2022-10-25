pro DIY_data_warp,target_data,lon_data,lat_data,DPI,fit_degree,control_point_percent,warped_image,warped_geo_info
  ;输入参数：
  ;target_data：待重投影目标数据
  ;lon_data：待重投影数据经度数据集（控制点）
  ;lat_data：待重投影数据纬度数据集（控制点）
  ;DPI：输出结果分辨率（°为单位）
  ;fit_degree：重投影多项式系数
  ;control_point_percent：控制点使用百分比
  ;输出参数:
  ;warped_image：重投影后的影像数组
  ;warped_geo_info：重投影后影像的geotiff结构体
;  lon_data=(lon_data GT 0)*lon_data

  data_size=size(target_data)
  col_ori=intarr(data_size[1],data_size[2])
  line_ori=intarr(data_size[1],data_size[2])
  for col_i=0,data_size[1]-1 do col_ori[col_i,*]=col_i
  for line_i=0,data_size[2]-1 do line_ori[*,line_i]=line_i

  out_col_num=ceil((max(lon_data)-min(lon_data))/DPI)
  out_line_num=ceil((max(lat_data)-min(lat_data))/DPI)
  col_out=floor((lon_data-min(lon_data))/DPI)
  line_out=floor((max(lat_data)-lat_data)/DPI)

  control_point_num=control_point_percent*n_elements(target_data)
  selected_pos=findgen(control_point_num)/float(control_point_num)
  pixel_pos=floor(selected_pos*n_elements(target_data))
  
  polywarp,col_ori[pixel_pos],line_ori[pixel_pos],col_out[pixel_pos],line_out[pixel_pos],fit_degree,coe_x,coe_y
  warped_image=poly_2d(target_data,coe_x,coe_y,0,out_col_num,out_line_num,missing=0.0)

  warped_geo_info={$
    MODELPIXELSCALETAG:[DPI,DPI,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,min(lon_data),max(lat_data),0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}
end