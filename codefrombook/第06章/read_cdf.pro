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
PRO READ_CDF
  ;获取当前文件所在目录
  curDir = FILE_DIRNAME(ROUTINE_FILEPATH('READ_CDF'),/mark_directory)
  ;定义要读取的cdf文件
  cdfFile = curDir+'data\example.cdf'
  ;判断文件是否存在，不存在则提示信息然后退出
  IF ~FILE_TEST(cdfFile) THEN BEGIN
    void = DIALOG_MESSAGE('cdf文件不存在！',/Error)
    RETURN
  ENDIF
  ;打开cdf文件，获取文件ID
  Id  = CDF_OPEN(cdfFile)
  ;获取属性TITLE的内容，存储在title变量中
  CDF_ATTGET, Id, "TITLE", 0, Title
  ;获取jpgfile的数据内容
  CDF_VARGET, Id, 'jpgfile', Data
  ;真彩色方式显示
  TVSCL, Data,/true
 
  ;显示窗口中间输出title
  XYOUTS, !d.X_SIZE/2, !d.Y_SIZE - 20, ALIGNMENT=0.5, /DEVICE, $
    STRING(title)
  ;关闭文件ID
  CDF_CLOSE, Id
END