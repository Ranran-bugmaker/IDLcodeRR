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
PRO USING_CONTINUATIONLINE
  s = 'abc'
  PRINT,'esri'+s
  PRINT,'esri'+ $
    s
END
