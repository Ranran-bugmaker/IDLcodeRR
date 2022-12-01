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
  angle = startLat*!Dtor+findgen(nums+1)*(endLat - startLat)/nums*!Dtor
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
  oModel->Add,oPoly
  
  ;球面切方向多边形
  nums = (endLon - startLon)/density
  inArr = make_Array(3,sliderNums+1,/float)
  inArr[2,*] = minR +(maxR-minR)*findgen(sliderNums+1)/sliderNums
  ;
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =(endLat-startLat)/density , P2=[0,0,0], $
    P3 = [cos(startLon*!dtor+!pi/2),sin(startLon*!dtor+!pi/2),0], $
    P4 =startLat*!Dtor, P5 = endLat*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = inSideColor,style =1)
  oModel->Add,oPoly
  
  return,oModel
end
pro test_drawOrb0
  ;
  ;直径为1的地球
  MESH_OBJ, 4, vertices, polygons, REPLICATE(1, 72, 72), $
    /CLOSED
  ;绘制地球出来
  oOrb = Obj_new('IDLgrPolygon', vertices,polygons = polygons,$
    color = [0,0,128], style =1,TEXTURE_MAP=oImage)
    
  oModel = Obj_New('IDLgrModel')
  oModel->Add,oOrb
  ;绘制矢量
  shapeFile = OBJ_NEW('IDLffShape', SourceRoot()+'\shapefile\continents.shp');shapefile\china.shp');
  shapeFile->Getproperty, N_Entities = nEntities
  
  color = [255,255,0]
  FOR i=0, nEntities-1 DO BEGIN
    entitie = shapeFile->Getentity(i)
    IF PTR_VALID(entitie.parts) NE 0 THEN BEGIN
      cuts = [*entitie.parts, entitie.n_vertices]
      FOR j=0, entitie.n_parts-1 DO BEGIN
        tempLon = (*entitie.vertices)[0,cuts[j]:cuts[j+1] - 1]*!dtor
        tempLat = (*entitie.vertices)[1,cuts[j]:cuts[j+1] - 1]*!dtor
        ;
        IF N_ELEMENTS(tempLat) GT 1 THEN BEGIN
          verts  = fltarr(3,N_Elements(templat))
          verts[0,*] = cos(tempLat)*cos(templon)
          verts[1,*] = cos(tempLat)*sin(templon)
          verts[2,*] = sin(templat)
          polyLines = lindgen(N_Elements(templat)+1)-1
          polylines[0] =  N_Elements(templat)
          tempPlot = OBJ_NEW('IDLgrPolyline', $
            verts, $
            Polylines = polyLines    , $
            color = color)
          oModel->Add,tempPlot
        ENDIF
      ENDFOR
    ENDIF
    shapeFile->Destroyentity, entitie
  ENDFOR
  
  OBJ_DESTROY, shapeFile
  ;
  ;创建下面的半球
  angle = 0-findgen(37)*90/36*!Dtor
  inArr = make_array(3,37,/float)
  inArr[0,*] = 1.3*cos(angle)
  inArr[2,*] = 1.3*sin(angle)
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =36 , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =0, P5 = 360*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = [96,196,0],style =1) &  oModel->Add,oPoly
    
  ;创建上面的半球
  angle =0-angle
  inArr[0,*] = 1.3*cos(angle)
  inArr[2,*] = 1.3*sin(angle)
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =27 , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =0*!Dtor, P5 = 270*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = [96,196,0],style =1)
  oModel->Add,oPoly
  ;
  ;左侧红色斜面
  inArr = make_array(3,11,/float)
  inArr[2,*]=1+0.3*findgen(11)/10
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =18 , P2=[0,0,0], $
    P3 = [1,0,0], $
    P4 =0*!Dtor, P5 = 90*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = [196,0,0],style =1)
  oModel->Add,oPoly
  ;红色底面
  inArr = make_array(3,11,/float)
  inArr[0,*]=1+0.3*findgen(11)/10
  Mesh_Obj, 6, Vertex_List, Polygon_List  , $
    inArr, P1 =18 , P2=[0,0,0], $
    P3 = [0,0,1], $
    P4 =270*!Dtor, P5 = 360*!Dtor
  oPoly = Obj_New('IDLgrPolygon', vertex_list, $
    Polygons = polygon_list, $
    color = [196,0,0],style =1)
  oModel->Add,oPoly
  ;右侧小侧面
  oModel->Add, createCureveSurface(3, $
    maxR = 1.3, $
    minR = 1.2, $
    startLon = 350, $
    endLon = 360, $
    startLat = 0, $
    endLat = 90, $
    sliderNums = 10, $
    outSideColor = [96,196,0], $
    inSideColor =[196,0,0] )
  ;
  oModel->Add, createCureveSurface(3, $
    maxR = 1.2, $
    minR = 1.1, $
    startLon = 340, $
    endLon = 350, $
    startLat = 0, $
    endLat = 90, $
    sliderNums = 10, $
    outSideColor = [96,196,0], $
    inSideColor =[196,0,0] )
  ;
  oModel->Add, createCureveSurface(3, $
    maxR = 1.1, $
    minR = 1.0, $
    startLon = 330, $
    endLon = 340, $
    startLat = 0, $
    endLat = 90, $
    sliderNums = 10, $
    outSideColor = [96,196,0], $
    inSideColor =[196,0,0] )
  xobjview,oModel,background = [0,0,0]
end

