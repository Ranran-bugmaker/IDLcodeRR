pro geotiff_file_average,geotiff_filelist,averaged_data,averaged_geoinfo,helpme=helpme
  if (keyword_set(helpme)) then begin
    print,'函数功能为计算所有输入geotiff文件的均值，要求投影为经纬度格网'
    print,'输入参数：'
    print,'geotiff_filelist：待计算均值的geotiff文件名（含路径）数组'
    print,'输出参数:'
    print,'averaged_data：均值计算后的影像数组'
    print,'averaged_geoinfo：均值计算后的geotiff结构体'
    return
  endif
  ;输入参数：
  ;geotiff_filelist：待求均值的geotiff文件数组，要求所有文件空间分辨率一致
  ;输出参数：
  ;averaged_data：均值结果数组
  ;averaged_geoinfo：均值结果对应geotiff结构体
  file_n=n_elements(geotiff_filelist)
  lon_min=999.0
  lon_max=-999.0
  lat_min=999.0
  lat_max=-999.0
  for file_i=0,file_n-1 do begin
    data_temp=read_tiff(geotiff_filelist[file_i],geotiff=geo_info)
    res_tag=geo_info.(0)
    geo_tag=geo_info.(1)
    data_size=size(data_temp)
    lon_min_temp=geo_tag[3]
    lon_max_temp=geo_tag[3]+data_size[1]*res_tag[0]
    lat_max_temp=geo_tag[4]
    lat_min_temp=geo_tag[4]-data_size[2]*res_tag[1]

    if lon_min_temp lt lon_min then lon_min=lon_min_temp
    if lon_max_temp gt lon_max then lon_max=lon_max_temp
    if lat_min_temp lt lat_min then lat_min=lat_min_temp
    if lat_max_temp gt lat_max then lat_max=lat_max_temp
  endfor
  data_box_col=ceil((lon_max-lon_min)/res_tag[0])
  data_box_line=ceil((lat_max-lat_min)/res_tag[1])
  data_box_sum=fltarr(data_box_col,data_box_line)
  data_box_num=fltarr(data_box_col,data_box_line)
  for file_i=0,file_n-1 do begin
    data_temp=read_tiff(geotiff_filelist[file_i],geotiff=geo_info)
    res_tag=geo_info.(0)
    geo_tag=geo_info.(1)
    data_size=size(data_temp)

    col_start=floor((geo_tag[3]-lon_min)/res_tag[0])
    line_start=floor((lat_max-geo_tag[4])/res_tag[1])
    col_end=col_start+data_size[1]-1
    line_end=line_start+data_size[2]-1
    data_box_sum[col_start:col_end,line_start:line_end]+=data_temp
    data_box_num[col_start:col_end,line_start:line_end]+=(data_temp gt 0.0)
  endfor
  data_box_num=(data_box_num gt 0)*data_box_num+(data_box_num eq 0)*1.0
  averaged_data=data_box_sum/data_box_num

  averaged_geoinfo={$
    MODELPIXELSCALETAG:[res_tag[0],res_tag[1],0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,lon_min,lat_max,0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}
end