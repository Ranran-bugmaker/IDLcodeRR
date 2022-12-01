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

PRO USER_PROJ_TEST2_DEFINE, add_params

  IF (N_ELEMENTS(add_params) GT 0) THEN BEGIN  
    default_1 = add_params[0]    
    default_2 = add_params[1]    
    default_3 = add_params[2]    
    default_4 = add_params[3]    
  ENDIF  
  
  base = WIDGET_AUTO_BASE(title='User Projection #1 Additional Parameters')  
  sb = WIDGET_BASE(base, /column, /frame)  
  sb1 = WIDGET_BASE(sb, /row)  
  wp = WIDGET_PARAM(sb1, prompt='Parameter #1', $  
    xsize=12, dt=4, field=4, default=default_1, $    
    uvalue='param_1', /auto)    
  sb1 = WIDGET_BASE(sb, /row)  
  wp = WIDGET_PARAM(sb1, prompt='Parameter #2', $  
    xsize=12, dt=4, field=4, default=default_2, $    
    uvalue='param_2', /auto)
    
  sb1 = WIDGET_BASE(sb, /row)  
  wp = WIDGET_PARAM(sb1, prompt='Parameter #3', $  
    xsize=12, dt=4, field=4, default=default_3, $    
    uvalue='param_3', /auto)
    
  sb1 = WIDGET_BASE(sb, /row)
  
  wp = WIDGET_PARAM(sb1, prompt='Parameter #4', $  
    xsize=12, dt=4, field=4, default=default_4, $    
    uvalue='param_4', /auto)
    
  result = AUTO_WID_MNG(base)
  
  IF (result.ACCEPT) THEN $  
    add_params = [result.PARAM_1, result.PARAM_2, $    
    result.PARAM_3, result.PARAM_4]
    
END



PRO USER_PROJ_TEST2_CONVERT, x, y, lat, lon, $
    to_map=to_map, projection=p    
  COMPILE_OPT IDL2
  
  IF (KEYWORD_SET(to_map)) THEN BEGIN  
    x = lon * 100. + p.PARAMS[4]    
    y = lat * 100. + p.PARAMS[5]    
  ENDIF ELSE BEGIN  
    lon = (x - p.PARAMS[4]) / 100.    
    lat = (y - p.PARAMS[5]) / 100.    
  ENDELSE
  
END

