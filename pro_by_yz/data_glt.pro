pro data_glt,target_lon_data,target_lat_data,target_data,out_res,data_box_geo_out,geo_info_out,helpme=helpme
  if (keyword_set(helpme)) then begin
    print,'函数功能为通过地理查找表方式实现数据的重投影（经纬度格网）'
    print,'输入参数：'
    print,'target_lon_data：待重投影数据经度数组'
    print,'target_lat_data：待重投影数据纬度数组'
    print,'target_data：待重投影目标数据'
    print,'out_res：输出结果分辨率（°为单位）'
    print,'输出参数:'
    print,'data_box_geo_out：重投影后的影像数组'
    print,'geo_info_out：重投影后影像的geotiff结构体'
    return
  endif
  congrid_scale=5
  data_size=size(target_data)
  data_col=data_size[1]
  data_line=data_size[2]
  target_lon_data_interp=congrid(target_lon_data,data_col*congrid_scale,data_line*congrid_scale,/interp)
  target_lat_data_interp=congrid(target_lat_data,data_col*congrid_scale,data_line*congrid_scale,/interp)

  lon_min=min(target_lon_data)
  lon_max=max(target_lon_data)
  lat_min=min(target_lat_data)
  lat_max=max(target_lat_data)

  data_box_geo_col=ceil((lon_max-lon_min)/out_res)
  data_box_geo_line=ceil((lat_max-lat_min)/out_res)
  data_box_lon=fltarr(data_box_geo_col,data_box_geo_line)
  data_box_lat=fltarr(data_box_geo_col,data_box_geo_line)
  data_box_geo=fltarr(data_box_geo_col,data_box_geo_line)

  data_box_lon_col_pos=floor((target_lon_data_interp-lon_min)/out_res)
  data_box_lon_line_pos=floor((lat_max-target_lat_data_interp)/out_res)
  data_box_lon[data_box_lon_col_pos,data_box_lon_line_pos]=target_lon_data_interp

  data_box_lat_col_pos=floor((target_lon_data_interp-lon_min)/out_res)
  data_box_lat_line_pos=floor((lat_max-target_lat_data_interp)/out_res)
  data_box_lat[data_box_lon_col_pos,data_box_lon_line_pos]=target_lat_data_interp

  data_box_geo_col_pos=floor((target_lon_data-lon_min)/out_res)
  data_box_geo_line_pos=floor((lat_max-target_lat_data)/out_res)
  data_box_geo[data_box_geo_col_pos,data_box_geo_line_pos]=(target_data gt 0.0)*target_data+(target_data le 0.0)*(-9999.0)

  data_box_geo_out=fltarr(data_box_geo_col,data_box_geo_line)
  window_size=9
  jump_size=(window_size-1)/2
  for data_box_geo_line_i=jump_size,data_box_geo_line-jump_size-1 do begin
    for data_box_geo_col_i=jump_size,data_box_geo_col-jump_size-1 do begin
      if data_box_geo[data_box_geo_col_i,data_box_geo_line_i] eq 0.0 then begin
        distance=sqrt((data_box_lon[data_box_geo_col_i,data_box_geo_line_i]-data_box_lon[(data_box_geo_col_i-jump_size):(data_box_geo_col_i+jump_size),(data_box_geo_line_i-jump_size):(data_box_geo_line_i+jump_size)])^2+$
          (data_box_lat[data_box_geo_col_i,data_box_geo_line_i]-data_box_lat[(data_box_geo_col_i-jump_size):(data_box_geo_col_i+jump_size),(data_box_geo_line_i-jump_size):(data_box_geo_line_i+jump_size)])^2)
        distance_sort_pos=sort(distance)
        data_box_geo_window=data_box_geo[(data_box_geo_col_i-jump_size):(data_box_geo_col_i+jump_size),(data_box_geo_line_i-jump_size):(data_box_geo_line_i+jump_size)]
        data_box_geo_sort=data_box_geo_window[distance_sort_pos]
        fill_pos=where(data_box_geo_sort ne 0.0)
        fill_value=data_box_geo_sort[fill_pos[0]]
        data_box_geo_out[data_box_geo_col_i,data_box_geo_line_i]=fill_value
      endif else begin
        data_box_geo_out[data_box_geo_col_i,data_box_geo_line_i]=data_box_geo[data_box_geo_col_i,data_box_geo_line_i]
      endelse
    endfor
  endfor

  data_box_geo_out=abs((data_box_geo_out gt 0.0)*data_box_geo_out)

  geo_info_out={$
    MODELPIXELSCALETAG:[out_res,out_res,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,lon_min,lat_max,0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGANGULARUNITSGEOKEY:9102}
end