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
FUNCTION PF_ZERO_MEAN, x, y, bbl, bbl_array, _extra=_extra
  Bbl_ptr=WHERE(bbl_array EQ 1,count)
  IF(count GT 0) THEN $
    Result=y-(TOTAL(y[bbl_ptr])/count) $
  ELSE $
    Result=FLTARR(N_ELEMENTS(y))
  RETURN, result
END
