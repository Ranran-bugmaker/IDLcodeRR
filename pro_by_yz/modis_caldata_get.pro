function modis_caldata_get,file_name,sds_name,scale_name,offset_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回MODIS一级数据的定标结果'
    print,'输入参数：'
    print,'file_name：待处理MODIS文件名'
    print,'sds_name：待定标MODIS数据集名'
    print,'scale_name：定标scale属性名称'
    print,'offset_name：定标offset属性名称'
    print,'返回值:'
    print,'定标后的结果数组'
    return,0
  endif
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  hdf_sd_getdata,sds_id,data
  att_index=hdf_sd_attrfind(sds_id,scale_name)
  hdf_sd_attrinfo,sds_id,att_index,data=scale_data
  att_index=hdf_sd_attrfind(sds_id,offset_name)
  hdf_sd_attrinfo,sds_id,att_index,data=offset_data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  data_size=size(data)
  data_ref=fltarr(data_size[1],data_size[2],data_size[3])
  for layer_i=0,data_size[3]-1 do begin
    data_ref[*,*,layer_i]=scale_data[layer_i]*(data[*,*,layer_i]-offset_data[layer_i])
  endfor
  data=!null
  return,data_ref
end