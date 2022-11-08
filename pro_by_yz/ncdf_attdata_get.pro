function ncdf_attdata_get,file_name,dataset_name,att_name
  file_id=ncdf_open(file_name)
  dataset_id=ncdf_varid(file_id,dataset_name)
  ncdf_attget,file_id,dataset_id,att_name,data
  ncdf_close,file_id
  return,data
  data=!null
end