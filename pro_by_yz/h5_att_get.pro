function h5_att_get,file_name,dataset_name,att_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回hdf5文件的数据集属性'
    print,'输入参数：'
    print,'file_name：待处理hdf5文件名'
    print,'sds_name：待查询hdf5数据集名'
    print,'att_name：待查询hdf5数据集属性名'
    print,'返回值:'
    print,'目标数据集属性结果，一般为数组形式'
    return,0
  endif
  file_id=h5f_open(file_name)
  dataset_id=h5d_open(file_id,dataset_name)
  att_id=h5a_open_name(dataset_id,att_name)
  att_data=h5a_read(att_id)
  h5a_close,att_id
  h5d_close,dataset_id
  h5f_close,file_id
  return,att_data
end