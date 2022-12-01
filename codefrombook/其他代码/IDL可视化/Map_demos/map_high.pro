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

PRO MAP_HIGH

  DEVICE, decomposed=0
  
  ; 	window, 0, xsize=450, ysize=700  ; india
  WINDOW, 0, xsize=700, ysize=650	; australia
  LOADCT, 24
  
  ; Low resolution
  MAP_SET,  /MERCATOR,  /ISOTROPIC, $
    /HORIZON, E_HORIZON={FILL:1, COLOR:40}, $
    ;/GRID, COLOR=0, LIMIT=[30,127,45,145]  ; Japan
    ;/GRID, COLOR=0, LIMIT=[6,68,37,90]		; India
    /GRID, COLOR=0, LIMIT=[-45,111,-9,155]		; Australia
    
  MAP_CONTINENTS, /COASTS, COLOR=200
  MAP_CONTINENTS, /RIVERS, COLOR=240
  MAP_CONTINENTS, /COUNTRIES, COLOR=152, MLINETHICK=2
  
  
  ; 	window, 2, xsize=450, ysize=700  ; india
  WINDOW, 2, xsize=700, ysize=650	; australia
  
  ; High resolution
  MAP_SET,  /MERCATOR,  /ISOTROPIC, $
    /HORIZON, E_HORIZON={FILL:1, COLOR:40}, $
    ;/GRID, COLOR=0, LIMIT=[30,127,45,145], /HIRES    ; Japan
    ;/GRID, COLOR=0, LIMIT=[6,68,37,90], /hires			; India
    /GRID, COLOR=0, LIMIT=[-45,111,-9,155]		; Australia
    
  MAP_CONTINENTS, /COASTS, COLOR=200,  /HIRES
  MAP_CONTINENTS, /RIVERS, COLOR=240, /HIRES
  MAP_CONTINENTS, /COUNTRIES, COLOR=152, MLINETHICK=2, /HIRES
  
  
END