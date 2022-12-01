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
FUNCTION FUN_TOTAL, x,y
  RETURN, x+y
END


PRO usingfunction
  a = 1
  b = 2
  result = FUN_TOTAL(a,b)
  PRINT,result
END
;

