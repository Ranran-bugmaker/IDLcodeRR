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

PRO test_widgets, event
  COMPILE_OPT STRICTARR
  TLB = WIDGET_AUTO_BASE(title='ENVI组件界面示例')
  p1 = WIDGET_PARAM(tlb, /auto_manage, dt=4, field=2, $
    prompt='输入第一个参数：', uvalue='p1')
  p2 = WIDGET_PARAM(tlb, /auto_manage, dt=4, field=2, $
    prompt='输入第二个参数：', uvalue='p2')
  operation = WIDGET_TOGGLE(tlb, /auto_manage, default=0, $
    list=['加', '乘'], prompt='操作', $
    uvalue='operation')
  result=AUTO_WID_MNG(TLB)
  IF (result.accept EQ 0) THEN RETURN
  IF (result.operation EQ 0) THEN $
    ENVI_INFO_WID, STRTRIM(result.p1 + result.p2) ELSE $
    ENVI_INFO_WID, STRTRIM(result.p1 * result.p2)
END
