;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
;
;传递'IDLgrView'存储为图像，存储范围和大小可以自行设定。
;-----------------------------------------------------------------
;
;Image_Save响应事件
;
;
PRO IMAGE_SAVE_EVENT,ev
  COMPILE_OPT idl2
  
  WIDGET_CONTROL,ev.ID,get_uvalue = uval
  WIDGET_CONTROL,ev.TOP,get_uvalue = pState
  
  CASE uval OF
    ;设置保存路径;
    'ReName' : BEGIN
    
      WIDGET_CONTROL,(*pState).FILENAMETEXT,get_Value = oriFile
      
      File_Path = DIALOG_PICKFILE(/Directory)
      
      IF File_Path EQ '' THEN file = oriFile  ELSE  $
        file = File_Path + FILE_BASENAME(OriFile)
        
      CASE (*pState).FILETYPE OF
        0: DefaultEx = 'jpg'
        1: DefaultEx = 'bmp'
        2: DefaultEx = 'tif'
        3: DefaultEx = 'png'
      ENDCASE
      
      STRPUT,file ,DefaultEx,STRLEN(file)-3;替换扩展名
      WIDGET_CONTROL,(*pState).FILENAMETEXT,set_Value = STRING(file)
      
    END
    ;设置保存类型;
    'TypeList':BEGIN
    
    (*pState).FILETYPE = Ev.INDEX
    WIDGET_CONTROL,(*pState).FILENAMETEXT,Get_Value = file
    
    CASE Ev.INDEX OF
      0: DefaultEx = 'jpg'
      1: DefaultEx = 'bmp'
      2: DefaultEx = 'tif'
      3: DefaultEx = 'png'
    ENDCASE
    STRPUT,file ,DefaultEx,STRLEN(file)-3;替换扩展名
    WIDGET_CONTROL,(*pState).FILENAMETEXT,set_Value = STRING(file)
    
  END
  
  'DoSave':    BEGIN
  
    WIDGET_CONTROL,(*pState).FILENAMETEXT,get_Value = FileNameText
    
    ;获取保存文件路径并检测
    str = STRSPLIT( FileNameText , '\')
    N = N_ELEMENTS(STRSPLIT( FileNameText , '\'))
    TestPath = STRMID(FileNameText,0,Str[n-1])
    
    IF FILE_TEST(TestPath,/Directory) EQ 0 THEN BEGIN
      void = DIALOG_MESSAGE('文件路径错误！',Title = '警告！',/Error)
      RETURN
    ENDIF
    
    process = IDLITWDPROGRESSBAR( $
      GROUP_LEADER=(*pState).SAVETLB, $
      TIME=0,$
      TITLE='保存中... 请稍等')
      
    IDLITWDPROGRESSBAR_SETVALUE, process, 0
    
    ;需要存储的图像大小
    WIDGET_CONTROL,(*pState).WIDTH,Get_Value = XSize
    WIDGET_CONTROL,(*pState).HEIGHT,Get_Value = YSize
    
    XSize = FIX(XSize)
    YSize = FIX(YSize)
    
    IF(XSize LE 0 OR YSize LE 0 )THEN BEGIN
    
      Void = DIALOG_MESSAGE('输出大小出错！',/ERROR )
      WIDGET_CONTROL,process,/Destroy
      RETURN
      
    ENDIF
    
    ;鼠标选取范围的大小
    SelectX =  ABS((*pState).STARTPOS[0]-(*pState).ENDPOS[0])
    SelectY =  ABS((*pState).STARTPOS[1]-(*pState).ENDPOS[1])
    
    ;需要存储图的原始视图大小及起始xy大小
    ViewSize =[((*pState).NEWDIMS[0])*(FLOAT(XSize)/SelectX),$
      ((*pState).NEWDIMS[1])*(FLOAT(YSize)/SelectY)]
      
    StartX = (((*pState).STARTPOS[0] < (*pState).ENDPOS[0])-$
      (*pState).NEWLOC[0] )*FIX(FLOAT(XSize)/SelectX)
      
    StartY = (((*pState).STARTPOS[1] < (*pState).ENDPOS[1])-$
      (*pState).NEWLOC[1] )*FIX(FLOAT(YSize)/SelectY)
      
    ;;开始拼图实现
    BufferSize = [1024,1042]
    FullImg = BYTARR(3,XSize,YSize)
    
    obuffer = OBJ_NEW('idlgrbuffer')
    obuffer->SETPROPERTY,Graphics_tree = (*pState).CURRVIEW
    ;                ;计算循环次数
    DoneNum = 0
    IF(YSize/BufferSize[1] EQ 0 )AND(XSize/BufferSize[0] EQ 0) THEN TotalNum  = 1 $
    ELSE IF(YSize/BufferSize[1] EQ 0 ) THEN TotalNum = FIX(XSize/BufferSize[0])+1      $
  ELSE IF(XSize/BufferSize[0] EQ 0 ) THEN TotalNum = FIX(YSize/BufferSize[1])+1      $
ELSE  TotalNum = (FIX(YSize/BufferSize[1])+1)*(FIX(XSize/BufferSize[0])+1)

xn = 0
yn = 0

UpRate = 100/TotalNum

WHILE(yn LT FIX(YSize/BufferSize[1])) DO BEGIN

  WHILE(xn LT FIX(XSize/BufferSize[0])) DO BEGIN
  
    location = [StartX+BufferSize[0]*xn,StartY+BufferSize[1]*yn]
    (*pState).CURRVIEW->SETPROPERTY,location = -location,$
      Dimension = ViewSize
      
    obuffer->SETPROPERTY,dimensions=BufferSize
    obuffer->DRAW
    Temp = obuffer->READ()
    Temp->GETPROPERTY,data = img
    
    FullImg[*,BufferSize[0]*xn:(BufferSize[0]*(xn+1)-1), $
      BufferSize[1]*yn:(BufferSize[1]*(yn+1)-1)] = img
    DoneNum = DoneNum+1
    
    IDLITWDPROGRESSBAR_SETVALUE, process, UpRate*DoneNum
    xn++
    
  ENDWHILE
  ;-------
  IF(XSize GT BufferSize[0]*xn)THEN BEGIN
  
    (*pState).CURRVIEW->SETPROPERTY,location = $
      -[StartX+BufferSize[0]*xn,StartY+BufferSize[1]*yn],$
      Dimension = ViewSize;
    obuffer->SETPROPERTY,dimensions=[XSize-BufferSize[0]*xn,BufferSize[1]]
    obuffer->DRAW
    Temp = obuffer->READ()
    Temp->GETPROPERTY,data = img
    
    FullImg[*,BufferSize[0]*xn:(XSize-1),BufferSize[1]*yn:(BufferSize[1]*(yn+1)-1)] = img
  ENDIF
  ;-------
  
  xn = 0
  yn++
ENDWHILE

;------- 最上面一行不完整的部分
IF(YSize GT BufferSize[1]*yn)THEN BEGIN
  xn = 0
  WHILE(xn LT FIX(XSize /BufferSize[0])) DO BEGIN
    (*pState).CURRVIEW->SETPROPERTY,location = $
      -[StartX+BufferSize[0]*xn,StartY+BufferSize[1]*yn],$
      Dimension = ViewSize
    obuffer->SETPROPERTY,dimensions=[BufferSize[0],YSize-BufferSize[1]*yn]
    obuffer->DRAW
    Temp = obuffer->READ()
    Temp->GETPROPERTY,data = img
    ;                           Obj_Destroy, obuffer
    FullImg[*,BufferSize[0]*xn:(BufferSize[0]*(xn+1)-1),BufferSize[1]*yn:(YSize-1)] = img
    
    xn++
    DoneNum =DoneNum + xn
    IDLITWDPROGRESSBAR_SETVALUE, process, UpRate*DoneNum
    
  ENDWHILE
ENDIF
;------- 最右上的一角

IF((YSize GT BufferSize[1]*yn)AND(XSize GT BufferSize[0]*xn) )THEN BEGIN

  (*pState).CURRVIEW->SETPROPERTY,location = $
    -[StartX+BufferSize[0]*xn,StartY+BufferSize[1]*yn],$
    Dimension = ViewSize
  obuffer->SETPROPERTY,dimensions=[XSize-BufferSize[0]*xn,YSize-BufferSize[1]*yn]
  obuffer->DRAW
  Temp = obuffer->READ()
  Temp->GETPROPERTY,data = img;
  FullImg[*,BufferSize[0]*xn:(XSize-1),BufferSize[1]*yn:(YSize-1)] = img
  DoneNum++
  IDLITWDPROGRESSBAR_SETVALUE, process, UpRate*DoneNum
  
ENDIF
;-------
CASE (*pState).FILETYPE OF
  0: WRITE_JPEG, FileNameText, FullImg,True = 1, QUALITY=100
  1: WRITE_IMAGE,FileNameText,'bmp',FullImg
  2: WRITE_TIFF,FileNameText,REVERSE(FullImg,3),compression = 1
  3: WRITE_PNG,FileNameText,FullImg
ENDCASE

IDLITWDPROGRESSBAR_SETVALUE, process, 100
WAIT,0.3
WIDGET_CONTROL,process,/Destroy
OBJ_DESTROY,obuffer
PTR_FREE, pState
WIDGET_CONTROL, ev.TOP,/DESTROY

END

'DoCancel': BEGIN
  WIDGET_CONTROL, ev.TOP,/DESTROY
  PTR_FREE, pState
  
END

'draw':  CASE ev.TYPE OF
;点击-记录起点
0: BEGIN                               ;
  (*pState).STARTPOS[0] = ev.X  > (*pState).NEWLOC[0]
  (*pState).STARTPOS[0] = (*pState).STARTPOS[0] < $
    ((*pState).NEWLOC[0]+ $
    (*pState).NEWDIMS[0] )
    
  (*pState).STARTPOS[1] = ev.Y > (*pState).NEWLOC[1]
  (*pState).STARTPOS[1] = (*pState).STARTPOS[1] < $
    ((*pState).NEWLOC[1]+ $
    (*pState).NEWDIMS[1]  )
    
  WIDGET_CONTROL, ev.ID, Draw_Motion_Events=1
  
END

1: BEGIN   ;鼠标释放时记录终点

  IF ev.X  LE (*pState).NEWLOC[0] THEN ev.X = (*pState).NEWLOC[0]
  
  (*pState).ENDPOS[0] = ev.X < ((*pState).NEWLOC[0]+ $
    (*pState).NEWDIMS[0] )
    
  (*pState).ENDPOS[1] = ev.Y > (*pState).NEWLOC[1]
  (*pState).ENDPOS[1] = (*pState).ENDPOS[1] < $
    ((*pState).NEWLOC[1]+ $
    (*pState).NEWDIMS[1] )
    
  data = [[(*pState).STARTPOS[0],(*pState).STARTPOS[1]], $
    [(*pState).STARTPOS[0],(*pState).ENDPOS[1]], $
    [(*pState).ENDPOS[0],(*pState).ENDPOS[1]], $
    [(*pState).ENDPOS[0],(*pState).STARTPOS[1]]    ]
    
  (*pState).ORECTANGLE->SETPROPERTY,Data = data
  (*pState).OFILL->SETPROPERTY,Data = data
  (*pState).SHOWWINDOW->DRAW,(*pState).OVIEW
  IF ((*pState).ENDPOS[1]-(*pState).STARTPOS[1]) NE 0 THEN $
    (*pState).VIEWSCALE = ABS(FLOAT(((*pState).ENDPOS[0]-(*pState).STARTPOS[0])/ $
    ((*pState).ENDPOS[1]-(*pState).STARTPOS[1])))
  ;--修改输入图像大小
  WIDGET_CONTROL,(*pState).WIDTH,Get_Value = x
  WIDGET_CONTROL,(*pState).HEIGHT,Set_Value = FIX(x/(*pState).VIEWSCALE)
  WIDGET_CONTROL, ev.ID, Draw_Motion_Events=0
END

2: BEGIN

  (*pState).ENDPOS[0] = ev.X > (*pState).NEWLOC[0]
  (*pState).ENDPOS[0] = (*pState).ENDPOS[0] <((*pState).NEWLOC[0]+ $
    (*pState).NEWDIMS[0] )
    
  (*pState).ENDPOS[1] = ev.Y
  (*pState).ENDPOS[1] = (*pState).ENDPOS[1]< ((*pState).NEWLOC[1]+ $
    (*pState).NEWDIMS[1] )
  data = [[(*pState).STARTPOS[0],(*pState).STARTPOS[1]], $
    [(*pState).STARTPOS[0],(*pState).ENDPOS[1]]   , $
    [(*pState).ENDPOS[0],(*pState).ENDPOS[1]]     , $
    [(*pState).ENDPOS[0],(*pState).STARTPOS[1]]    ]
    
  (*pState).ORECTANGLE->SETPROPERTY,Data = data
  (*pState).OFILL->SETPROPERTY,Data = data
  (*pState).SHOWWINDOW->DRAW,(*pState).OVIEW
  
END
ELSE :
ENDCASE

'InputX':   BEGIN
  WIDGET_CONTROL,(*pState).WIDTH,Get_Value = x
  WIDGET_CONTROL,(*pState).HEIGHT,Set_Value = FIX(x/(*pState).VIEWSCALE)
END

'InputY':    BEGIN
  WIDGET_CONTROL,(*pState).HEIGHT,Get_Value = y
  WIDGET_CONTROL,(*pState).WIDTH,Set_Value = FIX(y*(*pState).VIEWSCALE)
END
ELSE:

ENDCASE

END

;-----------------------------------------------------------------
; 2007-5-30 Write By DYQ (Learning IDL...)
;;Image_Save主函数
FUNCTION IMAGE_SAVE, currView

  COMPILE_OPT IDL2
  
  ;获取当前窗口大小
  DEVICE ,get_Screen_size = Scr_Dims
  
  XDim = Scr_Dims[0]/3
  YDim = Scr_Dims[1]/3
  
  ;初始化tlb
  SaveTlb  = WIDGET_BASE( Title  = '保存为图像'        ,$
    tlb_frame_attr =1,/column ,Map =0)
    
    
  DrawBase = WIDGET_BASE( SaveTlb,Frame = 1,xSize = xDim ,$
    ySize = yDim,/column           )
    
  Label = WIDGET_LABEL( DrawBase,value = '[场景缩略图-鼠标选择存储范围 ]')
  
  wDraw = WIDGET_DRAW( DrawBase, xSize = xDim, ySize = yDim ,$
    Frame = 0, Uvalue = 'draw'           ,$
    Uname = 'draw', Graphics_level = 2   ,$
    Retain = 2, /Button_Events           )
    
  ;设置大小base
  SizeBase = WIDGET_BASE( SaveTlb, Frame = 1, xSize = xDim       ,$
    /row, /Align_Center, title = '图像大小')
    
  width  = CW_FIELD( SizeBase, Title ='设置图像大小（像素） X:'  ,$
    value ='800', /long, uvalue = 'InputX'     ,$
    /All_events, xSize = 8                     )
    
  height = CW_FIELD( SizeBase, Title ='Y:', value =''    ,$
    uvalue = 'InputY', /long, xSize = 8 ,$
    /All_events )
    
  ;文件类型base
  FileTypeBase = WIDGET_BASE( SaveTlb, Frame = 1, xSize = xDim ,$
    /Align_Center   ,/row  )
    
  Void = WIDGET_LABEL( FileTypeBase, value = ' 选择保存图像类型：',$
    yOffset = 7 )
    
  SelectPath = WIDGET_BUTTON( FileTypeBase, valu = '更改保存路径'      ,$
    uval = 'ReName', yOffset= 5 )
    
  listTems = ['JPEG','BMP','TIF','PNG']
  FileTypeList = WIDGET_DROPLIST(FileTypeBase,uvalue = 'TypeList',value = listTems,$
    yOffset = 5)
  CD, Current = rootDir
  FileName = rootDir + '\SaveImage.jpg'
  FileSaveBase = WIDGET_BASE( SaveTlb, Frame = 1, xSize = xDim ,$
    /Align_Center   ,/row  )
  FileNameText = WIDGET_TEXT(FileSaveBase,uvalue = 'SaveFileName',value = FileName,$
    xSize = xDim,yOffset = 28,/Editable)
    
  ;保存按钮base
  DoBase = WIDGET_BASE(SaveTlb,Frame = 1,xSize = xDim,/row)
  DoSaveButton = WIDGET_BUTTON(DoBase,value = '保存',uValue = 'DoSave',xsize =50,ysize = 20 ,$
    xOffset =50)
  CancelButton = WIDGET_BUTTON(DoBase,value = '取消',uValue = 'DoCancel',xsize =50,ysize = 20,$
    xOffset =50)
    
  WIDGET_CONTROL,SaveTlb,/realize
  WIDGET_CONTROL,wDraw,get_value = showWindow
  
  ;获取当前VIEW的大小和范围并存贮
  currView->GETPROPERTY, dimensions=oriDims,location=oriLoc
  
  ;计算View和显示的XY比例
  IF oriDims[1] EQ 0 THEN ViewDims =1 ELSE $
    ViewScale = FLOAT(oriDims[0])/FLOAT(oriDims[1])
  IF yDim EQ 0 THEN DisplayScale =1 ELSE $
    DisplayScale = FLOAT(xDim)/FLOAT(yDim)
    
  ;设置默认输出图像的Y数据
  WIDGET_CONTROL ,height,Set_Value = 800/ViewScale
  
  ;显示缩略图-并使其按照原始比例居中显示
  IF ViewScale GT DisplayScale THEN $
    currView->SETPROPERTY,Dimensions = [xDim, xDim/ViewScale]  ,$
    Location = [0,(yDim - xDim/ViewScale)/2]                    $
  ELSE  currView->SETPROPERTY,Dimensions = [yDim*ViewScale, yDim] ,$
  Location = [(xDim - yDim*ViewScale)/2,0]
  
;调整后的VIEW大小和位置
currView->GETPROPERTY, dimensions=NewDims,location = NewLoc

;图像拍照
obuffer = OBJ_NEW('idlgrbuffer')
obuffer->SETPROPERTY, graphics_tree = currView
obuffer->DRAW
Temp = obuffer->READ()
Temp->GETPROPERTY,data = img
;IDLgrImage存贮
oImage = OBJ_NEW('IDLgrImage')
oImage->SETPROPERTY,Data = img

;恢复原来View
currView->SETPROPERTY,dimensions = oriDims,location = oriLoc

;建立Model和View来显示

oModel = OBJ_NEW('IDLgrModel')
oView = OBJ_NEW('IDLgrView',Dimension = [xDim,yDim],location = [0,0],$
  ViewPlane_Rect = [0,0,xDim,yDim])
  
oModel->ADD,oImage


;建立矩形框对象
oRectangle = OBJ_NEW('IDLgrPolygon'   , $;
  LineStyle = 0           , $;实心线性
  Thick = 1               , $;
  Style = 1               , $;绘制顶点和线框
  Color = [0,100,200]         )
  
;创建矩形内部
oFill = OBJ_NEW('IDLgrPolygon'              , $;
  LineStyle = 6              , $;
  Alpha_Channel = 0.4        , $;透明度
  Style = 2                  , $;填充绘制
  Color = [71,204,235]          )
  
oModel->ADD,oRectangle
oModel->ADD,oFill
oView->ADD,oModel
showWindow->DRAW,oView
StartPos = [NewLoc[0],NewLoc[1]]
EndPos = [NewLoc[0]+NewDims[0],NewLoc[1]+NewDims[1]]
FileType = 0
pState = {                                    $
  currView      :   currView     ,$
  FileType      :   FileType     ,$
  FileNameText  :   FileNameText ,$
  SAVETLB       :   SAVETLB      ,$
  oView         :   oView        ,$
  oModel        :   oModel       ,$
  oImage        :   oImage       ,$
  ViewScale     :   ViewScale    ,$
  showWindow    :   showWindow   ,$
  width         :   width        ,$
  height        :   height       ,$
  oRectangle    :   oRectangle   ,$
  oFill         :   oFill        ,$
  xDim:xDim,yDim:   yDim         ,$
  NewLoc        :   NewLoc       ,$
  NewDims       :   NewDims      ,$;view图像的大小
  oriLoc        :   oriLoc       ,$
  oriDims       :   oriDims      ,$
  StartPos      :   StartPos     ,$
  EndPos        :   EndPos  }
  
;
Geom = WIDGET_INFO(SaveTlb, /Geometry)
WIDGET_CONTROL, SaveTlb, XOffset = (Scr_Dims[0] - Geom.SCR_XSIZE)/2., $
  YOffset = (Scr_Dims[1] - Geom.SCR_YSIZE)/2., $
  Set_uvalue = PTR_NEW(pState), Map =1
XMANAGER,'Image_Save',SaveTlb
END