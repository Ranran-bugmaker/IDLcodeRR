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
PRO USING_KEYWORDS, input, keyword1 = keyword1, keyword2 = keyword2,swap = swap
  COMPILE_OPT idl2
  HELP,input
  HELP,keyword1
  HELP,keyword2
  PRINT, KEYWORD_SET(swap)
  IF KEYWORD_SET(swap) THEN BEGIN
    PRINT,'swap'
  ENDIF
END
