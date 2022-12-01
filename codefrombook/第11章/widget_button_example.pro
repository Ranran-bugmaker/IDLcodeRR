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
PRO WIDGET_BUTTON_EXAMPLE
  ;创建base
  tlb = WIDGET_BASE($
    xoffset = 400, $
    yoffset = 400, $
    /column, $
    mbar =mbar,$
    title ='test_button')
  ;如基于mBar创建则为菜单
  menu = WIDGET_BUTTON(mbar, value ='文件(&F)')
  fmenu = WIDGET_BUTTON(menu, value ='打开')
  ;使用menu关键字
  mMenu = WIDGET_BUTTON(menu, value ='进入',/menu)
  tMenu = WIDGET_BUTTON(mMenu, value ='二级',/menu)
  ;使用separator关键字
  eMenu = WIDGET_BUTTON(menu, value ='退出',/SEPARATOR)
  ;创建上下两个base组件
  ubase = WIDGET_BASE(tlb,/row)
  dbase = WIDGET_BASE(tlb,/row)
  ;创建鼠标放置有提示的按钮和图标按钮
  b = WIDGET_BUTTON(ubase,value = '按钮',tooltip = '创建的button')
  h = WIDGET_BUTTON(ubase,value = BINDGEN(2,40))
  ;创建位图图标按钮
  bmpfile  = FILEPATH('colorbar.bmp', SUBDIRECTORY=['resource','bitmaps'])
  bit =WIDGET_BUTTON(ubase,value =bmpfile,/bitmap)
  ;设置widget_Base关键字创建单选button'
  exbase = WIDGET_BASE(dbase,/EXCLUSIVE,/column)
  eb1 = WIDGET_BUTTON(exbase,value ='对')
  eb2 = WIDGET_BUTTON(exbase,value ='错')
  ;设置widget_Base关键字创建多选按钮
  nexbase = WIDGET_BASE(dbase,/NONEXCLUSIVE,/column)
  eb1 = WIDGET_BUTTON(nexbase,value ='envi')
  eb2 = WIDGET_BUTTON(nexbase,value ='idl')
  ;显示界面
  WIDGET_CONTROL,tlb,/realize
END