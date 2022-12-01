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
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO christmasLight::toggle
  ;toggles a light on or off depending upon its state
  IF self.on EQ 1 THEN BEGIN
    self.on = 0 ;turn it off
    self.oPoly->Setproperty,hide=1
  ENDIF ELSE BEGIN
    self.on = 1 ;turn it on
    self.oPoly->Setproperty,hide=0
  ENDELSE
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

FUNCTION christmasLight::Init
  ;initialization for the individual light on the tree
  ;initialize the super class
  IF (self->Idlgrmodel::init(_extra=extra) NE 1) THEN RETURN, 0
  ;y goes from -0.5 to +0.75 so height = 1.25 and is offset by -0.5
  ;radius goes from 0 to 0.5, theta from 0 to 2pi
  ;choose random y, radius and theta
  height = 1.25
  y = (RANDOMU(seed,1) * 1.25)
  radius = 0.5
  theta = RANDOMU(seed,1) * 2. * !pi
  ;now we can determine x and z so that light will fit on surface of the "tree"
  x = ((height-y)/height) * radius * COS(theta)
  z = ((height-y)/height) * radius * SIN(theta)
  Mesh_obj,4,verts, conn, REPLICATE(0.03 ,20,20) ;.03 is the size of the light
  verts[0,*] = verts[0,*] + x[0]
  verts[1,*] = verts[1,*] + y[0] - 0.5
  verts[2,*] = verts[2,*] + z[0]
  color = [RANDOMU(seed,1)*256,RANDOMU(seed,1)*256,RANDOMU(seed,1)*256]
  self.oPoly = OBJ_NEW('IDLgrPolygon',data=verts,polygons=conn,color=color,shading=0)
  self->Add,self.oPoly
  ;light is created on
  self.on = 1
  RETURN,1
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO christmasLight::Cleanup
  ;cleanup routine
  OBJ_DESTROY,self.oPoly
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmaslight__define
  ;definition of the christmasLight object
  void = {christmasLight, $
    inherits IDLgrModel, $
    oPoly : OBJ_NEW(), $ ;object holder
    on : 0 } ;on or off flag
    
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
;  CHRISTMAS TREE CODE FROM HERE DOWN
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastreeexit,event
  ;called from the pull down menu
  WIDGET_CONTROL,event.top,/destroy
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmascleanup, base
  ;called no matter how the GUI is destroyed
  WIDGET_CONTROL,base,get_uvalue=object
  OBJ_DESTROY,object
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree_event,event
  ;event handler for the top base
  WIDGET_CONTROL,event.top, get_uvalue=object
  eventType = TAG_NAMES(event, /struct) ;find out what it is
  CASE eventType OF
    ;resize events go here and keep the window square
    'WIDGET_BASE' : object->Resize, newSize = (event.x + event.y)/2
    'WIDGET_TIMER':BEGIN ;this timer rotates the tree
    object->Turnthetree
    WIDGET_CONTROL,event.top,timer=1 ;set the timer again
  END
  ELSE:
END

RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Blinkthelights,event
  ;handles the timer events for the lights
  WIDGET_CONTROL,event.top, get_uvalue=object
  object->Blinkthelights
  WIDGET_CONTROL,event.id,timer=0.1 ;set the light timer
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree::Blinkthelights
  ;picks a random light to toggle on or off
  ranIndex = LONG(RANDOMU(seed,1) * self.nLights)
  (*self.oLightArrayPtr)[ranIndex[0]]->Toggle
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree::resize, newSize=newSize
  ;resizes the draw widget and redraws the view

  WIDGET_CONTROL,self.drawId,draw_xsize=newSize,draw_ysize=newSize
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree::turnTheTree
  ;rotates the tree by 10 degrees each time around the y axis
  self.oRotateModel->Rotate,[0,1,0],10
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

FUNCTION Christmastree::Init, nlights=nlights
  ;initialization routine for the christmas tree
  IF NOT KEYWORD_SET(nlights) THEN nlights=50
  ;initialize the super class
  IF (self->Idlgrmodel::init(_extra=extra) NE 1) THEN RETURN, 0
  
  ;Get the screen size.
  DEVICE, get_screen_size = screenSize
  xdim = screenSize[0]*.50 ;about 50 percent of the screen size
  ydim=xdim  ;keep isotropic
  
  base=WIDGET_BASE(title='Christmas Tree',column=1,/tlb_size_events,mbar=barBase)
  ;pull down menu next
  fileId = WIDGET_BUTTON(barBase, value='File', /menu)
  void = WIDGET_BUTTON(fileId, /separator, value='Exit', $
    event_pro='christmasTreeExit')
    
  self.drawId=WIDGET_DRAW(base, xsize=xdim, ysize=ydim, event_pro='blinkTheLights',$
    graphics_level=2, retain=0, /expose_events)
    
  WIDGET_CONTROL, base, /realize
  WIDGET_CONTROL, hourglass=1
  WIDGET_CONTROL, self.drawId, get_value=oWindow
  self.oWindow=oWindow
  
  ;create view object.
  self.oView = OBJ_NEW('IDLgrView', projection=1, eye=1.1, $
    color=[0,0,0], view=[-1,-1,2,2], zclip=[1,-1])
  self.oRotateModel = OBJ_NEW('IDLgrModel') ;need a model to rotate
  ;outside of tree first
  array1 = [[0.5,-0.5,0.0],[0.0,0.75,0.0]]
  p1=36
  p2=[0.0, 0.0, 0.0]
  p3=[0,1,0]
  Mesh_obj, 6, verts, conn, array1,p1=p1, p2=p2, p3=p3
  oPoly1 = OBJ_NEW('IDLgrPolygon',data=verts,polygons=conn,color=[0,255,0],shading=0,hide=0)
  ;trunk now
  array2 = [[0.15,-0.75,0],[0.15,0.15,0]]
  Mesh_obj,6,tverts,tconn,array2,p1=p1, p2=p2, p3=p3
  oPoly2 = OBJ_NEW('IDLgrPolygon',data=tverts,polygons=tconn,color=[105,58,42],shading=1,hide=0)
  
  ;add the objects to the model
  self.oRotateModel->Add, oPoly1
  self.oRotateModel->Add, oPoly2
  
  ;add the rotating model to the view
  self.oView -> add, self.oRotateModel
  
  ;don't want light sources to rotate so give them a separate model
  oLightModel = OBJ_NEW('IDLgrModel')
  oLight1 = OBJ_NEW('IDLgrLight',direction=[0,0,0],location=[0,0,1],type=2, $
    color=[255,255,255],hide=0)
  oLight2 = OBJ_NEW('IDLgrLight', direction=[1,0,0],location=[-1,1,0],type=1, $
    color=[255,255,255],intensity=0.5)
  oLightModel->Add,oLight1
  oLightModel->Add,oLight2
  ;add some text that will not rotate
  displayText = ['M','E','R','R','Y','C','H','R','I','S','T','M','A','S']
  numDisplay = N_ELEMENTS(displayText)
  xPos = ((FINDGEN(numDisplay)/(numDisplay-1.))*1.5) - 0.75 ;from -.25 to .75
  yPos = (SIN((FINDGEN(numDisplay)/(numDisplay-1.))*!pi)*(-0.5)) - 0.5 ;-.5 to -1
  zPos = FLTARR(numDisplay) + 0.5
  oText = OBJ_NEW('IDLgrText',string=displayText,location=TRANSPOSE([[xPos],[yPos],[zPos]]), $
    color=[255,0,0],char_dim=[.15,.15])
  oLightModel->Add,oText
  self.oView-> add, oLightModel
  
  ;add the blinking lights
  oLightArray = OBJARR(nLights)
  FOR i=0,nLights-1 DO BEGIN
    oLightArray[i] = OBJ_NEW('christmasLight')
    self.oRotateModel->Add,oLightArray[i]
  ENDFOR
  self.nLights = nLights
  self.oLightArrayPtr = PTR_NEW(oLightArray,/no_copy)
  
  self.oWindow->Draw, self.oView
  ;store objects for cleanup
  self.oContainer = OBJ_NEW('IDL_Container')
  self.oContainer -> add, oPoly1
  self.oContainer -> add, oPoly2
  self.oContainer-> add,oLight1
  self.oContainer-> add,oLight2
  self.oContainer-> add,oText
  self.oContainer-> add, oLightModel
  ;store the object reference in the base
  WIDGET_CONTROL, base,set_uvalue=self
  WIDGET_CONTROL,self.drawId, timer=0.1 ;start the timer event for the lights
  WIDGET_CONTROL,base,timer=1.0 ;timer for rotating the tree
  
  Xmanager,'christmasTree',base,/no_block,cleanup='christmasCleanup'
  RETURN,1
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree::Cleanup
  ;cleanup routine for the christmas tree object
  IF OBJ_VALID(self.oContainer) THEN OBJ_DESTROY,self.oContainer
  IF PTR_VALID(self.oLightArrayPtr) THEN BEGIN
    OBJ_DESTROY,*self.oLightArrayPtr
    PTR_FREE,self.oLightArrayPtr
  ENDIF
  IF OBJ_VALID(self.oWindow) THEN OBJ_DESTROY,self.oWindow
  IF OBJ_VALID(self.oView) THEN OBJ_DESTROY,self.oView
  IF OBJ_VALID(self.oRotateModel) THEN OBJ_DESTROY, self.oRotateModel
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree__define
  ;defintion routine for the christmas tree object
  void = {christmasTree, $
    inherits IDLgrmodel, $
    oLightArrayPtr : PTR_NEW(), $
    nLights : 0, $
    drawId : 0L, $
    oRotateModel : OBJ_NEW(), $
    oWindow : OBJ_NEW(), $
    oView : OBJ_NEW(), $
    oContainer : OBJ_NEW()}
    
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Christmastree, nlights=nlights
  ;driver program for the christmas tree object
  oTree = OBJ_NEW('christmastree',nlights=nlights)
  
  RETURN
END