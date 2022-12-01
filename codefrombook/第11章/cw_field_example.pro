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
;事件响应程序
PRO CW_FIELD_EXAMPLE_EVENT, event
END
;CW_FIELD组件演示
PRO CW_FIELD_EXAMPLE
  ;创建tlb
  base = WIDGET_BASE($
    title ='CW_Field', $
    /COLUMN)
  ;创建cw_field组件，只能输入整型
  field = CW_FIELD(base, $
    TITLE = "输入：", $
    /FRAME, $
    /integer)
  ;例示
  WIDGET_CONTROL, base, /REALIZE
  
  ;响应事件处理
  XMANAGER, 'CW_FIELD_EXAMPLE', base, GROUP_LEADER = GROUP, /NO_BLOCK
  
END