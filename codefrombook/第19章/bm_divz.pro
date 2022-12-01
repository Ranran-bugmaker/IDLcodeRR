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
;
;计算(b1+b2)/(b1-b2)并增加条件处理
;
FUNCTION bm_divz, b1, b2, check=check, div_zero=div_zero

  ;如果设置了check关键字
  IF (KEYWORD_SET(check)) THEN BEGIN
    ; 当分母为0时的处理方式
    IF (N_ELEMENTS(div_zero) GT 0) THEN $
      temp_value = div_zero $
    ELSE temp_value = 0.0

    ; 定位波段中为0的像元
    temp = FLOAT(b1) - b2
    ptr = WHERE(temp EQ 0, count)

    ;如果有0值，则设置为1
    IF (count GT 0) THEN temp(ptr) = 1

    ;计算比值
    result = (FLOAT(b1) + b2) / temp

    ; 如果进行了除0则设置
    IF (count GT 0) THEN result(ptr) = temp_value

  ENDIF ELSE BEGIN

    ;计算忽略0值的比值
    result = (FLOAT(b1) + b2) / (FLOAT(b1) - b2)

  ENDELSE

  RETURN, result

END
