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
pro simpleCam

  oWIndow = obj_new('IDLgrWindow',dimen=[600,600],retain=2)
  
  camera = obj_new('Camera', color=[0,0,0], viewplane_rect=[-5,-5,110,110], $
    projection=2, camera_location=[50,0,30], zclip=[100,-100], lookat=[50,100,0], $
    /track, eye=100)
    
  camera = obj_new('IDLgrView', color=[0,0,0], viewplane_rect=[-5,-5,110,110], $
    projection=2, zclip=[10,-10], eye=12)
    
  ;create something to look at
  ;seed=100
  snowSurface = randomu(seed, 100, 100)*25.0
  for j = 0, 2 do snowSurface = smooth(snowSurface, 5,/edge)
  ;square = obj_new('IDLgrPolygon',[0,1,1,0],[0,0,1,1],color=[255,0,0])
  square = obj_new('IDLgrSurface',snowSurface,color=[255,255,255],style=2,shading=1)
  ;create a top level model whose transform will be manipulated directly
  ;by the camera.  Since the ORB is a subclass of IDLgrModel you could
  ;throw the orbs directly into the camera and unlike in camdemo_basic.pro
  ;this would actually produce the expected result since we haven't
  ;manipulated any of the orb's transform matricies.
  topmodel = obj_new('IDLgrModel')
  
  topmodel -> add, square
  
  ;blue ambient light for effect
  oAmbLight = obj_new('IDLgrLight', type=0, color=[0,0,255],intensity=0.4)
  ;positional light to mimic moonlight
  oPosLight1 = obj_new('IDLgrLight', type=1, $
    color=[255,255,255], location=[100, 50, 35])
    
  topmodel -> add,[oAmbLight, oPosLight1]
  ;Since we want to view the items in top model "thru the lens",
  ;add this model to the camera
  camera -> add, topmodel
  
  oWindow->draw, camera
  
  return & end