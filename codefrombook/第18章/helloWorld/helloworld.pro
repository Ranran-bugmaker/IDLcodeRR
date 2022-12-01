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
PRO HELLOWORLD
  ;调用IDL自带的样例数据
  jpgfile = FILEPATH('people.jpg', SUBDIRECTORY=['examples','data'])
  ;读取JPEG文件
  READ_JPEG,jpgfile,data,/true
  ;创建显示窗口
  WINDOW,1,title ='彩色头像显示', $
    xsize = (SIZE(data,/dimension))[2], $
    ysize = (SIZE(data,/dimension))[2]
  ;彩色绘制图像
  TV,data,/true
  ;选择对话框
  tmp = DIALOG_MESSAGE('关闭显示窗口不？',/default_No,/Question)
  IF tmp EQ 'Yes' THEN WDELETE,1
END
