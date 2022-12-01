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
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;事件处理
;
PRO AdTool::HandleEvent, event

  COMPILE_OPT IDL2
  
  oSystem = self.OSYSTEM
  oManager = oSystem.OMANAGER
  
  uName = WIDGET_INFO(event.ID, /UName)
  
  CASE uName OF
    'AdTool::suitSCR' : BEGIN
      oManager->CONFIGVIEWRANGE
      oManager->REFRESHDRAW
      (oManager.ODRAW).OWINDOW->DRAW
    END
    'AdTool::suitImg' : BEGIN
      oManager->CONFIGVIEWRANGE,/Image
      oManager->REFRESHDRAW
      (oManager.ODRAW).OWINDOW->DRAW
    END
    ;导入图像并显示
    'AdTool::image' : BEGIN
      filters = [['*.jpg;*.jpeg', '*.tif;*.tiff', '*.png', '*.*'], $
      ['JPEG', 'TIFF', 'Bitmap', 'All files']]
      
      file = DIALOG_PICKFILE(filter =filters,$
        path =oSystem.ROOTDIR )
      IF file EQ '' THEN RETURN;
      item = oManager->GET(/All   , $
        ISA = 'ADIMAGELAYER')
      item->SHOWIMAGE, fileName = file
      oManager.MOUSESTATUS = 'hand'
    END
    'AdTool::point' : BEGIN
      oManager.MOUSESTATUS = 'annotate'
      oManager.ANNOTATESTATUS[0] = 'point'
    END
    
    'AdTool::save' : BEGIN
      currProject.OVIEW->GETPROPERTY, dimensions=oriDims,location=oriLoc
      temp = Image_Save(currProject.OVIEW);传递oview
      currProject.OVIEW->SETPROPERTY, dimensions=oriDims, location=oriLoc
    END
    
    ELSE:
  ENDCASE
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;创建工具栏
;
PRO AdTool::Create

  COMPILE_OPT IDL2
  
  self.TBASE = WIDGET_BASE(self.PARENT    , $
    /Row                    , $
    /Base_Align_Center      , $
    Space = 0               , $
    XPad  = 0               , $
    YPad  = 0                )
    
  WIDGET_CONTROL, /Realize, self.TBASE
  
  bitmaps = (self.OSYSTEM).ROOTDIR+'\'+   $
    ['image.bmp','suitScr.bmp','suitImg.bmp','measure.bmp']
    
  uNames = 'AdTool::'+['image','suitSCR','suitImg','point']
  toolTips = ['导入图像','适合屏幕','适合图像','标点']
  
  FOR i=0, N_ELEMENTS(bitmaps)-1 DO BEGIN
    self.WBUTTONS[i] = WIDGET_BUTTON( $
      self.TBASE                  , $
      Value = bitmaps[i]          , $
      /Bitmap                     , $
      ToolTip = toolTips[i]       , $
      UName = uNames[i]             )
  ENDFOR
  
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;析构
;
PRO AdTool::CLEANUP

  COMPILE_OPT IDL2
  
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;初始化
;
FUNCTION AdTool::INIT, OSystem = oSystem, parent = parent

  COMPILE_OPT IDL2
  
  self.OSYSTEM = oSystem
  
  self.PARENT = parent;oSystem.tlb
  
  DEVICE, Get_Screen_Size = screenSize
  self.GEOM = [screenSize[0], 36]
  
  self.ROOTDIR = oSystem.ROOTDIR
  
  self->CREATE
  
  geom = WIDGET_INFO(self.TBASE, /Geometry)
  self.GEOM = [geom.SCR_XSIZE, geom.SCR_YSIZE]
  
  RETURN, 1
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;定义
;
PRO ADTOOL__DEFINE

  COMPILE_OPT IDL2
  
  void = {AdTool                       , $
    ;继承的父类
  
    ;系统参数
    parent          :  0              , $
    tBase          :   0           , $
    geom          :    [0, 0]          , $
    rootDir          : ''            , $
    wButtons            :   LONARR(10)          , $
    
    ;系统对象
    oSystem          : OBJ_NEW()       $
    }
    
END