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
PRO USING_PROFILER
  ;
  PROFILER, /SYSTEM
  a =  DIST(2000,2000)
  sum = 0.
  sum1 = 0.
  FOR i=0L,N_ELEMENTS(a)-1L DO IF(a[i] GT 100.0)THEN sum = sum +a[i]
  i=0L
  WHILE i LT N_ELEMENTS(a)-1L DO BEGIN
    IF(a[i] GT 100.0)THEN sum = sum +a[i]
    i++
  ENDWHILE
  sum = TOTAL(a * (a GT 100.0))
  PROFILER,/REPORT
END
