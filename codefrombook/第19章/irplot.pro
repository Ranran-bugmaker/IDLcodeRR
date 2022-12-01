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
; *******************************************************
; This routine is an example of a user defined plot function.
; Move this file to the save_add directory of the ENVI
; installation tree. Add an entry to the useradd.txt file to
; allow selection of this method from the Plot Function menu.
;
; For more information see the ENVI Programmer's Guide.
; *******************************************************
; Copyright (c) 1995-2010, ITT Visual Information Solutions. All
;       rights reserved. Unauthorized reproduction is prohibited.
; *******************************************************

FUNCTION pf_zero_mean, plot_x, plot_y, bbl, bbl_array, $
    _extra=_extra
  bbl_ptr = WHERE(bbl_array EQ 1b, count)
  IF (count GT 0) THEN $
    RETURN, FLOAT(plot_y) - (TOTAL(plot_y(bbl_ptr)) / N_ELEMENTS(bbl_ptr)) $
  ELSE $
    RETURN, FLTARR(N_ELEMENTS(plot_y))
END
