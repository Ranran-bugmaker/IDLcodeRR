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
PRO READ_MODIS
  ;获取当前文件所在目录
  curDir = FILE_DIRNAME(ROUTINE_FILEPATH('READ_MODIS'),$
    /mark_directory)
    
  ;定义要读取的modis文件
  modisFile = curDir+$
    'data\MOD021KM.A2002248.0345.005.2007348121959.hdf'
  ;判断文件是否存在，不存在则提示信息然后退出
  IF ~FILE_TEST(modisFile) THEN BEGIN
    void = DIALOG_MESSAGE('modis文件不存在！',/Error)
    RETURN
  ENDIF
  ;打开hdf文件，获取SD_ID
  sd_id=HDF_SD_START(modisFile)
  
  ;获取纬度数据索引ID并读取
  lat_SD_index = HDF_SD_NAMETOINDEX(sd_id,'Latitude')
  ;直接定位到数据ID
  sds_id=HDF_SD_SELECT(sd_id,lat_SD_index)
  ;获取该数据集的信息
  HDF_SD_GETINFO,sds_id,name=n,ndims=r,$
    type=t,natts=nats,$
    hdf_type=h,unit=u
  ;输出纬度数据的单位
  PRINT,u
  
  ;获取数据集内容
  HDF_SD_GETDATA,sds_id,data
  ;hdf_sds读取结束
  HDF_SD_ENDACCESS,sds_id
  
  ;获取经度数据索引ID并读取
  lat_SD_index = HDF_SD_NAMETOINDEX(sd_id,'Longitude')
  ;直接定位到数据ID
  sds_id=HDF_SD_SELECT(sd_id,lat_SD_index)
  ;获取该数据集的信息
  HDF_SD_GETINFO,sds_id,name=n,ndims=r,$
    type=t,natts=nats,$
    hdf_type=h,unit=u
    
  ;获取数据集内容
  HDF_SD_GETDATA,sds_id,data
  ;hdf_sds读取结束
  HDF_SD_ENDACCESS,sds_id
  
  ;获取反射率数据索引ID并读取
  RefSB_SD_index = HDF_SD_NAMETOINDEX(sd_id,'EV_1KM_RefSB')
  ;直接定位到数据ID
  sds_id=HDF_SD_SELECT(sd_id,RefSB_SD_index)
  ;获取该数据集的信息
  HDF_SD_GETINFO,sds_id,name=n,ndims=r,$
    type=t,natts=nats,$
    hdf_type=h,unit=u
  ;获取数据集内容
  HDF_SD_GETDATA,sds_id,data
  ;hdf_sds读取结束
  HDF_SD_ENDACCESS,sds_id
  
  ;sd_id关闭
  HDF_SD_END,sd_id
  ;真彩色方式显示
  HELP,data
END