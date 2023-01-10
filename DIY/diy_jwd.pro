;;function atan2,x,y
;;;此函数和matlab中的atan2输入的xy是相反的
;;
;;x=x*1d0 & y=y*1d0
;;absy = 0d & absx = 0d & val = 0d
;;
;;IF(x eq 0 and y eq 0)THEN BEGIN
;;return, 0 ; ERROR!
;;ENDIF
;;
;;absy = abs(y) & absx = abs(x)
;;
;;IF(absy - absx eq absy)THEN BEGIN
;;IF(y lt 0)THEN BEGIN
;;return, -!pi/2
;;ENDIF ELSE BEGIN
;;return, !pi/2
;;ENDELSE
;;ENDIF
;;
;;IF(absx - absy eq absx)THEN BEGIN
;;val = 0d0
;;ENDIF ELSE BEGIN
;;val = atan(y/x)
;;ENDELSE
;;
;;IF(x gt 0)THEN BEGIN
;;return, val
;;ENDIF
;;
;;IF(y lt 0)THEN BEGIN
;;return, val-!pi
;;ENDIF
;;
;;return, val+!pi
;;
;;;———————————
;;; another algorithm
;;; IF(y gt 0)THEN BEGIN
;;; IF(x gt 0)THEN BEGIN
;;; val = atan(y/x)
;;; ENDIF
;;; IF(x lt 0)THEN BEGIN
;;; val = !pi - atan(-y/x)
;;; ENDIF
;;; IF(x eq 0)THEN BEGIN
;;; val = !pi/2
;;; ENDIF
;;; ENDIF
;;; IF(y lt 0)THEN BEGIN
;;; IF(x gt 0)THEN BEGIN
;;; val = -atan(-y/x)
;;; ENDIF
;;; IF(x lt 0)THEN BEGIN
;;; val = atan(y/x)-!pi
;;; ENDIF
;;; IF(x eq 0)THEN BEGIN
;;; val = !pi/2*3
;;; ENDIF
;;; ENDIF
;;; IF(y eq 0)THEN BEGIN
;;; IF(x gt 0)THEN BEGIN
;;; val = 0
;;; ENDIF
;;; IF(x lt 0)THEN BEGIN
;;; val = !pi
;;; ENDIF
;;; IF(x eq 0)THEN BEGIN
;;; val = 0 ;error
;;; ENDIF
;;; ENDIF
;;; return, val
;;end
;
;function PlanarPolygonAreaMeters2,points
;  compile_opt IDL2,HIDDEN
;  arr_len=!arr_lenx
;  a = 0.0d
;  for i = 0L, arr_len-1 do begin
;    j = (i + 1) MOD arr_len;
;    xi = points[i,0] * !metersPerDegree * cos(points[i,1] * !radiansPerDegree);
;    yi = points[i,1] * !metersPerDegree;
;    xj = points[j,0] * !metersPerDegree * cos(points[j,1] * !radiansPerDegree);
;    yj = points[j,1] * !metersPerDegree;
;    a +=xi * yj - xj * yi;
;  endfor
;  return,abs(a/2.0);
;end
;
;function SphericalPolygonAreaMeters2,points
;  arr_len=!arr_lenx
;  totalAngle = 0.0;
;  for i = 0L, arr_len-1 do begin
;    j = (i + 1) mod arr_len;
;    k = (i + 2) mod arr_len;
;    totalAngle = Angley(points[i,*], points[j,*], points[k,*])
;    totalAngle  +=totalAngle
;  endfor
;  planarTotalAngle = (arr_len - 2) * 180.0
;  sphericalExcess = totalAngle - planarTotalAngle;
;  if  (sphericalExcess > 420.0) then begin
;    totalAngle = arr_len * 360.0 - totalAngle;
;    sphericalExcess = totalAngle - planarTotalAngle;
;  ENDIF ELSE IF (sphericalExcess > 300.0 and sphericalExcess < 420.0) then begin
;    sphericalExcess = abs(360.0 - sphericalExcess);
;  ENDIF
;  return,sphericalExcess * !radiansPerDegree * !earthRadiusMeters * !earthRadiusMeters;
;end
;
;
;function Angley,p1, p2, p3
;  bearing21 = Bearing(p2, p1)
;  bearing23 = Bearing(p2, p3)
;  anglex = bearing21 - bearing23
;  if (anglex < 0.0) then begin
;    anglex += 360.0;
;  endif else begin
;  endelse
;  return,anglex;
;end
;
;
;function Bearing,from1, to
;  lat1 = from1[1] * !radiansPerDegree;
;  lon1 = from1[0] * !radiansPerDegree;
;  lat2 = to[1] * !radiansPerDegree;
;  lon2 = to[0] * !radiansPerDegree;
;  angle = -1*atan2(sin(lon1 - lon2) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon1 - lon2));
;  if (angle < 0.0) then begin
;    angle += !pi * 2.0
;  endif else begin
;  endelse
;  anglex = angle * !degreesPerRadian;
;  return,anglex;
;end
;
;
;
;pro DIY_jwd,txt,ans
;
;;earthRadiusMeters = 6371000.0; 
;;metersPerDegree = 2.0 * !pi * earthRadiusMeters / 360.0;
;;degreesPerRadian = 180.0 / !pi;
;DEFSYSV,'!earthRadiusMeters',6371000.0
;;111194.92664455873 57.29577951308232 0.017453292519943295
;DEFSYSV,'!metersPerDegree',111194.92664455873d;double(2.0 * !pi * !earthRadiusMeters / 360.0)
;DEFSYSV,'!degreesPerRadian',57.29577951308232d;double(180.0 / !pi)
;DEFSYSV,'!radiansPerDegree',0.017453292519943295d;double(!pi / 180.0)
;data=txt
;arr = data.split(",0")
;arrx=STRSPLIT(arr,',',/EXTRACT)
;
;
;DEFSYSV,'!arr_lenx',N_ELEMENTS(arr)-1
;artxt=MAKE_ARRAY(!ARR_LENX,2,/DOUBLE)
;
;
;
;
;
;if (!arr_lenx lt 3) then begin
;  ans=-99999
;  RETURN
;endif else begin
;  for i = 0L, !ARR_LENX-1 do begin
;    artxt[i,0]=arrx[i,0]
;    artxt[i,1]=arrx[i,1]
;  endfor
;  ans=PlanarPolygonAreaMeters2(artxt)
;;  if (ans gt  1000000.0) then begin
;;    ans=SphericalPolygonAreaMeters2(artxt)
;;  endif else begin
;;  endelse
;
;endelse
;
;;txt=STRSPLIT(txt,",0 ",/EXTRACT)
;
;
;
;;for i in range(0,arr_len):
;;temp.append([float(x) for x in arr[i].split(',')])
;;a=PlanarPolygonAreaMeters2(temp)
;;if a> 1000000.0:
;;a=SphericalPolygonAreaMeters2(temp)
;
;;print (a)
;end