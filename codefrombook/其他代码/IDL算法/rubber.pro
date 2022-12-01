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
; $Id: planet.pro,v 1.7 1998/02/23 17:35:09 slasica Exp $
;
; Copyright (c) 1997-1998, Research Systems, Inc.  All rights reserved.
;   Unauthorized reproduction prohibited.
;+
; NAME:
;   RUBBER
;
; PURPOSE:
;   This procedure demonstrates the use of object graphics to
;   fool around with texture maps and dynamic surfaces
;
;   From original OpenGL source by Nate Robbins
;
; CATEGORY:
;   Object graphics.
;
; CALLING SEQUENCE:
;   Rubber
;
; MODIFICATION HISTORY:
;   Written by:  RJF, May 1998 (somewhere between Sydney and LA)
;                  (wouldn't a 3D version be cool???)
;-


PRO rubber::update,mousex,mousey

  IF ((self.grab NE -1) AND (N_PARAMS() NE 2)) THEN BEGIN
    mousex = (*self.pX)[self.grab]
    mousey = (*self.pY)[self.grab]
  ENDIF
  
  d = FLTARR(3)
  
  !except = 0
  
  FOR k = 0, self.spring_count-1 DO BEGIN
  
    i = (*self.spring)[k].i
    j = (*self.spring)[k].j
    
    d[0] = (*self.pX)[i] - (*self.pX)[j]
    d[1] = (*self.pY)[i] - (*self.pY)[j]
    d[2] = (*self.pZ)[i] - (*self.pZ)[j]
    
    l = TOTAL(d^2.0)
    
    IF (l NE 0.0) THEN BEGIN
    
      l = SQRT(l)
      
      d = d / l
      
      a = l - (*self.spring)[k].r
      
      (*self.v)[*,i] = (*self.v)[*,i] - d*a*self.spring_ks
      
      (*self.v)[*,j] = (*self.v)[*,j] + d*a*self.spring_ks
      
    ENDIF
    
  ENDFOR
  
  j = CHECK_MATH()
  !except = 1
  
  FOR k = 0, self.d[2]-1 DO BEGIN
    IF ((*self.nail)[k] NE 1) THEN BEGIN
    
      (*self.pX)[k] = (*self.pX)[k] + (*self.v)[0,k]
      (*self.pY)[k] = (*self.pY)[k] + (*self.v)[1,k]
      (*self.pZ)[k] = (*self.pZ)[k] + (*self.v)[2,k]
      
      (*self.v)[*,k] = (*self.v)[*,k] * (1.0 - self.drag)
      
    ENDIF
  ENDFOR
  
  (*self.pZ) = (*self.pZ) > 0.0
  (*self.pZ) = (*self.pZ) < 250.0
  
  IF (self.grab NE -1) THEN BEGIN
    IF ((*self.nail)[self.grab] NE 1) THEN BEGIN
      (*self.pX)[self.grab] = mousex
      (*self.pY)[self.grab] = mousey
      (*self.pZ)[self.grab] = 250.0
    ENDIF
  ENDIF
  
  self.oSurf->setproperty,DATAZ=*(self.pZ),$
    DATAX=*(self.pX),DATAY=*(self.pY)
    
END

FUNCTION rubber::init,oSurf,dx,dy,imdx,imdy

  self.d = [dx,dy,dx*dy]
  self.oSurf = oSurf
  self.grab = -1
  self.img = [imdx,imdy]
  
  nail = INTARR(self.d[0],self.d[1])
  v = FLTARR(3,self.d[2])
  tc = FLTARR(2,self.d[0],self.d[1])
  
  datax = FLTARR(self.d[0],self.d[1])
  datay = FLTARR(self.d[0],self.d[1])
  dataz = FLTARR(self.d[0],self.d[1])
  dataz[*] = 0
  
  nail[*] = 0
  nail[0,*] = 1
  nail[dx-1,*] = 1
  nail[*,0] = 1
  nail[*,dy-1] = 1
  v[*] = 0.0
  
  FOR j = 0, dy-1 DO BEGIN
    FOR i = 0, dx-1 DO BEGIN
      tc[0,i,j] = FLOAT(i)/(dx - 1.0)
      tc[1,i,j] = FLOAT(j)/(dy - 1.0)
      datax[i,j] = (FLOAT(i)/(dx - 1.0))*imdx
      datay[i,j] = (FLOAT(j)/(dy - 1.0))*imdy
    ENDFOR
  ENDFOR
  
  self.pX = PTR_NEW(datax,/NO_COPY)
  self.pY = PTR_NEW(datay,/NO_COPY)
  self.pZ = PTR_NEW(dataz,/NO_COPY)
  self.v = PTR_NEW(v,/NO_COPY)
  self.nail = PTR_NEW(nail,/NO_COPY)
  
  self.oSurf->setproperty,TEXTURE_COORD=tc,DATAZ=*(self.pZ),$
    DATAX=*(self.pX),DATAY=*(self.pY)
    
  self.spring_count = (dx-1)*(dy) + (dy-1)*(dx)
  struct = { spring, i: 1, j: 1, r: 0.0 }
  spring = REPLICATE(struct,self.spring_count)
  
  k = 0
  FOR i = 0, dx - 2 DO BEGIN
    FOR j = 0, dy - 1 DO BEGIN
      m = i + j*dx
      spring[k].i = m
      spring[k].j = m+1
      spring[k].r = (imdx-1.0)/(dx - 1.0);
      k = k + 1
    ENDFOR
  ENDFOR
  
  FOR j = 0, dy - 2 DO BEGIN
    FOR i = 0, dx - 1 DO BEGIN
      m = i + j*dx
      spring[k].i = m
      spring[k].j = m+dx
      spring[k].r = (imdy-1.0)/(dy - 1.0);
      k = k + 1
    ENDFOR
  ENDFOR
  
  self.spring = PTR_NEW(spring,/NO_COPY)
  
  self.spring_ks = 0.3
  self.drag = 0.5
  
  RETURN,1
END

PRO rubber::ungrab
  self.grab = -1
END

PRO rubber::reset

  FOR i = 0, self.d[0]-1 DO BEGIN
    FOR j = 0, self.d[1]-1 DO BEGIN
      (*self.pX)[i,j] = (FLOAT(i)/(self.d[0] - 1.0))*self.img[0]
      (*self.pY)[i,j] = (FLOAT(j)/(self.d[1] - 1.0))*self.img[1]
    ENDFOR
  ENDFOR
  
  (*self.pZ)[*] = 0
  (*self.v)[*] = 0
  
END

; Find the point closest to the mouse point
PRO rubber::grab,x,y

  min_i = -1
  min_d = 0.0
  
  dx = FLTARR(2)
  
  FOR i = 0, self.d[2]-1 DO BEGIN
    dx[0] = (*self.pX)[i] - x
    dx[1] = (*self.pY)[i] - y
    d = TOTAL(dx^2)
    IF ((min_i[0] EQ -1) OR (d LT min_d)) THEN BEGIN
      min_i = i
      min_d = d
    ENDIF
  ENDFOR
  
  self.grab = min_i
  
END

PRO rubber::cleanup
  PTR_FREE,self.pX,self.pY,self.pZ,self.v,self.nail,self.spring
END

PRO rubber__define

  struct = { rubber, $
    oSurf: OBJ_NEW(), $
    grab: -1, $
    spring_count: 1, $
    pX: PTR_NEW(), pY: PTR_NEW(), pZ: PTR_NEW(), $
    v: PTR_NEW(), $
    nail: PTR_NEW(), $
    spring: PTR_NEW(), $
    img: LONARR(2), $
    spring_ks: 0.0, $
    drag: 0.0, $
    d: LONARR(3) $
    }
END

;----------------------------------------------------------------------------
FUNCTION toggle_state, wid

  WIDGET_CONTROL, wid, GET_VALUE=name
  
  s = STRPOS(name, '(off)')
  IF (s NE -1) THEN BEGIN
    STRPUT, name, '(on) ', s
    ret = 1
  ENDIF ELSE BEGIN
    s = STRPOS(name, '(on) ')
    STRPUT, name, '(off)',s
    ret = 0
  ENDELSE
  
  WIDGET_CONTROL, wid, SET_VALUE=name
  RETURN, ret
END

;----------------------------------------------------------------------------
; RUBBER_EVENT
;
; Purpose:
;  Handle events for the rubber example.
;
PRO rubber_event, sEvent

  ; Handle a kill request.
  IF TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
    WIDGET_CONTROL, sEvent.top, GET_UVALUE=sState
    OBJ_DESTROY, sState.oRubber
    WIDGET_CONTROL, sEvent.top, /DESTROY
    RETURN
  ENDIF
  
  ; Handle other events.
  WIDGET_CONTROL, sEvent.id, GET_UVALUE=uval
  WIDGET_CONTROL, sEvent.top, GET_UVALUE=sState, /NO_COPY
  CASE uval OF
    'SLDR' : BEGIN
      sState.timer = sEvent.value
    END
    'INTERP' : BEGIN
      j = toggle_state(sEvent.id)
      sState.oSurf->setproperty,TEXTURE_INTERP=j
    END
    'WIRE' : BEGIN
      j = toggle_state(sEvent.id)
      sState.oSurf->setproperty,STYLE= 1 +j
    END
    'RESET' : BEGIN
      sState.oRubber->reset
      sState.oWindow->draw
    END
    'TIMER' : BEGIN ; Timer event for automotion.
      sState.oRubber->update
      sState.oWindow->draw
      WIDGET_CONTROL, sState.wTimerBase, TIMER=sState.timer
    END
    'DRAW': BEGIN  ; Expose event.
      IF (sEvent.type EQ 4) THEN BEGIN
        sState.oWindow->draw
      ENDIF
      
      ; Handle other events: Button press.
      IF (sEvent.type EQ 0) THEN BEGIN
        WIDGET_CONTROL, sState.wDraw, DRAW_MOTION=1
        sState.oRubber->grab,sEvent.x*sState.scale,sEvent.y*sState.scale
      ; Button up
      ENDIF ELSE IF (sEvent.type EQ 1) THEN BEGIN
        WIDGET_CONTROL, sState.wDraw, DRAW_MOTION=0
        sState.oRubber->ungrab
      ; Button motion
      ENDIF ELSE IF (sEvent.type EQ 2) THEN BEGIN
        sState.oRubber->update,sEvent.x*sState.scale,sEvent.y*sState.scale
        sState.oWindow->draw
      ENDIF
    END
  ENDCASE
  WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState, /NO_COPY
END

;----------------------------------------------------------------------------
; RUBBER
;
; Purpose:
;  This procedure uses a polygon "rubber" sheet to allow the user to
;  interactively deform an image.
;
PRO rubber, SCALE=scale

  READ_JPEG,filepath('rose.jpg', SUBDIRECTORY=['examples','data']),iData
  
  IF (N_ELEMENTS(scale) EQ 0) THEN scale = 2.0
  
  sz = SIZE(iData)
  xdim = sz[2]
  ydim = sz[3]
  
  ; Create the widgets.
  wBase = WIDGET_BASE(/COLUMN, XPAD=0, YPAD=0, TITLE='Rubber', $
    /TLB_KILL_REQUEST_EVENTS)
  wDraw = WIDGET_DRAW(wBase, XSIZE=xdim*scale, YSIZE=ydim*scale, UVALUE='DRAW', $
    RETAIN=0, /EXPOSE_EVENTS, GRAPHICS_LEVEL=2, /BUTTON)
  wTimerBase = WIDGET_BASE(wBase, /ROW, UVALUE='TIMER' )
  wOptions = WIDGET_BUTTON(wTimerBase,Menu=2,Value="Options",/frame)
  wBut = WIDGET_BUTTON(wOptions,VALUE="Texturing (on) ",UVALUE='WIRE')
  wBut = WIDGET_BUTTON(wOptions,VALUE="Interpolation (off)",UVALUE='INTERP')
  wBut = WIDGET_BUTTON(wOptions,VALUE="Reset",UVALUE='RESET')
  
  wSlider = cw_fslider(wTimerBase,/DRAG,MIN=0.01,MAX=1.0,VALUE=0.1, $
    uval='SLDR')
    
  WIDGET_CONTROL, wBase, /REALIZE
  WIDGET_CONTROL, wDraw, GET_VALUE=oWindow
  
  ; Create a view.
  myview = [0,0,xdim,ydim]
  oView = OBJ_NEW('IDLgrView', COLOR=[0,0,0], EYE = 300, $
    ZCLIP=[251.0,-1.0], VIEWPLANE_RECT=myview )
    
  ; Create the top level model.
  oTop = OBJ_NEW('IDLgrModel')
  oView->add,oTop
  
  oImage = OBJ_NEW('IDLgrImage',iData,HIDE=1)
  oTop->add,oImage
  oSurf = OBJ_NEW('IDLgrSurface',STYLE=2,TEXTURE_MAP=oImage, $
    COLOR=[255,255,255])
  oTop->add,oSurf
  
  ; Attach the view to the window
  oWindow->setproperty,GRAPHICS_TREE=oView
  
  ; Create the rubber object
  oRubber = OBJ_NEW('rubber',oSurf,xdim/15,ydim/15,xdim,ydim)
  
  sState = { wTimerBase: wTimerBase, $
    wDraw: wdraw, $
    oWindow: oWindow, $
    oSurf: oSurf, $
    oRubber: oRubber, $
    scale: 1.0/scale, $
    timer: 0.1 $
    }
    
  WIDGET_CONTROL, wBase, SET_UVALUE=sState
  
  WIDGET_CONTROL, wTimerBase, TIMER=sState.timer
  
  xmanager, 'rubber', wBase, /NO_BLOCK
END

