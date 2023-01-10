function PlanarPolygonAreaMeters2,points
  compile_opt IDL2
  arr_len=!ents
  a = 0.0d
  for i = 0L, arr_len-1 do begin
    j = (i + 1) MOD arr_len;
    xi = points[i,0] * !metersPerDegree * cos(points[i,1] * !radiansPerDegree);
    yi = points[i,1] * !metersPerDegree;
    xj = points[j,0] * !metersPerDegree * cos(points[j,1] * !radiansPerDegree);
    yj = points[j,1] * !metersPerDegree;
    a +=xi * yj - xj * yi;
  endfor
  return,abs(a/2.0);
end

function SphericalPolygonAreaMeters2,points
  compile_opt idl2
  arr_len=!ENTS
  totalAngle = 0.0;
  for i = 0L, arr_len-1 do begin
    j = (i + 1) mod arr_len;
    k = (i + 2) mod arr_len;
    totalAngle = Angle(points[i,*], points[j,*], points[k,*])
    totalAngle  +=totalAngle
  endfor
  planarTotalAngle = (arr_len - 2) * 180.0
  sphericalExcess = totalAngle - planarTotalAngle;
  if  (sphericalExcess gt 420.0) then begin
    totalAngle = arr_len * 360.0 - totalAngle;
    sphericalExcess = totalAngle - planarTotalAngle;
  ENDIF ELSE IF (sphericalExcess gt 300.0 and sphericalExcess lt 420.0) then begin
    sphericalExcess = abs(360.0 - sphericalExcess);
  ENDIF
  return,sphericalExcess * !radiansPerDegree * !earthRadiusMeters * !earthRadiusMeters;
end


function Angle,p1, p2, p3
  compile_opt idl2
  bearing21 = Bearing(p2, p1)
  bearing23 = Bearing(p2, p3)
  anglex = bearing21 - bearing23
  if (anglex lt 0.0) then begin
    anglex += 360.0;
  endif else begin
  endelse
  return,anglex;
end

function Bearing,from1,to
  compile_opt idl2
  lat1 = from1[1] * !radiansPerDegree;
  lon1 = from1[0] * !radiansPerDegree;
  lat2 = to[1] * !radiansPerDegree;
  lon2 = to[0] * !radiansPerDegree;
  angle = -1*atan(  sin(lon1 - lon2) * cos(lat2)    ,$
    cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon1 - lon2)  );
  if (angle lt 0.0) then begin
    angle += !pi * 2.0
  endif else begin
  endelse
  anglex = angle * !degreesPerRadian;
  return,anglex;
end





pro DIY_lonlat_area,entvs,out
  tm=N_ELEMENTS(entvs)/2
  DEFSYSV,  "!earthRadiusMeters" , 6371000.0; #源码中使用半径为6367460.0;6371000.0
  DEFSYSV,  "!metersPerDegree" , 2.0 * !dpi * !earthRadiusMeters / 360.0;
  DEFSYSV,  "!degreesPerRadian" , 180.0 / !dpi;
  DEFSYSV,  "!radiansPerDegree" , !dpi / 180.0;
  DEFSYSV,  "!ents",tm
  out=PlanarPolygonAreaMeters2(transpose(entvs))
  if (out gt  1000000.0) then begin
    out=SphericalPolygonAreaMeters2(transpose(entvs))
  endif else begin
  endelse
end