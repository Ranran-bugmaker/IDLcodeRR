pro data_warp,target_data,lon_data,lat_data,out_res,fit_degree,control_point_percent,warped_image,warped_geo_info,helpme=helpme
  if (keyword_set(helpme)) then begin
    print,'函数功能为通过控制点方式实现数据的重投影（经纬度格网）'
    print,'输入参数：'
    print,'target_data：待重投影目标数据'
    print,'lon_data：待重投影数据经度（控制点）'
    print,'lat_data：待重投影数据纬度（控制点）'
    print,'out_res：输出结果分辨率（°为单位）'
    print,'fit_degree：重投影多项式系数'
    print,'control_point_percent：控制点使用百分比'
    print,'输出参数:'
    print,'warped_image：重投影后的影像数组'
    print,'warped_geo_info：重投影后影像的geotiff结构体'
    return
  endif
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