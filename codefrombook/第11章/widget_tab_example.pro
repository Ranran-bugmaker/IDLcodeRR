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
PRO WIDGET_TAB_EXAMPLE_event, ev
  ;
  uName = WIDGET_INFO(ev.id,/uname)
  ;如果触发的是tab组件
  IF uname EQ 'tab' THEN BEGIN
    WIDGET_CONTROL, ev.top,get_uvalue = pState
    ;设置label的值
    WIDGET_CONTROL,(*pState).show,set_value = ' 当前是：第'+STRTRIM(ev.Tab+1,2)+'个Tab窗口'
  ENDIF
END
;TAB组件演示
PRO WIDGET_TAB_EXAMPLE
  ;
  tlb = WIDGET_BASE(title='Widget_Tab', $
    /Column, /BASE_ALIGN_TOP, $
    xOffset = 200, $
    yOffset = 200)
  WIDGET_CONTROL,tlb,/Realize
  ;tab界面组件
  wt = WIDGET_TAB(tlb,uname = 'tab')
  ;显示标签
  show = WIDGET_LABEL(tlb,xsize = 200)
  w1 = WIDGET_BASE(wt, $
    title ='第一个' , $
    xSize = 200, $
    ySize = 20  )
  wb = WIDGET_BUTTON(w1, $
    value ='tab1')    
  w2 = WIDGET_BASE(wt, $
    title ='第二个'  )
  wb = WIDGET_BUTTON(w2, $
    value ='tab2')
  w3 = WIDGET_BASE(wt, $
    title ='第三个'  )
  wb = WIDGET_BUTTON(w3, $
    value ='tab3')
  ;
  WIDGET_CONTROL, tlb, set_uvalue = PTR_NEW({show: show},/no_copy)
  XMANAGER, 'WIDGET_TAB_EXAMPLE',tlb,/no_block
END