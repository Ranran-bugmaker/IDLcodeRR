;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
function earthCentralAngle,Lat1,Lat2,Lon1,Lon2
  ;
  ;+
  ; Computes the earth central angle subtended by two longitudes and two
  ; latitudes.
  ; This function does assume that the input values are in degrees!
  ; Output is in degrees too!
  ; According to Don Brand, lon1 must be to the left of lon2
  ;-

  dtor = 2.0d*!dpi/360.0d ;have to have double precision!
  londiff = abs(Lon1-Lon2)
  ;
  ;;index = where( londiff lt 0.0d, count)
  ;;if count gt 0. then londiff[index] = londiff[index] + (360.0d)
  ;;index = where( londiff gt 180.0d, count)
  ;;if count gt 0 then londiff[index] = (360.0d) - londiff[index]
  ;
  ECA = acos(sin(Lat1*dtor)*sin(Lat2*dtor) + $
    cos(Lat1*dtor)*cos(Lat2*dtor)*cos(londiff*dtor))/dtor
    
  ;was experimenting with the following way but it was way too slow
  ;it did work though
  ;ecf1 = ([[cos(Lat1*dtor)*cos(Lon1*dtor)], $
  ;         [cos(Lat1*dtor)*sin(Lon1*dtor)], $
  ;         [sin(Lat1*dtor)]])
  ;ecf2 = ([[cos(Lat2*dtor)*cos(Lon2*dtor)], $
  ;         [cos(Lat2*dtor)*sin(Lon2*dtor)], $
  ;         [sin(Lat2*dtor)]])
  ;nPoints = n_elements(Lat1)
  ;pole = ([[fltarr(nPoints)],[fltarr(nPoints)],[fltarr(nPoints)+1.0]])
  ;ECA = directedAngle(ecf1,ecf2, pole, /degrees)
    
  return,ECA
  
end
