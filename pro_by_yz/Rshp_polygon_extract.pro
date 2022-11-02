pro Rshp_polygon_extract
shpfile='R:\IDL\resource\data\chapter_2\chapter_0\sichuan_county_wgs84.shp'
prjfile='R:\IDL\resource\data\chapter_2\chapter_0\sichuan_county_wgs84.prj'
output_directory='R:\IDL\resource\data\chapter_2\chapter_0/shp_out/'
out_field_position1=6
out_field_position2=2
dir_test=file_test(output_directory,/directory)
if dir_test eq 0 then BEGIN
  file_mkdir,output_directory
endif

shpobj=obj_new('IDLffShape',shpfile)
shpobj.GetProperty, n_entities=ent_n,n_attributes=att_n,attribute_info=att_info

enumlist=shpobj.GetAttributes(/ALL);获取所有属性表内容
sea=enumlist.(5);获取城市代码

for ent_i=0,ent_n-1 do begin
  ent_result=shpobj.GetEntity(ent_i)
  att_result=shpobj.GetAttributes(ent_i)


  ;命名输入输出
  out_name=output_directory+att_result.(out_field_position1)+'_'+att_result.(out_field_position2)+'.shp'
  out_prj=output_directory+att_result.(out_field_position1)+'_'+att_result.(out_field_position2)+'.prj'
  
  ;写入shp基础文件
  out_obj=obj_new('IDLffShape',out_name,/update,entity_type=5)
  out_obj.PutEntity,ent_result
  shpobj.DestroyEntity,ent_result


  ;添加定义属性表结构
  for att_i=0,att_n-1 do begin
    att_temp=att_info[att_i]
    out_obj.AddAttribute,att_temp.(0),att_temp.(1),att_temp.(2),precision=att_temp.(3)
  endfor
  
  ;添加表信息
  out_attr=out_obj->GetAttributes(/attribute_structure)
  out_attr[0]=att_result[0]
  out_obj.SetAttributes,0,out_attr
  
  ;释放对象
  out_obj.close
  obj_destroy,out_obj

  ;复制投影信息
  file_copy,prjfile,out_prj
  
ENDFOR
end