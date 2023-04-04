PRO rondomsplit
  outpath='R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outshp\'
  shppath='R:\JX\kjxxx\实验五 气温空间插值方法比较分析\实验数据\qiwen.shp'
  prjfile='R:\JX\kjxxx\实验五 气温空间插值方法比较分析\实验数据\qiwen.prj'
  
  shp_obj=obj_new('IDLffShape',shppath)
  shp_obj.GetProperty, n_entities=ent_n,n_attributes=att_n,attribute_info=att_info
  
  enumlist=shp_obj.GetAttributes(/ALL);获取所有属性表内容
  
  num_groups = 5
  group_size = N_ELEMENTS(enumlist)/5
  num_records = N_ELEMENTS(enumlist)
  T_out=INDGEN(5)
  ;
  idx = INDGEN(num_records)
  ;
  for i = 0L, num_records-1 do begin
    currentRandom = fix(randomu(undefinevar,1)*num_records)
    current = idx[i];
    idx[i] = idx[currentRandom];
    idx[currentRandom] = current;
  endfor
  groups=idx
  
  for ig = 0L, num_groups-1 do begin
    ;命名输入输出
    out_name=outpath+'out_'+STRCOMPRESS(STRING(ig+1), /REMOVE_ALL)+'.shp'
    out_name_T=outpath+'out_T_'+STRCOMPRESS(STRING(ig+1), /REMOVE_ALL)+'.shp'
    out_prj=outpath+'out_'+STRCOMPRESS(STRING(ig+1), /REMOVE_ALL)+'.prj'
    out_prj_T=outpath+'out_T_'+STRCOMPRESS(STRING(ig+1), /REMOVE_ALL)+'.prj'
    
    ;写入shp基础文件
    out_obj=obj_new('IDLffShape',out_name,/update,entity_type=1)
    out_obj_T=obj_new('IDLffShape',out_name_T,/update,entity_type=1)

    
    ;添加定义属性表结构
    for att_i=0,att_n-1 do begin
      att_temp=att_info[att_i]
      out_obj.AddAttribute,att_temp.(0),att_temp.(1),att_temp.(2),precision=att_temp.(3)
      out_obj_T.AddAttribute,att_temp.(0),att_temp.(1),att_temp.(2),precision=att_temp.(3)
    endfor
    
    

    PRINT,ig*group_size+0
    PRINT,"-------------"
    for inum = 0L, group_size-1 do begin
      pos=groups[ig*group_size+inum]
      ent_result=shp_obj.GetEntity(pos)
      att_result=shp_obj.GetAttributes(pos)
      out_obj.PutEntity,ent_result
      shp_obj.DestroyEntity,ent_result
      
      out_attr=out_obj->GetAttributes(/attribute_structure)
      ;添加表信息
      out_attr[0]=att_result[0]
      out_obj.SetAttributes,inum,out_attr
    endfor
    ;释放对象
    out_obj.close
    obj_destroy,out_obj
    
    
    
    
    new=T_OUT[WHERE(T_OUT ne ig)]
    num=0
    for index = 0L, N_ELEMENTS(new)-1 do begin
      igg=new[index]
      PRINT,igg*group_size+0
      for inum = 0L, group_size-1 do begin
        pos=groups[igg*group_size+inum]
        ent_resultl=shp_obj.GetEntity(pos)
        att_result=shp_obj.GetAttributes(pos)
        out_obj_T.PutEntity,ent_resultl
        out_attr=out_obj_T->GetAttributes(/attribute_structure)
        ;添加表信息
        out_attr[0]=att_result[0]
        out_obj_T.SetAttributes,num,out_attr
        shp_obj.DestroyEntity,ent_resultl
 
        num+=1
      endfor
    endfor
    ;释放对象
    out_obj_T.close
    obj_destroy,out_obj_T



    ;复制投影信息
    file_copy,prjfile,out_prj,/OVERWRITE
    file_copy,prjfile,out_prj_T,/OVERWRITE
  endfor

  
end