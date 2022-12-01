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
;ENVI功能扩展函数格式示例
;
PRO ENVI_FUNCTION,event
  COMPILE_OPT idl2
  ;调用ENVI的文件选择对话框选择一个文件
  ENVI_SELECT ,  DIMS=dims , FID=fid, /NO_DIMS, POS=pos, TITLE='选择一个文件，注意此操作不具备dims选择项'
  ;选择结果判断
  IF fid EQ -1 THEN BEGIN
    ENVI_REPORT_ERROR,'未选择文件！',/warning
    RETURN
  ENDIF
  ;选择文件的信息查询
  ENVI_FILE_QUERY,id = fid, fname = fname
  ;文件id的移除
  ENVI_FILE_MNG,fid,/remove
  HELP,event
END