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
pro objectMeshEvent, event
  ;
  ; PURPOSE  This is the main event handler routine
  ;          use in the objectMesh demo.
  ;

  widget_control, event.top, get_uvalue=state, /NO_COPY
  
  ;resize events go here
  if (TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_BASE') then begin
    newSize = (event.x + event.y)/2 ;keep the base square
    widget_control,state.wdraw,draw_xsize=newSize,draw_ysize=newSize ;change draw widget size
    ;reset rotator to work in entire window
    state.oRotator->setProperty,center=[newSize/2,newSize/2],radius=newSize/2
    state.oWindow->Draw, state.oView ;draw the new view
    WIDGET_CONTROL, event.top, sET_UVALUE=state, /NO_COPY
    RETURN
  endif
  
  WIDGET_CONTROL, event.id, GET_UVALUE=uvalue
  
  case uvalue of
    ;display the help file
    'HELP' : xdisplayfile,'objectMeshHelp.txt'
    
    ;  Reset perspective.
    ;
    'RESET': begin ;reset the orientation back to the original
      state.oRotator->SetProperty, $
        TRANSFORM=state.resetTransform
      state.oWindow->Draw, State.oView
    end
    
    'DRAW': begin
      if (event.press gt 0) then begin
        WIDGET_CONTROL, state.wDraw, DRAW_MOTION=1
        ;I need the next statement to intialize what button (left,middle,right) the
        ;rotator is looking for.
        validTransform = state.oRotator->update(event)
      endif else $
        ;  Handle button release.
      
        if (event.release ge 1) then begin
        state.oRotator->setProperty,currentButton=0b ;clear button
        state.oWindow->SetProperty, QUALITY=2 ;get high quality
        WIDGET_CONTROL, state.wDraw, DRAW_MOTION=0 ;turn off motion events
        state.oWindow->Draw, state.oView ;draw new view
      endif
      ;need to check if mouse has moved
      validTransform = state.oRotator->update(event)
      
      if (event.type EQ 2) then begin ;motion events here
        if (validTransform) then begin
          state.oWindow->SetProperty, QUALITY=1 ;lower the quality a bit
          state.oWindow->Draw,state.oView ;draw the view
        endif
      endif
      
      ;  Handle expose events.
      ;
      if (event.type EQ 4) then begin
        state.oWindow->Draw, state.oView
      endif
    end
    ELSE:    ;  Do nothing
  endcase
  widget_control, event.top, set_uvalue=state, /NO_COPY
  return
end

;----------------------------------------------------------------------
;
; PURPOSE  Cleanup everything associated with the
;          meshObject demo, including all objects and pointers.
;          Restore the original color table.
;
pro objectMeshCleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=state, /NO_COPY
  
  ;  Restore the previous color table.
  TVLCT, state.colorTable
  
  ;  Destroy the top objects
  OBJ_DESTROY, state.oContainer
  
  ;  Free all pointers.
  ;
  ;none!
  return
end

;---------------------------------------------------------------------

pro objectMeshDemoImage,event

  widget_control,event.top,get_uvalue=state,/no_copy
  widget_control,event.id,get_uvalue=uvalue
  case uvalue of
    'None': begin
      ;setting the texture_map to a null object disables the image mapping
      state.oMesh->setProperty,texture_map=obj_new()
    end
  else : begin
    if (file = dialog_pickfile(filter='*.jpg') )then begin
      read_jpeg,file,image
      state.oImage->setProperty,data=image
      state.oMesh->setProperty,texture_map=state.oImage
    endif
  end
endcase
state.oWindow->Draw, state.oView
widget_control,event.top,set_uvalue=state,/no_copy
return
end
;---------------------------------------------------------------------

pro objectMeshDemoProj,event

  widget_control,event.top,get_uvalue=state,/no_copy
  widget_control,event.id,get_uvalue=uvalue
  case uvalue of
    'ortho': begin
      ;make the object appear as if viewed from infinity
      state.oView->setProperty,projection=1
    end
  else : begin
    ;make the object appear as if viewed from the observer
    state.oView->setProperty,projection=2
  end
endcase
state.oWindow->Draw, state.oView
widget_control,event.top,set_uvalue=state,/no_copy
return
end
;---------------------------------------------------------------------

pro objectMeshDemoObject,event

  widget_control,event.top,get_uvalue=state,/no_copy
  widget_control,event.id,get_uvalue=uvalue
  state.oMesh->resetMesh ;clean out old values
  case uvalue of
    'Triangulated':begin ;random values for the surface
    z = randomu(seed,3,50)-.5
    state.oMesh->setProperty,array1= z,/tex_coords,$
      meshType='triangulated',color=[255,255,255]
  end
  
  'TriangulatedB':begin ;bessel function for this surface
  z = BESELJ(SHIFT(DIST(40),20,20)/2,0) ;generate the data
  z = z[*] ;change it from 2D to 1D
  i = fltarr(40)+1.0 ;make the x and y values go from 0 to 1
  x = findgen(40)/39.#i
  y = transpose(x)
  x = x[*]-.5 ;subtract .5 to center it
  y = y[*]-.5
  newz = transpose([[x],[y],[z]])
  state.oMesh->setProperty,array1= newz,/tex_coords,$
    meshType='triangulated',color=[255,255,255]
end

'Rectangular':begin ;"tent" surface
z = dist(40,40)
z=z/max(z) ;normalize
state.oMesh->setProperty,array1= z,/tex_coords,p1= (findgen(40)/39.) - .5, $
  p2 = (findgen(40)/39.) - .5, meshType='rectangular',color=[255,255,255]
end

'Polar':     begin ;make a surface that looks like a ballerina skirt
  z = transpose(findgen(40)#(sin(findgen(37)*10.)*!dtor))
  state.oMesh->setProperty,array1=z,/tex_coords,p3=0.,p4=.75 $
    ,meshType='polar',color=[255,255,255]
end

'Spherical': begin ;sphere with radius of 0.75
  state.oMesh->setProperty,array1=Replicate(0.75 ,36,36),/tex_coords,$
    meshType='spherical',color=[255,255,255]
end

'Cylindrical':begin ;cylinder with radius of 0.5 no endcaps
state.oMesh->setProperty,array1=Replicate(0.5, 48, 64), $
  P4=.75,/tex_coords,meshType='cylindrical',color=[255,255,255]
end

'CylindricalWith':begin ;cylinder with radius of 0.5 with endcaps
state.oMesh->setProperty,array1=Replicate(0.5, 48, 64),/endcaps, $
  P4=.75,/tex_coords,meshType='cylindrical',color=[255,255,255]
end

'Extrusion' : begin ;extrusion shaped like a T
  t = [[.3,0,0],[.6,0,0],[.6,.6,0],[.9,.6,0],[.9,.9,0],$
    [0,.9,0],[0,.6,0],[.3,.6,0],[.3,0,0]] - .45 ;subtract this off to center
  state.oMesh->setProperty,array1=T,  $
    P1=10,/tex_coords,meshType='extrusion',color=[255,255,255]
end

'Revolution':begin  ;Create a cone (surface of revolution).
state.oMesh->setProperty,array1=[[0.00, 0.0, 0.50], [0.0, 0.0, 0.75]],  $;p4=!pi*2.,p5=0.,$
  P1=36, P2=[0.0, 0.0, 0.0],p3=[1,0,0], $
  /tex_coords,meshType='revolution',color=[255,255,255]
end
'Ruled'     :begin  ;Create a ruled surface.  This will be a sin/cos surface
x = findgen(36)/35.
y = abs(sin(x*360.0*!dtor)) ;keep between 0 and 1
z = abs(cos(x*360.0*!dtor))
a = fltarr(3,36)
b = fltarr(3,36)
a[0,*] = x-.5 ;index along x and center it
a[1,*] = y-.5 ; sin along y, leave z = 0
;now do the b array
b[0,*] = x
b[2,*] = z
state.oMesh->setProperty,array1=a ,array2=b,  $
  P1=5,/tex_coords,meshType='ruled',color=[255,255,255]
end
else :
endcase
state.oWindow->Draw, state.oView
widget_control,event.top,set_uvalue=state,/no_copy
return
end
;---------------------------------------------------------------------

pro objectMeshDemoExit,event
  ; Time to go away.
  widget_control,event.top,/destroy
  return
end
;---------------------------------------------------------------------


pro objectMeshDemo

  ;  Get the current color table.
  ;  It will be restored when exiting.
  ;
  TVLCT, savedR, savedG, savedB, /GET
  colorTable=[[savedR],[savedG],[savedB]]
  
  ;  Get the screen size.
  ;
  DEVICE, GET_SCREEN_SIZE = screenSize
  xdim = screenSize[0]*.50 ;about 10 percent of the screen size
  ydim=xdim  ;keep isotropic
  
  nColors = !d.table_size
  ;  Construct all base widgets.
  ;
  
  wTopBase=WIDGET_BASE(TITLE='objectMesh', $
    XPAD=0, YPAD=0, $
    /COLUMN,/tlb_size_events,MBAR=barBase)
    
  ; Create FILE menu buttons for printing and exiting.
    
  fileId = Widget_Button(barBase, Value='File', /Menu)
  quitter = Widget_Button(fileId, /Separator, Value='Exit', $
    Event_Pro='objectMeshDemoExit')
    
  objId = widget_button(barBase,value='Object Type',/menu)
  void = widget_button(objId,value='Triangulated (Random values)',uvalue='Triangulated',$
    event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Triangulated (Bessel function)',uvalue='TriangulatedB',$
    event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Rectangular (dist(40,40))',uvalue='Rectangular',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Polar',uvalue='Polar',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Cylindrical (w/endcaps)',uvalue='CylindricalWith',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Cylindrical (no endcaps)',uvalue='Cylindrical',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Spherical',uvalue='Spherical',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Extrusion (T shape)',uvalue='Extrusion',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Revolution (cone)',uvalue='Revolution',event_pro='objectMeshDemoObject')
  void = widget_button(objId,value='Ruled (sin/cos)',uvalue='Ruled',event_pro='objectMeshDemoObject')
  
  imgId = widget_button(barBase,value='Image Overlay',/menu)
  void = widget_button(imgId,value='None',uvalue='None',event_pro='objectMeshDemoImage')
  void = widget_button(imgId,value='Choose Jpeg Image',uvalue='Choose',event_pro='objectMeshDemoImage')
  
  resetId = widget_button(barBase,value='Reset',/menu)
  void = widget_button(resetId,value='Reset',uvalue='RESET',event_pro='objectMeshEvent')
  
  projId = widget_button(barBase,value='Projection Type',/menu)
  void = widget_button(projId,value='Orthogonal ',uvalue='ortho',event_pro='objectMeshDemoProj')
  void = widget_button(projId,value='Perspective',uvalue='persp',event_pro='objectMeshDemoProj')
  
  helpId = widget_button(barBase,value='Help',/menu)
  void = widget_button(helpId,value='Help',uvalue='HELP',event_pro='objectMeshEvent')
  
  wDraw=WIDGET_DRAW(wTopBase, XSIZE=xdim, $
    YSIZE=ydim, $  ;keep isotropic
    UVALUE='DRAW', /BUTTON_EVENTS, $
    GRAPHICS_LEVEL=2, RETAIN=0, /EXPOSE_EVENTS)
    
  ;  Realize  the widget hierarchy.
    
  WIDGET_CONTROL, wTopBase, /REALIZE
  WIDGET_CONTROL, HOURGLASS=1
  WIDGET_CONTROL, wDraw, GET_VALUE=oWindow
  
  
  ;  Create the objects.
  ;All objects are going to be scaled between 0 and 1
  myView = [-1.0, -1.0, 2.0, 2.0]
  ;  Create view object.
  oView = OBJ_NEW('IDLgrView', PROJECTION=1, EYE=1.1, $
    COLOR=[0,0,0], $
    VIEW=myView, ZCLIP=[1.0, -1.0])
    
  ;  Create and display the PLEASE WAIT text.
  oFont = OBJ_NEW('IDLgrFont', 'Helvetica', SIZE=12)
  oText = OBJ_NEW('IDLgrText', $
    'Starting up ', $
    ALIGN=0.5, $
    LOCATION=textLocation, $
    COLOR=[255,255,0], FONT=oFont)
    
  ;  Create model objects for rotation, this is the top level coord system
  oRotator=OBJ_NEW('rotator',center=[xdim/2.0, ydim/2.0], $
    radius = xdim, viewModel=oView)
    
  ;  Show the starting up text.
  oview->Add, oRotator
  oRotator->Add, oText
  
  owindow->Draw, oView
  
  ;create the first mesh object
  oMesh = obj_new('mesh', 'spherical',Replicate(0.75 ,20,20) , /TEX_COORDS, $
    COLOR=[255, 255, 255])
    
  read_jpeg,'thissideup.jpg',image
  
  ;Create color palette object.
  tvlct,red,green,blue,/get
  oPalette=obj_new('IDLgrPalette', red, green, blue)
  
  ;  Create image object and add to model hierarchy.
  oImage=OBJ_NEW('IDLgrImage', image, HIDE=0, $
    PALETTE=oPalette)
    
  oMesh->setProperty,texture_map=oImage
  
  oRotator->Add,oMesh
  
  oRotator->Rotate, [1, 0, 0], -90
  ;have to get the transform from the model
  oRotator->GetProperty, TRANSFORM=resetTransform
  ;  Remove the starting up text.
  oRotator->Remove, oText
  
  oContainer = OBJ_NEW('IDL_Container')
  oContainer->Add, oView
  oContainer->Add, oRotator
  oContainer->Add, oMesh
  oContainer->add, oText
  oContainer->add, oFont
  oContainer->add, oPalette
  oContainer->add, oImage
  
  ;  Build state structure used in event handlers.
  ;
  state={ wDraw:wDraw, $             ; Widget draw ID
    oRotator:oRotator, $       ;rotator object
    oMesh : oMesh, $           ;mesh object
    OContainer: oContainer, $  ; Container object
    oWindow:oWindow, $         ; Window object
    oView:oView, $             ; View object
    oPalette : oPalette, $     ;Palette object
    oImage : oImage, $         ;image object
    nColors:nColors, $         ; Number of available colors
    colorTable:colorTable, $    ; Color table to restore
    resetTransform:resetTransform } ;original transformation
    
    
  WIDGET_CONTROL, wTopBase, SET_UVALUE=state, /NO_COPY
  WIDGET_CONTROL, HOURGLASS=0
  
  ;  Register with the XMANAGER
  ;
  XMANAGER, 'objectMesh', wTopBase, /NO_BLOCK, $
    EVENT_HANDLER='objectMeshEvent', CLEANUP="objectMeshCleanup"
  return
end

