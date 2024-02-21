function hdf4_data_get,file_name,sds_name
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  hdf_sd_getdata,sds_id,data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,data
end

function hdf4_attdata_get,file_name,sds_name,att_name
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  att_index=hdf_sd_attrfind(sds_id,att_name)
  hdf_sd_attrinfo,sds_id,att_index,data=att_data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,att_data
end

function doytodate,doystr
  doy=fix(strmid(doystr,4,3))
  year=fix(strmid(doystr,0,4))
  date_julian=imsl_datetodays(31,12,year-1) 
  imsl_daystodate,date_julian+doy,out_day,out_month,out_year
  date=string(out_year,format='(I04)')+string(out_month,format='(I02)')+string(out_day,format='(I02)')
  return,date
end

pro data_glt,target_lon_data,target_lat_data,target_data,out_res,data_box_geo_out,geo_info_out
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

pro geotiff_file_average,geotiff_filelist,averaged_data,averaged_geoinfo
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

pro mod04_batch
  file_list=file_search('R:\IDL\resource\mcd04\','*.hdf',count=file_n)
  ;print,file_list
  out_dir='R:\IDL\resource\mcd04\geo\'
  if ~file_test(out_dir,/directory) then file_mkdir,out_dir
  for file_i=0,file_n-1 do begin
    input_file=file_list[file_i]
    print,input_file
    res=0.1
    out_name=out_dir+strmid(file_basename(file_list[file_i]),10,12)+'.tiff'
    data=hdf4_data_get(input_file,'Optical_Depth_Land_And_Ocean')
    lon=hdf4_data_get(input_file,'Longitude')
    lat=hdf4_data_get(input_file,'Latitude')
    data=(data gt 0)*data*0.001
    data_glt,lon,lat,data,res,out_data,out_geoinfo
    write_tiff,out_name,out_data,/float,geotiff=out_geoinfo
  endfor
  file_list_all=file_search(out_dir,'*.tiff')
  geotiff_file_average,file_list_all,avr_data,avr_geoinfo
  write_tiff,'R:\IDL\resource\mcd04\avr.tiff',avr_data,geotiff=avr_geoinfo,/float
  doy_all=strmid(file_basename(file_list_all),0,7)
  doy_uniq=doy_all.uniq()
  for doy_i=0,n_elements(doy_uniq)-1 do begin
    search_str=doy_uniq[doy_i]+'*.tiff'
    file_list_temp=file_search(out_dir,search_str)
    print,doy_uniq[doy_i]
    ;print,file_list_temp
    geotiff_file_average,file_list_temp,avr_data,avr_geoinfo
    date=doytodate(doy_uniq[doy_i])
    out_name='R:\IDL\resource\mcd04\'+date+'.tiff'
    write_tiff,out_name,avr_data,/float,geotiff=avr_geoinfo
  endfor
end