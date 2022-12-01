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
;柱形图绘制函数
PRO EX_BOX, X0, Y0, X1, Y1, color
  ;调用PolyFill进行绘制
  POLYFILL, [X0, X0, X1, X1], [Y0, Y1, Y1, Y0], COL = color
END
;
;柱形图绘制Demo
;
PRO BARPLOT_EXAMPLE
  ;定义变量
  SOCKEYE=[463, 459, 437, 433, 431, 433, 431, 428, 430, 431, 430]
  COHO=[468, 461, 431, 430, 427, 425, 423, 420, 418, 421, 420]
  CHINOOK=[514, 509, 495, 497, 497, 494, 493, 491, 492, 493, 493]
  HUMPBACK=[467, 465, 449, 446, 445, 444, 443, 443, 443, 443, 445]
  names = ['Coho','Sockeye','Humpback','Chinook']
  ALLPTS = [[COHO], [SOCKEYE], [HUMPBACK], [CHINOOK]]
  ;年份
  YEAR = [1967, 1970, INDGEN(9) + 1975]
  XVAL = FINDGEN(4)/5. + .2
  ;第一年数组组合
  YVAL = [COHO[0], SOCKEYE[0], HUMPBACK[0], CHINOOK[0]]
  ;绘制无数据的曲线，x范围[0,1],xVal居中显示.
  ;基于变量names显示线标题:
  PLOT, XVAL, YVAL, /YNOZERO, XRANGE = [0,1], XTICKV = XVAL, $
    XTICKS = 3, XTICKNAME = NAMES, /NODATA, $
    TITLE = 'Salmon Populations, 1967'
  ;绘制柱状图，在刻度线中间显示，!Y.CRange是X轴刻度线的y标识。
  FOR I = 0, 3 DO EX_BOX, XVAL[I] - .08, !Y.CRANGE[0], $
    XVAL[I] + 0.08, YVAL[I], 128
END

