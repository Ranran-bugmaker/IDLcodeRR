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

PRO Snowfall_event,event
  ;event handler for the top base. does not do anything right now

  RETURN
END

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Snowfallcleanup, base
  ;called no matter how the widget dies

  WIDGET_CONTROL, base, get_uvalue=object
  OBJ_DESTROY, object
  
  RETURN & END
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  PRO Snowfallexit, event
    ;destroy the top level base
    WIDGET_CONTROL, event.top,/destroy
    
    RETURN & END
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    PRO Snowfall::Update
    
      self.oWindow->Draw, self.oCamera
      
      RETURN & END
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      FUNCTION Snowfall::Init, numSnowflakes=numSnowflakes, _extra=extra
        ;initialization routine for the snowFall
      
        IF NOT KEYWORD_SET(numSnowflakes) THEN numSnowflakes = 25
        ;initialize the super class
        IF (self->Idlgrmodel::init(_extra=extra) NE 1) THEN RETURN, 0
        
        ;Get the screen size.
        DEVICE, get_screen_size = screenSize
        xdim = screenSize[0]*.50 ;about 50 percent of the screen size
        ydim=xdim  ;keep isotropic
        
        self.base =WIDGET_BASE(title='Christmas Snowfall',column=1,mbar=barBase)
        ;pull down menu next
        fileId = WIDGET_BUTTON(barBase, value='File', /menu)
        void = WIDGET_BUTTON(fileId, /separator, value='Exit', $
          event_pro='snowFallExit')
        self.drawId = WIDGET_DRAW(self.base, xsize=xdim, ysize=ydim, $
          graphics_level=2, retain=2, renderer=0)
          
        WIDGET_CONTROL, self.base, /realize
        WIDGET_CONTROL, hourglass=1
        WIDGET_CONTROL, self.drawId, get_value=oWindow
        self.oWindow=oWindow
        
        ;create the snow surface
        snowSurface = RANDOMU(seed, 100, 100)*25.0
        ; Smooth the array to produce a smooth surface
        FOR j = 0,2 DO snowSurface = SMOOTH(snowSurface, 5,/edge)
        
        viewPlane_rect = [-5,-5,110,110]
        zclip = [100,-100]
        ;create Rick Towler's camera object.
        self.oCamera = OBJ_NEW('Camera', color=[0,0,0], viewplane_rect=viewPlane_rect, $
          projection=2, camera_location=[50,0,30], zclip=zclip, lookat=[50,120,0], $
          /track, eye=101, depth_cue=[-50,10]) ;use depth cueing so the background fades away
          
        ;create the model hierarchy
          
        ;model for the surface
        self.oSurfaceModel = OBJ_NEW('IDLgrModel')
        
        ;snow surface
        oSnowSurface = OBJ_NEW('IDLgrSurface',snowSurface,color=[255,255,255],style=2,shading=1,hide=0)
        self.oSurfaceModel->Add,oSnowSurface
        
        ;create a model just for the text
        oTextModel = OBJ_NEW('IDLgrModel')
        displayText = ['Merry Christmas!','From Kling Research and Software, inc']
        oFont = OBJ_NEW('IDLgrFont','Times*Bold*italic',size=5)
        oText = OBJ_NEW('IDLgrText',string=displayText,render=1, $
          location=TRANSPOSE([[50,50],[20,20],[16,14]]), updir=[0,0,1], $
          color=[0,255,0],font = oFont, align=0.5)
        oTextModel->Add,oText
        
        ;add the models to the view
        self.oCamera -> add, self.oSurfaceModel
        self.oCamera -> add,oTextModel
        ;light objects
        ;blue ambient light for effect
        oAmbLight = OBJ_NEW('IDLgrLight', type=0, color=[0,0,255],intensity=0.4)
        ;positional light to mimic moonlight
        oPosLight1 = OBJ_NEW('IDLgrLight', type=1, $
          color=[255,255,255], location=[xdim*2, ydim/2, 700])
          
        self.oSurfaceModel->Add, [oAmbLight, oPosLight1]
        
        self.oWindow->Draw, self.oCamera
        
        ;model for the snowflakes
        oSnowflakeModel = OBJ_NEW('IDLgrModel')
        self.oCamera->Add, oSnowflakeModel
        
        FOR i=0,numSnowflakes-1 DO BEGIN
          ;disable the lighting so that flakes appear white and not blue
          oSnowFlake = OBJ_NEW('snowflake',viewPlane_rect=viewPlane_rect,$
            zclip=zclip, parentObject=self, lighting=0)
          oSnowflakeModel->Add, oSnowFlake
          self.oWindow->Draw, self.oCamera
        ENDFOR
        
        
        ;store objects for cleanup
        self.oContainer = OBJ_NEW('IDL_Container')
        self.oContainer-> add, self.oSurfaceModel
        self.oContainer-> add, [oSnowflakeModel,oTextModel, oFont, oText]
        ;store the object reference in the base
        WIDGET_CONTROL, self.base,set_uvalue=self
        
        Xmanager,'snowFall',self.base,/no_block,cleanup='snowFallCleanup'
        
        RETURN,1
      END
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      PRO Snowfall::Cleanup
        ;cleanup routine for the snowFall object
      
        self->Idlgrmodel::cleanup
        IF OBJ_VALID(self.oContainer) THEN OBJ_DESTROY,self.oContainer
        IF OBJ_VALID(self.oWindow) THEN OBJ_DESTROY,self.oWindow
        IF OBJ_VALID(self.oCamera) THEN OBJ_DESTROY,self.oCamera
        
        IF PTR_VALID(self.message) THEN PTR_FREE, self.message
        
        RETURN & END
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        PRO Snowfall__define
        
          ;defintion routine for the snowFall object
          void = {snowFall, $
            inherits IDLgrmodel, $
            base : 0L, $
            drawId : 0L, $
            oWindow : OBJ_NEW(), $
            oCamera : OBJ_NEW(), $
            oSnowflakeModel : OBJ_NEW(), $
            oSurfaceModel : OBJ_NEW(), $
            oContainer : OBJ_NEW(), $
            message : PTR_NEW() }
            
          RETURN
        END
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        
        PRO Snowfall, numSnowflakes=numSnowflakes, _extra=extra
          ;driver routine for the snowfall visualization
        
          oSnowFall = OBJ_NEW('snowFall',numSnowflakes=numSnowflakes, _extra=extra)
          
          RETURN & END
