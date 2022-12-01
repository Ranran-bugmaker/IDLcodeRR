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
;GRIB数据的写出操作示例代码
;注意，IDL的最低版本是8。1
PRO GRIB_WRITE_EXample, filename_in, filename_out, KEY=key, VALUE=value
  ON_ERROR, 2
  ;判断是否调用参数
  IF(filename_in EQ !null) THEN MESSAGE, 'File is undefined.'
  IF(filename_out EQ !null) THEN MESSAGE, 'File is undefined.'

  IF(ARG_PRESENT(key) AND ~ ARG_PRESENT(value)) $
    THEN MESSAGE, 'If key is set then value has to be set.'
  IF(ARG_PRESENT(value) AND ~ ARG_PRESENT(key)) $
    THEN MESSAGE, 'If value is set then key has to be set.'
  ;打开grib文件获取指针
  fin = GRIB_OPEN(filename_in)
  ;从grib文件中获取grib句柄
  h = GRIB_NEW_FROM_FILE(fin)
  ;设置了grib的key
  IF (ARG_PRESENT(key)) THEN BEGIN
    IF (ISA(value, /ARRAY)) THEN GRIB_SET_ARRAY, h, key, value $
    ELSE GRIB_SET, h, key, value
  ENDIF
  ;文件中中写入信息
  GRIB_WRITE_MESSAGE, filename_out, h
  ;销毁grid句柄并清空内存
  GRIB_RELEASE, h
  ;关闭grid文件指针
  GRIB_CLOSE, fin 
  
END
