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
;-
;第八章书中示例代码
;-

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [600,400])
;创建一个显示view
oView = Obj_New('IDLgrView')
;创建model对象
oModel = Obj_New('IDLgrModel')
;model添加到view
oView.ADD,oModel
;创建一个文本对象
oText = Obj_New('IDLgrText','Using IDL Objects!')
;添加对象到model中
oModel.ADD,oText
;window对象绘制view对象（图8.2）
oWindow.DRAW, oView



;创建IDLgrWindow对象，大小为400*300.
owindow = Obj_new('idlgrwindow', $
  dimensions = [400,300], $
  title ='400*300')
;创建IDLgrWindow对象，大小为200*200，与显示器左上角偏移量为400*50.
owindow = Obj_new('idlgrwindow', $
  dimension = [200,200], $
  title ='200*200', Location = [400,50])
  
;实例化IDLgrWindow对象
owindow = Obj_New('idlgrwindow',dimension = [400,300])
;建立IDLgrView对象，背景色为灰色
oView = Obj_New('IDLgrView',color = (bytarr(3)+1)*128)
;绘制显示（图8.4-(a)）
oWindow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',retain=2,dimension = [600,400])
;创建一个显示view
oView = Obj_New('IDLgrView')
;创建model对象
oModel = Obj_New('IDLgrModel')
;model添加到view
oView.ADD,oModel
;创建一个曲线对象
x = findgen(200)/100-1
oSinPlot = Obj_New('IDLgrPlot',x,sin(x*2*!pi))
;添加对象到model中
oModel.ADD,oSinPlot
;window对象绘制view对象（图8.5）
oWindow.DRAW, oView


;创建window对象
oWindow= Obj_New('IDLgrWindow',retain=2,dimension = [400,300])
;创建一个显示view，灰色背景
oView = Obj_New('IDLgrView', $
  color =[128,128,128], $
  viewPlane_Rect = [-100,-100,400,400])
;设置oWindow的渲染对象是oView
oWindow.SETPROPERTY, Graphics_tree = oView
;window对象渲染显示（图8.7-(1)）
oWindow.DRAW

;创建model对象
oModel = Obj_New('IDLgrModel')
;model添加到view
oView.ADD,oModel
;创建一个图像200*200
oImage = Obj_New('IDLgrImage',DIST(200))
;添加对象到model中
oModel.ADD,oImage
;window对象渲染显示（图8.7-(2)）
oWindow.DRAW

oView.SETPROPERTY,dimensions = [200,150]
;window对象擦除，可对比查看有何不同。
;oWindow.Erase
;window对象渲染显示（图8.7-(3)）
oWindow.DRAW
oView.SETPROPERTY,location = [100,100]
;window对象擦除
;oWindow.Erase
;window对象渲染显示（图8.7-(4)）
oWindow.DRAW


;创建window对象
oWindow= Obj_New('IDLgrWindow',retain=2,dimension = [400,300])
;创建一个显示view
oView = Obj_New('IDLgrView')
;设置oWindow的渲染对象是oView
oWindow.SETPROPERTY, Graphics_tree = oView
;创建model对象
oModel = Obj_New('IDLgrModel')
;model添加到view
oView.ADD,oModel
;创建一个图像200*200
oImage = Obj_New('IDLgrImage',DIST(200))
;添加对象到model中
oModel.ADD,oImage
;window对象渲染显示，图8.9-(1)，此时ViewPort默认值，为[0,0,1,1]
oWindow.DRAW
;设置View的ViewPort范围[0,0,200,200]，即显示区域与原图一致。
oView.SETPROPERTY, viewPlane_Rect = [0,0,200,200]
;window对象渲染显示，图8.9-(2)
oWindow.DRAW
;设置View的ViewPort范围[-100,-100,400,400]
oView.SETPROPERTY, viewPlane_Rect = [-100,-100,400,400]
;window对象渲染显示，图8.9-(3)
oWindow.DRAW
;设置View的ViewPort范围[100,100,200,200]
oView.SETPROPERTY, viewPlane_Rect = [100,100,200,200]
;window对象渲染显示，图8.9-(4)
oWindow.DRAW


;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建一个显示view，根据zClip可知z值在 [-1,1]之间可以被看到
oView = Obj_New('IDLgrView', $
  zClip = [1,-1],$
  eye = 5, $
  viewPlane_Rect = [0,0,300,300])
;设置oWindow的渲染对象是oView
oWindow.SETPROPERTY, Graphics_tree = oView
;创建model对象
oModel = Obj_New('IDLgrModel')
;model添加到view
oView.ADD,oModel
;创建一个数据数组，注意Z方向高度均为0.5
polyData = [[50,50,0.5],[50,150,0.5],[150,150,0.5],[150,50,0.5]]
;生成一红色矩形
oRedPoly = Obj_New('IDLgrPolygon', polydata, color = [255,0,0])
;修改该数据，使得x和y方向均增加100，z方向增加1即高度均为1.5
polyData[0,*] +=100
polyData[1,*] +=100
polyData[2,*] +=1
;生成一蓝色矩形
oBluePoly = Obj_New('IDLgrPolygon', polydata, $
  color = [0,255,0])
;添加对象到model中
oModel.ADD,[oRedPoly,oBluePoly]
;window对象渲染显示（图8.13-(1)）。
oWindow.DRAW
;设置view对象z方向可视范围为[-1,2]
oView.SETPROPERTY,zClip = [2,-1]
;window对象渲染显示（图8.13-(2)）。
oWindow.DRAW

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [600,400])
;创建scene对象
oScene = Obj_New('IDLgrScene')
;新建view,大小为窗体四分之一，位于左下角，设为浅灰色, units为3即归一化坐标
oView1= Obj_New('IDLgrView', $
  location = [0,0.5], dimension = [0.5,0.5], $
  color = [100,100,100],units = 3)
;新建view,大小为窗体四分之一，位于右下角，设为红色
oView2= Obj_New('IDLgrView', $
  location=[0.5,0], dimension=[0.5,0.5],$
  color = [255,0,0],units=3)
;添加oView和oView2对象到场景oScene中
oScene.ADD,[oView1,oView2]
;window对象渲染scene对象，即绘制场景（图8.14）
oWindow.DRAW,oScene


;初始化显示窗体,大小为400*400像素
oWindow = Obj_New('IDLgrWindow',dimension =[400,400],retain = 2)
;创建View对象，显示范围([-1,-1,2,2]),表示左下角为[-1,-1]左上角为[1,1]
oView = Obj_New('IDLgrView',viewPlane_Rect = [-1,-1,2,2])
;绘制显示，见图8.16-(a)
oWindow.DRAW,oView
;创建左下角在[-1,-1]、边长为1的红色正方形。
oPolygon = Obj_New('IDLgrPolygon',[[-1,-1],[-1,0],[0,0],[0,-1]],$
  color =[255,0,0])
;设置显示体系层次
oModel = Obj_New('IDLgrModel')
oModel.ADD,oPolygon
oView.ADD,oModel
;绘制显示，见图8.16-(b)
oWindow.DRAW,oView
;平移图形，X和Y方向移动0.5，Z方向不动
oModel.TRANSLATE,0.5,0.5,0
;绘制显示，见图8.16-(c)
oWindow.DRAW,oView
;旋转图形，绕Z轴顺时针45
oModel.ROTATE,[0,0,1],45
;绘制显示，见图8.16-(d)
oWindow.DRAW,oView
;缩放图形，X和Y方向缩为0.5，Z方向不变
oModel.SCALE,0.5,0.5,1
;绘制显示，见图8.16-(e)
oWindow.DRAW,oView
;恢复到初始状态
oModel.RESET
;绘制显示，见图8.16-(f)
oWindow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
x = [-.5,.5]
y = [-.5,.5]
;创建Idlgrpolyline对象
oPolyline = Obj_New('IDLgrPolyline',x,y)
oModel.ADD,oPolyline
;绘制显示，见图8.17-(a)
oWIndow.DRAW,oView
;对线对象进行颜色的修改
oPolyline.SETPROPERTY,color =[255,0,0]
;绘制显示，见图8.17-(b)
oWIndow.DRAW,oView
;修改线粗为5
oPolyline.SETPROPERTY,thick = 5
;绘制显示，见图8.17-(c)
oWIndow.DRAW,oView
;创建一折线数据段
data = fltarr(2,4)
data[0,*]= [-.5,-.5,.5,.5]
data[1,*]= [-.5,.5,.5,-.5]
;赋值
oPolyline.SETPROPERTY,data = data
;绘制显示，见图8.17-(d)
oWIndow.DRAW,oView
;交叉图形链接关系
polylines = [4,0,1,3,2]
oPolyline.SETPROPERTY,polylines = polylines
;绘制显示，见图8.17-(e)
oWIndow.DRAW,oView
;正方形链接关系
polylines = [5,0,1,2,3,0]
oPolyline.SETPROPERTY,polylines = polylines
;绘制显示，见图8.17-(f)
oWIndow.DRAW,oView
;X形链接关系
polylines = [2,0,2,2,1,3]
oPolyline.SETPROPERTY,polylines = polylines
;绘制显示，见图8.17-(g)
oWIndow.DRAW,oView
;正方形+对角线链接关系
polylines = [5,0,1,2,3,0,2,0,2,2,1,3]
oPolyline.SETPROPERTY,polylines = polylines
;绘制显示，见图8.17-(h)
oWIndow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,400])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;创建IDLgrPolyline对象
oPolyline = Obj_New('IDLgrPolyline')
oPolygon = Obj_New('IDLgrPolygon')
;设置显示体系层次
oView.ADD,oModel
oModel.ADD,[oPolyline,oPolygon]
;创建一折线数据段
data = fltarr(2,4)
data[0,*]= [-.5,-.5,-.1,-.1]
data[1,*]= [-.5,-.1,-.1,-.5]
;设置线对象为红色，值为data
oPolyline.SETPROPERTY,color =[255,0,0],data = data
;设置多边形对象为蓝色，值为data向X和Y方向偏移0.5
oPolygon.SETPROPERTY,color =[0,0,255],data = data+0.5
;绘制显示（图8.20）
oWIndow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,400])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;创建IDLgrPolygon对象
oPolygon = Obj_New('IDLgrPolygon')
;设置显示体系层次
oView.ADD,oModel
oModel.ADD,oPolygon
;创建一正方形
data = fltarr(2,4)
data[0,*]= [-.5,-.5,.5,.5]
data[1,*]= [-.5,.5,.5,-.5]
;设置多边形对象为蓝色，值为data
oPolygon.SETPROPERTY,color =[0,0,255],data = data
;绘制显示，见图8.21-(a)
oWIndow.DRAW,oView
;创建样式对象
oPattern = Obj_New('IDLgrPattern',1)
;设置多边形样式填充
oPolygon.SETPROPERTY, fill_pattern= oPattern
;绘制显示，见图8.21-(b)
oWIndow.DRAW,oView
;读取纹理文件,注意纹理文件路径
read_jpeg,'c:\data\tree.jpg',imgData,/true
;创建纹理对象
oImage = Obj_New('IDLgrImage',imgData,BLEND_FUNCTION =[3,4])
;为IDLgrPolygon对象赋值纹理对象，因已设置样式，故需要需要清除样式.
oPolygon.SETPROPERTY, Texture_map = oImage,fill_pattern= Obj_New(),$
  Texture_Coord = [[0,0], [0,1], [1,1], [1,0]],color = [255,255,255]
;绘制显示，见图8.21-(c)
oWIndow.DRAW,oView
;设置纹理坐标，此时的纹理坐标表示图像在X和Y方向各填充两次。
Texture_Coord = [[0,0], [0,2], [2,2], [2,0]]
oPolygon.SETPROPERTY,Texture_Coord = Texture_Coord
;绘制显示，见图8.21-(d)
oWIndow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;创建IDLgrPolygon对象
oPolygon = Obj_New('IDLgrPolygon')
;设置显示体系层次
oView.ADD,oModel
oModel.ADD,oPolygon
;创建一凹多边形
data = fltarr(2,8)
data[0,*]= [-.75,.75,.75,.25,.25,-.25,-.25,-.75]
data[1,*]= [-.75,-.75,.75,.75,0,0,.75,.75]
;设置多边形对象为蓝色，值为data
oPolygon.SETPROPERTY,color =[0,0,255],data = data
;绘制显示，见图8.22-(a)
oWIndow.DRAW,oView
;创建IDLgrTessellator对象
oTessellator = Obj_New('IDLgrTessellator')
;添加多边形对象
oTessellator.ADDPOLYGON,data
;计算多边形转换为三角形的顶点和链接关系
tmp = oTessellator.TESSELLATE(vert,poly)
;设置多边形对象的顶点数据和链接关系
oPolygon.SETPROPERTY,data = vert, polygons = poly
;绘制显示，见图8.22-(b)
oWIndow.DRAW,oView



;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
oWindow.SETPROPERTY,graphics_tree = oView
oText = Obj_New('IDLgrText','Hello IDL!',Alignment = 0.5)
;添加对象到model中
oModel.ADD,oText
;绘制显示，见图8.23-(a)
oWIndow.DRAW
;修改字体颜色为红色
oText.SETPROPERTY, color=[255,0,0]
;绘制显示，见图8.23-(b)
oWIndow.DRAW
oText.SETPROPERTY, strings = ['IDL','ENVI']
;绘制显示，见图8.23-(c)
oWindow.DRAW,oView
oText.SETPROPERTY, location = [[0,0],[.5,.5]]
;绘制显示，见图8.23-(d)
oWindow.DRAW
;baseline是文字的基准方向，由二维或三维的矢量组成。
oText.SETPROPERTY, BASELINE =[1,1]
;绘制显示，见图8.23-(e)
oWIndow.DRAW
;char_dimension指的是文字占的大小
oText.SETPROPERTY,baseline=[1,0],updir =[0,1], CHAR_DIMENSION = [.5,.5]
;绘制显示，见图8.23-(f)
oWIndow.DRAW
;VERTICAL_ALIGNMENT是指文字在y方向的位置，0则文字底部靠近基准面（默认）
; 1则文字顶部靠近基准面。
oText.SETPROPERTY, VERTICAL_ALIGNMENT=1
;绘制显示，见图8.23-(g)
oWIndow.DRAW
;DRAW_CURSOR设置文字中间是否有光标
;Selection_start设置选择开始字符索引
;Selection_length设置选择字符长度。
oText.SETPROPERTY,draw_cursor =1, SELECTION_START=1, SELECTION_LENGTH =2
;绘制显示，见图8.23-(h)
oWIndow.DRAW



;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
oWindow.SETPROPERTY,graphics_tree = oView
;创建IDLgrText对象
oText = Obj_New('IDLgrText','IDL uses fonts!',font = myFont)
oModel.ADD,oText
;绘制显示，见图8.24-(a)
oWIndow.DRAW
;创建IDLgrFont对象
oFont = OBJ_NEW('IDLgrFont', 'times', SIZE=20)
;使用oFont对象
oText.SETPROPERTY, font = oFont
;绘制显示，见图8.24-(b)
oWindow.DRAW


;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,200])
; 创建IDLgrView对象
oView= Obj_New('IDLgrView',viewPlane_Rect=[-10,-1,200,2])
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
oWindow.SETPROPERTY,graphics_tree = oView
;创建坐标轴，0为X轴（1为Y轴，2为Z轴），线粗为2，红色
oAxis = OBJ_NEW('IDLgrAxis',0,range =[0,180], $
  location =[0,-0.5],thick =2, color =[255,0,0])
oModel.ADD,oAxis
;绘制显示，见图8.25-(a)
oWindow.DRAW
;10个大刻度线，中间5个小刻度线，tickdir控制刻度线在x轴下
oAxis.SETPROPERTY, major= 10,minor =5, tickdir =1
;绘制显示，见图8.25-(b)
oWindow.DRAW
;文字标注对齐，textAlign分别是[水平方向，竖直方向]
oAxis.SETPROPERTY, textAlign =[0,1]
;绘制显示，见图8.25-(c)
oWindow.DRAW
;文字标注对齐
oAxis.SETPROPERTY, textAlign =[1,1]
;绘制显示，见图8.25-(d)
oWindow.DRAW
;设置X坐标轴标题，黑色
oText = OBJ_NEW('IDlgrText','X Axis',color =[0,0,0])
oAxis.SETPROPERTY, title= oText,tickValues = [0,60,120,150,180]
;绘制显示，见图8.25-(e)
oWindow.DRAW
;设置坐标轴文字基线
oAxis.SETPROPERTY, TextBaseline=[-1,0,0]
;绘制显示，见图8.25-(f)
oWindow.DRAW
;设置坐标轴文字基线
oAxis.SETPROPERTY, TextBaseline=[1,0,0]
;绘制显示，见图8.25-(g)
oWindow.DRAW
;创建坐标轴文本对象
oTickText = OBJ_NEW('IDLgrText',['A','B','C','D','E'], color = [0,0,255])
;设置文本字符，use_text_color控制是否显示文字对象颜色
oAxis.SETPROPERTY, TextBaseline=[1,0,0],$
  tickText = otickText,/USE_TEXT_COLOR
;绘制显示，见图8.25-(h)
oWindow.DRAW


;创建window对象
oWindow= OBJ_NEW('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= OBJ_NEW('IDLgrView')
;创建IDLgrModel对象
oModel = OBJ_NEW('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
oWindow.SETPROPERTY,graphics_tree = oView
;构建jpg文件名
file = FILEPATH('rose.jpg', SUBDIRECTORY = ['examples', 'data'])
;查询图像信息
queryStatus = QUERY_IMAGE(file, imageInfo)
imageSize = imageInfo.DIMENSIONS
;读取图像数据
image = READ_IMAGE(file)
;创建图像对象
oImage = Obj_New('IDLgrImage',image)
oModel.ADD,oImage
;设置显示区域范围
oView.SETPROPERTY,viewPlane_Rect = [0,0,imageSize]
;设置显示窗口大小
oWindow.SETPROPERTY,dimension = imageSize
;绘制显示（图8.26-(a)）
oWindow.DRAW
;销毁图像对象
Obj_Destroy,oImage
;设置显示区域为X方向为图像三倍
oView.SETPROPERTY,viewPlane_Rect = [0,0,imageSize]*[0,0,3,1]
;创建R、G、B波段灰度图像及
oRed = Obj_New('IDLgrImage',image[0,*,*])
oGreen = Obj_New('IDLgrImage',image[1,*,*], $
  Location = [imageSize[0],0])
oBlue = Obj_New('IDLgrImage',image[2,*,*], $
  Location = [imageSize[0]*2,0])
;添加对象
oModel.ADD,[oRed, oGreen, oBlue]
;设置显示窗口大小
oWindow.SETPROPERTY,dimension = imageSize*[3,1]
;绘制显示（图8.26-(b)）
oWindow.DRAW
;设置三个图像的位置
oGreen.SETPROPERTY, Location=imageSize*.5
oBlue.SETPROPERTY, Location=imageSize
;设置窗口大小
oWindow.SETPROPERTY, dimension = imageSize*2
;设置显示区域大小
oView.SETPROPERTY,viewPlane_Rect = [0,0,imageSize]*[0,0,2,2]
;绘制显示（图8.26-(c)）
oWindow.DRAW


;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
; 创建IDLgrView对象,显示区域为[-100,-50,400,300]
; 可根据显示效果体会下该参数的含义
oView= Obj_New('IDLgrView', ViewPlane_Rect = [-100,-50,400,300])
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
;创建单波段图像对象
oImage = Obj_New('IDLgrImage',Bytscl(DIST(200)))
;添加对象到Model中
oModel.ADD,oImage
;绘制显示，见图8.27-(a)
oWindow.DRAW,oView
;创建IDLgrPalette对象，载入索引为2的系统颜色表
oPalette = Obj_New('IDLgrPalette')
oPalette.LOADCT,2
;设置图像颜色表
oImage.SETPROPERTY, palette = oPalette
;绘制显示，见图8.27-(b)
oWindow.DRAW,oView

;创建window对象
oWindow= Obj_New('IDLgrWindow',dimension = [400,300])
;创建IDLgrView对象
oView= Obj_New('IDLgrView')
oView.GETPROPERTY, ViewPlane_Rect = vp
;查看vp的值，即此为IDLgrView对象初始化参数

;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
;创建单波段图像对象
oImage = Obj_New('IDLgrImage',Bytscl(DIST(200)))
;添加对象到Model中
oModel.ADD,oImage
;绘制显示，见图8.28-(a)
oWindow.DRAW,oView
;获取对象的X方向和Y方向的数据范围
oImage.GETPROPERTY, XRange = xr, YRange = yr
;设置对象的归一化转换系数，利用函数Norm_Coord求解！
oImage.SETPROPERTY, XCoord_Conv = NORM_COORD(xr), YCoord_Conv = NORM_COORD(yr)
;绘制显示，见图8.28-(b)
oWindow.DRAW,oView
;设置view的显示范围是[0,0,1,1]
oView.SETPROPERTY, viewPlane_Rect = [0,0,1,1]
;绘制显示，见图8.28-(c)
oWindow.DRAW,oView
polyData = [[0.3,0.3],[0.3,0.7],[0.7,0.7],[0.7,0.3]]
;添加矩形对象，颜色设置为红色
oModel.ADD,Obj_New('IDLgrPolygon',polyData,$
  color = [255,0,0])
;绘制显示，见图8.28-(d)
oWindow.DRAW,oView

;创建400*300的界面
wTlb = Widget_Base(xSize = 400,ysize =300)
;创建wDraw组件，对象图形法的Draw，大小为300*200，并居中显示。
;注意，此时的大小和定位坐标均为实际像素尺寸。（设备坐标系）
wDraw = Widget_Draw(wTlb, $
  Graphics_Level = 2, $
  xSize = 300,ysize = 200,$
  xOffset = 50,yOffset = 50)
;组件绘制，见图8.29-(a)
Widget_Control, wTlb,/Realize
;获得wDraw组件的value，此即IDLgrWindow对象。
Widget_Control, wDraw,Get_Value = oWindow
; 创建IDLgrView对象
oView= Obj_New('IDLgrView')
;创建IDLgrModel对象
oModel = Obj_New('IDLgrModel')
;设置显示体系层次
oView.ADD,oModel
;创建正弦曲线对象
oPlot = Obj_New('IDLgrPLot',Sin(findgen(300)/10))
;添加对象到Model中
oModel.ADD,oPlot
;绘制显示，见图8.29-(b)，注意此时二者坐标系不匹配！
oWindow.DRAW,oView
;设置显示范围为数据坐标系
oView.SETPROPERTY,viewPlane_Rect = [0,-1,300,2]
;绘制显示，见图8.29-(c)
oWindow.DRAW,oView
;设置IDLgrView对象归一化坐标系区域
oView.SETPROPERTY, viewPlane_Rect = [0,0,1,1]
;获取图形数据范围
oPlot.GETPROPERTY, XRange = xr,yRange = yr
;设置对象的归一化转换系数
oPlot.SETPROPERTY, XCoord_Conv = NORM_COORD(xr), $
  YCoord_conv = NORM_COORD(yr)
;绘制显示，见图8.29-(d)
oWindow.DRAW,oView

;创建window对象
oWindow = OBJ_NEW('IDLgrWindow',dimension =[400,400],retain = 2)
;创建view对象，显示区域及Z方向范围，视角高度等参数
oView = OBJ_NEW('IDLgrView',viewPlane_Rect =[-1,-1,3,3],zClip = [4,-4],eye = 5)
oModel = OBJ_NEW('IDLgrModel')
;创建多边形
oPoly = OBJ_NEW('IDLgrPolygon')
;设置对象层次体系结构
oView.ADD,oModel & oModel.ADD,oPoly
;顶点坐标
verts = [[0,0,0],[1,0,0],[1,1,0],[0,1,0], $
  [0,0,1],[1,0,1],[1,1,1],[0,1,1]]
;顶点链接顺序
connect =[4, 0,1,2,3, $
  4,0,1,5,4, $
  4,1,2,6,5, $
  4,2,3,7,6, $
  4,3,0,4,7, $
  4, 4,5,6,7]
;设置多边形顶点与链接关系，类型显示为线
oPoly.SETPROPERTY,data =verts, polygons = connect,style =1
;选择45度
oModel.ROTATE ,[1,1,0],45
;绘制显示（图8.31-(a)）
oWindow.DRAW,oView
;设置立方体顶点颜色
vertscolor = [[0,0,0],[1,0,0],[1,1,0],[0,1,0], $
  [0,0,1],[1,0,1],[1,1,0],[0,1,1]]*255
;设置立方体面显示，并渲染显示颜色
oPoly.SETPROPERTY, vert_color = vertsColor,$
  style=2, shading = 1
;绘制显示（图8.31-(b)）
oWindow.DRAW,oView

;创建圆对象
oCircle = Obj_New('IDLgrCircle',[0,0])
;注意，因参数radius未设置，故对象未创建成功。
print,Obj_Valid(oCircle)

;按照正确参数设置创建圆对象
oCircle = Obj_New('IDLgrCircle',[0,0],1.5)
;调用GetProperty方法获取圆半径
oCircle.GETPROPERTY,Radius = r
;输出查看
print,r

;圆对象类定义
oCircle = Obj_New('IDLgrCircle')
;显示圆对象（图8.34-(a)）
oCircle.SHOW
;设置圆对象参数，红色
oCircle.SETPROPERTY,color = [255,0,0]
;显示圆对象（图8.34-(b)）
oCircle.SHOW
;设置圆对象参数，类型为线
oCircle.SETPROPERTY,style = 1
;显示圆对象（图8.34-(c)）
oCircle.SHOW
;设置圆对象参数
oCircle.SETPROPERTY,thick = 5
;显示圆对象（图8.34-(d)）
oCircle.SHOW
;获取圆对象颜色参数
oCircle.GETPROPERTY,color = circleColor
;输出颜色
print,circleColor
;销毁圆对象
Obj_Destroy,oCircle
END