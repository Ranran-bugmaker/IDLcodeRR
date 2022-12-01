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
; $Id: //depot/Release/IDL_81/idl/idldir/examples/doc/objects/sel_obj.pro#1 $
;
; Copyright (c) 1997-2011, ITT Visual Information Solutions. All
;       rights reserved.
;+
; NAME:
;	SEL_OBJ
;
; PURPOSE:
;	This procedure demonstrates how to perform selections of
;	views, models, and graphic atoms using object graphics.
;
;	This procedure creates a simple widget application that allows
;       the user to click the mouse within views to make selections.
;       The user may choose between model selections or graphic atom
;       selections.  The current selection(s) are identified for the user.
;
; CATEGORY:
;	Object graphics.
;
; CALLING SEQUENCE:
;	SEL_OBJ
;
; MODIFICATION HISTORY:
; 	Written by:	DD, February 1997.
;-

;----------------------------------------------------------------------------
; SEL_OBJ_EVENT
;
; Purpose:
;  Handle events for the selection example.
;
PRO SEL_OBJ_EVENT, sEvent

  ; Handle kill requests.
  IF (TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL, sEvent.TOP, GET_UVALUE=sState, /NO_COPY
    OBJ_DESTROY, sState.OSCENE
    OBJ_DESTROY, sState.OIMAGE
    WIDGET_CONTROL, sEvent.TOP, /DESTROY
    RETURN
  ENDIF
  
  ; Handle other events.
  WIDGET_CONTROL, sEvent.ID, GET_UVALUE=uval
  CASE uval OF
    'DRAW': BEGIN
      WIDGET_CONTROL, sEvent.TOP, GET_UVALUE=sState, /NO_COPY
      
      CASE sEvent.TYPE OF
        0: BEGIN ; Button Press.
          ; First, select the view.
          oViewArr = sState.OWINDOW->SELECT(sState.OSCENE, $
            [sEvent.X, sEvent.Y], DIMENSIONS=[20,20] )
          nSel = N_ELEMENTS(oViewArr)
          ; If we have a view selection...
          IF ((SIZE(oViewArr))[0] NE 0) THEN BEGIN
            oView = oViewArr[0]
            
            ; Now select an object within the view.
            oObjArr = sState.OWINDOW->SELECT(oView, $
              [sEvent.X, sEvent.Y], DIMENSIONS=[20,20] )
            nSel = N_ELEMENTS(oObjArr)
            
            ; If we have an object selection...
            IF ((SIZE(oObjArr))[0] NE 0) THEN BEGIN
              FOR i=0, nSel-1 DO BEGIN
                oObjArr[i]->GETPROPERTY, NAME=name
                IF (i EQ 0) THEN $
                  label = 'Current Selections: ' + name $
                ELSE $
                  label = label + ', ' + name
              ENDFOR
            ENDIF ELSE BEGIN
              oView->GETPROPERTY, NAME=name
              label = 'Current Selections: ' + name
            ENDELSE
          ENDIF ELSE BEGIN
            label = 'Current Selections: <None>'
          ENDELSE
          WIDGET_CONTROL, sState.WLABEL, SET_VALUE=label
        END
        4: BEGIN ; Exposure.
          sState.OWINDOW->DRAW, sState.OSCENE
        END
        ELSE: BEGIN
        ; Do Nothing.
        END
      ENDCASE
      WIDGET_CONTROL, sEvent.TOP, SET_UVALUE=sState, /NO_COPY
    END
    'SELECT': BEGIN
      WIDGET_CONTROL, sEvent.TOP, GET_UVALUE=sState, /NO_COPY
      ; Set the model as a selection target as requested by user.
      sState.OSURFMODEL->SETPROPERTY, SELECT_TARGET=(1-sEvent.VALUE)
      sState.OPLOTMODEL->SETPROPERTY, SELECT_TARGET=(1-sEvent.VALUE)
      WIDGET_CONTROL, sEvent.TOP, SET_UVALUE=sState, /NO_COPY
    END
  ENDCASE
END

;----------------------------------------------------------------------------
; SEL_OBJ
;
; Purpose:
;  This procedure creates a simple widget application that demonstrates
;  object selection.
;
PRO SEL_OBJ
  xdim = 480
  ydim = 360
  
  ; Create the widgets.
  wBase = WIDGET_BASE(TITLE='Selection Example', /COLUMN, $
    /TLB_KILL_REQUEST_EVENTS )
  wDraw = WIDGET_DRAW(wBase, XSIZE=xdim, YSIZE=ydim, GRAPHICS_LEVEL=2, $
    RETAIN=0, $
    /BUTTON_EVENTS, /EXPOSE_EVENTS, UVALUE='DRAW')
  wSelGroup = CW_BGROUP(wBase, $
    ['Model', 'Graphic Atoms'], $
    LABEL_LEFT='Selection Target:', /EXCLUSIVE, /ROW, $
    /NO_RELEASE, SET_VALUE=1, UVALUE='SELECT')
  wLabel = WIDGET_LABEL(wBase, VALUE='Current Selections: <None>', $
    /DYNAMIC_RESIZE)
    
  WIDGET_CONTROL, wBase, /REALIZE
  WIDGET_CONTROL, wDraw, GET_VALUE=oWindow
  
  ; Create a scene.
  oScene = OBJ_NEW('IDLgrScene')
  
  ; Create the views.
  aspect = FLOAT(xdim/2) / FLOAT(ydim)
  IF (aspect GT 1.) THEN BEGIN
    vrect = [-aspect, -1, aspect * 2.0, 2.0]
  ENDIF ELSE BEGIN
    vrect = [-1, -1 - (((1./aspect) - 1)/2.), 2, 2.0/aspect]
  ENDELSE
  oView1 = OBJ_NEW('IDLgrView', LOCATION=[0,0], DIMENSIONS=[xdim/2,ydim],$
    COLOR=[60,60,60], NAME='View 1' )
  oScene->ADD, oView1
  oView2 = OBJ_NEW('IDLgrView', LOCATION=[xdim/2,0], $
    DIMENSIONS=[xdim/2,ydim], VIEWPLANE_RECT=vrect, $
    COLOR=[0,0,0], NAME='View 2')
  oScene->ADD, oView2
  
  ; Create a top-level plot model for the first view.
  oPlotModel = OBJ_NEW('IDLgrModel', NAME='Cosine Plot Model')
  oView1->ADD, oPlotModel
  
  ; Create some plot data.
  xData = FINDGEN(100) / 99.
  yData = COS(xData*!PI)
  xMax = MAX(xData, MIN=xMin)
  yMax = MAX(yData, MIN=yMin)
  xRange = xMax - xMin
  yRange = yMax - yMin
  xPad = xRange * 0.3
  yPad = yRange * 0.2
  oView1->SETPROPERTY, VIEWPLANE_RECT = [xMin-xPad, yMin - yPad, $
    xRange + 2*xPad, yRange + 2*yPad]
  ; X axis.
  xTickLen = 0.05 * yRange
  oXAxis = OBJ_NEW('IDLgrAxis', 0, LOCATION=[xMin, yMin], $
    RANGE=[xMin, xMax], COLOR=[60,200,90], TICKLEN=xTicklen, $
    NAME='X Axis', MAJOR=3)
  oPlotModel->ADD, oXAxis
  
  ; Y axis.
  yTickLen = 0.05 * xRange
  oYAxis = OBJ_NEW('IDLgrAxis', 1, LOCATION=[xMin, yMin], $
    RANGE=[yMin, yMax], COLOR=[60,200,90], TICKLEN=yTicklen, $
    NAME='Y Axis')
  oPlotModel->ADD, oYAxis
  
  ; Plot.
  oPlot = OBJ_NEW('IDLgrPlot', xDAta, yData, COLOR=[60,200,90], $
    NAME='Plot Line')
  oPlotModel->ADD, oPlot
  
  ; Create a top-level surface model for the second view.
  oSurfModel = OBJ_NEW('IDLgrModel', NAME='DIST Model')
  oSurfModel->ROTATE, [1,0,0], -90
  oSurfModel->ROTATE, [0,1,0], 30
  oSurfModel->ROTATE, [1,0,0], 30
  oView2->ADD, oSurfModel
  
  ; Create some surface data.
  zData = BESELJ(SHIFT(DIST(20),10,10)/2,0) * 0.8
  xData = (FINDGEN(20) - 10.) / 20.
  yData = xData
  
  ; Surface.
  oSurface = OBJ_NEW('IDLgrSurface', zData, xData, yData, COLOR=[255,90,60],$
    STYLE=1, NAME='Surface')
  oSurfModel->ADD, oSurface
  
  oImage = OBJ_NEW('IDLgrImage', BYTSCL(zData), /GREYSCALE)
  xMax = MAX(xData, MIN=xMin)
  yMax = MAX(yData, MIN=yMin)
  zMax = MAX(zData, MIN=zMin)
  zMin = zMin - 0.2
  oPolygon = OBJ_NEW('IDLgrPolygon', [xMin, xMax, xMax, xMin], $
    [yMin, yMin, yMax, yMax], [zMin, zMin, zMin, zMin], $
    TEXTURE_MAP=oImage, $
    TEXTURE_COORD=[[0,0],[1,0],[1,1],[0,1]],$
    COLOR=[255,255,255], NAME='Image' )
  oSurfModel->ADD, oPolygon
  
  ; Draw.
  oWindow->DRAW, oScene
  
  ; Store the state in a structure.
  sState = { wLabel : WLABEL,        $
    oWindow: oWindow,       $
    oScene: oScene,         $
    oImage: oImage,         $
    oPlotModel: oPlotModel, $
    oSurfModel: oSurfModel  $
    }
  WIDGET_CONTROL, wBase, SET_UVALUE=sState, /NO_COPY
  
  XMANAGER, 'sel_obj', wBase, /NO_BLOCK
END