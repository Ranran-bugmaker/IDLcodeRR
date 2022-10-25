function fy4a_cal,file_name,target_channel_name,cal_channel_name
  target_channel=h5_data_get(file_name,target_channel_name)
  cal_channel=h5_data_get(file_name,cal_channel_name)
  target_channel_size=size(target_channel)
  target_data=fltarr(target_channel_size[1],target_channel_size[2])
  for col_i=0,target_channel_size[1]-1 do begin
    for line_i=0,target_channel_size[2]-1 do begin
      if (target_channel[col_i,line_i] ge 0) and (target_channel[col_i,line_i] le 4095) then begin
        cal_data_line=target_channel[col_i,line_i]
        target_data[col_i,line_i]=cal_channel[cal_data_line]
      endif else begin
        target_data[col_i,line_i]=0.0
      endelse
    endfor
  endfor
  return,target_data
end



pro fy4a_calibration_warp
  start_time=systime(1)
  ;风四地理查找表文件下载地址：http://satellite.nsmc.org.cn/PortalSite/StaticContent/DocumentDownload.aspx?TypeID=3
  data_col=2748
  data_line=2748
  georaw_file='O:/coarse_data/chapter_4/FullMask_Grid_4000.raw'
  openr,1,georaw_file
  georaw_data=dblarr(2,data_col,data_line)
  readu,1,georaw_data
  free_lun,1
  fy4a_lon_data=reform(georaw_data[1,*,*])
  fy4a_lat_data=reform(georaw_data[0,*,*])
  
  resolution=0.04
  degree=5
  cp_percent=0.1
  fy4a_file='O:/coarse_data/chapter_4/FY4A-_AGRI--_N_DISK_1047E_L1-_FDI-_MULT_NOM_20190921070000_20190921071459_4000M_V0001.HDF'
  result_name='O:/coarse_data/chapter_4/FY4A_20190921070000_geo.tiff'

  pos=where((fy4a_lon_data ge 97.0) and (fy4a_lon_data le 109.0) and (fy4a_lat_data ge 26.0) and (fy4a_lat_data le 35.0),count)
  if count eq 0 then return
  pos_col=pos mod data_col
  pos_line=pos/data_col
  col_min=min(pos_col)
  col_max=max(pos_col)
  line_min=min(pos_line)
  line_max=max(pos_line)
  
  band3=fy4a_cal(fy4a_file,'NOMChannel03','CALChannel03')
  band2=fy4a_cal(fy4a_file,'NOMChannel02','CALChannel02')
  band1=fy4a_cal(fy4a_file,'NOMChannel01','CALChannel01')
  
  data_warp,band3[col_min:col_max,line_min:line_max],fy4a_lon_data[col_min:col_max,line_min:line_max],fy4a_lat_data[col_min:col_max,line_min:line_max],$
    resolution,degree,cp_percent,warped_band3,geo_info
  data_warp,band2[col_min:col_max,line_min:line_max],fy4a_lon_data[col_min:col_max,line_min:line_max],fy4a_lat_data[col_min:col_max,line_min:line_max],$
    resolution,degree,cp_percent,warped_band2,geo_info
  data_warp,band1[col_min:col_max,line_min:line_max],fy4a_lon_data[col_min:col_max,line_min:line_max],fy4a_lat_data[col_min:col_max,line_min:line_max],$
    resolution,degree,cp_percent,warped_band1,geo_info
    
  warped_data_size=size(warped_band3)
  final_target_data=fltarr(3,warped_data_size[1],warped_data_size[2])
  final_target_data[0,*,*]=warped_band3
  final_target_data[1,*,*]=warped_band2
  final_target_data[2,*,*]=warped_band1

  write_tiff,result_name,final_target_data,/float,geotiff=geo_info
  end_time=systime(1)
  print,end_time-start_time
end