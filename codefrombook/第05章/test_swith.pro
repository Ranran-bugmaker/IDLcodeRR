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
PRO TEST_SWITH
  x=2  
  SWITCH x OF
    1: PRINT,'one'
    2: PRINT,'two'
    3: PRINT,'three'
    4: PRINT, 'four'
  ENDSWITCH
  PRINT,'end'
END