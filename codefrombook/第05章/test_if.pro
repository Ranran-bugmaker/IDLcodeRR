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
PRO TEST_IF,num,div
  IF((num MOD 2) EQ 0) THEN BEGIN
    tmp = DIALOG_MESSAGE(STRING(num)+' 是偶数！')
  ENDIF
  IF((num MOD div) EQ 0) THEN BEGIN
    tmp = DIALOG_MESSAGE(STRING(num)+'能够被'+STRING(div)+'整除！')
  ENDIF ELSE BEGIN
    tmp = DIALOG_MESSAGE(STRING(num)+'不能够被'+STRING(div)+'整除！')
  ENDELSE
  IF 0 THEN BEGIN
  ENDIF ELSE IF 0 THEN BEGIN
  ENDIF ELSE IF 1 THEN BEGIN
    PRINT,'end'
  ENDIF
END