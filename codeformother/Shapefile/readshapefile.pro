Pro readshapefile
  shapefile='C:\ESRI\ESRIDATA\WORLD\country.shp' ;定义shape文件位置
  oshp=OBJ_NEW('IDLffShape',shapefile)
  oshp->getproperty,n_entities=n_ent,Attribute_info=attr_info,n_attributes=n_attr,Entity_type=ent_type
  ;读坐标值
  for i=0,n_ent-1 do begin
    ent=oshp->getEntity(i)
    ;输出实体范围
    print,'最小x:',ent.bounds[0]
    print,'最小y:',ent.bounds[1]
    print,'最大x:',ent.bounds[4]
    print,'最大y:',ent.bounds[5]
    ;输出坐标值
    vert=*(ent.vertices)
    print,'顶点个数为:',ent.n_vertices
    print,vert
  endfor
  ;输出表结构
  For i=0,n_attr-1 Do Begin ;循环
    PRINT, '字段序号: ',i
    PRINT, '字段名: ', attr_info[i].name
    PRINT, '字段类型代码: ', attr_info[i].type
    PRINT, '字段宽度: ', attr_info[i].width
    PRINT, '精度: ', attr_info[i].precision
  Endfor 
  
  ;输出属性表中的值   
  For i=0,n_ent-1 Do Begin ;循环，n_ent跟记录数是一样的
    attr=oshp->GetAttributes(i) ;读取第i个记录
    For index=0, n_attr-1 Do Begin
      PRINT,attr_info[index].name,' = ',attr.(index)
    Endfor
  Endfor
  OBJ_DESTROY,oshp ;销毁一个shape对象
  print,'---end----'
End