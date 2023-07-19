;+
; :Description:将01类型的字符串转换为byte
;
;-
function DIY_string_2_byte,str,set_0=sa,set_1=sb
  compile_opt idl2
  a=0b
  b=1B
  str_lenth=strlen(str)
  if (str_lenth eq 0b) then RETURN, !values.F_NAN

  str_arry=fix(STRMID(str,0,1))
  for si = 1L, str_lenth-1 do str_arry=[str_arry,fix(STRMID(str,si,1))]
  for ii = 0L, str_lenth-1 do begin
    if (str_arry[ii] gt 1L) then begin
      PRINT,"字符不符合二进制字符"
      RETURN, !values.F_NAN
    endif
  endfor
  out=0B
  for oi = 0L, str_lenth-1 do begin
    if (str_arry[str_lenth-oi-1] eq 1) then begin
      out+=b*2^oi
    endif else begin
      out+=a*2^oi
    endelse
  endfor
  return, out
end


