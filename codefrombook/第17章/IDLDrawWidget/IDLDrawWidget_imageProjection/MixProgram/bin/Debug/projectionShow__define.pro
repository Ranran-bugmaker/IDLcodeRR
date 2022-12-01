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
 PRO CENTERTLB, tlb, x, y, NoCenter=nocenter  
    COMPILE_OPT StrictArr
        
    geom = WIDGET_INFO(tlb, /Geometry)
    
    IF N_ELEMENTS(x) EQ 0 THEN xc = 0.5 ELSE xc = FLOAT(x[0])
    IF N_ELEMENTS(y) EQ 0 THEN yc = 0.5 ELSE yc = 1.0 - FLOAT(y[0])
    center = 1 - KEYWORD_SET(nocenter)
    ;
    oMonInfo = OBJ_NEW('IDLsysMonitorInfo')
    rects = oMonInfo -> GetRectangles(Exclude_Taskbar=exclude_Taskbar)
    pmi = oMonInfo -> GetPrimaryMonitorIndex()
    OBJ_DESTROY, oMonInfo
    
    screenSize =rects[[2, 3], pmi]
    
    ; Get_Screen_Size()
    IF screenSize[0] GT 2000 THEN screenSize[0] = screenSize[0]/2 ; Dual monitors.
    xCenter = screenSize[0] * xc
    yCenter = screenSize[1] * yc
    
    xHalfSize = geom.SCR_XSIZE / 2 * center
    yHalfSize = geom.SCR_YSIZE / 2 * center
    
    XOffset = 0 > (xCenter - xHalfSize) < (screenSize[0] - geom.SCR_XSIZE)
    YOffset = 0 > (yCenter - yHalfSize) < (screenSize[1] - geom.SCR_YSIZE)
    
    WIDGET_CONTROL, tlb, XOffset=XOffset, YOffset=YOffset
  END
  PRO SELMAP_WIDGET_EVENT, ev
    COMPILE_OPT idl2
    
    WIDGET_CONTROL, ev.TOP, get_uvalue=pState
    
    tagName = TAG_NAMES(ev, /Structure_Name)
    
    IF tagName EQ 'WIDGET_PROPSHEET_CHANGE' THEN BEGIN
      IF (ev.PROPTYPE NE 0) THEN BEGIN
        value = WIDGET_INFO(ev.ID, Property_Value = ev.IDENTIFIER)
        ev.COMPONENT->SETPROPERTYBYIDENTIFIER, ev.IDENTIFIER, value
        WIDGET_CONTROL, (*pState).PSHEET, /Refresh_Property
        prevImage = (*pState).OMAPPROJECTION->GETPREVIEW()
        WSET, (*pState).WPREVID
        TV, CONGRID(prevImage,300,300)
      ENDIF
    ENDIF
    CASE WIDGET_INFO(ev.ID,/uname) OF
      'ok': BEGIN
        (*pState).SMAP = (*pState).OMAPPROJECTION->_GETMAPSTRUCTURE()
        WIDGET_CONTROL,ev.TOP,/destroy
      END
      'cancel':   WIDGET_CONTROL,ev.TOP,/destroy
      ELSE:
    ENDCASE
  END
  
  FUNCTION SELMAP_WIDGET,sMap
    ;
    wTlb = WIDGET_BASE(title ='投影设置',$
      map=0,TLB_FRAME_ATTR=4, /column)
    wProjSelBase = WIDGET_BASE(wTlb, /column)
    ;投影参数设置对象，初始显示为当前投影(projection=),WGS84坐标系
    oMapProjection = OBJ_NEW('SetMapParamet', $
      Name='设定投影参数' , $
      projection=7,$ ; sMap.PROJECTION        , $
      datum='WGS84'       )
      
    pSheet = WIDGET_PROPERTYSHEET( $
      wProjSelBase, $
      Value = oMapProjection, $
      /Sunken_Frame, $
      Scr_XSize = 310, $
      YSize = 15, $
      UName = 'pSheet', $
      /Multiple_Properties)
      
    wPreview = WIDGET_DRAW( $
      wProjSelBase, $
      xsize=300, $
      ysize=300, $
      retain=2)
    ;
    wControl = WIDGET_BASE(wTlb,/align_center,/row)
    wOK = WIDGET_BUTTON(wControl, value = '确定',$
      uName = 'ok')
    wCancel = WIDGET_BUTTON(wControl, value ='取消', $
      uName = 'cancel')
    WIDGET_CONTROL,wTlb,/real
    CENTERTLB,wtlb
    WIDGET_CONTROL,wTlb,/map
    ;
    WIDGET_CONTROL, wPreview, get_value=wPrevID
    prevImage = oMapProjection->GETPREVIEW()
    WSET, wPrevID
    TV, CONGRID(prevImage,300,300)
    ;
    pState = PTR_NEW({ $
      pSheet:pSheet, $
      sMap : sMap, $
      wPrevID:wPrevID, $
      oMapProjection:oMapProjection })
    WIDGET_CONTROL, wtlb, set_uvalue=pState
    
    XMANAGER,'selMap_Widget',wtlb
    
    RETURN,(*pState).SMAP
  END
  ;销毁析构
  PRO PROJECTIONShow::CLEANUP
  
    IF OBJ_VALID(self.OVIEW) THEN OBJ_DESTROY, self.OVIEW
    IF OBJ_VALID(self.OMODEL) THEN OBJ_DESTROY, self.OMODEL
  END
  PRO PROJECTIONShow::SelectMapProjection
    CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    self.SMAP = SELMAP_WIDGET(MAP_PROJ_INIT('Equirectangular'))
    self.INITVIEW
  END
  
  ;鼠标滚轮时的事件
  PRO PROJECTIONShow::WheelEvents,wType,xPos,yPos
    COMPILE_OPT idl2
    CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    ;void = dialog_message()
    
    self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
    oView.GETPROPERTY, viewPlane_Rect = viewRect
    
    IF wType GT 0 THEN rate = 0.8 ELSE rate = 1.125
    
    oriDis =[xPos,yPos]*viewRect[2:3]/winDims
    viewRect[0:1]+=(1-rate)*oriDis
    viewRect[2:3]= viewRect[2:3]*rate
    ;
    oView.SETPROPERTY, viewPlane_Rect = viewRect
    self.OWINDOW.DRAW
  END
  
  
  ;鼠标点击时的事件
  PRO PROJECTIONShow::MousePress,xpos,ypos
    COMPILE_OPT idl2
    CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    self.MOUSELOC[0:1] = [xPos,yPos]
  END
  ;鼠标弹起时的操作
  PRO PROJECTIONShow::MouseRelease,xpos,ypos
    COMPILE_OPT idl2
    
    curLoc = [xPos,yPos]
    self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
    oView.GETPROPERTY, viewPlane_Rect = viewRect
    
    self.OWINDOW.DRAW
  END
  PRO PROJECTIONShow::MouseMotion,xpos,ypos
    ;
    curLoc = [xPos,yPos]
    ;
    self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
    oView.GETPROPERTY, viewPlane_Rect = viewRect
    
    ;屏幕偏移量
    offset = curLoc- self.MOUSELOC
    ;对应偏移量
    viewRect[0:1]-=offset*viewRect[2:3]/WinDims
    oView.SETPROPERTY, viewPlane_Rect = viewRect
    self.OWINDOW.DRAW
    ;
    self.MOUSELOC = curLoc
    
  END
  PRO PROJECTIONShow::ChangeDrawSize,width,height
  CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    IF N_ELEMENTS(width) THEN BEGIN
      self.OWINDOW.GETPROPERTY, graphics_tree = oView
      oView.GETPROPERTY,ViewPlane_Rect = viewP,dimensions = dims
      oriWL = viewP[2:3]
      viewP[2:3] =viewP[2:3]*[width,height]/dims
      viewP[0:1]+=(oriWL-viewP[2:3])/2
      
      oView.SETPROPERTY,dimension = [width,height],viewPlane_Rect= viewP
      self.OWINDOW.DRAW
      
    ENDIF
  END
  PRO PROJECTIONShow::DRAW,oDraw
  end
  
  PRO PROJECTIONShow::INIT_contents,uvrange
    COMPILE_OPT idl2
    CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    self.OMODEL =  OBJ_NEW('IDLgrModel')
    oImgModel = OBJ_NEW('IDLgrModel')
    OPOLYMODEL = OBJ_NEW('IDLgrModel')
    
    ;;读取图像数据
    image = FILE_DIRNAME(ROUTINE_FILEPATH("PROJECTIONShow__DEFINE"))+ $
      "\PROJECTION\day.jpg"
    READ_JPEG, image, data
    
    red0 = REFORM(data[0,*,*])
    green0 = REFORM(data[1,*,*])
    blue0 = REFORM(data[2,*,*])
    
    ;转换图像的经纬度范围到特定的投影下
    red1 = MAP_PROJ_IMAGE( red0, MAP_STRUCTURE=self.SMAP, $
      [-180, -90, 180, 90] )
    green1 = MAP_PROJ_IMAGE( green0, MAP_STRUCTURE=self.SMAP, $
      [-180, -90, 180, 90] )
    blue1 = MAP_PROJ_IMAGE( blue0, MAP_STRUCTURE=self.SMAP, $
      [-180, -90, 180, 90] )
    ;
    data[0,*,*] = red1
    data[1,*,*] = green1
    data[2,*,*] = blue1
    
    uRange = uvRange[2]-uvRange[0]
    vRange = uvRange[3]-uvRange[1]
    
    ;添加图像对象
    OIMGMODEL->ADD, OBJ_NEW('IDLgrImage', $
      data= data, $
      dimensions=[uRange,vRange], $
      location=[uvRange[0:1],0]   )
      
    shpFiles = FILE_DIRNAME(ROUTINE_FILEPATH("PROJECTIONShow__DEFINE"))+ $
      "\PROJECTION\shapefile\"+["continents.shp","china.shp"]
    color = [[255,0,0],[200,200,0]]
    
    FOR ii=0,1 DO BEGIN
      shapeFile = OBJ_NEW('IDLffShape', (shpFiles)[ii])
      shapeFile->GETPROPERTY, N_Entities = nEntities
      
      FOR i=0, nEntities-1 DO BEGIN
        entitie = shapeFile->GETENTITY(i)
        IF PTR_VALID(entitie.MEASURE) THEN BEGIN
          HELP,'adf'
        ENDIF
        IF PTR_VALID(entitie.PARTS) NE 0 THEN BEGIN
          cuts = [*entitie.PARTS, entitie.N_VERTICES]
          FOR j=0, entitie.N_PARTS-1 DO BEGIN
            tempLon = (*entitie.VERTICES)[0,cuts[j]:cuts[j+1] - 1]
            tempLat = (*entitie.VERTICES)[1,cuts[j]:cuts[j+1] - 1]
            
            vert = MAP_PROJ_FORWARD([tempLon,tempLat], $
              Map_Structure = self.SMAP, $
              Polylines = polyLines)
            IF N_ELEMENTS(vert) GT 2 THEN BEGIN
              tempPlot = OBJ_NEW('IDLgrPolyline', $
                vert[0,*], $
                vert[1,*], $
                LONARR(1,N_ELEMENTS(vert[0,*])), $
                Polylines = polyLines    , $
                Alpha_Channel = 1, $
                color = color[*,ii])
              OPOLYMODEL->ADD,tempPlot
            ENDIF
          ENDFOR
        ENDIF
        shapeFile->DESTROYENTITY, entitie
      ENDFOR
      OBJ_DESTROY, shapeFile
    ENDFOR
    ;
    self.OMODEL.ADD,[oImgModel,OPOLYMODEL]
  END
  PRO PROJECTIONShow::InitView
  CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    self.OWINDOW.GETPROPERTY, dimension= dims
    ;系统显示范围
    range = [-90,-180, 90,  180]
    ;设立系统坐标系
    tempArr = BYTARR(2,2)
    tempArr = MAP_PROJ_IMAGE(tempArr , $
      [-180, -90, 180, 90]    , $
      Map = self.SMAP, $
      UVrange = uvrange   )
      
    tempArr = 0B
    self.UVRANGE = uvrange
    ;
    vd = dims
    uRange = self.UVRANGE[2]-self.UVRANGE[0]
    vRange = self.UVRANGE[3]-self.UVRANGE[1]
    
    xrate = DOUBLE(vd[0])/uRange
    yrate = DOUBLE(vd[1])/vRange
    vp = DBLARR(4)
    IF xrate GT yrate THEN BEGIN
      vp[3] = vRange
      vp[2] = DOUBLE(vd[0])/vd[1]*vp[3]
      vp[1] = self.UVRANGE[1]
      vp[0] = self.UVRANGE[0]-(vp[2]-uRange)/2.
    ENDIF ELSE BEGIN
      vp[2] = uRange
      vp[3] = DOUBLE(vd[1])/vd[0]*vp[2]
      vp[0] = self.UVRANGE[0]
      vp[1] = self.UVRANGE[1]-(vp[3]-vRange)/2.
    ENDELSE
    IF OBJ_VALID(self.OVIEW) THEN OBJ_DESTROY,self.OVIEW
    self.OVIEW = OBJ_NEW('IDLgrView', viewplane_rect=vp,$
      dimension = dims)
      
    ;转换图像的经纬度
    self.INIT_CONTENTS,uvrange
    self.OVIEW.ADD,self.OMODEL
    self.OWINDOW.SETPROPERTY, graphics_tree = self.OVIEW
    
    (self.OWINDOW).DRAW
  END
  PRO  PROJECTIONShow::oriShow
    CATCH, error_status
    IF Error_status NE 0 THEN RETURN
    self.SMAP = MAP_PROJ_INIT('Equirectangular')
    
    self.INITVIEW
  END
  
  FUNCTION PROJECTIONShow::INIT, $
      drawID,  _Extra=extra
    COMPILE_OPT idl2
    IF (self->IDLGRMODEL::INIT(_Extra=extra) NE 1) THEN RETURN, 0
    
    ;传入的drawID
    WIDGET_CONTROL, drawID, get_Value = oWindow
    
    
    self.OWINDOW = oWindow
    self.ORISHOW
    RETURN, 1
  END
  
  PRO PROJECTIONSHOW__DEFINE
    str = {PROJECTIONShow, $
      INHERITS IDLgrModel, $
      mouseType : 0B, $;鼠标状态，0-默认,1-平移,2-放大,3-缩小。
      mouseLoc : FLTARR(2), $
      oView:OBJ_NEW(),$
      oWindow:OBJ_NEW(), $
      oModel:OBJ_NEW(), $
      uvRange     : DBLARR(4), $
      sMap : MAP_PROJ_INIT('Equirectangular')  }
  END
  PRO SDRAW,wDraw
    WIDGET_CONTROL, wDraw, get_Value = oWin
    ;层次体系结构
    oView = OBJ_NEW('IDLgrView',viewPlane_rect =[0,0,1,1])
    oModel = OBJ_NEW('IDLgrModel')
    oView->ADD,oModel;
    ;你要做的是修改image为IDLgrVolume
    imgdata = DIST(400)
    oimage = OBJ_NEW('IDLgrImage',imgdata)
    oModel->ADD,oImage
    ;归一化坐标处理，XY方向
    oImage->GETPROPERTY, XRANGE = xr, $
      YRange = yr
    xs = NORM_COORD(xr)
    ys = NORM_COORD(yr)
    ;  zs = Norm_coord(zr)
    ;
    oImage->SETPROPERTY, xCoord_Conv = xs, $
      yCoord_Conv = ys
    ;显示
    oWin->DRAW,oView
  END
  PRO TEST
    ;
    wTlb = WIDGET_BASE()
    wDraw = WIDGET_DRAW(wtlb,$
      xSize = 400,$
      ySize = 400, $
      retain=0,$
      graphics_level = 2)
    WIDGET_CONTROL, wTlb,/real
    ;
    ;file = "D:\2011UC\MixProgram\MixProgram\bin\Debug\can_tmr.jpg"
    oFile = OBJ_NEW('PROJECTIONShow', wDraw)
    ofile.SELECTMAPPROJECTION
  ;oFile.DRAW
  ;sdraw,wDraw
  ;
  ;XMANAGER,'test',wTlb
    
    
  END
