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
pro helioCentric, julian, earth=earth, L=L, B=B, R=R , $
    degrees=degrees
    
  ;calculate the helio centric coordinates of the planets
  ;Currently only does earth
    
  ;Inputs
  ; julian = julian day for the calculation time
  ; earth = set keyword for earth position to be found
  ;
  ;Outputs
  ; helioLon = heliocentric longitude
  ; helioLat = heliocentric latitude
  ; helioRad = heliocentric radius
  ;
    
  np = n_params()
  if np eq 0 then begin
    r = widget_message('Julian day must be passed in!')
    return
  endif
  
  ;get the julian millenia
  tau = (julian - 2451545.0d)/365250.d
  
  ;get the earth parameters
  earthVSOP87, L0, L1,L2,L3, L4, B0,B1,B2,B3,B4,R0,R1,R2,R3,R4
  
  L = ( total(L0[0,*] * cos(L0[1,*] + L0[2,*]*tau),/double) + $
    total(L1[0,*] * cos(L1[1,*] + L1[2,*]*tau),/double) * tau + $
    total(L2[0,*] * cos(L2[1,*] + L2[2,*]*tau),/double) * tau^2. + $
    total(L3[0,*] * cos(L3[1,*] + L3[2,*]*tau),/double) * tau^3. + $
    total(L4[0,*] * cos(L4[1,*] + L4[2,*]*tau),/double) * tau^4. )/1.0d08
    
  B = ( total(B0[0,*] * cos(B0[1,*] + B0[2,*]*tau),/double) + $
    total(B1[0,*] * cos(B1[1,*] + B1[2,*]*tau),/double) * tau + $
    total(B2[0,*] * cos(B2[1,*] + B2[2,*]*tau),/double) * tau^2. + $
    total(B3[0,*] * cos(B3[1,*] + B3[2,*]*tau),/double) * tau^3. + $
    total(B4[0,*] * cos(B4[1,*] + B4[2,*]*tau),/double) * tau^4. )/1.0d08
    
  R = ( total(R0[0,*] * cos(R0[1,*] + R0[2,*]*tau),/double) + $
    total(R1[0,*] * cos(R1[1,*] + R1[2,*]*tau),/double) * tau + $
    total(R2[0,*] * cos(R2[1,*] + R2[2,*]*tau),/double) * tau^2. + $
    total(R3[0,*] * cos(R3[1,*] + R3[2,*]*tau),/double) * tau^3. + $
    total(R4[0,*] * cos(R4[1,*] + R4[2,*]*tau),/double) * tau^4. )/1.0d08
    
  if  keyword_set(degrees) then begin
    L = L * (180.0d/!dpi)
    B = B * (180.0d/!dpi)
    L = L mod 360.0d
    B = B mod 360.0d
    index = where( L lt 0, count)
    if count gt 0 then L[index] = L[index] + 360.0d
  endif
  
  return
end


