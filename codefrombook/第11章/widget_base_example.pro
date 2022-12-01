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
PRO WIDGET_BASE_EXAMPLE
  ;创建最高级base(Top Level Base = tlb)
  tlb = WIDGET_BASE(xsize =200,ysize =200,title ='widget_base')
  ;显示
  WIDGET_CONTROL,tlb,/realize
  ;使用floating关键字创建浮动窗口
  fbase = WIDGET_BASE(GROUP_LEADER =tlb, $
    xsize =200,ysize =200,$
    xOffset =200, $
    yOffset =200, $
    /floating,$
    title ='floating')
  ;显示
  WIDGET_CONTROL,fbase,/realize
  ;使用modal关键字创建模式窗口
  mbase = WIDGET_BASE(GROUP_LEADER =tlb, $
    xsize =200,ysize =200, $
    xOffset =400, $
    yOffset =200, $
    /modal,$
    title ='modal')
  ;显示
  WIDGET_CONTROL,mbase,/realize
  ;创建tlb_frame_attr为1的窗口
  ttlb = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=1', $
    xOffset =000, $
    yOffset =400, $
    TLB_FRAME_ATTR = 1)
  ;显示
  WIDGET_CONTROL,ttlb,/realize
  ;创建tlb_frame_attr为2的窗口
  ttlb2 = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=2', $
    xOffset =200, $
    yOffset =400, $
    TLB_FRAME_ATTR = 2)
  ;显示
  WIDGET_CONTROL,ttlb2,/realize
  ;创建tlb_frame_attr为9的窗口
  ttlb3 = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=9,1+8', $
    xOffset =400, $
    yOffset =400, $
    TLB_FRAME_ATTR = 9)
  ;显示
  WIDGET_CONTROL,ttlb3,/realize
  ;创建tlb_frame_attr为4的窗口
  ttlb4 = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=4', $
    xOffset =600, $
    yOffset =400, $
    TLB_FRAME_ATTR = 4)
  ;显示
  WIDGET_CONTROL,ttlb4,/realize
  ;创建tlb_frame_attr为8的窗口
  ttlb8 = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=8', $
    xOffset =800, $
    yOffset =400, $
    TLB_FRAME_ATTR = 8)
  ;显示
  WIDGET_CONTROL,ttlb8,/realize
  ;创建tlb_frame_attr为16的窗口
  ttlb16 = WIDGET_BASE(xsize =200,ysize =200, $
    title ='TLB_FRAME_ATTR=16', $
    xOffset =1000, $
    yOffset =400, $
    TLB_FRAME_ATTR = 16)
  ;显示
  WIDGET_CONTROL,ttlb16,/realize
END