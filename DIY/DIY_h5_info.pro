function DIY_h5_info,file,group,name
  ;获取h5文件信息并转存为数据而非数组
  tmp=h5f_open(file)
  group_id=h5g_open(tmp,group)
  att_idx=h5a_open_name(group_id,name)
  info=fix(h5a_read(att_idx))
  return,info
end