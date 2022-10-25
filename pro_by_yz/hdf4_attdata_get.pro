function hdf4_attdata_get,file_name,sds_name,att_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回hdf4文件的数据集属性'
    print,'输入参数：'
    print,'file_name：待处理hdf4文件名'
    print,'sds_name：待查询hdf4数据集名'
    print,'att_name：待查询hdf4数据集属性名'
    print,'返回值:'
    print,'目标数据集属性结果，一般为数组形式'
    return,0
  endif
  sd_id=hdf_sd_start(file_name,/read)
  sds_index=hdf_sd_nametoindex(sd_id,sds_name)
  sds_id=hdf_sd_select(sd_id,sds_index)
  att_index=hdf_sd_attrfind(sds_id,att_name)
  hdf_sd_attrinfo,sds_id,att_index,data=att_data
  hdf_sd_endaccess,sds_id
  hdf_sd_end,sd_id
  return,att_data
end