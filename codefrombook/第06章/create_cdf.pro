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
PRO CREATE_CDF
  ;获取当前文件所在目录
  curDir = FILE_DIRNAME(ROUTINE_FILEPATH('create_cdf'),/mark_directory)
  ;定义要读取的jpeg文件
  jpegfile =curDir+'data\idl.jpg'
  ;判断文件是否存在，不存在则提示信息然后退出
  IF ~FILE_TEST(jpegFile) THEN BEGIN
    void = DIALOG_MESSAGE('jpeg文件不存在！',/Error)
    RETURN
  ENDIF
  ;读取jpeg文件
  READ_JPEG, jpegFile,data
  ;获取数据信息
  dimensions = SIZE(data,/dimensions)
  ;构建保存的cdf文件
  cdfFile = curDir+'data\example.cdf'
  ;文件若已经存在则删除
  IF FILE_TEST(cdfFile) THEN FILE_DELETE, cdfFile
  ;创建CDF文件，设置数据大小，返回CDF文件ID
  Id  = CDF_CREATE(cdfFile,dimensions)
  ;构建属性title
  dummy = CDF_ATTCREATE(Id, "TITLE", /GLOBAL)
  ;写入属性title内容
  CDF_ATTPUT, Id, "TITLE", 0, "idl.jpg"
  ;构建数据内容
  VarId = CDF_VARCREATE(Id,'jpgfile', ['VARY', 'VARY', 'VARY'])
  ;写入数据
  CDF_VARPUT, Id, VarId, Data
  
  ;关闭CDF文件ID
  CDF_CLOSE, Id
  
END