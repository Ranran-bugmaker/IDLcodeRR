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
;ENVI下自动添加菜单
PRO ENVI_READ_AWX_DEFINE_BUTTONS,buttonInfo
  ENVI_DEFINE_MENU_BUTTON, buttonInfo,  VALUE = 'AWX', $
    uValue = '', $
    event_pro ='ENVI_READ_AWX', $
    REF_VALUE = 'Generic Formats', $
    POSITION = 1, REF_INDEX = 0
END
;AWX文件解析程序
PRO ENVI_READ_AWX,event
  compile_opt strictarr
  ;获取ENVI默认设置参数
  cfg = envi_get_configuration_values()
  ;默认数据打开目录
  inPath = cfg.DEFAULT_DATA_DIRECTORY
  ;对话框选择文件
  file = DIALOG_PICKFILE(path = inPath, $
    filter ='*.awx',title ='选择AWX文件')
  ;判断文件是否存在
  IF FILE_TEST(file) NE 1 THEN RETURN
  ;打开文件
  OPENR, file_lun, file ,/Get_Lun
  ;定位到信息部分
  POINT_LUN,file_lun,20
  HeadLine =INDGEN(3)
  READU,file_lun,HeadLine
  ;定位到信息部分
  POINT_LUN,file_lun,58
  BeginDate=INDGEN(5) ;依次为年月日时分
  EndDate =INDGEN(5)	;依次为年月日时分
  ;读取
  READU,file_lun,BeginDate
  READU,file_lun,EndDate
  descriptionStr = '起始时间：'+STRJOIN(StrTrim(BeginDate,2),'-')+$
    '结束时间：'+STRJOIN(StrTrim(EndDate,2),'-')
  ;定义数据
  data = BYTARR(HeadLine[2],(HeadLine[0]))
  ;定位到数据部分
  POINT_LUN,file_lun,HeadLine[0]*HeadLine[1]
  READU,file_lun,data
  ;关闭文件lun
  FREE_LUN,file_lun
  ;设置ENVI内容
  ENVI_SETUP_HEAD, fname=file, $
    ns=headLine[2], nl=HeadLine[0], nb=1, $
    DESCRIP=descriptionStr, $
    interleave=0, data_type=1, $
    offset=HeadLine[0]*HeadLine[1], /write, /open
END