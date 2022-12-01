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
PRO WIDGET_DropLIST_EXAMPLE_event,event
  ;输出下拉列表选择索引
  print,event.index
end
;属性界面组件演示
PRO WIDGET_DropLIST_EXAMPLE
  tlb = WIDGET_BASE($
    xsize = 200, $
    ysize = 200, $
    /column, $   
    title ='test_droplist')
  WIDGET_CONTROL,tlb,/realize
  ;
  listvalue =['列表1','列表2','列表3','列表4']
  wlist = Widget_Droplist(tlb,value = listvalue,$
    scr_ysize=20,$
    UNITS =2,$
    ysize = 20)  
  ;
  xmanager,'WIDGET_DropLIST_EXAMPLE',tlb,/no_block
END