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
;对数据作求正弦
 data = sin(arr/20)
 ;创建大小400*300的显示窗口，设置标题
 window,2,xsize =400,ysize =300,title = 'Plot Sin'
 ;绘制曲线
 plot,data
