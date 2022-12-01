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
;IDL自带的dicom文件
dicomFile = FILEPATH('mr_knee.dcm',SUBDIR=['examples','data'])
;查询文件基本信息
result = QUERY_DICOM(dicomFile,infor)
;创建显示窗口（图16. 9）
WINDOW,0,xsize = infor.DIMENSIONS[0],ysize = infor.DIMENSIONS[1]
TVSCL,READ_DICOM(dicomFile)


END