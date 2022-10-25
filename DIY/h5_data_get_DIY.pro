function h5_data_get_DIY,file_name,dataset_name
;获取栅格数据
  file_id=h5f_open(file_name)
  dataset_id=h5d_open(file_id,dataset_name)
  data=h5d_read(dataset_id)
  h5d_close,dataset_id;释放文件
  h5f_close,file_id;释放文件
  return,data
  data=!null;清空data
end