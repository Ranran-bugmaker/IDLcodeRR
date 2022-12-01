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
;+
;ENVI二次开发功能代码
;
;Author: DYQ
;问题讨论：
; http://hi.baidu.com/dyqwrp
; http://bbs.esrichina-bj.cn/ESRI/?fromuid=9806
;描述：
; 大气校正
;
;调用方法：
;cal_QUAC,inputfile,outputfile
;
;-
PRO CAL_QUAC,inputfile,outputfile
  COMPILE_OPT idl2
  CATCH, Error_status
  errorshow = 'Sorry to see the error,'+ $
    ' please send the error Information to "dongyq@esrichina-bj.cn"'
  IF Error_status NE 0 THEN BEGIN
    tmp = DIALOG_MESSAGE(errorshow+STRING(13b)+$
      !ERROR_STATE.MSG,/error,title = '错误提示!')
    return
  ENDIF
  ENVI_OPEN_FILE, inputfile, r_fid=fid
  IF (fid EQ -1) THEN BEGIN
    RETURN
  ENDIF
  
  ENVI_FILE_QUERY, fid, dims=dims, nb=nb, sensor_type=sensor_type
  pos  = LINDGEN(nb)
  
  sensor = envi_sensor_type(sensor_type)
  ; Perform QUick Atmospheric Correction
  ENVI_DOIT, 'envi_quac_doit', $
    fid=fid, pos=pos, dims=dims, $
    quac_sensor=sensor, $
    out_name=outputfile, r_fid=r_fid   
;
END
