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
PRO WIDGET_SLIDER_EXAMPLE_EVENT,event
  ;查看当前选择值
  PRINT,event.value
END
;滑动条组件演示
PRO WIDGET_SLIDER_EXAMPLE
  tlb = WIDGET_BASE($
    /column, $
    title ='test_slider')
  WIDGET_CONTROL,tlb,/realize
  ;创建滑动条，范围为 [0,100]，修改步长为2
  wSlider = WIDGET_SLIDER(tlb, $
    MAXIMUM = 100,$
    MINIMUM =0,$
    xsize = 400, $
    scroll =2 )
  ;响应事件
  XMANAGER,'WIDGET_SLIDER_EXAMPLE',tlb,/no_block
END

