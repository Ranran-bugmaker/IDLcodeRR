function DIY_h5_info,file,group,name,key=identify
  
  
  IF ~keyword_set(identify) THEN BEGIN
    identify=0
  ENDIF
  ;获取h5文件信息并转存为数据而非数组
  case (identify) of
    0: begin
      
   case (identify) of
        0: begin

        end
        0: begin

        end
        0: begin

        end
        else: begin
        end
      endcase

  tmp=h5f_open(file)
  group_id=h5g_open(tmp,group)
  att_idx=h5a_open_name(group_id,name)
  info=fix(h5a_read(att_idx))
  return,info
end