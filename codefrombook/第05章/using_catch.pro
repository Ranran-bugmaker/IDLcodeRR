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
PRO USING_CATCH

  CATCH, error_status
  
  A = INDGEN(6)
  ;检测错误信息
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;重新定义A
    A = INDGEN(7)
    CATCH, /CANCEL
  ENDIF
  
  A[6]=12
  PRINT, A
  
END
