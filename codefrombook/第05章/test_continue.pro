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
PRO TEST_CONTINUE

  FOR i = 1,5 DO BEGIN
    IF (i GT 2) THEN CONTINUE
    PRINT, i
  ENDFOR
  PRINT,'end'
END