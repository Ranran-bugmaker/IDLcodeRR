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
 ;查找例子数据文件
 file = FILEPATH('convec.dat', SUBDIRECTORY = ['examples', 'data'])
 ;读取248*248的二进制数据
 data = READ_BINARY(file, DATA_DIMS = [248, 248])
 ;调用iContour绘制
 ICONTOUR, data
 
 
 IPLOT, RANDOMU(seed, 20)
 IPLOT, FINDGEN(20), FINDGEN(20), RANDOMU(seed, 20)
 
 
 
 IPLOT, SIN(2.0*FINDGEN(200)*!PI/25.0)*EXP(-0.02*FINDGEN(200))
 IPLOT,COS(2.0*FINDGEN(200)*!PI/25.0)*EXP(-0.02*FINDGEN(200)),$
   color = [255,0,0],/overplot
   
   
 x = (y = FINDGEN(21) - 10)
 u = REBIN(-TRANSPOSE(y),21,21)
 v = REBIN(x,21,21)
 ;矢量场绘制，使用39号颜色表（图10.63）
 IVECTOR, u, v, x, y, AUTO_COLOR=1, $
   RGB_Table = 39, Scale_ISOTropic = 1
   
 x = (y = 2*FINDGEN(11) - 10)
 u = 9*REBIN(-TRANSPOSE(y),11,11)
 v = 9*REBIN(x,11,11)
 ;显示风场（图10.64）
 IVECTOR, u, v, x, y, VECTOR_STYLE=1
 
 
 u = RANDOMU(1,20,20) - 0.5
 v = RANDOMU(2,20,20) - 0.5
 ;显示流线（图10.65）
 IVECTOR, u, v, /STREAMLINES, $
   X_STREAMPARTICLES=10, Y_STREAMPARTICLES=10, $
   HEAD_SIZE=0.1, STREAMLINE_NSTEPS=200
   
   
 END