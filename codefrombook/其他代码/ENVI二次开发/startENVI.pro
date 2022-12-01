;+
;      《IDL语言程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
;+
;ENVI二次开发功能代码
;
;Author: DYQ
;问题讨论：
; http://hi.baidu.com/dyqwrp
; http://bbs.esrichina-bj.cn/ESRI/?fromuid=9806
;描述：
; 初始化ENVI
;
;调用方法：
;(1) ENVI的处理过程中不显示进度条
; startEnvi
;(2) ENVI的处理过程中显示进度条
; startEnvi,/ShowProcess
;-

PRO startENVI, showProcess = showProcess
  compile_opt idl2  
  
  ENVI, /restore_base_save_files
  ENVI_BATCH_INIT, NO_STATUS_WINDOW = 1- keyWord_set(showProcess)
END