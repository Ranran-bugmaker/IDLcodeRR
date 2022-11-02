pro Drafts
  
;  file='D:\WorkSpace_IDL\resource\data\chapter_3\modis_swath\warp_out\MYD04_3K.A2018121.0545.061.2018121172155.tiff'
;  data=read_tiff(file,geotiff=geo_info)
;  resolution_tag=geo_info.(0)
;  help,resolution_tag
;  print,resolution_tag
;;  RESOLUTION_TAG  DOUBLE    = Array[3]
;;  0.029999999     0.029999999      0.00000000
;  geo_tag=geo_info.(1)
;  help,geo_tag
;  print,geo_tag
;;  GEO_TAG         DOUBLE    = Array[6]
;;  0.00000000      0.00000000      0.00000000       106.74319       45.877384      0.00000000
;  data_size=size(data)
;  data_col=data_size[1]
;  data_line=data_size[2]
;  temp_lon_min=geo_tag[3]
;  temp_lon_max=temp_lon_min+data_col*resolution_tag[0]
;  temp_lat_max=geo_tag[4]

    
;    shpfile='R:\IDL\resource\data\chapter_2\chapter_0/sichuan_county_wgs84.shp'
;    oshp=Obj_New('IDLffShape',shpfile)
;    oshp->getproperty,n_entities=n_ent,Attribute_info=attr_info,n_attributes=n_attr,Entity_type=ent_type
;    FOR i=0,n_attr-1 do begin ;循环
;      PRINT, '字段序号: ',i
;      PRINT, '字段名: ', attr_info[i].name
;      PRINT, '字段类型代码: ', attr_info[i].type
;      PRINT, '字段宽度: ', attr_info[i].width
;      PRINT, '精度: ', attr_info[i].precision
;    endfor
;    Obj_destroy,oshp ;销毁一个shape对象

  shpfile='R:\IDL\resource\data\chapter_2\chapter_0/sichuan_county_wgs84.shp'
  prjfile='R:\IDL\resource\data\chapter_2\chapter_0/sichuan_county_wgs84.prj'
  output_directory='R:\IDL\resource\data\chapter_2\chapter_0/shp_out/'
  out_field_position1=6
  out_field_position2=2
  dir_test=file_test(output_directory,/directory)
  if dir_test eq 0 then begin
    file_mkdir,output_directory
  endif
  
  shpobj=obj_new('IDLffShape',shpfile)
  shpobj.GetProperty, n_entities=ent_n,n_attributes=att_n,attribute_info=att_info
  
  enumlist=shpobj.GetAttributes(/ALL)
  enumlist2=shpobj.GetEntity(/ALL)
  sea=enumlist.(5);获取城市代码
  sea=sea[UNIQ(sea[SORT(sea)])]
  Attr=enumlist[WHERE(enumlist.(5) eq sea[0])]
  Enty=enumlist2[WHERE(enumlist.(5) eq sea[0])]
  
  
  
  att_result=shpobj.GetAttributes(0)
  out_name=output_directory+att_result.(out_field_position1)+'.shp'
  out_obj=obj_new('IDLffShape',out_name,/update,entity_type=5)
  a=SIZE(attr)
  for ni = 0L, a[1]-1 do begin
    ent_result=shpobj.GetEntity(0)
    
    
    
    
    
    out_obj.PutEntity,ent_result
    
    
  endfor
    shpobj.DestroyEntity,ent_result
 
 
 
 
 
 
 
;  for ent_i=0,ent_n-1 do begin
    ent_result=Enty;shpobj.GetEntity(ent_i)
    att_result=Attr;shpobj.GetAttributes(ent_i)


    ;命名输入输出
    out_name=output_directory+att_result.(out_field_position1)+'_'+att_result.(out_field_position2)+'.shp'
    out_prj=output_directory+att_result.(out_field_position1)+'_'+att_result.(out_field_position2)+'.prj'

    ;写入shp基础文件
    out_obj=obj_new('IDLffShape',out_name[0],/update,entity_type=5)
    out_obj.PutEntity,ent_result
    shpobj.DestroyEntity,ent_result


    ;添加定义属性表结构
    for att_i=0,att_n-1 do begin
      att_temp=att_info[att_i]
      out_obj.AddAttribute,att_temp.(0),att_temp.(1),att_temp.(2),precision=att_temp.(3)
    endfor

    ;添加表信息
    out_attr=out_obj->GetAttributes(/attribute_structure)
    for index = 0L, N_ELEMENTS(att_result)-1 do begin
      out_attr.add=att_result[index]
    endfor

    
    out_obj.c,0,out_attr

    ;释放对象
    out_obj.close
    obj_destroy,out_obj

    ;复制投影信息
    file_copy,prjfile,out_prj

;  ENDFOR

end