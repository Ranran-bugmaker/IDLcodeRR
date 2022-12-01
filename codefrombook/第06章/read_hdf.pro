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
PRO READ_HDF
  ;获取当前文件所在目录
  curDir = FILE_DIRNAME(ROUTINE_FILEPATH('READ_HDF'),$
    /mark_directory)
  ;定义要读取的hdf文件
  hdfFile = curDir+'data\example.hdf'
  ;判断文件是否存在，不存在则提示信息然后退出
  IF ~FILE_TEST(hdfFile) THEN BEGIN
    void = DIALOG_MESSAGE('hdf文件不存在！',/Error)
    RETURN
  ENDIF
  ;打开hdf文件，获取SD_ID
  sd_id=HDF_SD_START(hdfFile)
  ;获取属性信息
  HDF_SD_FILEINFO,sd_id,NumSDS,attributes
  ;读取第一个数据集
  sds_id=HDF_SD_SELECT(sd_id,0)
  ;获取数据集的信息
  HDF_SD_GETINFO,sds_id,NDIMS=NDIMS,LABEL=LABEL,$
    DIMS=DIMS,TYPE=TYPE
  ;获取数据集内容
  HDF_SD_GETDATA,sds_id,data
  ;hdf_sds读取结束
  HDF_SD_ENDACCESS,sds_id
  ;sd_id关闭
  HDF_SD_END,sd_id
  ;真彩色方式显示
  TVSCL, Data,/true
   erase,color = 'ffffff'x
  TVSCL, Data,/true
END