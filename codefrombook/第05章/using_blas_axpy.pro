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
PRO USING_BLAS_AXPY
  ;初始化测试数组
  X = LINDGEN(4000,4000)
  Y = LINDGEN(4000,4000)
  ;记录开始时间
  start = SYSTIME(1)
  FOR i=0,9 DO BEGIN
    Y=x*3+Y
  ENDFOR
  PRINT,'数组直接运算用时:',SYSTIME(1)-start
  ;
  X = LINDGEN(4000,4000)
  Y = LINDGEN(4000,4000)
  start = SYSTIME(1)
  FOR i=0,9 DO BEGIN
    BLAS_AXPY, Y, 3, X
  ENDFOR
  PRINT,'BLAS_AXPY运算用时:',SYSTIME(1)-start
END