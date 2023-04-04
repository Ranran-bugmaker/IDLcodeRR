pro geotiff_file_average,geotiff_filelist,averaged_data,averaged_geoinfo
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

pro modis_geotiff_interval_average
  input_directory='R:/modis/modis_chengdu/mod04_3k/geo_out/mosaic/'
  output_directory='R:/modis/modis_chengdu/mod04_3k/geo_out/mosaic/inverval_average/'
  start_date=20150530
  end_date=20160630
  if ~file_test(input_directory,/directory) then begin
    print,'输入路径不存在！'
    return
  endif
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory

  file_list=file_search(input_directory,'*.tif',count=file_n_all)
  if file_n_all eq 0 then begin
    print,'输入路径下无指定后缀的文件！'
    return
  endif
  file_date=fix(strmid(file_basename(file_list),0,8),type=3)
  file_pos=where((file_date ge start_date) and (file_date le end_date),file_n)
  if file_n eq 0 then begin
    print,'输入路径下无指定时间段的文件！'
    return
  endif
  out_name=strmid(file_basename(file_list[file_pos[0]]),0,8)+'-'+strmid(file_basename(file_list[file_pos[file_n-1]]),0,8)+'_average.tiff'
  geotiff_file_average,file_list[file_pos],avr_data,avr_geoinfo
  write_tiff,output_directory+out_name,avr_data,/float,geotiff=avr_geoinfo
end