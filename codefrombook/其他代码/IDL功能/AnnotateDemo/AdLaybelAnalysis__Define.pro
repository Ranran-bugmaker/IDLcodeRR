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
;------------------------------------------------------------------------
;
;刷新显示
;
PRO  AdLaybelAnalysis::RefreshDraw, ratio= ratio
  ;
  items = self.PARENT->GET(ISA = 'ADLabel',/All,count = count)
  ;是否已经存在base
  FOR  i=0,count-1 DO BEGIN
    ;
    items[i]->GETPROPERTY, Type = type, location = labelLoc, dimension = labelDim
    
    CASE type OF
      0: self.BASELOC = labelLoc
      1:self.EXPECTLOC = labelLoc
      2:self.ACTUALLOC = labelLoc
      ELSE:
    ENDCASE
  ENDFOR
  
  ;  创建连线、箭头及计算文字
  self->CREATEARROW, baseLoc = self.BASELOC, expectLoc = self.EXPECTLOC , $
    actualLoc = self.ACTUALLOC, labelDimension = labelDim*ratio;符号的宽度
    
END

;------------------------------------------------------------------------
;
;距离量算--线段的长度
;
PRO  AdLaybelAnalysis::Measure,data, object
  COMPILE_OPT idl2
  
  oSystem = self.OSYSTEM
  
  ;计算周长和面积
  oRoi = OBJ_NEW('IDLanROI', data=data)
  r = oRoi->COMPUTEGEOMETRY(area=area, perimeter=perimeter);//面积及周长
  OBJ_DESTROY, oRoi
  
  IF perimeter GE 100000D THEN BEGIN
    perimeter = STRTRIM(STRING(DOUBLE(perimeter/(1000*2)), FORMAT='(F12.2)'),2)+'km'
    
  ENDIF ELSE BEGIN
    perimeter = STRTRIM(STRING(DOUBLE(perimeter)/2, FORMAT='(F12.2)'),2)+'m'
    
  ENDELSE
  ;更新对象
  object->SETPROPERTY, strings = perimeter;
;
END
;------------------------------------------------------------------------
;
;创建箭头数据
;
PRO AdLaybelAnalysis::CreateArrow, baseLoc = baseLoc, expectLoc = expectLoc , $
    actualLoc = actualLoc, labelDimension = labelDim
  COMPILE_OPT idl2
  ;
  ;创建连线
  self.ACTUALLINE->SETPROPERTY, Data = [[baseLoc],[actualLoc]]
  self.EXPECTLINE->SETPROPERTY, Data = [[baseLoc], [expectLoc]]
  ;
  
  ;计算是否顺时针方向
  c = COMPUTE_MESH_NORMALS([[baseLoc],[expectLoc],[actualLoc]])
  ;记录原始方向
  oriDirection =  c[2,0]
  ;
  loc1 = [actualLoc[0], expectLoc[1:2]]
  
  ;计算选取的点坐标
  c = COMPUTE_MESH_NORMALS([[expectLoc],[loc1],[actualLoc]])
  
  IF c[2,0] EQ oriDirection THEN BEGIN
    ;计算起始点位置使得Y文字方向合适
    ;水平线
    IF expectLoc[0] LT loc1[0] THEN $
      CREATELINEARROW, self.OHORILINE, expectLoc, $
      loc1, /double_head,labelDim = labelDim, direction = c[2,0] $
    ELSE CREATELINEARROW, self.OHORILINE,loc1, $
    expectLoc, /double_head,labelDim = labelDim, direction = c[2,0]*(-1)
    
  IF actualLoc[1] LT loc1[1] THEN $
    CREATELINEARROW, self.OVERTLINE, actualLoc, $
    loc1, /double_head,labelDim = labelDim, direction = c[2,0]*(-1) $
  ELSE CREATELINEARROW, self.OVERTLINE, loc1, $
  actualLoc, /double_head,labelDim = labelDim, direction = c[2,0]
;更新文字
self->MEASURE,[[expectLoc],[loc1]], self.OHORITEXT
self->MEASURE,[[actualLoc],[loc1]], self.OVERTTEXT

ENDIF ELSE BEGIN
  loc1 = [expectLoc[0], actualLoc[1:2]]
  c = COMPUTE_MESH_NORMALS([[expectLoc],[loc1],[actualLoc]])
  ;计算起始点位置使得Y文字方向合适
  IF actualLoc[0] LT loc1[0] THEN $
    CREATELINEARROW, self.OHORILINE, actualLoc, $
    loc1, /double_head,labelDim = labelDim, direction = oriDirection*(-1) $
  ELSE CREATELINEARROW, self.OHORILINE,loc1, $
  actualLoc, /double_head,labelDim = labelDim, direction = oriDirection
  
IF expectLoc[1] LT loc1[1] THEN $
  CREATELINEARROW, self.OVERTLINE, expectLoc, $
  loc1, /double_head,labelDim = labelDim, direction = oriDirection $
ELSE   CREATELINEARROW, self.OVERTLINE, loc1, $
expectLoc, /double_head,labelDim = labelDim, direction = oriDirection*(-1)

;更新文字
self->MEASURE,[[actualLoc],[loc1]], self.OHORITEXT
self->MEASURE,[[expectLoc],[loc1]], self.OVERTTEXT

ENDELSE;
;更新连线上的文字

self->MEASURE,[[actualLoc],[baseLoc]], self.ACTUALTEXT
self->MEASURE,[[expectLoc],[baseLoc]], self.EXPECTTEXT

END

;------------------------------------------------------------------------
;
;属性对话框事件处理
;
PRO AdLaybelAnalysis::HandleEvent, event
  COMPILE_OPT idl2
  
  UName = WIDGET_INFO(event.ID, /UName)
  
  tagName = TAG_NAMES(event, /Structure_Name)
  
  IF tagName EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
    WIDGET_CONTROL, event.TOP, /Destroy
    self->SETPROPERTY, /OutLineHide
  ENDIF
  
  IF tagName EQ 'WIDGET_PROPSHEET_CHANGE' THEN BEGIN
    IF (event.PROPTYPE NE 0) THEN BEGIN
    
      value = WIDGET_INFO(event.ID, Property_Value = event.IDENTIFIER)
      
      event.COMPONENT->SETPROPERTYBYIDENTIFIER, event.IDENTIFIER, value
      
    ENDIF
  ENDIF
  
  IF UName EQ 'pButton' THEN BEGIN
    WIDGET_CONTROL, event.TOP, /Destroy
    self->SETPROPERTY, /OutLineHide
  ENDIF
END

;-----------------------------------------------------------------
;
;属性管理器
;
PRO AdLaybelAnalysis::PropertyManager, XOff = xOff, yOff = yOff
  COMPILE_OPT idl2
  
  oSystem = self.OSYSTEM
  DEVICE, Get_Screen_Size = screenSize
  
  ;计算弹出对话框的位置
  geom = WIDGET_INFO(oSystem.WTLB, /geometry)
  baseXOffset = geom.XOFFSET
  
  xoff = (baseXOffset GT screenSize[0]/2.) ? screenSize[0]*3/2. : screenSize[0]/2.
  yoff = screenSize[1]/2.
  
  ;属性对话框顶base
  pBase = WIDGET_BASE(Group_Leader = (self.OSYSTEM).WTLB , $
    UName = 'PropertyManager'        , $
    UValue = self                     , $
    Title = 'Property'            , $
    Space = 2                         , $
    XOffSet = xOff                    , $
    YOffSet = yOff                    , $
    XPad = 2                          , $
    YPad = 2                          , $
    Tlb_Frame_Attr = 1                , $
    /Toolbar                          , $
    /Column                           , $
    /Modal                            , $
    /Floating                         , $
    /Tlb_Kill_Request_Events          )
    
  tempBase = WIDGET_BASE(pBase        , $
    XPad = 0        , $
    YPad = 0        , $
    Scr_XSize = 200 , $
    /Base_Align_Left, $
    /Column         )
    
  pSheet = WIDGET_PROPERTYSHEET(tempBase    , $
    Value = self          , $
    /Sunken_Frame         , $
    Scr_XSize = 200       , $
    UName = 'pSheet'     , $
    /Multiple_Properties   )
    
  tempBase = WIDGET_BASE(pBase          , $
    XPad = 0          , $
    YPad = 0          , $
    Scr_XSize = 200   , $
    /Base_Align_Right , $
    /Column           )
    
  pButton = WIDGET_BUTTON(tempBase, Scr_XSize = 60, UName = 'pButton', Value = 'OK')
  
  WIDGET_CONTROL, /Realize, pBase
  
  XMANAGER, 'VideoPro', pBase, /No_Block, Event_Handler = '_VideoPro_Event',$
    Cleanup = '_VideoPro_Cleanup'
    
END

;-----------------------------------------------------------------
;
;获取属性
;
PRO AdLaybelAnalysis::GetProperty           , $
    b2aColor = b2aColor         , $
    b2aLineStyle = b2aLineStyle , $
    b2aLineThick = b2aLineThick , $
    
    b2eColor = b2eColor         , $
    b2eLineStyle = b2eLineStyle , $
    b2eLineThick = b2eLineThick , $
    
    HoriLineColor = HoriLineColor , $
    HoriLineStyle = HoriLineStyle , $
    HoriLineThick = HoriLineThick , $
    
    vertLineColor = vertLineColor , $
    vertLineStyle = vertLineStyle , $
    vertLineThick = vertLineThick , $
    baseLoc = baseLoc           , $
    
    Alpha = alpha               , $
    Height = height             , $
    status = status         , $
    _Ref_Extra = _extra
    
  COMPILE_OPT idl2
  
  IF ARG_PRESENT(b2aColor) NE 0 THEN b2aColor = self.B2ACOLOR
  IF ARG_PRESENT(b2aLineStyle) NE 0 THEN b2aLineStyle = self.B2ALINESTYLE
  IF ARG_PRESENT(b2aLineThick) NE 0 THEN b2aLineThick = self.B2ALINETHICK
  
  IF ARG_PRESENT(b2eColor) NE 0 THEN b2eColor = self.B2ECOLOR
  IF ARG_PRESENT(b2eLineStyle) NE 0 THEN b2eLineStyle = self.B2ELINESTYLE
  IF ARG_PRESENT(b2eLineThick) NE 0 THEN b2eLineThick = self.B2ELINETHICK
  
  IF ARG_PRESENT(HoriLineColor) NE 0 THEN HoriLineColor = self.HORILINECOLOR
  IF ARG_PRESENT(HoriLineStyle) NE 0 THEN HoriLineStyle = self.HORILINESTYLE
  IF ARG_PRESENT(HoriLineThick) NE 0 THEN HoriLineThick = self.HORILINETHICK
  
  IF ARG_PRESENT(vertLineColor) NE 0 THEN vertLineColor = self.VERTLINECOLOR
  IF ARG_PRESENT(vertLineStyle) NE 0 THEN vertLineStyle = self.VERTLINESTYLE
  IF ARG_PRESENT(vertLineThick) NE 0 THEN vertLineThick = self.VERTLINETHICK
  ;
  IF ARG_PRESENT(baseLoc) THEN baseLoc = STRTRIM(STRING(self.BASELOC[0]),2)+$
    ','+STRTRIM(STRING(self.BASELOC[1]),2)+','+STRTRIM(STRING(self.BASELOC[2]),2);self.baseLoc
    
  IF ARG_PRESENT(alpha) THEN alpha = self.ALPHA
  IF ARG_PRESENT(status) NE 0 THEN status = 1-self.STATUS
  IF ARG_PRESENT(height) NE 0 THEN height = self.HEIGHT/1000
  
  IF N_ELEMENTS(_extra) GT 0 THEN self->IDLITCOMPONENT::GETPROPERTY, _Extra = _extra
END

;-----------------------------------------------------------------
;
;设置属性
;
PRO AdLaybelAnalysis::SetProperty           , $
    b2aColor = b2aColor         , $
    b2aLineStyle = b2aLineStyle , $
    b2aLineThick = b2aLineThick , $
    
    b2eColor = b2eColor         , $
    b2eLineStyle = b2eLineStyle , $
    b2eLineThick = b2eLineThick , $
    
    HoriLineColor = HoriLineColor , $
    HoriLineStyle = HoriLineStyle , $
    HoriLineThick = HoriLineThick , $
    
    vertLineColor = vertLineColor , $
    vertLineStyle = vertLineStyle , $
    vertLineThick = vertLineThick , $
    baseLoc = baseLoc           , $
    
    Alpha = alpha               , $
    Height = height             , $
    status = status         , $
    _Ref_Extra = _extra
  COMPILE_OPT idl2
  
  oSystem = self.OSYSTEM
  project = self.PROJECT
  
  IF N_ELEMENTS(b2aColor) NE 0 THEN BEGIN
    self.B2ACOLOR = b2aColor
    self.ACTUALLINE->SETPROPERTY, color = b2aColor
  ENDIF
  
  IF N_ELEMENTS(b2aLineStyle) NE 0 THEN BEGIN
    self.B2ALINESTYLE = b2aLineStyle
    self.ACTUALLINE->SETPROPERTY, lineStyle = b2aLineStyle
  ENDIF
  IF N_ELEMENTS(b2eLineThick) NE 0 THEN BEGIN
    self.B2ELINETHICK = b2eLineThick
    self.ACTUALLINE->SETPROPERTY, thick = b2aLineThick
  ENDIF
  ;
  IF N_ELEMENTS(b2eColor) NE 0 THEN BEGIN
    self.B2ECOLOR = b2eColor
    self.EXPECTLINE->SETPROPERTY, color = b2eColor
  ENDIF
  
  IF N_ELEMENTS(b2eLineStyle) NE 0 THEN BEGIN
    self.B2ELINESTYLE = b2eLineStyle
    self.EXPECTLINE->SETPROPERTY, lineStyle = b2eLineStyle
  ENDIF
  IF N_ELEMENTS(b2eLineThick) NE 0 THEN BEGIN
    self.B2ELINETHICK = b2eLineThick
    self.EXPECTLINE->SETPROPERTY, thick = b2eLineThick
  ENDIF
  ;
  IF N_ELEMENTS(HoriLineColor) NE 0 THEN BEGIN
    self.HORILINECOLOR = HoriLineColor
    self.OHORILINE->SETPROPERTY, color = HoriLineColor
  ENDIF
  
  IF N_ELEMENTS(HoriLineStyle) NE 0 THEN BEGIN
    self.HORILINESTYLE = HoriLineStyle
    self.OHORILINE->SETPROPERTY, lineStyle = HoriLineStyle
  ENDIF
  IF N_ELEMENTS(HoriLineThick) NE 0 THEN BEGIN
    self.HORILINETHICK = HoriLineThick
    self.OHORILINE->SETPROPERTY, thick = HoriLineThick
  ENDIF
  ;
  IF N_ELEMENTS(vertLineColor) NE 0 THEN BEGIN
    self.VERTLINECOLOR = vertLineColor
    self.OVERTLINE->SETPROPERTY, color = vertLineColor
  ENDIF
  
  IF N_ELEMENTS(vertLineStyle) NE 0 THEN BEGIN
    self.VERTLINESTYLE = vertLineStyle
    self.OVERTLINE->SETPROPERTY, lineStyle = vertLineStyle
  ENDIF
  IF N_ELEMENTS(vertLineThick) NE 0 THEN BEGIN
    self.VERTLINETHICK = vertLineThick
    self.OVERTLINE->SETPROPERTY, thick = vertLineThick
  ENDIF
  
  
  IF N_ELEMENTS(alpha) NE 0 THEN BEGIN
    self.ALPHA = alpha
    ;
    items = self.PARENT->GET(/All,count = count)
    ;是否已经存在base
    FOR  i=0,count-1 DO BEGIN
      ;
      IF SIZE(items[i],/type) EQ 11 THEN $
        items[i]->SETPROPERTY, Alpha_Channel = alpha/100
    ENDFOR
  ENDIF
  
  IF N_ELEMENTS(status) NE 0 THEN  BEGIN
    self.STATUS = 1-status
    items = self.PARENT->GET(/All,count = count)
    ;是否已经存在base
    FOR  i=0,count-1 DO BEGIN
      ;
      IF SIZE(items[i],/type) EQ 11 THEN $
        items[i]->SETPROPERTY, Hide = status
    ENDFOR
    IF status EQ 0 THEN BEGIN
      bmp = READ_BMP(!vpdir+'\resource\bitmaps\oil\annotate.bmp', /rgb)
    ENDIF ELSE BEGIN
      bmp = READ_BMP(!vpdir+'\resource\bitmaps\oil\hide.bmp', /rgb)
    ENDELSE
    bitmap = BYTARR(16,16,3)
    bitmap[*,*,0] = REFORM(bmp[0,*,*])
    bitmap[*,*,1] = REFORM(bmp[1,*,*])
    bitmap[*,*,2] = REFORM(bmp[2,*,*])
    WIDGET_CONTROL, self.TREEID, set_tree_bitmap=bitmap
    
  ENDIF
  
  project.OWINDOW->DRAW
  
  self->IDLGRMODEL::SETPROPERTY, _Extra = _extra
END

;-----------------------------------------------------------------
;
;析构
;
PRO AdLaybelAnalysis::CLEANUP
  COMPILE_OPT idl2
  
  self->IDLGRMODEL::CLEANUP
  
  ;  obj_destroy, self.image
  OBJ_DESTROY, self.OVERTTEXT
  OBJ_DESTROY, self.OHORITEXT
  OBJ_DESTROY, self.OHORILINE
  OBJ_DESTROY, self.OVERTLINE
  OBJ_DESTROY, self.ACTUALTEXT
  OBJ_DESTROY, self.EXPECTTEXT
  OBJ_DESTROY, self.ACTUALLINE
  OBJ_DESTROY, self.EXPECTLINE
  
  OBJ_DESTROY, self.OFONT
  
END

;-----------------------------------------------------------------
;
;初始化
;
FUNCTION AdLaybelAnalysis::INIT, OSystem = oSystem   , $
    oManager = oManager      , $
    Parent = parent             , $
    Color = color               , $
    Thick = thick               , $
    Alpha = alpha               , $
    _Extra    = extra
  COMPILE_OPT idl2
  
  IF (self->IDLGRMODEL::INIT(_Extra=extra) NE 1) THEN RETURN, 0
  
  self.OSYSTEM = oSystem
  self.OPARENT = parent
  self.OMANAGER = oManager
  
  ;定义默认值
  ;  if ~Keyword_Set(color) then color = [255,255,255]
  IF ~KEYWORD_SET(data) THEN data = 1
  IF ~KEYWORD_SET(dimension) THEN dimension =12
  ;  if ~Keyword_Set(thick) then thick = 12
  IF ~KEYWORD_SET(alpha) THEN alpha = 100.
  IF ~KEYWORD_SET(location) THEN location = [0.,0.,80.]
  ;  ;
  ;保存值
  ;颜色
  self.B2ACOLOR = [255,255,0]
  ;  self.b2aTextColor = [255,255,0]
  self.B2ALINESTYLE = 0
  self.B2ALINETHICK = 1;
  ;
  self.B2ECOLOR = [255,255,0]
  ;  self.b2eTextColor = [255,255,0]
  self.B2ELINESTYLE = 0
  self.B2ELINETHICK = 1;
  
  self.HORILINECOLOR = [0,255,0]
  ;  self.horiTextColor = [255,0,0]
  self.HORILINESTYLE = 0
  self.HORILINETHICK = 1;
  
  self.VERTLINECOLOR = [0,255,0]
  ;  self.vertTextColor = [255,0,0]
  self.VERTLINESTYLE = 0
  self.VERTLINETHICK = 1
  ;线型
  
  self.DIMENSION = dimension
  self.ALPHA = alpha
  
  ;获取其他label数据
  items = parent->GET(ISA = 'ADLABEL',/All,count = count)
  ;是否已经存在base
  FOR  i=0,count-1 DO BEGIN
    ;
    items[i]->GETPROPERTY, Type = type, location = labelLoc, dimension = labelDim
    ;
    CASE type OF
      0: self.BASELOC = labelLoc
      1:self.EXPECTLOC = labelLoc
      2:self.ACTUALLOC = labelLoc
      ELSE:
    ENDCASE
  ENDFOR
  ;
  self.OFONT = OBJ_NEW('IDLgrFont', '宋体', size=self.DIMENSION)
  ;竖直方向上的字
  self.OVERTTEXT = OBJ_NEW('IDLgrText'    , $
    font = self.OFONT         , $
    recompute_dimensions = 1  , $
    render_method = 0         , $
    COLOR =self.VERTLINECOLOR , $
    VERTICAL_ALIGNMENT = 0.5  , $
    Location = Location         )
  ;水平方向文字
  self.OHORITEXT = OBJ_NEW('IDLgrText'    , $
    font = self.OFONT         , $
    recompute_dimensions = 1  , $
    render_method = 0         , $
    COLOR = self.HORILINECOLOR, $
    VERTICAL_ALIGNMENT = 0.5  , $
    Location = Location       )
  ;距离线
  self.OVERTLINE =  OBJ_NEW('idlgrpolyline'   , $
    color = self.VERTLINECOLOR    , $
    Label_Objects = self.OVERTTEXT, $
    Thick = self.VERTLINETHICK, $
    lineStyle = self.VERTLINESTYLE, $
    Label_Offsets = [0.5])
  self.OHORILINE =  OBJ_NEW('idlgrpolyline'   , $
    color = self.HORILINECOLOR    , $
    Label_Objects = self.OHORITEXT, $
    Thick = self.HORILINETHICK, $
    lineStyle = self.HORILINESTYLE, $
    Label_Offsets = [0.5])
  ;线上的文字
  self.ACTUALTEXT = OBJ_NEW('IDLgrText'   , $
    font = self.OFONT         , $
    recompute_dimensions = 1  , $
    render_method = 0         , $
    COLOR = self.B2ACOLOR , $
    VERTICAL_ALIGNMENT = 0.5  , $
    Location = Location)
  ;文字
  self.EXPECTTEXT = OBJ_NEW('IDLgrText'   , $
    font = self.OFONT         , $
    recompute_dimensions = 1  , $
    render_method = 0         , $
    COLOR = self.B2ECOLOR , $
    VERTICAL_ALIGNMENT = 0.5  , $
    Location = Location)
  ;两连线
  self.ACTUALLINE = OBJ_NEW('idlgrpolyline'     , $
    thick = self.B2ALINETHICK       , $
    Label_Objects = self.ACTUALTEXT , $
    lineStyle = self.B2ELINESTYLE   , $
    Label_Offsets = [0.5]           , $
    color = self.B2ACOLOR)
  self.EXPECTLINE = OBJ_NEW('idlgrpolyline'     , $
    thick = self.B2ELINETHICK       , $
    Label_Objects = self.EXPECTTEXT , $
    lineStyle = self.B2ELINESTYLE   , $
    Label_Offsets = [0.5]           , $
    color = self.B2ECOLOR)
  ;添加到self中
  self->ADD, [self.ACTUALLINE, self.EXPECTLINE, $
    self.OHORILINE, self.OVERTLINE]
  ;
  oManager.OVIEW->GETPROPERTY, Dimensions = viewDim, viewplane_rect=viewp
  ratio1 = viewp[2]/viewDim[0]
  
  ;创建连线、箭头及计算文字
  self->CREATEARROW, baseLoc = self.BASELOC, expectLoc = self.EXPECTLOC , $
    actualLoc = self.ACTUALLOC, labelDimension = labelDim*ratio1;符号的宽度
    
  self.OPARENT->ADD, self
  
  RETURN, 1
END

;-----------------------------------------------------------------
;
;定义
;
PRO ADLAYBELANALYSIS__DEFINE
  COMPILE_OPT idl2
  
  void = {AdLaybelAnalysis           , $
    ;继承的父类
    INHERITS IDLgrModel            , $
    
    ;参数
    treeID      :   0             , $
    status      :   0             , $
    alpha       :   0.            , $
    b2aColor    :   BYTARR(3)     , $起始点到实际点线颜色
  b2aLineStyle:   0             , $
    b2aLineThick:   0             , $
    
    b2eColor    :   BYTARR(3)     , $起始点到预期点线颜色
  b2eLineStyle:   0             , $
    b2eLineThick:   0             , $
    ;
    HoriLineColor:  BYTARR(3)     , $ 水平线属性
  HoriLineStyle:  0             , $
    HoriLineThick:  0             , $
    
    vertLineColor:  BYTARR(3)     , $ 竖直线属性
  vertLineStyle:  0             , $
    vertLineThick:  0             , $
    ;
    dimension   :   0             , $
    baseLoc     :   DBLARR(3)     , $
    expectLoc   :   DBLARR(3)     , $
    actualLoc   :   DBLARR(3)     , $
    height      :   0.            , $
    ;          status    :   1             , $
    moveXY      : [0,0]           , $
    framePos    : 0               , $
    type        : ''              , $
    
    ;对象
    oSystem     :   OBJ_NEW()     , $
    oParent     :   OBJ_NEW()     , $
    oManager    :   OBJ_NEW()     , $
    
    actualLine  :   OBJ_NEW()     , $ 绘制的线段
  expectLine  :   OBJ_NEW()     , $
    oVertLine   :   OBJ_NEW()     , $
    oHoriLine   :   OBJ_NEW()     , $
    
    image       :   OBJ_NEW()     , $
    oFont       :   OBJ_NEW()     , $
    oVertText   :   OBJ_NEW()     , $
    oHoriText   :   OBJ_NEW()     , $
    actualText  :   OBJ_NEW()     , $
    expectText  :   OBJ_NEW()       $
    }
END