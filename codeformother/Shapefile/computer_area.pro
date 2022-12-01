;*******************************************************************************
;* 作者:吴立宗
;* 单位：中国科学院寒区旱区环境与工程研究所
;* E-mail:wulizong at lzb.ac.cn
;* 创建日期：2008-
;* 程序更新纪录：
;*
;* 程序描述：
;*     本程序用于，在经纬度投影下计算多边形的面积
;********************************************************************************


Pro Computer_Area
  shapefile='D:\接图表\10万接图表.shp'  ;需要计算的shapefile文件
  out_shapefile='D:\test\world.shp'               ;输出文件
  Area_Fieldname='new_area'                       ;存储面积的字段名称，注意别于原有的字段名称重复
  Precision=4                                     ;面积精度（即小数后的位数）
  
  ;读取原始的shapefile文件
  oshp=OBJ_NEW('IDLffShape',shapefile)
  ;获取属性
  oshp->GetProperty,N_Entities=n_ent,n_attributes=n_attr,ENTITY_TYPE=ent_type,attribute_info=attr_info
  If ent_type Ne 5 Then Begin
    PRINT,'你输入的用来计算面积的文件不是多边形实体，请检查你的数据！'
    RETURN
  Endif
  
  ; 创建新的shapefile文件
  new_shp=OBJ_NEW('IDLffShape',out_shapefile,entity_type=ent_type,/update)
  ;为输出文件创建属性
  new_shp->AddAttribute,Area_Fieldname,5,16,Precision=precision      ;面积字段，16位宽度，
  For i=0,n_attr-1 Do Begin
    new_shp->AddAttribute, (attr_info.name)[i],(attr_info.type)[i],$
      (attr_info.width)[i],Precision=(attr_info.Precision)[i]      ;保留原有字段
  Endfor
  
  
  Albers=MAP_PROJ_INIT('Albers Equal Area',$
    SEMIMAJOR_AXIS=6378245.0 ,SEMIMINOR_AXIS=6356863.0188,$
    STANDARD_PAR1=25.0,STANDARD_PAR2=47.0,$
    CENTER_LATITUDE=0.0,CENTER_LONGITUDE=105.0,$
    FALSE_EASTING=0.0, FALSE_NORTHING=0.0,/GCTP)
    
    
    
    
    
  new_ent = {IDL_SHAPE_ENTITY}
  new_ent.Shape_Type=5
  
  For i=0,n_ent-1 Do Begin
    ent=oshp->getentity(i)
    attr=oshp->getattributes(i)
    vert=*(ent.vertices)
    new_vert=MAP_PROJ_FORWARD(vert,map_structure=albers)
    
    ;复制图形
    new_ent.Ishape=i
    new_ent.bounds=[MIN(new_vert[0,*]),MIN(new_vert[1,*]),0,0,MAX(new_vert[0,*]),MAX(new_vert[1,*]),0,0]
    new_ent.n_vertices=ent.n_vertices
    new_ent.vertices=PTR_NEW(new_vert)
    
    new_ent.n_parts=ent.n_parts
    new_ent.parts=ent.parts
    new_ent.part_types=ent.part_types
    
   
    ;计算面积       
    ROI=Obj_new('IDLanROI',new_vert)
    result=ROI->ComputeGeometry(Area=area,Centroid=Center_xy)
     ;写入图形
    new_shp->putEntity,new_ent
    ;更新属性
    new_attr=new_shp->GetAttributes(/ATTRIBUTE_STRUCTURE)
    
    ;写入属性
    
    new_attr.(0)=area    ;可以除以1000000
    for index=1,n_attr do begin
    new_attr.(index)=attr.(index-1)
    endfor
    
    new_shp->setAttributes,i,new_attr
    
    oshp->DestroyEntity,ent
    obj_destroy,roi
  Endfor
  new_shp->DestroyEntity,new_ent
  
  OBJ_DESTROY, new_shp
  OBJ_DESTROY, oshp
  
  PRINT,'end'
  
  
  
End
