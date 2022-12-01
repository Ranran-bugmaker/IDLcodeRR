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

;第七章书中示例代码
;-
;
 ;设置颜色模式
 DEVICE, decomposed =0
 ;构建IDL目录下的jpg文件路径
 file = FILEPATH('r_seeberi.jpg', $
   SUBDIRECTORY = ['examples', 'data'])
 ;加载Grayscale关键字读取灰度图像
 READ_JPEG, file, image, /GRAYSCALE
 ;查看图像信息
 HELP,image
 ;创建与图像大小一致的显示窗口，ID为1
 WINDOW,1,xsize = 280,ysize =195
 ;显示图像（图7.1）
 TV,image
 ;加载颜色表13（IDL系统自带）
 LOADCT,13
 ;显示图像（图7.2）.
 TV,image
 ;输入loadct
 LOADCT
 ;再显示图像（图7.4）
 tv,image
 
 ;调用XLoadCT界面（图7.5）
 XLOADCT
 ;显示图像（图7.6）
 tv,image
 
 ;载入索引13的颜色表，RGB对照表赋给变量rgb
 LOADCT,13,rgb_table = rgb
 ;查看变量rgb的信息
 help,rgb
 
 ;定义颜色表的R、G、B分量
 R = BYTSCL(SIN(FINDGEN(256)))
 G = BYTSCL(COS(FINDGEN(256)))
 B = BINDGEN(256)
 ;载入自定义的RGB分量
 TVLCT, R, G, B
 ;显示图像（图7.7）
 tv,image
 
 
 ;索引为41的颜色表，若存在则修改，不存在则自动创建
 MODIFYCT, 41, 'Sin And Cos', r,g,b
 ;调用XLoadCT，查看修改的颜色表（图7.8）
 XLOADCT
 
 
 ;保存系统变量值
 oriBkcolor = !p.BACKGROUND
 !p.BACKGROUND = !p.COLOR
 !p.COLOR = oriBKcolor
 ;创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;创建600*200的窗口
 WINDOW,xsize = 600,ysize = 200
 ;曲线黑色显示，白色背景（图7.9）
 PLOT,xData,sin(xData)
 ;恢复系统变量数值
 !p.COLOR = !p.BACKGROUND
 !p.BACKGROUND = oriBkcolor
 
 
 
 ;设置颜色转换模式
 Device,decomposed = 1
 ;创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;创建600*200的窗口
 WINDOW,xsize = 600,ysize = 200
 ;曲线蓝色显示，白色背景（图7.10）
 PLOT,xData,sin(xData),color=16711680L,background = 16777215L
 
 
 ;创建600*200的窗口
 WINDOW,xsize = 600,ysize = 200
 ; 创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;默认参数绘制曲线（图7.11）
 PLOT,xData,sin(xData)
 ;在窗口四分之一的左下角部分绘图（图7.12）
 PLOT,xData,sin(xData),position = [0,0,0.5,0.5]
 ;显示区域为窗口四分之一的左下角部分
 !p.REGION = [0,0,0.5,0.5]
 ;绘图（图7.13）
 PLOT,xData,sin(xData)
 
 ;将当前系统变量值赋值给变量sysFont
 sysFont = !p.FONT
 ;设置字体模式为矢量字体
 !p.FONT =-1
 ;创建大小600*200像素的窗口
 WINDOW,1,xsize =600,ysize =200
 ;创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;默认参数绘制曲线
 PLOT,xData,sin(xData),title = '!12sin plot',xtitle ='!3x axis'
 ;中心点输出字符串’Center Point’（图7.14）
 xyouts,0.5,0.5,'!13Center Point',/normal,charsize =2
 ;恢复系统变量字体初值
 !p.FONT = sysFont
 
 
 
 ;创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;创建大小400*150像素的窗口
 WINDOW,1,xsize =400,ysize =150
 ;绘制曲线，标题设置为汉字会显示乱码（图7.15-(1)）
 PLOT,xData,sin(xData),title = '正弦曲线'
 ;将当前系统变量值赋值给变量sysFont
 sysFont = !p.FONT
 ;使用系统字体
 !p.FONT = 0
 ;设置字体为“宋体”，确保设置的字体系统中存在。
 Device, Set_Font='宋体'
 ;绘制曲线（图7.15-(2)）
 PLOT,xData,sin(xData),title = '正弦曲线'
 ;设置字体为“楷体”，大小为12像素。
 Device, Set_Font='楷体*12'
 ;绘制曲线（图7.15-(3)）
 PLOT,xData,sin(xData),title = '正弦曲线'
 ;设置字体为黑体，大小为16像素，设置斜体(ITALTC)和显示下划线(UNDERLINE)。
 Device, Set_Font='黑体*ITALIC*UNDERLINE*16'
 ;绘制曲线（图7.15-(4)）
 PLOT,xData,sin(xData),title = '正弦曲线'
 ;恢复系统变量字体初值
 !p.FONT = sysFont
 
 
 ;创建大小400*150像素的窗口
 WINDOW,1,xsize =400,ysize =150
 ;创建一个正弦曲线数据
 xdata = findgen(200)/10
 ;将当前系统变量值赋值给变量sysFont
 sysFont = !p.FONT
 ;使用TrueType字体
 !p.FONT =1
 ;设置Helvetica字体并加粗、倾斜
 DEVICE, SET_FONT='Helvetica Bold Italic', /TT_FONT
 ;绘制曲线（图7.16-(1)）
 PLOT,xData,sin(xData),title = 'sin Plot'
 ;设置Courier字体倾斜并设置为[10,12]像素大小
 DEVICE, SET_FONT='Courier Italic', /TT_FONT, $
   SET_CHARACTER_SIZE=[10,12]
 ;绘制曲线（图7.16-(2)）
 PLOT,xData,sin(xData),title = 'sin Plot'
 ;恢复系统变量字体初值
 !p.FONT = sysFont
 
 
 ;设置调用TrueType字体“beijing2008”
 device, set_font ='beijing2008',/tt_font
 ;创建大小为900*200的显示窗体
 WINDOW,1,xsize = 900,ysize =200
 ;按照设备坐标从左下角[0,0]起显示当前TrueType字体(font=1)
 ;显示内容为’012abc’（图7.17）
 xyouts,0,0,'012abc',charsize=20,/device,font=1
 
 
 
 ;查看系统当前显示窗口。
 print,!d.WINDOW
 ;创建ID为8，大小为400*300的窗口（图7.18）
 WINDOW,8,xsize = 400,ysize =300
 ;输出系统变量，8即新创建的窗口。
 
 
 ;依次创建两个显示窗口（图7.19）
 WINDOW,1,xsize = 300,ysize =200
 WINDOW,2,xsize = 300,ysize =200
 ;设置颜色转换模式
 Device,decomposed = 1
 ;绘制红色曲线，显示在最后创建的“2”窗口中。
 PLOT,(findgen(20)/10)^3,color = 255L
 ;暴露“1”窗口
 wset,1
 ;绘制蓝色曲线（图7.20）
 PLOT,(findgen(20)/10)^3,color = 16711680L
 ;删除所有显示窗口
 wdelete,1,2
 
 
 ;创建大小为800*600的窗口
 WINDOW,0,xsize =800,ysize=600
 ;设置多图显示，2行2列
 !p.MULTI = [4,2,2,0,0]
 ;构建0-19的索引数组数据
 data = FINDGEN(20)
 ;数组数据绘图，见图7.21第一个图形
 PLOT,data
 ;数组正弦和余弦图，见图7.21第二个图形
 PLOT, SIN(data/3), COS(data/6)
 ;使用polar关键字绘制极射图，见图7.21第三个图形
 PLOT, data, data, /POLAR, TITLE = 'Polar'
 ;绘制曲线，符号显示并设置x、y轴标题，见图7.21中第四个图形
 PLOT, SIN(data/10), PSYM=4, XTITLE='X ', YTITLE='Y
 ;恢复多图控制参数
 !p.MULTI = 0
 
 ;创建几个变量
 SOCKEYE=[463, 459, 437, 433, 431, 433, 431, 428, 430, 431, 430]
 YEAR = [1967, 1970, INDGEN(9) + 1975]
 ;绘制年份与人口数曲线（图7.28），注意Title、xTitle和yTitle的使用。
 PLOT, YEAR, SOCKEYE, TITLE='Sockeye Population', XTITLE='Year', YTITLE='Fish (thousands)'
 
 
 ;创建大小为800*600的窗口
 WINDOW,0,xsize =800,ysize=600
 ;设置多图显示，2行2列
 !p.MULTI = [4,2,2,0,0]
 ;构建数据，ydata为xdata的正弦值
 xdata = findgen(200)/10+3
 ydata = sin(xdata)
 ;直接绘制曲线，见图7.23的第一个图形
 PLOT,xdata,ydata
 ; 设置x轴显示风格为1，见图7.23的第二个图形
 PLOT,xdata,ydata,/xstyle
 ;设置y轴显示风格为4，见图7.23的第三个图形
 PLOT,xdata,ydata,/xstyle,ystyle=4
 ;设置y轴显示风格为8，见图7.23的第四个图形
 PLOT,xdata,ydata,/xstyle,ystyle=8
 ;恢复多图控制参数
 !p.MULTI = 0
 
 
 ;创建大小为800*600的窗口
 WINDOW,0,xsize =800,ysize=600
 ;设置多图显示，2行2列
 !p.MULTI = [4,2,2,0,0]
 ;构建数据，ydata为xdata的正弦值
 xdata = findgen(20)/4
 ydata = sin(xdata)
 ;直接绘制正弦曲线，见图7.24的第一个图形
 PLOT,xdata,ydata
 ;设置曲线点方式显示，见图7.24的第二个图形
 PLOT,xdata,ydata,psym = 3
 ;设置曲线点方式显示，见图7.24的第三个图形
 PLOT,xdata,ydata,psym = 4
 ;设置曲线点方式显示，见图7.24的第四个图形
 PLOT,xdata,ydata,psym = 10
 ;恢复多图控制参数
 !p.MULTI = 0
 
 
 ;创建大小为800*600的窗口
 WINDOW,0,xsize =800,ysize=600
 ;设置多图显示，2行2列
 !p.MULTI = [4,2,2,0,0]
 ;创建200*200的数组，可tv,data查看数据分布
 data = DIST(200)
 ;直接绘制数据等值线，见图7.26的第一个图形
 CONTOUR,data
 ;设置等值线为10级并填充，显示注记，见图7.26的第二个图形
 CONTOUR,data,NLEVELS =10, /FOLLOW
 ;创建一个随机曲面数据
 A = RANDOMU(seed, 5, 6)
 ;等值线前线做平滑处理
 B = MIN_CURVE_SURF(A)
 ;绘制5级等值线及山脚朝向线，见图7.26的第三个图形
 CONTOUR, B, NLEVELS=5, /DOWNHILL
 ;调用IDL自身的独立颜色对照表
 TEK_COLOR
 ;5级填充显示并设置不同颜色，见图7.26的第四个图形
 CONTOUR, B, /FILL, NLEVELS=5, C_COLOR=INDGEN(5)*180
 ;恢复多图控制参数
 !p.MULTI = 0
 
 
 
 ;生成50个随机点
 x = RANDOMN(seed, 50)
 y = RANDOMN(seed, 50)
 ;计算XY表达式值Z
 Z = EXP(-(x^2 + y^2))
 ;根据离散点生成Delaunay三角网
 TRIANGULATE, X, Y, tri
 ;创建大小为400*300的窗口
 WINDOW,0,xsize =400,ysize =300
 ; 绘制等值线（图7.33）
 CONTOUR, Z, X, Y, TRIANGULATION = tri
 
 ;生成随机数据
 SEED = 20 & DATA = RANDOMU(SEED, 6, 8)
 ;设置多图显示模式
 !P.MULTI=[0,2,1]
 ;创建大小为800*400的窗口
 WINDOW,0,xsize =800,ysize =400
 ;绘制等值线，设置等值线数值，见图7.28.
 CONTOUR, LEVEL=[0.2, 0.5, 0.8], C_LABELS=[1, 1, 1], $
   C_CHARSIZE = 1.25, DATA
 ;绘制等值线，设置显示标注内容（图7.28）
 CONTOUR, LEVEL=[0.2, 0.5, 0.8], C_LABELS=[1, 1, 1], $
   C_ANNOTATION = ["Low", "Medium", "High"], $
   C_CHARSIZE = 1.25, DATA
 ;恢复多图显示控制参数
 !P.MULTI=0
 
 
 ;载入颜色表14
 DEVICE, DECOMPOSED=0
 LOADCT,14
 ;数据初步处理，拉伸及重采样
 RESTORE, FILEPATH('marbells.dat', SUBDIR=['examples','data'])
 X = 326.850 + .030 * FINDGEN(72)
 Y = 4318.500 + .030 * FINDGEN(92)
 image = BYTSCL(elev, MIN=2658, MAX=4241)
 new = REBIN(elev, 350/5, 450/5)
 ;设置图像绘制位置：!X.window-绘图起点归一化坐标，!D.x_Vsize绘图大小
 PX = !X.WINDOW * !D.X_VSIZE
 PY = !Y.WINDOW * !D.Y_VSIZE
 ;计算显示区域图像像素尺寸.
 SX = PX[1] - PX[0] + 1
 SY = PY[1] - PY[0] + 1
 ;创建大小为800*400的窗口
 WINDOW,0,xsize =800,ysize =400
 ;从左下角起根据计算的图像绘制位置显示图像.
 TVSCL, CONGRID(image, SX, SY), PX[0], PY[0]
 ;绘制等值线，NoErase关键字控制不擦除原栅格图像（图7.29）
 ;也可参考image_cont，该命令包含源码，可直接调用！
 CONTOUR, new, X, Y, LEVELS = 2750 + FINDGEN(6) * 250., $
   XSTYLE = 1, YSTYLE = 1, YMARGIN = 5, MAX_VALUE = 5000, $
   C_LINESTYLE = [1, 0], $
   C_THICK = [1, 1, 1, 1, 1, 3], $
   TITLE = 'Maroon Bells Region', $
   SUBTITLE = '250 meter contours', $
   XTITLE = 'UTM Coordinates (KM)', $
   /NoErase
 ;恢复颜色显示设置
 DEVICE, DECOMPOSED=1
 
 
 ;显示行数37
 number_samples = 37
 ;用TimeGen函数生成日期序列，起始日期为Julday格式
 date_time = TIMEGEN(number_samples, UNITS = 'Seconds', $
   START = JULDAY(3, 30, 2000, 14, 59, 30))
 ;角度序列数据
 angle = 10.*FINDGEN(number_samples)
 ;序列温度数据
 temperature = BYTSCL(SIN(10.*!DTOR* $
   FINDGEN(number_samples)) # COS(!DTOR*angle))
 ;载入颜色表5
 DEVICE, DECOMPOSED = 0
 LOADCT, 5
 ;利用LABEL_DATE函数生成日期标注值
 date_label = LABEL_DATE(DATE_FORMAT = $
   ['%I:%S', '%H', '%D %M, %Y'])
 ;创建大小为800*400的窗口
 WINDOW,0,xsize =800,ysize =400
 ;基于数据绘制等值线、显示标注
 CONTOUR, temperature, angle, date_time, $
   LEVELS = BYTSCL(INDGEN(8)), /XSTYLE, /YSTYLE, $
   C_COLORS = BYTSCL(INDGEN(8)), /FILL, $
   ;注意主标题，字符串中间加!C会换行显示.
   TITLE = 'Measured Temperature!C(degrees Celsius)', $
   XTITLE = 'Angle (degrees)', $
   YTITLE = 'Time (seconds)', $
   POSITION = [0.25, 0.2, 0.9, 0.85], $
   YTICKFORMAT = ['LABEL_DATE', 'LABEL_DATE', 'LABEL_DATE'], $
   YTICKUNITS = ['Time', 'Hour', 'Day'], $
   YTICKINTERVAL = 5, $
   YTICKLAYOUT = 2
 ;在刚才显示基础上增加绘制等值线（图7.30）
 CONTOUR, temperature, angle, date_time, /OVERPLOT, $
   LEVELS = BYTSCL(INDGEN(8))
 ;恢复颜色显示设置
 DEVICE, DECOMPOSED=1
 
 
 
 ;创建512*256大小的显示窗口
 WINDOW,0,xsize = 512,ysize = 256
 ;创建256*256的数组
 D = DIST(256)
 ;原数据绘制，图像绘制在窗口的左下角。
 TV, D
 ;拉伸显示，0表示图像显示在第一个索引位置。
 TVSCL, D,1
 
 ;创建512*256大小的显示窗口
 WINDOW,0,xsize = 512,ysize = 300
 ;在[128,22]的位置绘制，即居中显示图像（图7.31）
 tv,DIST(256),128,22
 
 
 
 
 ;构造IDL安装目录example\data目录下的rose.jpg文件全路径
 file = FILEPATH('rose.jpg', $
   SUBDIRECTORY = ['examples', 'data'])
 ;调用READ_IMAGE函数读取文件
 image = READ_IMAGE(file)
 ;查看图片信息
 HELP,image
 ;创建400*300大小的显示窗口
 WINDOW,0,xsize=400,ysize =300
 ;因图像格式符合[3,m,n],故true取1，可写为/true格式（图7.33）
 TV,image,81,75,/true
 ;QUERY_IMAGE函数查询文件信息
 queryStatus = QUERY_IMAGE(file, imageInfo)
 ;获取数据的维数大小
 imageDims = SIZE(image, /DIMENSIONS)
 ;查询函数的结果
 imagesize = imageinfo.DIMENSIONS
 ;利用判断算法来计算true的值
 trueValue= WHERE((imageDims NE imageSize[0]) AND (imageDims NE imageSize[1])) + 1
 ;查看计算结果.
 print,trueValue
 1
 
 ;创建大小为800*600的窗口
 WINDOW,0,xsize =800,ysize=600
 ;设置多图显示，2行2列
 !p.MULTI = [4,2,2,0,0]
 D = DIST(30)
 ;直接绘制网格曲面，见图7.34的第一个图像。
 SURFACE, D
 ;曲面绕z转60°且绕x旋转35°，见图7.34的第二个图像。
 SURFACE, d,   Az=60,  Ax=35
 ;添加“裙边”后曲面，见图7.34的第三个图像。
 SURFACE, D, SKIRT=0.0, TITLE = 'Surface Plot'
 ;阴影曲面绘制，见图7.34的第四个图像。
 SHADE_SURF, D, TITLE = 'Shaded Surface'
 
 
 
 DEVICE, DECOMPOSED=1
 ;构建完整的文件路径.
 file = Filepath('head.dat', SUBDIRECTORY = ['examples', 'data'])
 ;读取体数据到volume数组
 volume = READ_BINARY(file, DATA_DIMS = [80, 100, 57])
 ;重采样为小数据
 smallVol = CONGRID(volume, 40, 50, 27)
 ;XVOLUME交互式显示数据（图7.35）
 XVOLUME, smallVol, /INTERPOLATE
 ;创建200*100的显示窗口（图7.36）
 WINDOW,0,xsize =200,ysize =100
 ;设置多图显示，2行2列
 !p.MULTI = [2,1,2,0,0]
 ;特定方位切片，依次为切片大小、中心点坐标、绕XYZ轴的角度.
 slice = EXTRACT_SLICE(volume,40,40, 40,50,28, 30,0,0)
 ;显示结果切片.
 TV,slice ,0
 ;显示垂直切片.
 TV,volume[23,*,*],1
 ;调用Slicer3进行交互式操作，注意输入为指针（图7.37）
 SLICER3,Ptr_New(volume,/No_Copy)
 
 ;设置MERCATOR投影
 MAP_SET, /MERCATOR
 ;获取当前投影名称及其他信息
 MAP_PROJ_INFO, /CURRENT, NAME=name, AZIMUTHAL=az, $
      CYLINDRICAL=cyl, CIRCLE=cir
 ;输出
 print,name,az,cyl,cir
 Mercator       0       1       0
 ;创建Goodes Homolosine投影
 sMap = MAP_PROJ_INIT('Goodes Homolosine')
 ;使用该投影，赋值给系统变量!MAP即可。
 !Map = sMap
 ;获取当前投影名称
 MAP_PROJ_INFO, /CURRENT, NAME=name
 ;输出
 print,name
 GoodesHomolosine
 
 DEVICE, DECOMPOSED=0
 ;载入系统自定义颜色表
 TEK_COLOR
 ;设置颜色名称对应索引值
 black=0 & white=1 & red=2
 green=3 & dk_blue=4 & lt_blue=5
 ;设置MERCATOR投影，创建空白显示窗口。
 MAP_SET, /MERCATOR
 ;默认显示MAP_CONTINENTS选项
 MAP_CONTINENTS
 ;设置显示大陆边界填充，填充色为白色
 MAP_CONTINENTS, /FILL_CONTINENTS, COLOR=white
 ;叠加显示河流，河流颜色设置为浅蓝色lt_blue
 MAP_CONTINENTS, /RIVERS, COLOR=lt_blue
 ;叠加显示国家边界线，线粗为2，颜色为红色
 MAP_CONTINENTS, /COUNTRIES, COLOR=red, MLINETHICK=2
 ;叠加经纬度网格
 MAP_GRID
 
 ;载入系统Example目录下的avhrr.img文件。
 file = FILEPATH( 'avhrr.png', SUBDIRECTORY=['examples','data'] )
 ;读取数据的三个波段数据，分别存在变量r、g、b中。
 data = READ_PNG( file, r, g, b )
 ;数据进行重采样处理
 red0 = REBIN( r[data], 360, 180 )
 green0 = REBIN( g[data], 360, 180)
 blue0 = REBIN( b[data], 360, 180 )
 ;调用iImage创建三区域，显示重采样后数据在最上面区域
 IIMAGE, RED=red0, GREEN=green0, BLUE=blue0, $
   DIMENSIONS=[500,600], VIEW_GRID=[1,3]
 ;创建投影Interrupted Goode
 sMap = MAP_PROJ_INIT('Interrupted Goode')
 ;对第一个波段red0进行投影转换，获得掩膜区域文件mask和
 ;  笛卡尔坐标范围uvrange、X和Y的索引转换对应关系xIndex和yIndex。
 red1 = MAP_PROJ_IMAGE( red0, MAP_STRUCTURE=sMap, MASK=mask, $
   UVRANGE=uvrange, XINDEX=xindex, YINDEX=yindex )
 ;利用xIndex和yIndex转换第二个波段green0和第三个波段blue0.
 green1 = MAP_PROJ_IMAGE( green0, XINDEX=xindex, YINDEX=yindex )
 blue1 = MAP_PROJ_IMAGE( blue0, XINDEX=xindex, YINDEX=yindex )
 ;调用iImage显示转换后的图像文件，显示在区域中间位置
 IIMAGE, RED=red1, GREEN=green1, BLUE=blue1, ALPHA=mask*255b, $
       /VIEW_NEXT
 ;创建新的Mollweide投影
 mapStruct = MAP_PROJ_INIT( 'Mollweide', /GCTP )
 ;与上面类似进行各个波段的投影转换.
 red2 = MAP_PROJ_IMAGE( red1, uvrange, IMAGE_STRUCTURE=sMap, $
   MAP_STRUCTURE=mapStruct, MASK=mask, $
   XINDEX=xindex2, YINDEX=yindex2 )
 green2 = MAP_PROJ_IMAGE( green1, XINDEX=xindex2, YINDEX=yindex2 )
 blue2 = MAP_PROJ_IMAGE( blue1, XINDEX=xindex2, YINDEX=yindex2 )
 ;调用iImage显示转换后的图像文件，显示在区域最下方
 IIMAGE, RED=red2, GREEN=green2, BLUE=blue2, ALPHA=mask*255b, $
       /VIEW_NEXT

 ;保存系统变量值
 oriBkcolor = !p.BACKGROUND
 !p.BACKGROUND = !p.COLOR
 !p.COLOR = oriBKcolor