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
PRO VECTOR_READ_SHAPEFILE_OBJECT
  ;读取IDL自带的shape文件
  shapeFile = FILEPATH('states.shp', $
    SUBDIR=['examples', 'data'])
  ;设置显示属性
  oShape = OBJ_NEW('IDLffShape', shapeFile)
  ;从矢量对象中获取实体个数
  oShape->GETPROPERTY, N_Entities = nEntities
  ;创建IDLgrModel对象
  oModel= OBJ_NEW('IDLgrModel')
  ;获取每个实体的信息
  FOR i=0, nEntities-1 DO BEGIN
    entitie = oShape->GETENTITY(i)
    ;读取实体的组份
    IF PTR_VALID(entitie.PARTS) NE 0 THEN BEGIN
      cuts = [*entitie.PARTS, entitie.N_VERTICES]
      ;每个实体组份创建多边形
      FOR j=0, entitie.N_PARTS-1 DO BEGIN
        tempLon = (*entitie.VERTICES)[0,cuts[j]:cuts[j+1] - 1]
        tempLat = (*entitie.VERTICES)[1,cuts[j]:cuts[j+1] - 1]
        ;创建线状、红色多边形
        opoly = OBJ_NEW('IDLgrPolygon', [tempLon, tempLat], $
          STYLE=1, color=[255,0,0])
        ;添加多边形到oModel中
        omodel->ADD, opoly
      ENDFOR
    ENDIF
    ;删除实体
    oShape->DESTROYENTITY, entitie
  ENDFOR
  ;销毁shape对象
  OBJ_DESTROY, oShape
  ;查看显示
  XOBJVIEW, oModel
END