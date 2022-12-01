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

PRO user_proj_test1_convert,x,y,lat,lon,to_map=to_map,projection=p
  IF(KEYWORD_SET(to_map)) THEN BEGIN
    X=lon
    Y=lat
  ENDIF ELSE BEGIN
    Lon=x
    Lat=y
  ENDELSE
END
