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
;圆对象类定义源码,继承IDLgrPolygon。

;析构函数
PRO IDLgrCircle::CLEANUP
  ;调用IDLgrPolygon的析构函数
  self->IDLGRPOLYGON::CLEANUP
END

;属性获取
PRO IDLgrCircle::GetProperty,Center = Center, $
    Radius = Radius, _REF_EXTRA=_extra ; 获取设置父类的属性, 要使用_Ref_Extra
  IF (ARG_PRESENT(Center)) THEN center = self.center
  IF (ARG_PRESENT(Radius)) THEN radius = self.radius
  ;self->IDLGRPOLYGON::GETPROPERTY, _EXTRA = re
  if (N_Elements(_extra) gt 0) then $
        self->IDLgrPolygon::GetProperty, _EXTRA=_extra
END
;属性设置
PRO IDLgrCircle::SetProperty, Center = Center, $
    Radius = Radius, _REF_EXTRA = e ; 获取设置父类的属性, 要使用_Ref_Extra
  ;圆心须设定且为二维
  IF (N_ELEMENTS(Center) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Center) EQ 2) THEN  self.Center = center
  ENDIF
  ;圆半径须设定
  IF (N_ELEMENTS(Radius) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Radius) EQ 1) THEN  self.Radius = Radius
  ENDIF
  ;创建圆
  self->BUILDCIRCLE
  ;创建多边形
  self->IDLGRPOLYGON::SETPROPERTY, $
    DATA = TRANSPOSE([[self.xcoords],[self.ycoords]]), _EXTRA = e
END
;绘制显示
PRO IDLgrCircle::Show
  XOBJVIEW, self
END
;基于圆心和半径创建圆
PRO IDLgrCircle::BuildCircle
  self.xcoords = self.Center[0] + self.Radius * COS(INDGEN(361) * !DtoR)
  self.ycoords = self.Center[1] + self.Radius * SIN(INDGEN(361) * !DtoR)
END
;圆对象类初始化
FUNCTION IDLgrCircle::INIT, Center = Center, $
    Radius = Radius,_EXTRA = e ; 初始化父类, 用_Extra
  initSucess =1b
  ;圆心须设定且为二维
  IF (N_ELEMENTS(Center) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Center) EQ 2) THEN  self.Center = center ELSE BEGIN
      self.center = [0,0]
      initSucess =0b
    ENDELSE
  ENDIF ELSE self.center = [0,0]

  ;圆半径须设定
  IF (N_ELEMENTS(Radius) NE 0) THEN BEGIN
    IF (N_ELEMENTS(Radius) EQ 1) THEN  self.Radius = Radius ELSE BEGIN
      initSucess =0b
      self.Radius = 1
    ENDELSE
  ENDIF ELSE self.Radius = 1

  ;调用buildCircle方法计算
  self->BUILDCIRCLE
  ;继承IDLgrPolygon对象的初始化方法
  initSucess = self->IDLGRPOLYGON::INIT(self.xcoords, $
    self.YCOORDS, self.zcoords, _EXTRA = e)
  ;返回初始化成功标志
  RETURN, initSucess
END
;圆对象类定义
PRO IDLGRCIRCLE__DEFINE
  struct = { IDLgrCircle, $
    INHERITS IDLGRPOLYGON, $
    center:FLTARR(2), $
    xcoords:FINDGEN(361), $
    ycoords:FINDGEN(361), $
    zcoords:FINDGEN(361), $
    Radius:0.}
END

;oCircle = OBJ_NEW('IDLgrCircle',[0,0])
;PRINT,OBJ_VALID(oCircle)
;oCircle = OBJ_NEW('IDLgrCircle',[0,0],1.5)
;oCircle->GETPROPERTY,Radius = r
;PRINT,r
;oCircle.SHOW

