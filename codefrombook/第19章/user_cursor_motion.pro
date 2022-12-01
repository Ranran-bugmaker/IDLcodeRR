;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-

PRO USER_CURSOR_MOTION, dn, $
    xfloc, yfloc,$
    xstart=xstart, $
    ystart=ystart, $
    event=event
  COMPILE_OPT IDL2
  ;鼠标按下
  IF (event.PRESS EQ 1) THEN BEGIN
    DISP_GET_LOCATION, dn, xfloc, yfloc
    PRINT,'鼠标点击时位置：', xfloc, yfloc
  ENDIF
  ;鼠标弹起
  IF (event.RELEASE EQ 1) THEN BEGIN
    DISP_GET_LOCATION, dn, xfloc, yfloc
    PRINT,'鼠标弹起时位置：', xfloc, yfloc
  ENDIF
END

