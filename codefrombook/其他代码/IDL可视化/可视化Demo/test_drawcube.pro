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
;获取grid
pro GetGridData, m , gVerts = gVerts, gConn = gConn
  COMPILE_OPT IDL2
  
  IF m MOD 2 EQ 0 THEN Return;
  ;定义数据
  gVerts = FLTARR(3,m,m)
  gConn = IntArr(5,(m-1)^2)
  vertColors = BytArr(3,m^2)
  j = 0
  ;建立链接关系
  FOR i=0,(m-1)^2-1 DO BEGIN
    gConn[0,i] = 4
    gConn[1,i] = j
    gConn[2,i] = j+1
    gConn[3,i] = j+m+1
    gConn[4,i] = j+m
    j = j +1
    IF (j MOD m )EQ m-1 THEN j = j+1
  ENDFOR
  k = 0
  FOR i=0,m-1 DO BEGIN
    FOR j=0,m-1 DO BEGIN
      gVerts[0,i,j] = i
      gVerts[1,i,j] = j
      k = 1 - k
    ENDFOR
  ENDFOR
  gVerts[0,*,*] = (gVerts[0,*,*] -FIX(m/2))/FLOAT(FIX(m/2))
  gVerts[1,*,*] = (gVerts[1,*,*] -FIX(m/2))/FLOAT(FIX(m/2))
  
END
function createPolygon, xMax,xMin,yMax,yMin,zMax,zMin
  ;
  if xMax eq xMin then begin
    data = [[xMin,yMin,zMin],[xMin,yMax,zMin],[xMin,yMax,zMax],[xMin,yMin,zMax]]
  endif else begin
    data = [[xMin,yMin,zMin],[xMax,yMin,zMin],[xMax,yMin,zMax],[xMin,yMin,zMax]]
  endelse
  return,data
end

pro test_drawCube
  ;
  lineColor = [0,0,0]
  oModel = Obj_New('IDLgrModel')
  GetGridData,21, gVerts = gVerts, gConn = gConn
  
  ;底面
  oPoly = Obj_New('IDLgrPolygon',gVerts, polygons = gConn,$
    style =1)
  tmp = gVerts
  tmp[2,*,*]+=0.001
  oPoly1 = Obj_New('IDLgrPolygon',tmp, polygons = gConn,$
    style =2,color = [0,80,100])
  oModel->Add,[oPoly,oPoly1]
  
  ;
  ;顶面
  gVerts[2,*,*]+=2
  oPoly = Obj_New('IDLgrPolygon',gVerts, polygons = gConn,$
    style =1)
  tmp = gVerts
  tmp[2,*,*]-=0.001
  oPoly1 = Obj_New('IDLgrPolygon',tmp, polygons = gConn,$
    style =2,color = [255,255,0])
  oModel->Add,[oPoly,oPoly1]
  
  ;侧面
  gVerts[2,*,*]-=2
  gVerts = shift(gVerts,1)
  newgVerts = shift(gVerts,1)
  
  gVerts[2,*,*]+=1
  gVerts[0,*,*]+=1
  oPoly = Obj_New('IDLgrPolygon',gVerts, polygons = gConn,$
    style =1)
  ;
  xMin = Min(gVerts[0,*,*],max = xMax)
  yMin = Min(gVerts[1,*,*],max = yMax)
  zMin = Min(gVerts[2,*,*],max = zMax)
  data = createPolygon(xMax,xMin,yMax,yMin,zMax,zMin)
  VERT_COLORS  = [[0,80,100],[0,80,100],[255,255,0],[255,255,0]]
  oPoly1 = Obj_New('IDLgrPolygon',data, polygons = [4,0,1,2,3],$
    style =2,VERT_COLORS = VERT_COLORS,SHADING =1)
  oModel->Add,[ oPoly,oPoly1]
  ;
  gVerts[0,*,*]-=2
  oPoly = Obj_New('IDLgrPolygon',gVerts, polygons = gConn,$
    style =1)
  xMin = Min(gVerts[0,*,*],max = xMax)
  yMin = Min(gVerts[1,*,*],max = yMax)
  zMin = Min(gVerts[2,*,*],max = zMax)
  data = createPolygon(xMax,xMin,yMax,yMin,zMax,zMin)
  VERT_COLORS  = [[0,80,100],[0,80,100],[255,255,0],[255,255,0]]
  oPoly1 = Obj_New('IDLgrPolygon',data, polygons = [4,0,1,2,3],$
    style =2,VERT_COLORS = VERT_COLORS,SHADING =1)
  oModel->Add,[ oPoly,oPoly1]
  ;
  newgVerts[2,*,*]+=1
  newgVerts[1,*,*]+=1
  oPoly = Obj_New('IDLgrPolygon',newgVerts, polygons = gConn,$
    style =1)
  xMin = Min(newgVerts[0,*,*],max = xMax)
  yMin = Min(newgVerts[1,*,*],max = yMax)
  zMin = Min(newgVerts[2,*,*],max = zMax)
  data = createPolygon(xMax,xMin,yMax,yMin,zMax,zMin)
  VERT_COLORS  = [[0,80,100],[0,80,100],[255,255,0],[255,255,0]]
  oPoly1 = Obj_New('IDLgrPolygon',data, polygons = [4,0,1,2,3],$
    style =2,VERT_COLORS = VERT_COLORS,SHADING =1)
  oModel->Add,[ oPoly,oPoly1]
  
  newgVerts[1,*,*]-=2
  oPoly = Obj_New('IDLgrPolygon',newgVerts, polygons = gConn,$
    style =1)
  xMin = Min(newgVerts[0,*,*],max = xMax)
  yMin = Min(newgVerts[1,*,*],max = yMax)
  zMin = Min(newgVerts[2,*,*],max = zMax)
  data = createPolygon(xMax,xMin,yMax,yMin,zMax,zMin)
  VERT_COLORS  = [[0,80,100],[0,80,100],[255,255,0],[255,255,0]]
  oPoly1 = Obj_New('IDLgrPolygon',data, polygons = [4,0,1,2,3],$
    style =2,VERT_COLORS = VERT_COLORS,SHADING =1)
  oModel->Add,[ oPoly,oPoly1]
  
  xObjView, oModel
end