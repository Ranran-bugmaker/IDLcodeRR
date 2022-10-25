function hdf4_data_get,file_name,sds_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回hdf4文件的数据集数组'
    print,'输入参数：'
    print,'file_name：待处理hdf4文件名'
    print,'sds_name：待获取hdf4数据集名'
    print,'返回值:'
    print,'目标数据集结果，一般为数组形式'
    return,0
  endif
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  hdf_sd_getdata,sds_id,data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,data
end