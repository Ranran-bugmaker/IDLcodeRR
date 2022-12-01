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
  ;读取数据
 world = READ_PNG(FILEPATH('avhrr.png', $
  SUBDIRECTORY = ['examples', 'data']), R,G,B)
 ;设置显示模式
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 ;默认的颜色表
 TVLCT, R, G, B
 ;获得图像的大小
 worldSize = SIZE(world, /DIMENSIONS)
 ;建立同等大小的窗口
 WINDOW, 0, XSIZE = worldSize[0], YSIZE = worldSize[1]
 ;显示图像，见图12.1.
 TV, world
 ;裁剪非洲区域
 africa = world [312:475, 103:264]
 ;建立裁剪区域同大小的窗口
 WINDOW, 2, XSIZE =(475-312 + 1), YSIZE =(264-103 + 1)
 ;显示裁剪后图像，见图12.1。
 TV, africa
 
  ;读入样例数据.
 earth = READ_PNG (FILEPATH ('avhrr.png', $
  SUBDIRECTORY = ['examples', 'data']), R, G, B)
 ;加载图像的颜色表，并用白色填充颜色表最后一个。
 TVLCT, R, G, B
 maxColor = !D.TABLE_SIZE - 1
 TVLCT, 255, 255, 255, maxColor
 ;设置显示设备参数
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 ;获取图像的原始大小
 earthSize = SIZE(earth, /DIMENSIONS)
 ;创建显示窗口
 WINDOW, 0, XSIZE = earthSize[0] + 20, $
  YSIZE = earthSize[1] + 40
 ;显示图像，见图12.4）
 TV, earth
 ;返回要输出大小的新数组
 paddedEarth = REPLICATE(BYTE(maxColor), earthSize[0] + 20, $
  earthSize[1] + 40)
 ;将原图像copy到新数组中.
 paddedEarth [10,10] = earth
 ;显示图像（图12.5）
 TV, paddedEarth
 ;显示标题.
 x = (earthSize[0]/2) + 10
 y = earthSize[1] + 15
 XYOUTS, x, y, 'World Map', ALIGNMENT = 0.5, COLOR = 0, $
  /DEVICE
 
  ;读入原始数据
 file = FILEPATH('shifted_endocell.png', $
  SUBDIRECTORY = ['examples','data'])
 image = READ_PNG(file, R, G, B)
 ;载入图像颜色表
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 TVLCT, R, G, B
 ;获取图像尺寸
 imageSize = SIZE(image, /DIMENSIONS)
 ;构建显示窗口
 WINDOW, 0, XSIZE = imageSize[0], YSIZE = imageSize[1], $
  TITLE = 'Original Image'  
 ;显示图像,见图12.7-(a)
 TV, image
 ;平移图像.
 image = SHIFT(image, -imageSize[0]/4, -imageSize[1]/3)
 ;显示平移后结果.
 WINDOW, 1, XSIZE = imageSize[0], YSIZE = imageSize[1], $
  TITLE = 'Shifted Image'
 ;见图12.7-(b)
 TV, image
 
 
  ; 读入数据并获取数据大小.
 image = READ_DICOM (FILEPATH('mr_knee.dcm', $
  SUBDIRECTORY = ['examples', 'data']))
 imgSize = SIZE (image, /DIMENSIONS)
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 LOADCT, 0
 ;水平翻转图像.
 flipHorzImg = REVERSE(image, 1)
 ;竖直翻转图像.
 flipVertImg = REVERSE(image, 2)
 ;创建显示窗口
 WINDOW, 0, XSIZE = 2*imgSize[0], YSIZE = 2*imgSize[1], $
  TITLE = 'Original (Top) & Flipped Images (Bottom)'
 erase,color = !p.color
 ;显示原图像（图12.8）
 TV, image, 0
 ;显示两翻转后图像（图12.8）
 TV, flipHorzImg, 2
 TV, flipVertImg, 3
 
  ;读取文件
 file = FILEPATH('galaxy.dat', SUBDIRECTORY = ['examples', 'data'])
 image = READ_BINARY(file, DATA_DIMS = [256, 256])
 ;设置显示参数.
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 LOADCT, 4
 ;创建显示窗口，显示图像，见图12.9-(a)
 WINDOW, 0, XSIZE = 256, YSIZE = 256
 TVSCL, image
 ;对图像进行270度逆时针旋转.
 rotateImg = ROTATE(image, 3)
 ;创建新显示窗口，显示图像，见图12.9-(b)
 WINDOW, 1, XSIZE = 256, YSIZE = 256
 TVSCL, rotateImg
 
 
 ;读取数据
 file = FILEPATH('m51.dat', SUBDIRECTORY = ['examples', 'data'])
 image = READ_BINARY(file, DATA_DIMS = [340, 440])
 ;设置显示参数..
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 LOADCT, 0
 ;创建显示窗口，显示图像（图12.10-1）
 WINDOW, 0, XSIZE = 340, YSIZE = 440
 TVSCL, image
 ; 33度旋转图像、缩小二分之一且背景值设置为127
 arbitraryImg = ROT(image, 33, .5, /INTERP, MISSING = 127)
 ;创建新显示窗口，显示图像（图12.10-2）
 WINDOW, 1, XSIZE = 340, YSIZE = 440
 TVSCL, arbitraryImg
 
 
  ;构建图像文件路径.
 imageFile = FILEPATH('elev_t.jpg', SUBDIRECTORY = ['examples', 'data'])
 ;读取图像文件.
 READ_JPEG, imageFile, image
 ;构建DEM文件路径.
 demFile = FILEPATH('elevbin.dat', SUBDIRECTORY = ['examples', 'data'])
 ;读取数据.
 dem = READ_BINARY(demFile, DATA_DIMS = [64, 64])
 dem = CONGRID(dem, 128, 128, /INTERP)
 ;初始化显示.
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 ;构建显示窗口（图12.11-(a)）
 WINDOW, 0, TITLE = 'Elevation Data',$
  XSIZE = 400, YSIZE =300
  erase,color = !p.color
 SHADE_SURF, dem
 ;初始化显示对象体系.
 oModel = OBJ_NEW('IDLgrModel')
 oView = OBJ_NEW('IDLgrView')
 oWindow = OBJ_NEW('IDLgrWindow', RETAIN = 2, $
  COLOR_MODEL = 0 , $
  DIMENSION =[400,300])
 oSurface = OBJ_NEW('IDLgrSurface', dem, STYLE = 2)
 oImage = OBJ_NEW('IDLgrImage', image, $
  INTERLEAVE = 0, /INTERPOLATE)
 ; 计算归一化显示比例，并在各个方向平移-0.5，从而使图像居中.
 ; 显示区域默认坐标为[-1,-1], [1, 1].
 oSurface . GetProperty, XRANGE = xr, $
  YRANGE = yr, ZRANGE = zr
 xs = NORM_COORD(xr)
 xs[0] = xs[0] - 0.5
 ys = NORM_COORD(yr)
 ys[0] = ys[0] - 0.5
 zs = NORM_COORD(zr)
 zs[0] = zs[0] - 0.5
 oSurface . SetProperty, XCOORD_CONV = xs, $
  YCOORD_CONV = ys, ZCOORD = zs
 ; 曲面上添加纹理对象.
 oSurface . SetProperty, TEXTURE_MAP = oImage, $
  COLOR = [255, 255, 255]
 ; 构建对象体系，将oModel添加到oView.
 oModel.Add, oSurface
 oView.Add, oModel
 ; 为了得到更好的显示效果，旋转下model.
 oModel.ROTATE, [1, 0, 0], -90
 oModel.ROTATE, [0, 1, 0], 30
 oModel.ROTATE, [1, 0, 0], 30
 ;绘制oView(图12.11-(b))
 oWindow.Draw, oView
 ;利用XOBJVIEW查看对象（图12.11-(c)）
 XOBJVIEW, oModel, /BLOCK, SCALE = 1
 
  ; 构建数据文件路径.
 file = FILEPATH('worldelv.dat', $
  SUBDIRECTORY = ['examples', 'data'])
 ; 读取数据.
 image = READ_BINARY(file, DATA_DIMS = [360, 360])
 ; 初始化颜色表，并设置最后的颜色为白色.
 DEVICE, DECOMPOSED = 0
 LOADCT, 33
 TVLCT, 255, 255, 255, !D.TABLE_SIZE - 1
 ; 创建显示窗口显示原图（图12.12-(a)）
 WINDOW, 0, XSIZE = 360, YSIZE = 360
 TVSCL, image
 ; 调用Mesh_obj函数创建一个半径为0.25的球体.
 MESH_OBJ, 4, vertices, polygons, REPLICATE(0.25, 360, 360), $
  /CLOSED
 ; 创建显示窗体，设置显示范围与方式（图12.12-(b)）.
 WINDOW, 2, XSIZE = 512, YSIZE = 512
 ; 设置3D显示的系统参数
 SCALE3, XRANGE = [-0.25,0.25], YRANGE = [-0.25,0.25], $
  ZRANGE = [-0.25,0.25], AX = 0, AZ = -90
 ; 设置场景灯光渲染位置.
 SET_SHADING, LIGHT = [-0.5, 0.5, 2.0]
 !P.BACKGROUND = !P.COLOR
 ; 三维方式绘制已经映射纹理的地球.
 TVSCL, POLYSHADE(vertices, polygons, SHADES = image, /T3D)
 ;恢复系统变量为默认值
 !P.BACKGROUND = 0
 
 
  ; 构建数据文件路径.
 file = FILEPATH('worldelv.dat', $
  SUBDIRECTORY = ['examples', 'data'])
 ; 读取数据.
 image = READ_BINARY(file, DATA_DIMS = [360, 360])
 ; 调用Mesh_obj函数创建一个半径为0.25的球体.
 MESH_OBJ, 4, vertices, polygons, $
  REPLICATE(0.25, 101, 101)
 ; 创建一个model对象来囊括显示对象.
 oModel = OBJ_NEW('IDLgrModel')
 ; 包含image对象和颜色表对象来显示图像和颜色表.
 oPalette = OBJ_NEW('IDLgrPalette')
 oPalette.LOADCT, 33
 oPalette.SetRGB, 255,255,255,255
 oImage = OBJ_NEW('IDLgrImage', image, $
  PALETTE = oPalette)
 ; 计算纹理映射坐标.
 vector = FINDGEN(101)/100.
 texure_coordinates = FLTARR(2, 101, 101)
 texure_coordinates[0, *, *] = vector # REPLICATE(1., 101)
 texure_coordinates[1, *, *] = REPLICATE(1., 101) # vector
 ; 创建polygon对象.
 oPolygons = OBJ_NEW('IDLgrPolygon', SHADING = 1, $
  DATA = vertices, POLYGONS = polygons, $
  COLOR = [255,255,255], $
  TEXTURE_COORD = texure_coordinates, $
  TEXTURE_MAP = oImage, /TEXTURE_INTERP)
 ; 添加polygon对象到model中. 注意：
 ; object已经包含了纹理图像对象和坐标映射关系.
 oModel.ADD, oPolygons
 ; 旋转oModel到一个合适的角度.
 oModel.ROTATE, [1, 0, 0], -90
 oModel.ROTATE, [0, 1, 0], -90
 ; 显示oModel（图12.13）
 XOBJVIEW, oModel, /BLOCK
 
 
 
  ;构建数据文件路径.
 file = FILEPATH('worldelv.dat', $
  SUBDIRECTORY = ['examples', 'data'])
 ;初始化定义文件大小.
 imageSize = [360, 360]
 ;二进制方式读取文件
 image = READ_BINARY(file, DATA_DIMS = imageSize)
 ;初始化显示.
 DEVICE, DECOMPOSED = 0
 LOADCT, 38
 ;创建显示窗口并绘制Dem图像（图12.14）
 WINDOW, 0, XSIZE = imageSize[0], YSIZE = imageSize[1], $
  TITLE = 'World Elevation'
 TV, image
 ;计算生成海洋掩膜数据.
 oceanMask = image LT 125
 ;掩膜数据应用在Dem图像上.
 maskedImage = image*oceanMask
 ;创建显示窗口并显示掩膜文件和Dem掩膜结果（图12.15）
 WINDOW, 1, XSIZE = 2*imageSize[0], YSIZE = imageSize[1], $
  TITLE = 'Oceans Mask (left) and Resulting Image (right)'
 TVSCL, oceanMask, 0
 TV, maskedImage, 1
 ;计算陆地的掩膜数据.
 landMask = image GE 125
 ;掩膜数据应用在Dem图像上.
 maskedImage = image*landMask
 ;创建显示窗口并显示掩膜文件和Dem掩膜结果（图12.16）
 WINDOW, 2, XSIZE = 2*imageSize[0], YSIZE = imageSize[1], $
  TITLE = 'Land Mask (left) and Resulting Image (right)'
 TVSCL, landMask, 0
 TV, maskedImage, 1
 
 
  ;打开并读取文件.
 mapFile = FILEPATH('afrpolitsm.png', $
   SUBDIRECTORY = ['examples', 'data'])
 mapImg = READ_PNG(mapFile, mapR, mapG, mapB)
 ;创建颜色表对象.
 mapPalette = OBJ_NEW('IDLgrPalette', mapR, mapG, mapB)
 ;打开陆地分类文件并读取.
 landFile = FILEPATH('africavlc.png', $
   SUBDIRECTORY = ['examples', 'data'])
 landImg = READ_PNG (landFile, landR, landG, landB)
 landImgDims = SIZE(landImg, /Dimensions)
 ;创建4通道具备透明度的显示数据.
 alphaLand = BYTARR(4, landImgDims[0], landImgDims[1])
 ;赋前面三个通道分别为原数据RGB数据
 alphaLand[0, *, *] = landR[landImg]
 alphaLand[1, *, *] = landG[landImg]
 alphaLand[2, *, *] = landB[landImg]
 ;计算生成掩膜文件并赋值给显示数据
 mask = (landImg GT 0)
 alphaLand [3, *, *] = mask*255B
 ;生成显示数据对象.
 oAlphaLand = OBJ_NEW('IDLgrImage', alphaLand, $
   DIMENSIONS=[600, 600], BLEND_FUNCTION=[3,4], $
   ALPHA_CHANNEL=0.35)
 ;创建地图数据.
 oMapImg = OBJ_NEW('IDLgrImage', mapImg, $
   DIMENSIONS=[600, 600], PALETTE=mapPalette)
 ;创建显示对象体系结构.
 oWindow = OBJ_NEW('IDLgrWindow', $
   DIMENSIONS=[600, 600], RETAIN=2, $
   TITLE='Overlay of Land Cover Transparency')
 viewRect = [0, 0, 600, 600]
 oView = OBJ_NEW('IDLgrView', VIEWPLANE_RECT=viewRect)
 oModel = OBJ_NEW('IDLgrModel')
 oModel.Add, oMapImg
 oView.Add, oModel
 ;绘制显示（图12.17-(a)）
 oWindow.Draw, oView
 ;添加显示对象
 oModel.Add, oAlphaLand
 ;绘制显示（图12.17-(b)）
 oWindow.Draw, oView
 ;销毁对象.
 OBJ_DESTROY, [oView, oMapImg, oAlphaLand, mapPalette]
 
 
 
  ;打开并读取数据文件.
 roseFile = FILEPATH('rose.jpg', $
   SUBDIRECTORY = ['examples', 'data'])
 READ_JPEG,roseFile,roseImg
 ;获取文件信息
 dims = size(roseImg,/Dimension)
 ;创建显示窗口并显示原始图像，见图12.18-(a)
 Window,0,xsize = dims[1],ysize = dims[2],title='原始图像'
 tv,roseImg,/true
 ;设置控制点对
 Xo = [0.25,0.75,0.75,0.25]
 Yo = [0.75,0.75,0.25,0.25]
 Xi = Xo+[1,-1,-1,1]*1.0/8
 Yi = Yo+[-1,-1,1,1]*1.0/8
 ;通过控制点计算多形式校正转换矩阵
 POLYWARP, Xo*dims[1], Yo*dims[2], Xi*dims[1], Yi*dims[2], 1, KX, KY 
 ;校正第一个波段数据 
 tempImg = POLY_2D(Reform(roseImg[0,*,*]), KX, KY)
 ;根据校正波段文件信息定义三波段校正结果文件
 warpDims = Size(tempImg,/Dimension)
 warpType = Size(tempImg,/Type)
 WarpImg = Make_Array(3,warpDims[0],warpDims[1],type = warpType)
 ;三波段依次校正
 warpImg[0,*,*] = tempImg
 warpImg[1,*,*] = POLY_2D(Reform(roseImg[1,*,*]), KX, KY)
 warpImg[2,*,*] = POLY_2D(Reform(roseImg[2,*,*]), KX, KY)
 ;创建显示窗口并显示校正后图像，见图12.18-(b)
 Window,1,xsize =warpDims[0],ysize = warpDims[1],title='校正后图像'
 tv,warpImg,/True
 
 
  ;显示体系.
 DEVICE, DECOMPOSED = 0, RETAIN = 2
 LOADCT, 0
 ;读取数据文件.
 kneeImg = READ_DICOM(FILEPATH('mr_knee.dcm',$
  SUBDIRECTORY = ['examples','data']))
 ;获取文件的大小信息
 dims = SIZE(kneeImg, /DIMENSIONS)
 ;旋转并拉伸文件
 kneeImg = ROTATE(BYTSCL(kneeImg), 2)
 ;调用XROI功能，鼠标选择多边形股骨为感兴趣区，存在变量femurROIout中.
 ;感兴趣的大小和统计信息分别存在变量femurGeom和femurStats中。
 ;见图12.19-(a)
 XROI, kneeImg, REGIONS_OUT = femurROIout, $
  ROI_GEOMETRY = femurGeom, STATISTICS = femurStats, /BLOCK
 ;调用XROI功能，鼠标选择多边形胫骨为感兴趣区，存在变量tibiaROIout中.
 ;见图12.19-(b)
 XROI, kneeImg, REGIONS_OUT = tibiaROIout, $
  ROI_GEOMETRY = tibiaGeom, STATISTICS = tibiaStats, /BLOCK
 ;创建窗口显示原图，见图12.19-(c)
 WINDOW, 0, XSIZE = dims[0], YSIZE = dims[1]
 TVSCL, kneeImg
 ;载入颜色表并绘制选择的ROI区域.
 LOADCT, 12
 DRAW_ROI, femurROIout, /LINE_FILL, COLOR = 80, SPACING = 0.1, $
  ORIENTATION = 315, /DEVICE
 DRAW_ROI, tibiaROIout, /LINE_FILL, COLOR = 42, SPACING = 0.1, $
  ORIENTATION = 30, /DEVICE
 ;输出查看感兴趣区的信息.
 PRINT, '股骨区域几何和统计信息'
 PRINT, '    面积 =', femurGeom.area, $
  '    周长 = ', femurGeom.perimeter, $
  '    像素数 =',  femurStats.count
 PRINT, ' '
 PRINT, '胫骨区域几何和统计信息'
 PRINT, '    面积 =', tibiaGeom.area, $
  '    周长 = ', tibiaGeom.perimeter, $
  '    像素数 =', tibiaStats.count
 ;销毁对象.
 OBJ_DESTROY, [femurROIout, tibiaROIout]
 
 
 
 end