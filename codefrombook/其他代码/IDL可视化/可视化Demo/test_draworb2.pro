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
function createPolygon, xMax,xMin,yMax,yMin,zMax,zMin
  data = [[xMin,yMin,zMax],[xMin,yMax,zMax],[xMax,yMax,zMax],[xMax,yMin,zMax]]
  return,data
end
Function SourceRoot

  Compile_Opt StrictArr
  
  Help, Calls = Calls
  UpperRoutine = (StrTok(Calls[1], ' ', /Extract))[0]
  Skip = 0
  Catch, ErrorNumber
  If (ErrorNumber ne 0) then Begin
    Catch, /Cancel
    ThisRoutine = Routine_Info(UpperRoutine, /Functions, /Source)
    Skip = 1
  EndIf
  If (Skip eq 0) then Begin
    ThisRoutine = Routine_Info(UpperRoutine, /Source)
    if (thisRoutine.Path eq '') then begin
      message,'',/traceback
    endif
  EndIf
  catch,/cancel
  if (strpos(thisroutine.path,path_sep()) eq -1 ) then begin
    cd, current=current
    sourcePath = filepath(thisrouitine.path, root=current)
  endif else begin
    sourcePath = thisroutine.path
  endelse
  Root = StrMid(sourcePath, 0, StrPos(sourcePath, path_sep(), /Reverse_Search) + 1)
  Return, Root
End
;创建扇形条多边形
;density: 每一度网格个数
;maxR:大半径
;minR:小半径
function createCureveSurface,density, $
    maxR = maxR, $
    minR = minR, $
    startLon = sTartLon, $
    endLon = endLon, $
    startLat = sTartLat, $
    endLat = endLat, $
    sliderNums = sliderNums, $
    outSideColor = outSideColor, $
    inSideColor = inSideColor
  ;
  oModel = Obj_New('IDLgrModel')
  ;球面方向多边形
  nums = (endLat-startLat)/density
  angle = (90+startLat)*!Dtor+findgen(nums+1)*(endLat - startLat)/nums*!Dtor
  inArr = make_array(3,nums+1,/float)
  inArr[0,*] = maxR*cos(angle)
  inArr[2,*] = maxR*sin(angle)
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =(endLon - startLon)/density , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =startLon*!Dtor, P5 = endLon*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = outSideColor,style =1)
  ;纹理层
  read_jpeg,  SourceRoot()+'world_dem_rgb.jpg',image2,/true
  startX = (startLon+180)*800./360
  endX =  (endLon+180)*800./360
  startY = (startLat+90)*400./180
  endY =  (endLat+90)*400./180<399
  parts = image2[*,startX:endX, startY:endY]
  image = Obj_New('IDLgrImage',parts)
  xMin = Min(Vertex_List[0,*,*],max = xMax)
  yMin = Min(Vertex_List[1,*,*],max = yMax)
  zMin = Min(Vertex_List[2,*,*],max = zMax)
  data = createPolygon(xMax,xMin,yMax,yMin,zMax,zMax)
  oPoly1 = Obj_New('IDLgrPolygon',[[Vertex_List[*,0]],[Vertex_List[*,10]],$
    [Vertex_List[*,120]],[Vertex_List[*,110]]], polygons = [5,0,1,2,3,0],$
    style =2,$
    color = [255,255,255], $
    TEXTURE_MAP = image,$
    TEXTURE_c = [[0,0],[0,1],[1,1],[1,0]])
  oModel->Add,oPoly1
  
  ;球面切方向多边形
  nums = (endLon - startLon)/density
  inArr = make_Array(3,sliderNums+1,/float)
  inArr[2,*] = minR +(maxR-minR)*findgen(sliderNums+1)/sliderNums
  
  ;    ;
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =(endLat-startLat)/density , P2=[0,0,0], $
    P3 = [cos(startLon*!dtor-.5*!pi),sin(startLon*!dtor-.5*!pi),0], $
    P4 =startLat*!Dtor, P5 = endLat*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = inSideColor,style =1)
  oModel->Add,oPoly
  ;
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =(endLat-startLat)/density , P2=[0,0,0], $
    P3 = [cos(endLon*!dtor-.5*!pi),sin(endLon*!dtor-.5*!pi),0], $
    P4 =startLat*!Dtor, P5 = endLat*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = inSideColor,style =1)
  oModel->Add,oPoly
  ;
  inArr = make_Array(3,sliderNums+1,/float)
  inArr[0,*]=minR +(maxR-minR)*findgen(11)/10
  
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =(endLat-startLat)/density , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =startLon*!Dtor+!PI, P5 = endLon*!Dtor+!PI
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = inSideColor,style =1)
  oModel->Add,oPoly
  
  
  return,oModel
end
pro test_drawOrb2
  ;
  read_jpeg,  SourceRoot()+'world_dem_rgb.jpg',image2,/true
  
  oImage = Obj_New('idlgrImage',image2)
  oOrb = OBJ_NEW('orb', COLOR=[255, 255, 255], RADIUS=1, $
    DENSITY=4,/TEX_COORDS,TEXTURE_MAP=oImage)
    
  oModel = Obj_New('IDLgrModel')
  oModel->Add,oOrb
  ;
  ;创建下面的半球
  angle = findgen(37)*360/36*!Dtor
  inArr = make_array(3,37,/float)
  inArr[0,*] = 1.01*cos(angle)
  inArr[2,*] = 1.01*sin(angle)
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =36 , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =0, P5 = 360*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = [128,128,0], $
    style =1) &  oModel->Add,oPoly
  ;
  ;突出小界面
  oModel->Add, createCureveSurface(3, $
    maxR = 1.3, $
    minR = 1, $
    startLon = 80, $
    endLon = 110, $
    startLat =60, $
    endLat = 90, $
    sliderNums = 10, $
    outSideColor = [96,196,0], $
    inSideColor =[196,0,0] )
  ;
  xobjview,oModel
end

