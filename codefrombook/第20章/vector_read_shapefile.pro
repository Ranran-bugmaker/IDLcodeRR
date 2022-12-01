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
PRO VECTOR_READ_SHAPEFILE
  ;设置显示属性
  DEVICE, RETAIN=2, DECOMPOSED=0
  ;设置背景颜色
  !P.BACKGROUND=255
  ;定义颜色表
  r=BYTARR(256) & g=BYTARR(256) & b=BYTARR(256)
  r[0]=0 & g[0]=0 & b[0]=0             ;定义黑色
  r[1]=100 & g[1]=100 & b[1]=255       ;定义蓝色
  r[2]=0 & g[2]=255 & b[2]=0           ;定义绿色
  r[3]=255 & g[3]=255 & b[3]=0         ;定义黄色
  r[255]=255 & g[255]=255 & b[255]=255 ;定义白色
  ;载入颜色表
  TVLCT, r, g, b
  black=0 & blue=1 & green=2 & yellow=3 & white=255
  ;设置shape显示窗口投影
  MAP_SET, /ORTHO,45, -120,  /ISOTROPIC, $
    /HORIZON, E_HORIZON={FILL:1, COLOR:blue}, $
    /GRID, COLOR=black, /NOBORDER
  ;填充显示大陆
  MAP_CONTINENTS, /FILL_CONTINENTS, COLOR=green
  ;绘制显示 海岸线
  MAP_CONTINENTS, /COASTS, COLOR=black
  ;读取Example下的shape文件
  myshape=OBJ_NEW('IDLffShape', FILEPATH('states.shp', $
    SUBDIR=['examples', 'data']))
  ;从矢量对象中获取实体个数
  myshape->IDLFFSHAPE::GETPROPERTY, N_ENTITIES=num_ent
  ;获取每个实体的信息
  FOR x=1, (num_ent-1) DO BEGIN
    ;获取实体的属性信息
    attr = myshape->IDLFFSHAPE::GETATTRIBUTES(x)
    ;提取矢量中Colorado的内容
    IF attr.ATTRIBUTE_1 EQ 'Colorado' THEN BEGIN
      ;获取实体点
      ent=myshape->IDLFFSHAPE::GETENTITY(x)
      ;用黄色绘制实体面
      POLYFILL, (*ent.VERTICES)[0,*], (*ent.VERTICES)[1,*], $
        COLOR=yellow
      ;销毁实体点
      myshape->IDLFFSHAPE::DESTROYENTITY, ent
    ENDIF
  ENDFOR
  ;关闭矢量对象
  OBJ_DESTROY, myshape
END