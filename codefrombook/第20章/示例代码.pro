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
;-第20章示例代码

ENVI,/Restore_Base_Sav_Files
ENVI_Batch_init

;对话框选择文件，见图20.1
filename = ENVI_PICKFILE(title='Pick a img file',  filter='*.img')
;查看选择的文件名
PRINT,filename


;打开文件
ENVI_OPEN_FILE,filename,r_fid = fid
;选择文件，见图20.2
ENVI_SELECT, fid=fid,dims=dims,pos=pos
;查看选择的信息
PRINT,dims,pos

;获取已经打开的文件ID
ids = ENVI_GET_FILE_IDS()
;输出ID
PRINT,ids

;打开文件
ENVI_OPEN_FILE,filename,r_fid = fid
;移除已经打开的文件ID
ENVI_FILE_MNG,id = fid,/Remove
;获取已经打开的文件ID
fids = ENVI_GET_FILE_IDS()
;输出内容
print,fids

;移除已经打开的文件ID并从磁盘上删除
ENVI_FILE_MNG,id = fid1,/Remove,/Delete
;根据文件id查询文件信息
ENVI_FILE_QUERY,fid, $
  fname = fName, $
  dims = dims, $
  nb = nb , $
  ns = ns , $
  nl = nl , $
  SENSOR_TYPE = SENSOR_TYPE
;查看文件的ID
print,fid


;查看文件名
print,fname
C:\Program Files\ITT\IDL\IDL80\products\envi48\data\can_tmr.img
;查看文件空间子集范围
print,dims
;查看波段数
print,nb
;查看文件列数
print,ns
;查看文件行数
print,nl
;查看传感器代码
print,sensor_type

;读取所有波段、第20行、20-40列的波谱数据，
data = envi_get_slice(fid=fid, line=20, pos=lindgen(nb), xs=20, xe=40)
help,data

;读取文件的第一波段数据内容
data = ENVI_GET_DATA(fid=fid, dims=dims, pos=0)
help,data

;读取文件的第二波段数据内容
data = ENVI_GET_DATA(fid=fid, dims=dims, pos=1,XFACTOR =0.5,yFACTOR=0.5)
help,data


;将读取的第一个波段存储到内存中
ENVI_ENTER_DATA, data, r_fid = rFid

;获取ENVI的配置参数结构体
cfg = envi_get_configuration_values()
;默认输出目录
out_path = cfg.DEFAULT_OUTPUT_DIRECTORY
;定义输出文件名
out_file = out_path+'tm_band1.img'
;二进制方式输出
OPENW,lun,out_file,/get_lun
WRITEU,lun,data
FREE_LUN,lun
;写出文件的头文件信息并打开文件（图20.4）
ENVI_SETUP_HEAD, fname=out_file, $
  ns=ns, nl=nl, nb=1, $
  interleave=0, $
  data_type=data_type, $
  offset=0, /write, /open



;定义文件完整路径名
file = 'C:\Program Files\ITT\IDL\IDL80\products\envi48\data\bhtmref.img'
;打开文件
ENVI_OPEN_FILE,file,r_fid = fid
;获取文件的map信息
mapinfor = ENVI_GET_MAP_INFO(fid = fid, UNDEFINED = uDefined)
;如果文件不包含map信息，则输出信息。
IF uDefined EQ 1 THEN PRINT,'文件不包含map_info'
;包含信息则查看map信息结构体
HELP,mapInfor
;查看文件投影信息
HELP,mapInfor.PROJ
;输出文件左上角点信息
PRINT,mapinfor.MC
;输出文件分辨率
PRINT,mapinfor.PS
;获取文件投影信息
fileProj = ENVI_GET_PROJECTION(fid = fid)
;查看投影信息参数
HELP,fileProj


;创建经纬度投影
proj = ENVI_PROJ_CREATE(/geographic)

;转换单位
units = ENVI_TRANSLATE_PROJECTION_UNITS('km')
;设置椭球体名称
datum = 'WGS-84'
;创建椭球体为WGS-84的带号为23的南半球UTM投影
Proj = ENVI_PROJ_CREATE(/utm, $
  zone=23, /south, $
  datum=datum, units=units)
;查看创建的投影结构体信息
HELP,proj

; Define the PARAMS values

;定义投影参数数组
Params = [6378160.0, 6356774.7, $
  0.000000, 99.000000, $
  500000., 10000000., $
  .9996]

;定义椭球体名称和投影名称
datum = 'Australian Geodetic 1966'
name = 'Australian Map Grid (AGD 66) Zone 47'
;创建投影
proj = ENVI_PROJ_CREATE(type=3, $
  name=name, $
  datum=datum, $
  params=params)
;查看创建的投影结构体信息
HELP,proj

;投影参数信息字符串
projcsStr = 'PROJCS["Beijing_1954_GK_Zone_19N",GEOGCS["GCS_Beijing_1954",DATUM["D_Beijing_1954",SPHEROID["Krasovsky_1940",6378245.0,298.3]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Gauss_Kruger"],PARAMETER["False_Easting",
;创建投影，type为42即使用ESRI Projection Engine创建投影
proj = ENVI_PROJ_CREATE(type = 42, $
  pe_coord_sys_str=projcsStr)
;查看创建的投影结构体信息
HELP,proj


;图像左上角点图像坐标与地理坐标
;[0.5d,0.5d]代表左上角第一个像素的中心
;[-117.4D, 34.5D] 表示该位置的经纬度坐标值
mc = [0.5D, 0.5D, -117.4D, 34.5D]
;图像的分辨率
ps = [1D/3600, 1D/3600]
;创建经纬度坐标，默认投影坐标单位是度
map_info = ENVI_MAP_INFO_CREATE($
  /geographic, $
  mc=mc, ps=ps)
;查看创建的地理坐标结构体信息
HELP,map_info

;转换km单位标识
units = ENVI_TRANSLATE_PROJECTION_UNITS('km')
;设置椭球体名称
datum = 'North America 1983'
;设置左上角点像素坐标与地理坐标
mc = [0D, 0, 177246, 8339330]
;分辨率为0.03km=30m
ps=[0.03, 0.03]
; 创建投影
map_info = ENVI_MAP_INFO_CREATE($
  /UTM, ZONE=23, /SOUT, $
  DATUM = datum, UNITS = units, $
  MC = mc, PS = ps)
;查看创建的地理坐标结构体信息
HELP,map_info

END