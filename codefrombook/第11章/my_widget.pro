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
;PRO my_widget_event, event
;  WIDGET_CONTROL, event.TOP, GET_UVALUE=state, /NO_COPY
;  Event-handling code goes here
;  WIDGET_CONTROL, event.TOP, SET_UVALUE=state, /NO_COPY
;END
;
;PRO my_widget_event, event
;  WIDGET_CONTROL, event.TOP, GET_UVALUE=pState
;  Event-handling code goes here, accessing the state
;  structure via the retrieved pointer.
;END
;事件响应程序
PRO BUTTONEVENT,event
  HELP,event
END
;界面创建程序
PRO MY_WIDGET
  tlb = WIDGET_BASE()
  button = WIDGET_BUTTON(tlb,$
    value ='OK', $
    event_pro = 'buttonEvent')
  ;其他创建代码
  WIDGET_CONTROL,tlb,/Realize
  XMANAGER,'my_widget',tlb,/no_Block
END