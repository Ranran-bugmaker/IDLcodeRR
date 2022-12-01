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
PRO WIDGET_DRAW_EXAMPLE
  ;创建base
  tlb = WIDGET_BASE(title='直接图形法')
  ;创建直接图形法的draw
  wDraw = WIDGET_DRAW(tlb, $
    xSize =200,ySize =200)
  ;显示
  WIDGET_CONTROL,tlb,/realize
  WIDGET_CONTROL, wDraw,get_value = ddraw
  HELP, ddraw
  ;显示一个图像
  WSET,ddraw
  TVSCL,DIST(200)
  ;创建tlb1
  tlb1 = WIDGET_BASE(title='对象图形法', $
    xOffset = 200)
  ;创建对象法的draw
  wDraw1 = WIDGET_DRAW(tlb1, $
    xSize =200,ySize =200, $
    graphics_level = 2,$
    /DRAG_NOTIFY , $
    /wheel_events, $
    retain = 2, $
    /Expose_events )
  ;例示
  WIDGET_CONTROL,tlb1,/realize
  ;获取draw的value
  WIDGET_CONTROL, wDraw1,get_value = odraw
  oDraw.Draw,Obj_New('IDLgrView')
  
  HELP,odraw
END