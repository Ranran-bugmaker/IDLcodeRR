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
;读取ENVI的 EVF文件
;
PRO USING_ENVI_READ_EVF
  COMPILE_OPT IDL2
  ;定义EVF文件
  evf_fname = 'c:\temp\sample.evf'
  ;打开EVF文件
  evf_id = ENVI_EVF_OPEN(evf_fname)
  ;查询EVF文件信息
  ENVI_EVF_INFO, evf_id, num_recs=num_recs, $
    data_type=data_type, projection=projection, $
    layer_name=layer_name
    
  ;输出记录数
  PRINT, 'Number of Records: ',num_recs
  ;依次输出记录
  FOR i=0,num_recs-1 DO BEGIN
    ;读取当前记录
    record = ENVI_EVF_READ_RECORD(evf_id, i,type= type)
    ;输出点记录与点数
    PRINT, 'Number of nodes in Record: ' + $
      STRTRIM(i+1,2) + ': ',N_ELEMENTS(record[0,*])
    ;输出记录数据类型，1:点;3:折线;5:多边形;8多点
    PRINT,'Record Type: '+STRTRIM(type,2)
  ENDFOR
  ;关闭EVF文件
  ENVI_EVF_CLOSE, evf_id
  
END

