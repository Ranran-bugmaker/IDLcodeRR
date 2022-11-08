function ncdf_data_get,file_name,dataset_name
  file_id=ncdf_open(file_name)
  dataset_id=ncdf_varid(file_id,dataset_name)
  ncdf_varget,file_id,dataset_id,data
  ncdf_close,file_id
  return,data
end
