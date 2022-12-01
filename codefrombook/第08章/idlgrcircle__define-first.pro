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
;
;圆对象类定义源码,未对IDLgrPolygon继承。
;

;属性获取方法
PRO IDLgrCircle::GetProperty,Center = Center, Radius = Radius
  IF (ARG_PRESENT(Center)) THEN center = self.CENTER
  IF (ARG_PRESENT(Radius)) THEN radius = self.RADIUS
END
;绘制显示方法
PRO IDLgrCircle::Show
  XOBJVIEW,OBJ_NEW('IDLgrPolygon',self.XCOORDS,self.YCOORDS,style =1)
END
;基于圆心和半径创建圆
PRO IDLgrCircle::BuildCircle
  self.XCOORDS = self.CENTER[0] + self.RADIUS * COS(INDGEN(361) * !DtoR)
  self.YCOORDS = self.CENTER[1] + self.RADIUS * SIN(INDGEN(361) * !DtoR)
END

;圆对象类初始化
FUNCTION IDLgrCircle::INIT, Center, Radius
  initSucess =1b
  ;圆心须设定且为二维
  IF (N_ELEMENTS(Center) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Center) EQ 2) THEN  self.CENTER = center ELSE initSucess =0b
  ENDIF ELSE initSucess =0b
  ;圆半径须设定
  IF (N_ELEMENTS(Radius) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Radius) EQ 1) THEN  self.RADIUS = Radius ELSE initSucess =0b
  ENDIF ELSE initSucess =0b
  ;调用buildCircle方法计算
  self->BUILDCIRCLE
  ;返回初始化成功标志
  RETURN,initSucess
END
;圆对象类定义
PRO IDLGRCIRCLE__DEFINE
  struct = { IDLgrCircle, $
    center:FLTARR(2), $
    oCircle: OBJ_NEW(), $
    xcoords:FINDGEN(361), $
    ycoords:FINDGEN(361), $
    Radius:0.}
END

oCircle = OBJ_NEW('IDLgrCircle',[0,0])
PRINT,OBJ_VALID(oCircle)
oCircle = OBJ_NEW('IDLgrCircle',[0,0],1.5)
oCircle->GETPROPERTY,Radius = r
PRINT,r
oCircle.SHOW
END

