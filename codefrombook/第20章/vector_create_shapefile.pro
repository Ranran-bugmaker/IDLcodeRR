;+
;  《IDL程序设计》
;   -数据可视化与ENVI二次开发
;        
; 示例代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;-
PRO VECTOR_CREATE_SHAPEFILE

  ;创建矢量文件对象，实体类型参照表？？？
  mynewshape=OBJ_NEW('IDLffShape', 'c:\temp\cities.shp', ENTITY_TYPE=1)
    
  ;添加属性信息
  mynewshape->ADDATTRIBUTE, 'CITY_NAME', 7, 25, $
    PRECISION=0
  mynewshape->ADDATTRIBUTE, 'STAT_NAME', 7, 25, $
    PRECISION=0
    
  ;创建实体结构体
  entNew = {IDL_SHAPE_ENTITY}
  
  ;定义实体结构体成员值
  entNew.SHAPE_TYPE = 1
  entNew.ISHAPE = 1458
  entNew.BOUNDS[0] = -104.87270
  entNew.BOUNDS[1] = 39.768040
  entNew.BOUNDS[2] = 0.00000000
  entNew.BOUNDS[3] = 0.00000000
  entNew.BOUNDS[4] = -104.87270
  entNew.BOUNDS[5] = 39.768040
  entNew.BOUNDS[6] = 0.00000000
  entNew.BOUNDS[7] = 0.00000000
  entNew.N_VERTICES = 1 
  
  ;获取对象的属性结构体
  attrNew = mynewshape ->GETATTRIBUTES(/ATTRIBUTE_STRUCTURE)
  
  ;对结构体成员赋值
  attrNew.ATTRIBUTE_0 = 'Denver'
  attrNew.ATTRIBUTE_1 = 'Colorado'
  
  ;添加实体到shape对象中
  mynewshape -> PutEntity, entNew
  
  ;添加实体属性到shape对象中
  mynewshape -> SetAttributes, 0, attrNew
  
  ;关闭shape对象
  OBJ_DESTROY, mynewshape
  
END