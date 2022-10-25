function fy4a_caldata_get,file_name,target_channel_name,cal_channel_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回风云4A一级数据的定标结果'
    print,'输入参数：'
    print,'file_name：待处理风云4A文件名'
    print,'target_channel_name：待定标风云4A数据集名'
    print,'cal_channel_name：待定标风云4A数据集的对应定标表'
    print,'返回值:'
    print,'定标后的结果数组'
    return,0
  endif
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