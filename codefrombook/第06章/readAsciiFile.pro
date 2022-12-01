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
PRO READASCIIFILE
  ;对话框选择文件
  asciifile= DIALOG_PICKFILE(title='输入ascii.txt',$
    filter = '*.txt',$
    path = FILE_DIRNAME(ROUTINE_FILEPATH('READASCIIFILE')))
  ;打开文件
  OPENR,lun,asciifile,/get_lun
  
  IF lun EQ -1 THEN BEGIN
    void = DIALOG_MESSAGE('文件错误！',/error)
    RETURN
  ENDIF
  ;第一种读法
  ;全名按照字符串方式读取，并在控制台输出字符串
  tmp = ''
  WHILE(~EOF(lun)) DO BEGIN
    READF,lun,tmp
    PRINT,tmp
  ENDWHILE
  ;关闭文件
  FREE_LUN,lun
  ;第二种读法
  ;基于数据类型读取
  tmp = INTARR(3)
  str = STRARR(2)
  data = FLTARR(2,4)
  
  OPENR,lun,asciifile,/get_lun
  READF,lun,tmp
  READF,lun,str
  READF,lun,data
  ;关闭文件
  FREE_LUN,lun
END