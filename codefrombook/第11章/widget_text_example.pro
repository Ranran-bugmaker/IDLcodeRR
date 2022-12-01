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
;事件响应程序，未写任何代码
PRO WIDGET_TEXT_EXAMPLE_EVENT, event
END

PRO WIDGET_TEXT_EXAMPLE
  ;创建tlb，行排列
  base = WIDGET_BASE(/COLUMN)
  ;创建可编辑的文本框，
  text1 = WIDGET_TEXT(base, $
    VALUE = ' 可编辑文本框', $
    /EDITABLE, $
    YSIZE = 4)
  ;创建不可编辑文本框
  text2 = WIDGET_TEXT(base, $
    VALUE = ' 不可编辑文本框', $
    YSIZE = 2, $
    /FRAME)
  ;例示组件
  WIDGET_CONTROL, base, /REALIZE
  ;等待1秒
  WAIT,1
  ;设置组件内容
  WIDGET_CONTROL, text1,set_value ='文本框内容'
  ;响应事件
  XMANAGER, 'WIDGET_TEXT_EXAMPLE', base, GROUP_LEADER = GROUP, /NO_BLOCK
  
END