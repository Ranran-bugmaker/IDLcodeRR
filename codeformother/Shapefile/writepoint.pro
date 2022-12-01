Pro writepoint
  shapefile='d:\test\citys.shp'
  oshp=OBJ_NEW('IDLffshape',shapefile,Entity_type=1,/update)
  ;定义实体类型
  entNew = {IDL_SHAPE_ENTITY}
  entNew.SHAPE_TYPE = 1 ;1为实体类型，表示点
  ;添加坐标,加那个地方呢，我爱北京天安门吧
  entNew.ISHAPE=0
  entNew.BOUNDS[0] = 116.391188
  entNew.BOUNDS[1] = 39.904546
  entNew.BOUNDS[2] = 0.00000000
  entNew.BOUNDS[3] = 0.00000000
  entNew.BOUNDS[4] = 116.391188
  entNew.BOUNDS[5] = 39.904546
  entNew.BOUNDS[6] = 0.00000000
  entNew.BOUNDS[7] = 0.00000000
  entNew.N_VERTICES = 1
  ;加属性了
  ;先定义属性表结构
  oshp->AddAttribute,'id',3,8,PRECISION=0
  oshp->AddAttribute,'name',7,20,PRECISION=0
  oshp->AddAttribute,'longitude',5,8,PRECISION=4
  oshp->AddAttribute,'latitude',5,8,PRECISION=4
  ;还要把实体写入到shp对象中
  oshp -> PutEntity, entNew
  ;获得属性表结构对象
  new_attr = oshp ->GetAttributes(/ATTRIBUTE_STRUCTURE)
  new_attr.ATTRIBUTE_0 = 1
  new_attr.ATTRIBUTE_1 = '北京天安门'
  new_attr.ATTRIBUTE_2 = 116.3911
  new_attr.ATTRIBUTE_3 = 39.904546
  ;把属性写入到shp对象中
  oshp -> SetAttributes,0,new_attr;这里面的0是指实体的索引值，等于entNew.ISHAPE
  ;再加一个吧，就兰州了
  entNew.BOUNDS = [103.867694,36.048088,0,0,103.867694,36.048088,0,0]
  new_attr.(0)=2
  new_attr.(1)='兰州'
  new_attr.(2)=103.8676
  new_attr.(3)=36.0480
  oshp -> PutEntity, entNew
  oshp -> SetAttributes,1,new_attr;
  OBJ_DESTROY,oshp
  print,'end'
End