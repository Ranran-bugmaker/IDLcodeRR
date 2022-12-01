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
;GRIB数据的读取操作示例代码
;注意，IDL的最低版本是8.1
PRO  GRIB_Read_Example, HEADER=header
  compile_opt idl2
  ;IDL版本判断
  curversion = FLOAT(!Version.RELEASE)
  IF curversion LT 8.1 THEN BEGIN
    void = DIALOG_MESSAGE('当前IDL版本低于8.1',/infor)
    RETURN
  ENDIF
  ;选择Grib文件
  filename = DIALOG_PICKFILE(title ='选择Grib数据')
  ;打开grib文件获得指针
  f = GRIB_OPEN(filename)
  ;创建数据指针
  data = PTRARR(GRIB_COUNT(filename))
  ;如果设置了header则定义初始化数组
  IF(ARG_PRESENT(header)) THEN header = MAKE_ARRAY(GRIB_COUNT(filename), /OBJ)
  ;从grib文件中获取grib句柄
  h = GRIB_NEW_FROM_FILE(f)
  ;初始化计数变量
  i=0
  ;循环读取
  WHILE(h NE !NULL) DO BEGIN
  
    ;获取值数组
    values = GRIB_GET_VALUES(h)
    data[i] = PTR_NEW(values)
    ;如需要读取header则依次读取
    IF (ARG_PRESENT(header)) THEN BEGIN
      kiter = GRIB_KEYS_ITERATOR_NEW(h, /COMPUTED)
      header[i] = LIST()
      res = GRIB_KEYS_ITERATOR_NEXT(kiter)
      WHILE (res EQ 1) DO BEGIN
        key = GRIB_KEYS_ITERATOR_GET_NAME(kiter)
        IF (STRCMP(key, 'values', /FOLD_CASE) EQ 0) THEN BEGIN
          IF (GRIB_GET_SIZE(h, key) GT 1) THEN $
            val = GRIB_GET_ARRAY(h, key)ELSE val = GRIB_GET(h, key)
          IF (STRCMP(key, '7777', /FOLD_CASE) EQ 1) THEN key = 'end_section'
          key_value = CREATE_STRUCT(key, val)
          header[i].ADD, key_value
        ENDIF
        res = GRIB_KEYS_ITERATOR_NEXT(kiter)
      ENDWHILE
      GRIB_KEYS_ITERATOR_DELETE, kiter
    ENDIF
    
    GRIB_RELEASE, h
    h = GRIB_NEW_FROM_FILE(f)
    i++
  ENDWHILE
  ;关闭Grib文件指针
  GRIB_CLOSE, f
  ;查看读取的数据信息
  HELP, data
END

