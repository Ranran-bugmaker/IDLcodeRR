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
;界面程序事件响应函数
;
PRO WIDGET_CREATE_EXAMPLE_EVENT, event
  ;查看event事件结构体
  HELP,event,/Structure
  ;获得触发事件的组件ID
  PRINT,'uName:', WIDGET_INFO(event.ID,/uName)
  ;获得触发事件的uValue和value
  WIDGET_CONTROL, event.ID, get_Value = curValue, get_UValue = curUValue
  PRINT,'value:',curValue
  PRINT,'UValue:',curUValue
END
;
;界面程序事件响应示例
;  :界面创建
;
PRO WIDGET_CREATE_EXAMPLE
  ;创建界面顶级base,大小为200*200
  ;column则表示其子界面均行排列
  tlb = WIDGET_BASE(/COLUMN, $
    xsize = 200, ysize = 200)
  ;创建按钮1，标签为Close
  button1 = WIDGET_BUTTON(tlb, $
    value='Close',$
    xoffset = 100, $
    uValue = 'button1 uvalue', $
    uname = 'close')
  ;创建按钮2，标签为Information
  button2 = WIDGET_BUTTON(tlb, $
    value='Pop MSG',$
    uvalue = FINDGEN(4,4), $
    xoffset = 100, $
    uname = 'infor')
  ;组件例示，仅控制顶级base即可，否则不显示
  WIDGET_CONTROL, tlb, /REALIZE
  ;查看组件ID
  PRINT,'tlb:',tlb
  PRINT,'button1:',button1
  PRINT,'button2:',button2
  ;关联界面响应函数
  XMANAGER, 'Widget_Create_Example', tlb,/NO_Block
END