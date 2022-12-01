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
;  $Id: //depot/idl/releases/IDL_80/idldir/examples/doc/image/magnifyimage.pro#1 $
;  Copyright (c) 2005-2010, ITT Visual Information Solutions. All
;       rights reserved.
;
PRO MAGNIFYIMAGE

  ;读入数据
  file = FILEPATH('convec.dat', $
    SUBDIRECTORY = ['examples', 'data'])
  image = READ_BINARY(file, DATA_DIMS = [248, 248])
  
  ;加载一颜色表.
  LOADCT, 28
  DEVICE, DECOMPOSED = 0, RETAIN = 2
  WINDOW, 0, XSIZE = 248, YSIZE = 248
  
  ;显示图像.
  TV, image
  
  ;在一新窗口中放大显示.
  magnifiedImg = CONGRID(image, 600, 600, /INTERP)
  WINDOW, 1, XSIZE = 600, YSIZE = 600
  TV, magnifiedImg
  
END