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

PRO ENVI_BATCH_MODE

  COMPILE_OPT IDL2
  ;恢复ENVI的sav文件
  ENVI, /RESTORE_BASE_SAVE_FILES
  ;初始化ENVI，并保存日志文件
  ENVI_BATCH_INIT, log_file='batch.LOG'
  ;ENVI函数打开文件
  ENVI_OPEN_FILE, fname, r_fid=fid
  ;如果未选择文件或文件无法打开
  IF (fid EQ -1) THEN BEGIN
    ;ENVI二次开发模式关闭
    ENVI_BATCH_EXIT
    RETURN
  ENDIF
  ;查询文件信息
  ENVI_FILE_QUERY, fid,fName = fileName
  ;对话框提示文件名称
  tmp = DIALOG_MESSAGE(fileName,/infor)
  ;ENVI二次开发模式关闭
  ENVI_BATCH_EXIT

END