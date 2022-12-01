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
FUNCTION RGB2IDX, RGB

  return, rgb[0] + (rgb[1]*2L^8) + (rgb[2]*2L^16)
  
END





























