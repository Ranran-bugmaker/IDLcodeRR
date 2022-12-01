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
;第九章示例代码
;-

;生成正弦波形曲线数据
theory = SIN(2.0*FINDGEN(200)*!PI/25.0)*EXP(-0.02*FINDGEN(200))
;曲线可视化
plot = PLOT(theory, "r4D-", TITLE="Sine Wave")

;设置地图显示区域
ant_map = MAP('STEREOGRAPHIC', $
  Limit = [10,80,50,130], $
  CENTER_LATITUDE=30, $
  CENTER_LONGITUDE=105, $
  title ='Map Example',$
  FILL_COLOR='Light Blue')
;显示大陆边界，设置背景颜色
mc = MAPCONTINENTS(/COUNTRIES, FILL_COLOR='beige')
;显示河流
rivers = MAPCONTINENTS(/RIVERS, COLOR='blue')

;读取Dem数据
dem = READ_BINARY(FILE_WHICH('elevbin.dat'), data_dims=[64,64])
;显示Dem
c1 = CONTOUR(dem, $
  RGB_TABLE=30, $
  /FILL, $
  PLANAR=0, $
  TITLE='L.A. Basin and Santa Monica Mountains')
;添加颜色棒（图9.2）
cbar = COLORBAR(TARGET=c1,ORIENTATION=1, POSITION=[0.9, 0.2, 0.95, 0.75])


;生成正弦波形曲线数据
theory = SIN(2.0*FINDGEN(200)*!PI/25.0)*EXP(-0.02*FINDGEN(200))
;曲线可视化（图9.1）
plot = PLOT(theory, "r4D-", TITLE="Sine Wave")

;基于数据坐标x方向移动20（图9.3）
PLOT.TRANSLATE,20,0,0,/data
;恢复初始化显示（图9.1）
PLOT.TRANSLATE,/reset
;修改x坐标轴线粗为4
PLOT.XTHICK =4
;修改y轴的文本颜色为红色
PLOT.YTEXT_COLOR = 'red'

;设置为蓝色（图9.4）
PLOT.COLOR='blue'

;修改x坐标轴线粗为4
PLOT.XTHICK =4
;修改y轴的文本颜色为红色
PLOT.YTEXT_COLOR = 'red'

;设置title内容为“中文标题”
PLOT.TITLE='中文标题'
;因默认显示中文为乱码，故需要修改字体
;将当前title赋值给oTitle对象
oTitle = PLOT.TITLE
;修改title的字体为“youyuan”（幼圆），
;字体名称根据当前计算机中安装的字体为准（图9.7）
oTitle.FONT_NAME = 'youyuan'


; 在绘图区域正中位置([0.5,0.5]的归一化坐标)添加一红色文字(‘r’)注记
oText = TEXT(0.5,0.5,'abc','r')
;填充黄色
oText.FILL_COLOR='y'
;修改字体为times new roman
oText.FONT_NAME ='times new roman'
;文字标注加粗（图9.8）
oText.FONT_STYLE = 'Bold'


; 在中间(0.5)偏下(0.3)位置显示数学符号
oMathText1 = TEXT(0.5,0.3,'$a_n^2$','b')
; 在中间(0.5)偏上(0.7)位置显示希腊字母及数学符号（图9.9）
oMathText2 = TEXT(0.5,0.7,'$\alpha\beta a_{b_m}e^{x^2}$','b')

; 绘制一正弦曲线
plot = PLOT(SIN(FINDGEN(200)/10))
; 设置线段四个转折点的x坐标
xdata = [0,50,100,150]
; 设置y坐标
ydata = [-0.5,-1,0,0.5]
; 绘制红色线段，注意data关键字表示xy坐标均为数据坐标。
pline = POLYLINE(xData,yData,'r',/data)
; 绘制箭头线段，归一化坐标，显示箭头，金黄色，线粗为2（图9.10）
pline1 = POLYLINE([0.3,0.7],[0.6,0.5],/normal,color = !color.GOLD,thick =2)


; 绘制一正弦曲线
plot = PLOT(SIN(FINDGEN(200)/10))
arrow1 = ARROW([0,0], [0.5,0.5], ARROW_STYLE=1, $
  COLOR=!COLOR.CHARTREUSE, THICK=3,target = plot)
  
;arrow2 = ARROW([400,365], [375,79], /DATA, ARROW_STYLE=2, $
;
;   COLOR=!COLOR.GOLD, THICK=3, FILL_BACKGROUND=0)
  
;绘制显示一个图像
im = IMAGE(FILEPATH('muscle.jpg', $
  SUBDIRECTORY=['examples','data']), $
  TITLE='Muscle Cell Abnormality')
;绘制箭头
arrow1 = ARROW([125,252], [233,55], /DATA, ARROW_STYLE=1, $
  COLOR=!COLOR.CHARTREUSE, THICK=3)
;绘制箭头
arrow2 = ARROW([400,365], [375,79], /DATA, ARROW_STYLE=1, $
  COLOR=!COLOR.GOLD, THICK=3, FILL_BACKGROUND=0)
;箭头1文字注记，字体是宋体（Win7及Vista系统中为'stsong'）
t1 = TEXT(81,242,'箭头1', /DATA, TARGET=im, $
  FONT_NAME = 'stsong',$
  COLOR=!COLOR.CHARTREUSE)
;箭头2文字注记，字体是楷体
t2 = TEXT(372,387,'箭头 2', /DATA, TARGET=im, $
  FONT_NAME = 'stkaiti', $
  COLOR=!COLOR.GOLD)
  
  
  
  
;绘制一个正弦曲线
plot = PLOT(SIN(FINDGEN(200)/10))
;红色实线绘制矩形
poly = POLYGON([0.4,0.4,0.6,0.6],[0.4,0.6,0.6,0.4],'r')
;设置线型为长划线
POLY.LINESTYLE = 2
;米黄色填充 （图9.12）
POLY.FILL_COLOR = !color.BEIGE


;绘制正弦曲线
plot = PLOT(SIN(FINDGEN(200)/10))
;隐藏曲线，也可以直接用window函数创建
PLOT.HIDE = 1
;绘制四个矩形（红色、绿色、蓝色和黄色），坐标均为4个点
;     点顺序：自左下点起顺时针方向（图9.13）
poly1 = POLYGON([0.2,0.2,0.4,0.4],[0.2,0.4,0.4,0.2],'r')
poly2 = POLYGON([0.2,0.2,0.4,0.4],[0.6,0.8,0.8,0.6],'g')
poly3 = POLYGON([0.6,0.6,0.8,0.8],[0.6,0.8,0.8,0.6],'b')
poly4 = POLYGON([0.6,0.6,0.8,0.8],[0.2,0.4,0.4,0.2],'y')
;修改矩形1连接关系为: 2个点连接（第一个和第二个点）
poly1.CONNECTIVITY = [2,0,1]
;修改矩形2连接关系为：3个点连接（第一个、第二个和第三个点）
poly2.CONNECTIVITY = [3,0,1,2]
;修改矩形3连接关系为：4个点连接（第一个、第二个、第三个和第四个点）
poly3.CONNECTIVITY = [4,0,1,2,3]
;修改矩形4连接关系为：2个点连接（第一个和第三个点）+2个点连接（第二个和第四个点）（图9.14）
poly4.CONNECTIVITY = [2,0,2,2,1,3]


; 创建空白显示窗口
w = WINDOW(WINDOW_TITLE="Plot Window")
; 绘制椭圆，用黄色填充
elp = ELLIPSE(0.3,0.5,major =0.2,minor=0.1,fill_color ='y')
; 绘制椭圆，用蓝色填充并逆时针旋转45°（图9.15）
elp1 = ELLIPSE(0.7,0.5,major =0.2,minor=0.1,fill_color ='b',THETA = 45)


;创建算法数据集
theory = SIN(2.0*FINDGEN(201)*!PI/25.0)*EXP(-0.02*FINDGEN(201))
;算法数据集基础上加随机数模拟观测实际数据
observed = theory + RANDOMU(seed,201)*0.4-0.2
;绘制模拟观测数据
p1 = PLOT(observed, NAME='Observed')
;绘制算法数据（红色加粗）
p2 = PLOT(theory, /OVERPLOT, 'r2', NAME='Theory')
;添加图例（图9.16）
l = LEGEND(TARGET=[p1,p2], POSITION=[140,0.9], /DATA)



;生成正弦数据
sinewave = SIN(2.0*FINDGEN(200))*EXP(-0.02*FINDGEN(200))
;生成余弦数据
cosine = COS(2.0*FINDGEN(200))*EXP(-0.02*FINDGEN(200))
;指定显示区域红色绘制正弦数据曲线
p=PLOT(sinewave, '-r', AXIS_STYLE=1, $
  POSITION=[.075,.075,.90,.90])
;指定显示区域蓝色绘制余弦数据曲线（图9.17）
p=PLOT(cosine, '-b', AXIS_STYLE=1, $
  /CURRENT, POSITION=[.60,.60,.90,.90])
  
  
;定义200个元素的索引数组
x = FINDGEN(200)
;绘制3D曲线（图9.18）
plot3d = PLOT3D(x *COS(x/10), x*SIN(x/10), x, 'b2d')
;获得当前系统目录
CD, current = curdir
;输出查看
PRINT,curdir
;修改系统目录为’c:\temp’
CD, 'c:\temp'
;保存为bmp文件，300的分辨率
PLOT3D.SAVE,'plot3d.bmp',resolution =300




END