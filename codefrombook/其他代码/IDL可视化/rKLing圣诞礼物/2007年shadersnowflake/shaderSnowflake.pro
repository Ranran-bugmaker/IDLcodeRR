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
PRO Shadersnowflake_event, event
  ;only timer events

  WIDGET_CONTROL, event.top, get_uvalue=object
  
  object->Updatetimer
  
  RETURN & END
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  PRO Shadersnowflake_cleanup, wBase
  
    WIDGET_CONTROL, wBase, get_uvalue=object
    ;destroy the object
    OBJ_DESTROY,object
    
    RETURN & END
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    PRO Shadersnowflake::updateTimer
    
      ;give a random walk to the axis rotation, if you just want the snowflake to spin in
      ;place then comment the next line out
      self.axis = self.axis + RANDOMN(seed,3)/10.0
      self.oModel->Rotate,self.axis,1 ;only one degree at a time
      self.oWindow->Draw, self.oView
      WIDGET_CONTROL, self.wBase, timer=1/60.0 ;reset the timer
      
      RETURN & END
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      FUNCTION Shadersnowflake::Init, _extra=extra
        ;initialization routine for the shaderSnowflake
        COMPILE_OPT idl2
        
        ;cd, sourcePath()
        
        xdim = 500
        ydim = 500
        
        self.wBase =WIDGET_BASE(title='Shader Snowflake',column=1)
        ;renderer has to be 0 and retain = 0 or 1, otherwise the shader is turned off
        self.wDrawId = WIDGET_DRAW(self.wBase, xsize=xdim, ysize=ydim, $
          graphics_level=2,  renderer=0, retain=0)
        WIDGET_CONTROL, self.wBase, /realize
        WIDGET_CONTROL, hourglass=1
        WIDGET_CONTROL, self.wDrawId, get_value=oWindow
        self.oWindow=oWindow
        
        ;the view is set up to match the snowflake coordinates
        self.oView = OBJ_NEW('IDLgrView', color=[100,100,100], zclip=[30,-30], $
          viewplane_rect=[-20,-20,60,60], PROJECTION=2, eye=30.1)
          
        ; Read the background image
        READ_JPEG,'starfield.jpg',snowfield, true=1
        ;image location and dimension match the view
        oBackImage = OBJ_NEW('IDLgrImage',snowfield,dimen=[60,60],location=[-20,-20],interpolate=1)
        ;put this image in a separate model
        oBackModel = OBJ_NEW('IDLgrModel')
        oBackModel->Add, oBackImage
        displayText = ['Merry Christmas!','From Kling Research and Software, inc']
        oFont = OBJ_NEW('IDLgrFont','Times*Bold*italic',size=20)
        oText = OBJ_NEW('IDLgrText',string=displayText,render=0, $
          location=[[10,0],[10,-4]], updir=[0,1,0], $
          color=[0,255,0],font = oFont, align=0.5)
        oBackModel->Add,oText
        
        self.oView->Add, oBackModel
        
        ;this image gives a really nice overlay on the snowflake.
        READ_JPEG,'lead_tungstate_crystal_wall.jpg', EnvMap, TRUE=1
        
        ; Create environment map image
        oEnvMap = OBJ_NEW('IDLgrImage', EnvMap, INTERPOLATE=1)
        
        ; Create the glass shader
        oShader = OBJ_NEW('IDLgrShader', VERTEX_PROGRAM_FILENAME='Glass.vert', $
          FRAGMENT_PROGRAM_FILENAME='Glass.frag')
        ;set the shader variables to give a glass effect
        oShader->Setuniformvariable, 'eyePos', [0.0, 0.0, 0.0, 1.0]
        ; No displacement
        oShader->Setuniformvariable, 'displace', [0.0, 0.0, 0.0, 0.0]
        oShader->Setuniformvariable, 'etaValues', [1.1, 1.08, 1.06]
        oShader->Setuniformvariable, 'fresnelValues', [2.0, 2.0, 0.1]
        ;this one sets the image in the shader object
        oShader->Setuniformvariable, 'environmentMap', oEnvMap
        
        filename = 'snowflake.dxf'
        ;GET_DXF_OBJECTS is an undocumented routine in the lib/utilities directory
        oDXF = Get_dxf_objects(filename, bTable, lTable, IGNOR=ignored, ERROR=error)
        ;get the polygon object
        oObject = oDXF->Get(/all)
        oObject->Getproperty,data=data
        OBJ_DESTROY, oDXF
        ;GET_DXF_OBJECTS also creates two other models that we don't need but have to destroy to stop
        ;memory leaks
        OBJ_DESTROY, lTable.model
        
        ;make the data all positive
        data[0,*] = data[0,*] - MIN(data[0,*])
        data[1,*] = data[1,*] - MIN(data[1,*])
        data[2,*] = data[2,*] - MIN(data[2,*])
        
        ;setting shading=1 gives faster rendering, texture_interp does not seem to do much
        oObject->Setproperty,data=data, shading=1, style=2, $
          shader=oShader, texture_interp=1
          
        ;need a model for the snowflake
        self.oModel = OBJ_NEW('IDLgrModel')
        self.oModel->Add, oObject
        self.oView->Add, self.oModel
        
        self.oWindow->Draw, self.oView
        
        WIDGET_CONTROL, self.wBase, set_uvalue=self
        
        self.oContainer = OBJ_NEW('IDL_container')
        self.oContainer->Add,[self.oWindow, self.oView, self.oModel, oObject, oShader, $
          oBackModel, oBackImage, oEnvMap]
        ;start the timer event
        WIDGET_CONTROL, self.wBase, timer=0.1
        ;initial rotation axis
        self.axis = [1,1,1]
        
        Xmanager, 'shaderSnowflake', self.wBase, cleanup='shaderSnowflake_cleanup',/no_block
        
        RETURN,1
      END
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      PRO Shadersnowflake::Cleanup
        ;cleanup routine for the shaderSnowflake object
      
        IF OBJ_VALID(self.oContainer) THEN OBJ_DESTROY,self.oContainer
        
        RETURN & END
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        PRO Shadersnowflake__define
        
          ;defintion routine for the shaderSnowflake object
          void = {shaderSnowflake, $
            wBase : 0L, $
            wDrawId : 0L, $
            oWindow : OBJ_NEW(), $
            oView : OBJ_NEW(), $
            oModel : OBJ_NEW(), $
            oContainer : OBJ_NEW(), $
            axis : FLTARR(3) }
            
          RETURN
        END
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        
        PRO Shadersnowflake, _extra=extra
          ;driver routine for the shaderSnowflake visualization
          ;add By DYQ
          CD,Sourcepath()
          
          oShaderSnowflake = OBJ_NEW('shaderSnowflake', _extra=extra)
          
          RETURN & END
          
