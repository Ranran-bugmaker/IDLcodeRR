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
PRO WIDGET_LIST_EXAMPLE_EVENT,ev
;获取tlb的用户定义参数uvalue
  WIDGET_CONTROL, ev.top, get_uvalue = pState
  ;获取选择索引
  selected = WIDGET_INFO(ev.id,/LIST_SELECT )
  ;输出选择值
  PRINT,(*pState).listvalue[selected]  
END
;list界面组件演示
PRO WIDGET_LIST_EXAMPLE
  ;创建tlb
  tlb = WIDGET_BASE($
    xsize = 200, $
    /column, $
    title ='test_list')
  WIDGET_CONTROL,tlb,/realize
  ;使用list组件
  listvalue = "列表"+['1','2','3','4']
  wlist = WIDGET_LIST(tlb,value = listvalue,$
    /MULTIPLE, $
    SCR_YSIZE =50)
  WIDGET_CONTROL, tlb,set_uvalue= PTR_NEW({listvalue:listvalue},/no_copy)
  ;事件响应函数
  XMANAGER,'WIDGET_LIST_EXAMPLE',tlb,/no_block
END