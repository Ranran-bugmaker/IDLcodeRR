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
; 面向对象特征提取
;
;调用方法：
; cal_FX,in_file,out_file,scale_level,merge_level,ruleset_filename
;   in_file：FX输入文件
;   out_file：fx的输出shape结果
;   scale_level：fx的分割比例
;   merge_level:fx的合并比例
;   releset_filename:FX的规则配置文件，需要定制修改！
;-

PRO CAL_FX,in_file,out_file,scale_level,merge_level,ruleset_filename
  CATCH, Error_status
  errorshow = 'Sorry to see the error,'+ $
    ' please send the error Information to "dongyq@esrichina-bj.cn"'
  IF Error_status NE 0 THEN BEGIN
    tmp = DIALOG_MESSAGE(errorshow+STRING(13b)+$
      !ERROR_STATE.MSG,/error,title = '错误提示!')
    RETURN
  ENDIF
  ; 打开文件
  ENVI_OPEN_FILE, in_file, r_fid=in_fid
  
  ;文件打开出错则退出
  IF (in_fid EQ -1) THEN RETURN
  
  ;获取文件信息
  ENVI_FILE_QUERY, in_fid, dims=dims, nb=nb
  
  IF  ~FILE_TEST(ruleset_filename) THEN RETURN
  IF ~FILE_TEST(FILE_DIRNAME(out_file),/directory) THEN FILE_MKDIR,FILE_DIRNAME(out_file)
  ; 执行FX.
  ENVI_DOIT, 'envi_fx_doit', $
    pos=LINDGEN(nb), $
    dims=dims, $
    fid=in_fid, $
    scale_level=scale_level, $
    merge_level=merge_level, $
    vector_filename=out_file, $
    conf_threshold=0.10, $
    ruleset_filename=ruleset_filename, $
    r_fid = out_fid
END