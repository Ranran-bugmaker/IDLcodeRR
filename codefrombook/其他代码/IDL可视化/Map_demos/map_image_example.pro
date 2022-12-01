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

PRO MAP_IMAGE_EXAMPLE

  DEVICE, decomposed=0
  
  WINDOW, 1, xsize=360, ysize=360
  
  OPENR, 1, FILEPATH('worldelv.dat', SUBDIRECTORY=['examples','data'])
  elev = BYTARR(360,360)
  READU, 1, elev
  CLOSE, 1
  LOADCT, 13
  TVSCL, elev
  
  WINDOW, 0, xsize=750, ysize=700
  LOADCT, 13
  
  LATMIN=-90
  LONMIN=0
  LATMAX=90
  LONMAX=360
  
  ;MAP_SET,  /MERCATOR, -0, 130, /ISOTROPIC, $
  ;MAP_SET,  /MOLLW, -0, 130, /ISOTROPIC, $
  MAP_SET,  /ORTHO, -0, 130,  /ISOTROPIC, $
    /HORIZON, E_HORIZON={FILL:1, COLOR:40};, $
  ;LIMIT=[latmin, lonmin, latmax, lonmax]
    
  result = MAP_IMAGE(elev,Startx,Starty, COMPRESS=1, $
    LATMIN=LATMIN, LONMIN=LONMIN, $
    LATMAX=LATMAX, LONMAX=LONMAX, /BILINEAR)
    
  TV, result, Startx, Starty
  
  MAP_CONTINENTS, /FILL_CONTINENTS, COLOR=240
  MAP_CONTINENTS, /COASTS, COLOR=70
  MAP_CONTINENTS, /COUNTRIES, COLOR=200
  
END