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
PRO MAP_EXAMPLE

  DEVICE, decomposed=0
  LOADCT, 13
  WINDOW, 0, xs=700, ys=500
  
  ;MAP_SET,  /MERCATOR, -0, 130, /ISOTROPIC, $
  MAP_SET,  /MOLLW, -0, 130, /ISOTROPIC, $
    ;MAP_SET,  /ORTHO, -0, 130, 23, /ISOTROPIC, $
    /HORIZON, E_HORIZON={FILL:1, COLOR:40}, $
    /GRID, COLOR=0
    
  MAP_CONTINENTS, /FILL_CONTINENTS, COLOR=240
  
  MAP_CONTINENTS, /COASTS, COLOR=70
  
  MAP_CONTINENTS, /COUNTRIES, COLOR=200
  
END