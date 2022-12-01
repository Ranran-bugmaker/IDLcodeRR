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
PRO VECTOR_UPDATE_SHAPE

  ;矢量文件更新
  mynewshape=OBJ_NEW('IDLffShape', 'c:\temp\cities.shp', /UPDATE)
  
  ;创建实体结构体
  entNew = {IDL_SHAPE_ENTITY}
  
  ;定义实体结构体成员值
  entNew.SHAPE_TYPE = 1
  entNew.ISHAPE = 200
  entNew.BOUNDS[0] = -666.25100
  entNew.BOUNDS[1] = 40.026878
  entNew.BOUNDS[2] = 0.00000000
  entNew.BOUNDS[3] = 0.00000000
  entNew.BOUNDS[4] = -105.25100
  entNew.BOUNDS[5] = 40.026878
  entNew.BOUNDS[6] = 0.00000000
  entNew.BOUNDS[7] = 0.00000000
  entNew.N_VERTICES = 1
  
  ;获取对象的属性结构体
  attrNew = myshape ->GETATTRIBUTES(/ATTRIBUTE_STRUCTURE)
  
  ;对结构体成员赋值
  attrNew.ATTRIBUTE_0 = 'Boulder'
  attrNew.ATTRIBUTE_1 = 'Colorado'
  
  ;添加实体到shape对象中
  myshape -> PutEntity, entNew
  
  ;添加实体属性到shape对象中
  myshape -> SetAttributes, 0, attrNew
  
  ;关闭shape对象
  OBJ_DESTROY, myshape
  
END