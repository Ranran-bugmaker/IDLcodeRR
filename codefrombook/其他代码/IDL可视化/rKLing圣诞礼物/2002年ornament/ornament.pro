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

PRO Ornament_event,event
  ;event handler for the top base
  WIDGET_CONTROL,event.top, get_uvalue=object
  eventType = TAG_NAMES(event, /struct) ;find out what it is
  CASE eventType OF
    ;resize events go here and keep the window square
    'WIDGET_BASE' : object->Resize, newSize = (event.x + event.y)/2
    'WIDGET_TIMER':BEGIN ;this timer rotates the ornament
    object->Turntheornament
    WIDGET_CONTROL,event.top,timer=1 ;set the timer again
  END
  ELSE:
END

RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornamentcleanup, base
  ;called no matter how the GUI is destroyed
  WIDGET_CONTROL,base,get_uvalue=object
  OBJ_DESTROY,object
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornament::turnTheOrnament
  ;rotates the ornament by 10 degrees each time around the y axis
  self.oRotateModel->Rotate,[0,1,0],10
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornament::resize, newSize=newSize
  ;resizes the draw widget and redraws the view

  WIDGET_CONTROL,self.drawId,draw_xsize=newSize,draw_ysize=newSize
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

FUNCTION Ornament::Init
  ;initialization routine for the ornament

  ;initialize the super class
  IF (self->Idlgrmodel::init(_extra=extra) NE 1) THEN RETURN, 0
  
  ;Get the screen size.
  DEVICE, get_screen_size = screenSize
  xdim = screenSize[0]*.50 ;about 50 percent of the screen size
  ydim=xdim  ;keep isotropic
  
  base=WIDGET_BASE(title='Christmas Ornament',column=1,/tlb_size_events)
  self.drawId=WIDGET_DRAW(base, xsize=xdim, ysize=ydim,renderer=1, $
    graphics_level=2, retain=0, /expose_events)
    
  WIDGET_CONTROL, base, /realize
  WIDGET_CONTROL, hourglass=1
  WIDGET_CONTROL, self.drawId, get_value=oWindow
  self.oWindow=oWindow
  
  ;create view object.
  self.oView = OBJ_NEW('IDLgrView', projection=1, eye=2.1, $
    color=[0,0,0], view=[-1,-1,2,2], zclip=[2,-2])
  self.oRotateModel = OBJ_NEW('IDLgrModel') ;need a model to rotate
  ;read in the earth image although any true color image will work.
  READ_JPEG, Demo_filepath('earth.jpg', $
    subdir=['examples','demo','demodata']), earthImage, true=1
    
  oImage1 = OBJ_NEW('IDLgrImage', earthImage)
  oPoly1 = OBJ_NEW('orb', COLOR=[255, 255, 255], RADIUS=0.5, $
    DENSITY=0.8, /TEX_COORDS, TEXTURE_MAP=oImage1,style=2,hide=0,/zero)
  ;Invert texture coordinates, otherwise image is mirrored.
  oPoly1->Getproperty, POBJ=p
  p->Getproperty, TEXTURE_COORD=t
  t[0,*] = 1.0 - t[0,*]
  p->Setproperty, TEXTURE_COORD=t
  ;create the string as an ellipse
  a = .1 & b=1
  ap = FINDGEN(360)*!dtor
  xt = a*COS(ap)
  yt= FLTARR(360)
  zt = -(b*SIN(ap)+1.5)
  oPolyLine = OBJ_NEW('IDLgrPolyline',xt,yt,zt,color=[255,255,255],thick=3)
  
  ;add the objects to the model
  self.oRotateModel->Add, oPoly1
  self.oRotateModel->Add, oPolyLine
  self.oRotateModel->Rotate,[1,0,0],90
  
  ;add the rotating model to the view
  self.oView -> add, self.oRotateModel
  
  ;don't want light sources to rotate so give them a separate model
  oLightModel = OBJ_NEW('IDLgrModel')
  oLight1 = OBJ_NEW('IDLgrLight',direction=[0,0,0],location=[0,0,1],type=2, $
    color=[255,255,255])
  oLight2 = OBJ_NEW('IDLgrLight', direction=[1,0,0],location=[-1,1,0],type=1, $
    color=[255,255,255],intensity=0.75)
  oLightModel->Add,oLight1
  oLightModel->Add,oLight2
  
  ;add the background image, define image dimensions.
  ;larger images make smaller lights
  xsize = 256 & ysize = 256
  image = BYTARR(3,xsize,ysize)
  ;define input function parameters:
  A = [ 1., 1., 5., 5., xsize/2., ysize/2.]
  ;create X and Y arrays:
  X = FINDGEN(xsize) # REPLICATE(1.0, ysize)
  Y = REPLICATE(1.0, xsize) # FINDGEN(ysize)
  ;create a circle:
  U = ((X-A[4])/A[2])^2 + ((Y-A[5])/A[3])^2
  ;create gaussian Z for a blurred light
  Z = BYTSCL(A[0] + A[1] * EXP(-U/2))
  ind = WHERE(z GT 15) ;points where the blurring has a value gt 15
  xPoints = ind MOD xsize ;get the x and y points
  yPoints = FIX(ind/xsize)
  ;create 16 random lights
  FOR i =0,15 DO BEGIN
    im = BYTARR(xsize,ysize) ;used as a template for the lights
    xoffset = RANDOMN(seed,1)*xsize/4. ;random positions
    yoffset = RANDOMN(seed,1)*ysize/4.
    ;fill in the z points on a random place in im.
    im[xPoints-xoffset[0],yPoints-yoffset[0]] = z[xPoints,yPoints]
    ;spread them between the bands
    band = FIX(RANDOMU(seed,2)*3)
    ;if two bands are the same only do one.  Otherwise the values exceed 255
    IF band[0] NE band[1] THEN FOR j=0,1 DO image[band[j],*,*] = image[band[j],*,*] + im $
    ELSE image[band[0],*,*] = image[band[0],*,*]  + im
  ENDFOR
  
  ;background tree color (dark green)
  treeColor = 90B
  ;find out all the green plane indices that have a color less than the
  ;desired tree color. We will make these all dark green
  ind = WHERE(image[1,*,*] LT treeColor)
  ;we have a pixel interleaved image and we only want the green indices
  ;to change so we have ind*3+1. If we had wanted the blue plane to change
  ;this would have been ind*3+2 (red is just ind*3). This is much faster than a loop or trying to
  ;do it as a single plane. surprisingly, image[1,ind] = treeColor does not work.
  image[ind*3+1] = treeColor
  ;create the image object
  oImage2 = OBJ_NEW('IDLgrImage',image)
  ;the polygon will fill the entire view and be placed at z=-1
  face = [[0,2,0],[2,2,0],[2,0,0],[0,0,0]] - 1.0
  oPoly2 = OBJ_NEW('IDLgrPolygon', face ,color=[255,255,255], $
    texture_map=oImage2, texture_coord = [[0,0], [1,0], [1,1], [0,1]],$
    style=2) ;texture_coord and style=2 are necessary for the image to be seen.
  oLightModel->Add,oPoly2
  
  ;add some text that will not rotate
  oFont = OBJ_NEW('IDLgrFont','courier')
  displayText = ['M','E','R','R','Y',' ','C','H','R','I','S','T','M','A','S','!']
  numDisplay = N_ELEMENTS(displayText)
  xPos = ((FINDGEN(numDisplay)/(numDisplay-1.))*1.5) - 0.75 ;from -.25 to .75
  yPos = FLTARR(numDisplay)-0.75
  zPos = FLTARR(numDisplay) + 0.5
  oText = OBJ_NEW('IDLgrText',string=displayText,location=TRANSPOSE([[xPos],[yPos],[zPos]]), $
    color=[255,0,0],char_dim=[.15,.15],font=oFont)
  oLightModel->Add,oText
  
  self.oView-> add, oLightModel
  
  self.oWindow->Draw, self.oView
  ;store objects for cleanup
  self.oContainer = OBJ_NEW('IDL_Container')
  self.oContainer -> add, oPoly1
  self.oContainer -> add, oPoly2
  self.oContainer-> add,oLight1
  self.oContainer-> add,oLight2
  self.oContainer-> add,oImage1
  self.oContainer-> add,oImage2
  self.oContainer-> add,oFont
  self.oContainer-> add,oText
  self.oContainer-> add, oLightModel
  ;store the object reference in the base
  WIDGET_CONTROL, base,set_uvalue=self
  WIDGET_CONTROL,base,timer=1.0 ;timer for rotating the ornament
  
  Xmanager,'ornament',base,/no_block,cleanup='ornamentCleanup'
  RETURN,1
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornament::Cleanup
  ;cleanup routine for the Christmas ornament object
  IF OBJ_VALID(self.oContainer) THEN OBJ_DESTROY,self.oContainer
  IF OBJ_VALID(self.oWindow) THEN OBJ_DESTROY,self.oWindow
  IF OBJ_VALID(self.oView) THEN OBJ_DESTROY,self.oView
  IF OBJ_VALID(self.oRotateModel) THEN OBJ_DESTROY, self.oRotateModel
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornament__define

  ;defintion routine for the ornament object
  void = {ornament, $
    inherits IDLgrmodel, $
    drawId : 0L, $
    oRotateModel : OBJ_NEW(), $
    oWindow : OBJ_NEW(), $
    oView : OBJ_NEW(), $
    oContainer : OBJ_NEW()}
    
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Ornament
  ;driver program for the Christmas ornament object
  oOrnament = OBJ_NEW('ornament')
  
  RETURN
END