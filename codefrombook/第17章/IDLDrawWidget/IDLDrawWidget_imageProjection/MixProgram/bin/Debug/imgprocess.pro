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
;销毁析构
PRO ImgSHow::CLEANUP
  IF OBJ_VALID(self.OIMAGE) THEN OBJ_DESTROY, self.OIMAGE
END
;修改组件大小是
PRO ImgSHow::ChangeDrawSize,width,height
  IF N_ELEMENTS(width) THEN BEGIN
    self.OWINDOW.GETPROPERTY, graphics_tree = oView
    oView.GETPROPERTY,ViewPlane_Rect = viewP,dimensions = dims
    oriWL = viewP[2:3]
    viewP[2:3] =viewP[2:3]*[width,height]/dims
    viewP[0:1]+=(oriWL-viewP[2:3])/2
    oView.SETPROPERTY,dimension = [width,height],viewPlane_Rect= viewP
    self.OWINDOW.DRAW
  ENDIF
END

;图像处理
PRO ImgSHow::process,type = type
  CASE type OF
    ;均值平滑
    'Smooth':BEGIN
    data = *(self.ORIDATA)
    FOR i=0,2 DO data[i,*,*] = SMOOTH(REFORM(data[i,*,*]), 5, /EDGE_TRUNCATE)
    self.OIMAGE.SETPROPERTY, data = data
  END
  'CANNY': BEGIN
    data = *(self.ORIDATA)
    FOR i=0,2 DO data[i,*,*] = 255*CANNY(REFORM(data[i,*,*]),HIGH = .8, LOW = .8, SIGMA = .6)
    self.OIMAGE.SETPROPERTY, data = data
  END
  ELSE:
ENDCASE
self.OWINDOW.DRAW
END
;参数设置
PRO ImgSHow::GetProperty, initFlag = initFlag
  initFlag= self.INITFLAG
END

;参数设置
PRO ImgSHow::SetProperty, mouseType = mouseType
  self.MOUSETYPE= mouseType
END

;鼠标滚轮时的事件
PRO ImgSHow::WheelEvents,wType,xPos,yPos
  COMPILE_OPT idl2
    
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect  
  IF wType GT 0 THEN rate = 0.8 ELSE rate = 1.125
  
  oriDis =[xPos,yPos]*viewRect[2:3]/winDims
  viewRect[0:1]+=(1-rate)*oriDis
  viewRect[2:3]= viewRect[2:3]*rate
  ;
  oView.SETPROPERTY, viewPlane_Rect = viewRect
  self.OWINDOW.DRAW
END
;鼠标点击时的事件
PRO ImgSHow::MousePress,xpos,ypos  
  self.MOUSELOC[0:1] = [xPos,yPos]
END
;鼠标弹起时的操作
PRO ImgSHow::MouseRelease,xpos,ypos
  
  curLoc = [xPos,yPos]
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect  
  self.OWINDOW.DRAW
END

PRO ImgSHow::MouseMotion,xpos,ypos
  ;
  curLoc = [xPos,yPos]
  ;
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect
  
  ;屏幕偏移量
  offset = curLoc- self.MOUSELOC
  ;对应偏移量
  viewRect[0:1]-=offset*viewRect[2:3]/WinDims
  oView.SETPROPERTY, viewPlane_Rect = viewRect
  self.OWINDOW.DRAW
  ;
  self.MOUSELOC = curLoc
  
END
;初始化图像显示，注意XY方向同比例变换
PRO ImgSHow::originalShow
  ;
  self.OWINDOW.GETPROPERTY, dimensions = windowDims,graphics_tree = oView
  imageDims = self.IMAGEDIMS
  ;
  imgRate = FLOAT(imageDims[0])/imageDims[1]
  viewRate = FLOAT(windowDims[0])/windowDims[1]
  ;
  IF imgRate GT viewRate THEN BEGIN
    viewWidth = imageDims[0]
    viewHeight = imageDims[0]/viewRate
    viewPlant_rect = [0, -(viewHeight-imageDims[1])/2,viewWidth,viewHeight]    
  ENDIF ELSE BEGIN
    viewHeight = imageDims[1]
    viewwidth = imageDims[1]*ViewRate
    viewPlant_rect = [-(viewwidth-imageDims[0])/2,0,viewWidth,viewHeight]    
  ENDELSE
  oView.SETPROPERTY, viewPlane_Rect = viewPlant_rect,dimensions = WindowDims
  self.OWINDOW.DRAW
END
;构建显示图像体系
PRO ImgSHow::CreateDrawImage
  oView = OBJ_NEW('IDLgrView',color = [255,255,255])
  self.OWINDOW.SETPROPERTY, graphics_tree = oView
  
  queryStatus = QUERY_IMAGE(self.INFILE, imageInfo)
  IF queryStatus EQ 0 THEN BEGIN
    self.INITFLAG= 0
    RETURN
  ENDIF  
  self.IMAGEDIMS = imageInfo.DIMENSIONS
  data = READ_IMAGE(self.INFILE)
  self.ORIDATA = PTR_NEW(data,/no_Copy)
  ;
  IF imageInfo.CHANNELS EQ 1 THEN BEGIN
    self.RGBTYPE =0
    self.OIMAGE = OBJ_NEW('IDLgrImage',*(self.ORIDATA) )
  ENDIF ELSE BEGIN
    self.RGBTYPE =1
    self.OIMAGE = OBJ_NEW('IDLgrImage',*(self.ORIDATA) ,INTERLEAVE =0)
  ENDELSE
  ;辅助红色矩形，初始化为隐藏
  self.ORECT = OBJ_NEW('IDLgrPolygon', $
    style =1,$
    thick=1,$
    color = [230,0,0],/hide)    
  oModel = OBJ_NEW('IDLgrModel')  
  oModel.ADD, [self.OIMAGE,self.ORECT]
  oView.ADD,oModel
  self.ORIGINALSHOW
  self.INITFLAG= 1
END
;类初始化函数
FUNCTION ImgSHow::INIT,drawID
  ;
  routinefile = ROUTINE_FILEPATH('IMGSHOW__DEFINE')  
  ;READ_JPEG,
  self.INFILE = FILE_DIRNAME(routinefile)+'\can_tmr.jpg'
  ;传入的drawID
  WIDGET_CONTROL, drawID, get_Value = oWindow
  self.OWINDOW = oWindow
  ;调用CreateImage方法创建显示图像
  self.CREATEDRAWIMAGE
  self.OWINDOW.DRAW
  RETURN, self.INITFLAG
END
;对象类定义
PRO IMGSHOW__DEFINE
  struct = {ImgSHow, $
    initFlag  : 0b, $
    mouseType : 0B, $;鼠标状态，0-默认,1-平移,2-放大,3-缩小。
    mouseLoc : FLTARR(2), $
    infile: '' , $
    rgbType : 0, $
    imageDims : LONARR(2), $
    oriData  : PTR_NEW(), $
    oWindow : OBJ_NEW(), $
    oImage  : OBJ_NEW(), $
    oRect   : OBJ_NEW(), $
    DrawID: 0L $
    }
END
PRO ImgProcess_event,ev
  Widget_Control,ev.top,Get_UValue = pState
  case Widget_info(ev.id,/uName) of
  'smooth':(*pState).oFile.process,type ='Smooth'
  'edge':(*pState).oFile.process,type ='CANNY'
  else:
  endcase
end
PRO ImgProcess
  ;
  wTlb = WIDGET_BASE(mbar = mbar)
  wFile = Widget_Button(mBar,value= '文件',/menu)
  wProcess = Widget_Button(mBar,value= '图像处理',/menu)
  wSmooth = Widget_Button(wProcess,value= '平滑',uname ='smooth')
  wSmooth = Widget_Button(wProcess,value= '边缘检测',uname ='edge')
  wDraw = WIDGET_DRAW(wtlb,$
    xSize = 800,$
    ySize = 600, $
    retain=0,$
    graphics_level = 2)
  WIDGET_CONTROL, wTlb,/real  
  oFile = OBJ_NEW('ImgSHow', $
    wDraw)
    Widget_Control,wTlb,Set_UValue = Ptr_New({oFile:oFile},/no_copy)
  xManager,  'ImgProcess',wTlb,/no_block    
END





