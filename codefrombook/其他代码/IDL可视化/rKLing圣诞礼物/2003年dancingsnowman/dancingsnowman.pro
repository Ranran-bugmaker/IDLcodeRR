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
PRO Dancingsnowmanexit,event
  ;called from the pull down menu
  WIDGET_CONTROL,event.top,/destroy
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowmancleanup, base
  ;called no matter how the GUI is destroyed
  WIDGET_CONTROL,base,get_uvalue=object
  OBJ_DESTROY,object
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman_event,event
  ;event handler for the top base
  WIDGET_CONTROL,event.top, get_uvalue=object
  eventType = TAG_NAMES(event, /struct) ;find out what it is
  CASE eventType OF
    ;resize events go here and keep the window square
    'WIDGET_BASE' : object->Resize, newSize = (event.x + event.y)/2
    'WIDGET_TIMER': object->Boogie
    ELSE:
  END
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman::resize, newSize=newSize
  ;resizes the draw widget and redraws the view

  WIDGET_CONTROL,self.drawId,draw_xsize=newSize,draw_ysize=newSize
  self.oWindow->Draw, self.oView
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman::boogie
  ;makes the snowman dance via the double pendulum algorithm

  M = self.m1 + self.m2
  x1 = self.l1 * COS(self.theta1) & x2 = self.l2*COS(self.theta2)
  y1 = self.l1 * SIN(self.theta1) & y2 = self.l2*SIN(self.theta2)
  temp0 = y1*x2 - y2*x1
  temp1 = self.m2*self.omega2^2*temp0 + M*self.grav*y1
  temp2 = -self.m2*self.omega1^2*temp0 + self.m2*self.grav*y2
  temp5 = (x1*x2 + y1*y2)/self.l1/self.l2
  temp3 = temp5/self.l1/self.l2
  temp4 = (M-self.m2*temp5^2)
  
  self.omega1 = self.omega1 - self.dt*(temp1/self.l1^2. - temp3*temp2)/temp4
  self.omega2 = self.omega2 - self.dt*(-temp1*temp3 + temp2*M/self.m2/self.l2^2.)/temp4
  self.omega1 = self.omega1*self.damp
  self.omega2 = self.omega2*self.damp
  self.theta1 = self.theta1 + self.dt*self.omega1
  self.theta2 = self.theta2 + self.dt*self.omega2
  self.oBellyModel->Rotate,[0,0,1],(self.oldTheta1 - self.theta1)/!dtor
  self.oHeadModel->Rotate,[0,0,1],(self.oldTheta2 - self.theta2)/!dtor
  self.oldTheta1 = self.theta1
  self.oldTheta2 = self.theta2
  self.oWindow->Draw, self.oView
  
  WIDGET_CONTROL, self.base, timer=self.timer
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

FUNCTION Dancingsnowman::Init, m1=m1,m2=m2,l1=l1,l2=l2,grav=grav, $
    timer=timer, theta1=theta1, theta2=theta2, $
    damp=damp, dt=dt
  ;initialization routine for the dancing snowman
    
  ;Experiment with the mass (m1,m2),length(l1,l2), and gravity parameters
  ;to get different behaviors of the snowman.
  ;Theta1 and Theta2 are the starting angles of the double pendulum
  ;Damp controls how quickly the oscillations damp out and dt is the time interval for
  ;the swing on the pendulum. Timer is how often IDL calls the boogie routine,make this
  ;smaller to speed up the dance.
    
  IF NOT KEYWORD_SET(timer) THEN timer = 0.1 & self.timer = timer
  IF NOT KEYWORD_SET(grav) THEN grav = 98.0 & self.grav = grav
  IF NOT KEYWORD_SET(m1) THEN m1 = 80.0 & self.m1 = m1
  IF NOT KEYWORD_SET(m2) THEN m2 = 80.0 & self.m2 = m2
  IF NOT KEYWORD_SET(l1) THEN l1 = 80.0 & self.l1 = l1
  IF NOT KEYWORD_SET(l2) THEN l2 = 80.0 & self.l2 = l2
  IF NOT KEYWORD_SET(theta1) THEN theta1 = 90 & self.theta1 = theta1*!dtor
  IF NOT KEYWORD_SET(theta2) THEN theta2 = -45 & self.theta2 = theta2*!dtor
  IF NOT KEYWORD_SET(damp) THEN damp = 0.990 & self.damp = damp
  IF NOT KEYWORD_SET(dt) THEN dt = 0.3 & self.dt = dt
  self.oldTheta1 = self.theta1
  self.oldTheta2 = self.theta2
  
  ;initialize the super class
  IF (self->Idlgrmodel::init(_extra=extra) NE 1) THEN RETURN, 0
  
  ;Get the screen size.
  DEVICE, get_screen_size = screenSize
  xdim = screenSize[0]*.50 ;about 50 percent of the screen size
  ydim=xdim  ;keep isotropic
  
  base=WIDGET_BASE(title='Dancing Snowman',column=1,/tlb_size_events,mbar=barBase)
  ;pull down menu next
  fileId = WIDGET_BUTTON(barBase, value='File', /menu)
  void = WIDGET_BUTTON(fileId, /separator, value='Exit', $
    event_pro='dancingSnowmanExit')
  self.drawId=WIDGET_DRAW(base, xsize=xdim, ysize=ydim, $
    graphics_level=2, retain=0, /expose_events)
    
  WIDGET_CONTROL, base, /realize
  WIDGET_CONTROL, hourglass=1
  WIDGET_CONTROL, self.drawId, get_value=oWindow
  self.oWindow=oWindow
  
  ;create view object.
  self.oView = OBJ_NEW('IDLgrView', projection=1, eye=1.1, $
    color=[0,0,0], view=[-1,-1,2,2], zclip=[1,-1])
  self.oBaseModel = OBJ_NEW('IDLgrModel') ;need a model for the base
  self.oBellyModel = OBJ_NEW('IDLgrModel') ;need a model for the belly
  self.oHeadModel = OBJ_NEW('IDLgrModel') ;need a model for the head
  ;base ball first
  oBase = OBJ_NEW('orb', POS=[0,0,0], RADIUS=0.2,color=[255,255,255])
  ;belly next
  oBelly = OBJ_NEW('orb', POS=[0,0.0,0], RADIUS=0.14,color=[255,255,255])
  oBellyButton1 = OBJ_NEW('orb',pos=[0,+0.14*SIN(40*!dtor),0.14*COS(40*!dtor)],radius=.025,color=[0,0,0])
  oBellyButton2 = OBJ_NEW('orb',pos=[0,+0.14*SIN(0*!dtor),0.14*COS(0*!dtor)],radius=.025,color=[0,0,0])
  self.oBellyModel->Translate,0,0.25,0 ;translate to the middle position
  ;head last
  oHead = OBJ_NEW('orb', POS=[0,0,0], RADIUS=0.09,color=[255,255,255])
  oNose = OBJ_NEW('orb',pos=[0,+0.09*SIN(0*!dtor),0.09*COS(0*!dtor)],radius=.015,color=[255,0,0])
  oLeftEye= OBJ_NEW('orb',pos=[-0.09*SIN(25*!dtor),+0.09*SIN(25*!dtor),0.09*COS(40*!dtor)],radius=.015,color=[0,0,0])
  oRightEye= OBJ_NEW('orb',pos=[+0.09*SIN(25*!dtor),+0.09*SIN(25*!dtor),0.09*COS(40*!dtor)],radius=.015,color=[0,0,0])
  mouthX = [0.1*SIN(115*!dtor)*SIN(-30*!dtor),0, 0.1*SIN(115*!dtor)*SIN(30*!dtor)]
  mouthY = [0.1*COS(115*!dtor), 0.1*COS(130*!dtor), 0.1*COS(115*!dtor)]
  mouthZ = [0.1*SIN(115*!dtor)*COS(-30*!dtor), 0.1*SIN(115*!dtor),0.1*SIN(115*!dtor)*COS(30*!dtor)]
  oMouth= OBJ_NEW('IDLgrPolyline',mouthX,mouthY,mouthZ,color=[0,0,0],thick=3)
  self.oHeadModel->Translate,0,0.2,0 ;translate to the top of the other two balls
  ;add the objects to the model
  self.oBaseModel->Add, oBase
  self.oBellyModel->Add, oBelly
  self.oBellyModel->Add, oBellyButton1
  self.oBellyModel->Add, oBellyButton2
  self.oHeadModel->Add, oHead
  self.oHeadModel->Add, oNose
  self.oHeadModel->Add, oRightEye
  self.oHeadModel->Add, oLeftEye
  self.oHeadModel->Add, oMouth
  ;add the models together
  self.oBaseModel->Add,self.oBellyModel
  self.oBellyModel->Add,self.oHeadModel
  
  ;add the models to the view
  self.oView -> add, self.oBaseModel
  
  ;don't want light sources to rotate so give them a separate model
  oLightModel = OBJ_NEW('IDLgrModel')
  oLight1 = OBJ_NEW('IDLgrLight',direction=[0,0,0],location=[0,0,1],type=2, $
    color=[255,255,255],hide=0)
  oLight2 = OBJ_NEW('IDLgrLight', direction=[1,0,0],location=[-1,1,0],type=1, $
    color=[255,255,255],intensity=0.5)
  oLightModel->Add,oLight1
  oLightModel->Add,oLight2
  ;add some text that will not move
  ;displayText = ['M','E','R','R','Y',' ','C','H','R','I','S','T','M','A','S','!']
  displayText = ['MERRY CHRISTMAS!','From Kling Research and Software, inc']
  oFont = OBJ_NEW('IDLgrFont','Times*Bold*italic',size=20)
  oText = OBJ_NEW('IDLgrText',string=displayText,location=TRANSPOSE([[0.0,0.0],[-0.5,-0.6],[0.5,0.5]]), $
    color=[255,0,0],font = oFont, align=0.5)
  oLightModel->Add,oText
  self.oView-> add, oLightModel
  ;rotate the snowman to the starting position
  self.oBellyModel->Rotate,[0,0,1],(-self.theta1)/!dtor
  self.oHeadModel->Rotate,[0,0,1],(-self.theta2)/!dtor
  self.oWindow->Draw, self.oView
  
  ;store objects for cleanup
  self.oContainer = OBJ_NEW('IDL_Container')
  self.oContainer -> add, oBase
  self.oContainer -> add, oBelly
  self.oContainer-> add,oLight1
  self.oContainer-> add,oLight2
  self.oContainer-> add,oText
  self.oContainer-> add,oFont
  self.oContainer-> add, oLightModel
  ;store the object reference in the base
  self.base = base
  WIDGET_CONTROL, base,set_uvalue=self
  WIDGET_CONTROL,base,timer=0.010 ;timer for the dance
  
  Xmanager,'dancingSnowman',base,/no_block,cleanup='dancingSnowmanCleanup'
  RETURN,1
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman::Cleanup
  ;cleanup routine for the dancing snowman object
  IF OBJ_VALID(self.oContainer) THEN OBJ_DESTROY,self.oContainer
  IF PTR_VALID(self.oLightArrayPtr) THEN BEGIN
    OBJ_DESTROY,*self.oLightArrayPtr
    PTR_FREE,self.oLightArrayPtr
  ENDIF
  IF OBJ_VALID(self.oWindow) THEN OBJ_DESTROY,self.oWindow
  IF OBJ_VALID(self.oView) THEN OBJ_DESTROY,self.oView
  IF OBJ_VALID(self.oBaseModel) THEN OBJ_DESTROY, self.oBaseModel
  IF OBJ_VALID(self.oBellyModel) THEN OBJ_DESTROY, self.oBellyModel
  IF OBJ_VALID(self.oHeadModel) THEN OBJ_DESTROY, self.oHeadModel
  
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman__define

  ;defintion routine for the dancing snowman object
  void = {dancingSnowman, $
    inherits IDLgrmodel, $
    base : 0L, $
    timer : 0.0, $
    omega1 : 0.0, $
    omega2 : 0.0, $
    theta1 : 0.0, theta2: 0.0, $
    oldTheta1 : 0.0 , oldTheta2 : 0.0, $
    grav : 0.0, $
    m1 : 0.0, m2 : 0.0, $
    l1 : 0.0, l2 : 0.0, $
    dt : 0.0, damp: 0.0, $
    oLightArrayPtr : PTR_NEW(), $
    nLights : 0, $
    drawId : 0L, $
    oBaseModel : OBJ_NEW(), $
    oBellyModel : OBJ_NEW(), $
    oHeadModel : OBJ_NEW(), $
    oWindow : OBJ_NEW(), $
    oView : OBJ_NEW(), $
    oContainer : OBJ_NEW()}
    
  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Dancingsnowman,  m1=m1,m2=m2,l1=l1,l2=l2,grav=grav, $
    timer=timer, theta1=theta1, theta2=theta2, $
    damp=damp, dt=dt
  ;driver program for the dancing snowman object
    
  oMan = OBJ_NEW('dancingSnowman',m1=m1,m2=m2,l1=l1,l2=l2,grav=grav, $
    timer=timer, theta1=theta1, theta2=theta2, $
    damp=damp, dt=dt)
    
  RETURN
END