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
PRO WIDGET_LABEL_EXAMPLE
  ;创建base
  tlb = WIDGET_BASE(xsize =200,ysize =200,title ='widget_label',/column)
  ;显示界面
  WIDGET_CONTROL,tlb,/realize
  ;创建标签
  label = WIDGET_LABEL(tlb,value = '标签1')
  ;创建多行标签
  label = WIDGET_LABEL(tlb,value = '标签换行'+STRING(13b)+'第二行字符串',ysize =40)
  ;创建外框标签
  label = WIDGET_LABEL(tlb,value = '外框线',frame = 1)
END