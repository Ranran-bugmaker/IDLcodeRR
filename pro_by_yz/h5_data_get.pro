function h5_data_get,file_name,dataset_name,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回hdf5文件的数据集数组'
    print,'输入参数：'
    print,'file_name：待处理hdf5文件名'
    print,'sds_name：待获取hdf5数据集名'
    print,'返回值:'
    print,'目标数据集结果，一般为数组形式'
    return,0
  endif
  file_id=h5f_open(file_name)
  dataset_id=h5d_open(file_id,dataset_name)
  data=h5d_read(dataset_id)
  h5d_close,dataset_id
  h5f_close,file_id
  return,data
  data=!null
end