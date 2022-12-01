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
;创建对象
;
;圆对象类定义源码,继承IDLgrPolygon。
;针对演示，init方法中添加了tlb参数。

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
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IDLGRPOLYGON::GETPROPERTY, _EXTRA=_extra
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
;刷新显示
PRO IDLgrCircle::Refresh
  XOBJVIEW, REFRESH=self.xObjViewTlb
END
;绘制显示
PRO IDLgrCircle::Show

  XOBJVIEW, self,TLB=xObjViewTlb, GROUP=self.tlb
  ;保存XOBJVIEW的界面ID
  self.xObjViewTlb = xObjViewTlb
END
;基于圆心和半径创建圆
PRO IDLgrCircle::BuildCircle
  self.xcoords = self.Center[0] + self.Radius * COS(INDGEN(361) * !DtoR)
  self.ycoords = self.Center[1] + self.Radius * SIN(INDGEN(361) * !DtoR)
END
;圆对象类初始化
FUNCTION IDLgrCircle::INIT, tlb, Center = Center, $
    Radius = Radius,_EXTRA = e
  ;初始化标识
  initSucess =1b
  ;存储关联组件ID
  self.tlb = tlb
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
  self.SHOW
  ;继承IDLgrPolygon对象的初始化方法
  initSucess = self->IDLGRPOLYGON::INIT(self.xcoords, $
    self.YCOORDS, self.zcoords, _EXTRA = e)
  ;返回初始化成功标志
  RETURN, initSucess
END

;圆对象类定义
PRO IDLGRCIRCLE__DEFINE
  struct = { IDLgrCircle, $
    tlb : 0L, $
    xObjViewTlb : 0L, $
    INHERITS IDLGRPOLYGON, $
    center:FLTARR(2), $
    xcoords:FINDGEN(361), $
    ycoords:FINDGEN(361), $
    zcoords:FINDGEN(361), $
    Radius:0.}
END

;组件响应事件程序
PRO WIDGET_PROPERTYSHEET_EXAMPLE_EVENT, event
  ;组件修改了属性值
  IF (event.type EQ 0) THEN BEGIN 
    ;获取组件标识和修改的属性
    value = WIDGET_INFO(event.ID, COMPONENT = event.component, $
      PROPERTY_VALUE = event.identifier) 
    ;对组件进行属性设置.
    event.component->SETPROPERTYBYIDENTIFIER, event.identifier, $
      value
    ;调用刷新显示方法进行刷新
    event.component->refresh
    ;控制台输出
    PRINT, '修改的属性是: ', event.identifier, ': ', value    
  ENDIF   
END
;析构函数
PRO WIDGET_PROPERTYSHEET_EXAMPLE_cleanup, wID
  WIDGET_CONTROL, wID, GET_UVALUE=obj
  ;销毁对象
  OBJ_DESTROY, obj
END

;属性界面组件演示
PRO WIDGET_PROPERTYSHEET_EXAMPLE

  ;创建tlb界面.
  tlb = WIDGET_BASE(/TLB_SIZE_EVENT, $
    TITLE = '属性界面演示', $
    KILL_NOTIFY = 'WIDGET_PROPERTYSHEET_EXAMPLE_cleanup')
  
  ;创建圆对象
  oCircle = OBJ_NEW('IDLgrCircle', $
    tlb, $
    /REGISTER_PROPERTIES)
  ;隐藏圆的name属性参数
  oCircle->Setpropertyattribute, 'name', /Hide
  ;修改圆的属性参数description为'自定义圆参数'
  oCircle->Setpropertyattribute, 'description',name = '自定义圆参数'
  ;注册IDLgrCircle中的附加参数属性到设置界面
  oCircle->IDLitComponent::RegisterProperty,'Radius',3,name='半径'
  ;创建属性修改界面组件
  prop = WIDGET_PROPERTYSHEET(tlb, $
    VALUE = oCircle,$
    ySize = 20)    
  ;例示组件
  WIDGET_CONTROL, tlb, SET_UVALUE = oCircle, /REALIZE
  
  ;关联事件响应
  XMANAGER, 'WIDGET_PROPERTYSHEET_EXAMPLE', tlb, /NO_BLOCK  
END
