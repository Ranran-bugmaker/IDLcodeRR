pro writepolygon
shapefile='d:\test\Forbidden_City.shp'
oshp=obj_new('IDLffshape',shapefile,Entity_type=5,/update)
;定义实体类型
entNew = {IDL_SHAPE_ENTITY}  
entNew.SHAPE_TYPE = 5  
;添加坐标
coor=[[116.3852041484393,39.9214192520002],$
[116.3856922399481,39.91151453640624],$
[116.3960721525212,39.9118040463524],$
[116.3955102491546,39.92183809311693],$
[116.3852041484393,39.9214192520002]]

entNew.ISHAPE=0
entNew.BOUNDS[0] = min(coor[0,*]) 
entNew.BOUNDS[1] = min(coor[1,*])
entNew.BOUNDS[2] = 0.00000000 
entNew.BOUNDS[3] = 0.00000000 
entNew.BOUNDS[4] = max(coor[0,*])
entNew.BOUNDS[5] = max(coor[1,*])
entNew.BOUNDS[6] = 0.00000000 
entNew.BOUNDS[7] = 0.00000000 
pvertice=coor
entNew.VERTICES=PTR_NEW(pvertice,/no_copy)
entNew.N_VERTICES = 5
;还要把实体写入到shp对象中
oshp -> PutEntity, entNew
;加属性
;先定义属性表结构
oshp->AddAttribute,'id',3,8,PRECISION=0
oshp->AddAttribute,'name',7,20,PRECISION=0

;获得属性表结构对象
new_attr = oshp ->GetAttributes(/ATTRIBUTE_STRUCTURE) 
new_attr.ATTRIBUTE_0 = 1 
new_attr.ATTRIBUTE_1 = 'river'
;把属性写入到shp对象中
oshp -> SetAttributes,0,new_attr;这里面的0是指实体的索引值，等于entNew.ISHAPE

coor=[[116.3858622895445,39.92099455865304],$
[116.3863498312803,39.91211319734286],$
[116.3952884054441,39.91246510632352],$
[116.3948307781919,39.92118603918453],$
[116.3858622895445,39.92099455865304]]

entNew.ISHAPE=1
entNew.BOUNDS = [min(coor[0,*]),min(coor[1,*]),0,0,max(coor[0,*]),max(coor[1,*]),0,0]
pvertice=coor
entNew.VERTICES=PTR_NEW(pvertice,/no_copy)
entNew.N_VERTICES = (size(coor))[2]
entNew.N_Parts=2
P_parts=[0,5,9]
entNew.Parts=Ptr_new(P_parts,/no_copy)
;还要把实体写入到shp对象中
oshp -> PutEntity, entNew
;加属性
new_attr.ATTRIBUTE_0 = 1 
new_attr.ATTRIBUTE_1 = 'Forbidden_City'
;把属性写入到shp对象中
oshp -> SetAttributes,1,new_attr;这里面的0是指实体的索引值，等于entNew.ISHAPE
obj_destroy,oshp
print,'end'
end

