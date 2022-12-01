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
PRO test_goto

  GOTO, JUMP1
  PRINT, 'Skip this' ; This statement is skipped
  PRINT, 'Skip this' ; This statement is also skipped
  JUMP1: PRINT, 'Do this'
  
END