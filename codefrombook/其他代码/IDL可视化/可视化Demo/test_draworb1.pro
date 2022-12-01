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


pro test_drawOrb1

   READ_JPEG, SourceRoot()+'\earth.jpg',image,true=1

    oImageArray= OBJ_NEW('IDLgrImage', image, HIDE=1)
    oplanet = OBJ_NEW('orb', COLOR=[255, 255, 255], RADIUS=1, $
        DENSITY=1, /TEX_COORDS, TEXTURE_MAP=oImageArray, STYLE=2)

    oModel = Obj_New('IDLgrModel')
    oModel->Add,oplanet

    ;创建下面的半球
    angle = findgen(37)*360/36*!Dtor
    inArr = make_array(3,37,/float)
    inArr[0,*] = 1.000001*cos(angle)
    inArr[2,*] = 1.000001*sin(angle)
    Mesh_Obj, 6, Vertex_List, Polygon_List  , $
        inArr, P1 =36 , P2=[0,0,0], $
        P3 = [0,0,1], $
        P4 =0, P5 = 360*!Dtor
    oPoly = Obj_New('IDLgrPolygon', vertex_list, $
        Polygons = polygon_list, $
        color = [128,128,128],style =1)
    oModel->Add,oPoly

    ;绘制矢量
    shapeFile = OBJ_NEW('IDLffShape', SourceRoot()+'\shapefile\continents.shp');shapefile\china.shp');
    shapeFile->Getproperty, N_Entities = nEntities

    color = [255,255,0]
    FOR i=0, nEntities-1 DO BEGIN
      entitie = shapeFile->Getentity(i)
      IF PTR_VALID(entitie.parts) NE 0 THEN BEGIN
        cuts = [*entitie.parts, entitie.n_vertices]
        FOR j=0, entitie.n_parts-1 DO BEGIN
          tempLon = 2*!pi - (*entitie.vertices)[0,cuts[j]:cuts[j+1] - 1]*!dtor
          tempLat =!pi - (*entitie.vertices)[1,cuts[j]:cuts[j+1] - 1]*!dtor
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

  XOBJVIEW,omodel


end