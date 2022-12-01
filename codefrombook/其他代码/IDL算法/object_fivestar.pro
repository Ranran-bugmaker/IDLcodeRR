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
;
;五角星显示
PRO OBJECT_FIVESTAR
  ;多边形边数
  sidenumber = 5
  r = 1
  ;点及链接关系变量初值
  points = [0.,0]
  polylines = 0
  ;
  ica = 2*!pi/sidenumber
  startAngle = !pi /(2*sidenumber)
  ;循环生成点及链接关系
  FOR curs =0,sidenumber -1 DO BEGIN
    curPoints = [r*COS(startAngle +curs*ica),r*SIN(startAngle +curs*ica)]
    points = [[points],[curPoints]]
    polylines = [polylines,2,curs, (curs+2) MOD sidenumber]
  ENDFOR
  ;剔除初始值
  points = points[*,1:(N_ELEMENTS(points)/2-1)]
  polylines = polylines[1:N_ELEMENTS(polylines)-1]
  ;显示
  XOBJVIEW, OBJ_NEW('IDLgrPolyline',points, $
    polylines = polylines)
    
END