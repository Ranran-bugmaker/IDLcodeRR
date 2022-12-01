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
PRO TEST_DOUBLESCREEN_EVENT,ev
  ;事件处理
  WIDGET_CONTROL, ev.TOP,Get_UValue = pState
  uname = WIDGET_INFO(ev.ID,/uName)
  ;
  IF TAG_NAMES(ev, /STRUCTURE_NAME) EQ $
    'WIDGET_KILL_REQUEST' THEN BEGIN
    ;
    WIDGET_CONTROL, ev.TOP,/Destroy
    OBJ_DESTROY, (*pState).OSCENE
    OBJ_DESTROY, (*pState).OWINDOW
    PTR_FREE, pState
    
  ENDIF
  ;暴露事件
  IF TAG_NAMES(ev, /Structure_Name) EQ 'WIDGET_DRAW' THEN BEGIN
  
    IF ev.TYPE EQ 4 THEN BEGIN
      (*pState).OWINDOW->DRAW,(*pState).OSCENE
    ENDIF
  ENDIF
  
  CASE uname OF
    'draw':BEGIN
    
    CASE ev.TYPE OF
      ;鼠标点击
      0: BEGIN
        (*pState).NOWLOCATION = [ev.X,ev.Y]
        (*pState).MOUSEDOWN = 1
        (*pState).OWINDOW->SETCURRENTCURSOR,'ARROW'
      END
      ;鼠标弹起
      1:BEGIN
      (*pState).MOUSEDOWN = 0
      (*pState).OWINDOW->SETCURRENTCURSOR,'CROSSHAIR'
      ;
      (*pState).OWINDOW->DRAW,(*pState).OSCENE
    END
    ;鼠标移动
    2: BEGIN
      IF ((*pState).MOUSEDOWN EQ 1) THEN BEGIN
        xyOffset =([ev.X,ev.Y] -(*pState).NOWLOCATION)*(*pState).VIEWSCALE
        ;
        (*pState).OIMAGE1->GETPROPERTY,Location = oriLoc
        (*pState).OIMAGE1->SETPROPERTY,Location = oriLoc+xyOffset
        ;
        (*pState).OIMAGE2->GETPROPERTY,Location = oriLoc
        (*pState).OIMAGE2->SETPROPERTY,Location = oriLoc+xyOffset
        
        (*pState).NOWLOCATION = [ev.X,ev.Y]
        (*pState).OWINDOW->DRAW,(*pState).OSCENE
      ENDIF
    END
    ;键盘事件
    5: BEGIN
      ;ESC键退出
      IF ev.CH EQ 27 THEN  WIDGET_CONTROL, ev.TOP, /Destroy
      
    END
    6: BEGIN
      PRINT,ev.KEY
      CASE ev.KEY OF
        5:BEGIN
        (*pState).OVIEW1->GETPROPERTY, Location = oriLoc
        oriLoc[0] = oriLoc[0]- 1
        (*pState).OVIEW1->SETPROPERTY, Location = oriLoc
      END
      6:BEGIN
      (*pState).OVIEW1->GETPROPERTY, Location = oriLoc
      oriLoc[0] = oriLoc[0]+1
      (*pState).OVIEW1->SETPROPERTY, Location = oriLoc
    END
    ;up
    7:BEGIN
    (*pState).OVIEW1->GETPROPERTY, Location = oriLoc
    oriLoc[1] = oriLoc[1]+1;
    (*pState).OVIEW1->SETPROPERTY, Location = oriLoc
  END
  8:BEGIN
  (*pState).OVIEW1->GETPROPERTY, Location = oriLoc
  oriLoc[1] = oriLoc[1]-1;
  (*pState).OVIEW1->SETPROPERTY, Location = oriLoc
END

ELSE:

ENDCASE;		eprint,ev.ch
(*pState).OWINDOW->DRAW,(*pState).OSCENE
END
7: BEGIN
  ;
  ; 放大倍数为1.1,缩小倍数为0.9
  r = ev.CLICKS GT 0 ? 1 : -1
  viewScale = 1+ r/ 10.
  tmpScale =1.+ FLOAT(ev.CLICKS)/10
  ;
  (*pState).VIEWSCALE = (*pState).VIEWSCALE*tmpScale
  
  (*pState).OVIEW1->GETPROPERTY, viewPlane_r = vp,dimension = vd
  ;当前鼠标位置在view中的位置
  oriLoc = [vp[0]+DOUBLE(ev.X)*vp[2]/vd[0], $
    vp[1]+DOUBLE(ev.Y)*vp[3]/vd[1]]
    
  ;缩放后view显示区域
  vp[2:3] = vp[2:3]*tmpScale;(*pState).viewScale
  distance = (oriLoc - vp[0:1])*tmpScale;(*pState).viewScale
  vp[0:1] = oriLoc - distance
  ;设置
  (*pState).OVIEW1->SETPROPERTY, viewPlane_r = vp
  
  (*pState).OVIEW2->GETPROPERTY, viewPlane_r = vp,dimension = vd
  ;当前鼠标位置在view中的位置
  oriLoc = [vp[0]+DOUBLE(ev.X)*vp[2]/vd[0], $
    vp[1]+DOUBLE(ev.Y)*vp[3]/vd[1]]
    
  ;缩放后view显示区域
  vp[2:3] = vp[2:3]*tmpScale;(*pState).viewScale
  distance = (oriLoc - vp[0:1])*tmpScale;(*pState).viewScale
  vp[0:1] = oriLoc - distance
  ;设置
  (*pState).OVIEW1->SETPROPERTY, viewPlane_r = vp
  (*pState).OVIEW2->SETPROPERTY, viewPlane_r = vp
  
  (*pState).OWINDOW->DRAW,(*pState).OSCENE
END
ENDCASE
END
ELSE :
ENDCASE
END
;
PRO TEST_DOUBLESCREEN
  COMPILE_OPT idl2
  
  ;获得取出任务栏的组件大小
  oMonInfo = OBJ_NEW('IDLsysMonitorInfo')
  rects = oMonInfo->GETRECTANGLES(Exclude_Taskbar = 1 )
  pmi = oMonInfo->GETPRIMARYMONITORINDEX()
  ;获取偏移量
  mNum  = oMonInfo->GETNUMBEROFMONITORS()
  ;初始化屏幕参数
  sz = oMonInfo->GETRECTANGLES();
  ;屏幕两个时的初始化参数
  IF mNum GT 1 THEN BEGIN
    ;第一个显示器的屏幕参数
    scr1 = sz[*,0]
    scr2 = sz[*,1]
  ENDIF ELSE BEGIN
    ;单屏幕时的参数
    scr1 = sz
    column = 0
    IF column THEN BEGIN
      scr1[3] = scr1[3]/2
      scr2 = sz
      scr2[1] = scr2[3]/2
      scr2[3] = scr2[3]/2
      
    ENDIF ELSE BEGIN
      scr1[2] = scr1[2]/2
      
      scr2 = sz
      scr2[0] = scr2[2]/2
      scr2[2] = scr2[2]/2
    ;
    ENDELSE
  ENDELSE
  OBJ_DESTROY, oMonInfo
  ;
  CD,current=root
  file1 = DIALOG_PICKFILE(title='Please select the first image',path=root,GET_PATH=p2)
  file2 = DIALOG_PICKFILE(title='Please select the second image',path=p2)
  base = WIDGET_BASE(TLB_FRAME_ATTR =7, $
    /Tlb_Kill_Request_Events)
  ;
  xSize = scr1[2]+scr1[0]+scr2[0]
  ySize = scr1[3]+scr1[1]+scr2[1]
  wdraw = WIDGET_DRAW(base, $
    xsize= xSize, $
    ysize = ySIze , $
    uName = 'draw' ,$
    /MOTION_EVENTS, $
    /BUTTON_EVENTS   , $
    /WHEEL_EVENTS  , $
    KEYBOARD_EVENTS = 2, $
    GRAPHICS_LEVEL=2 , $
    retain=0)
  IF file1 EQ '' THEN RETURN;
  IF file2 EQ '' THEN RETURN;
  imgdata1 = READ_TIFF(file1,INTERLEAVE=0)
  imgdata2 = READ_TIFF(file2,INTERLEAVE=2)
  ;    ;
  imgSZ = SIZE(imgData1,/Dim)
  
  WIDGET_CONTROL,base,/realize
  ;
  WIDGET_CONTROL,wdraw,get_value=oWindow
  ;
  oImage1 = OBJ_NEW('IDLgrImage',imgdata1,dimension=SIZE(imgData1,/Dim))
  oImage2 = OBJ_NEW('IDLgrImage',imgdata2,dimension=SIZE(imgData2,/Dim))
  ;    ;
  oScene = OBJ_NEW('IDLgrScene')  ;
  
  oView1 = OBJ_NEW('IDLgrView', location=scr1[0:1], $
    DIMENSIONS=[xsize,ysize],viewp = [0,0,xsize,ysize])
    
  oView2 = OBJ_NEW('IDLgrView', location=scr2[0:1], $
    DIMENSIONS=[xsize,ysize],viewp = [0,0,xsize,ysize])
  ;
  oModel1 = OBJ_NEW('IDLgrModel')
  oModel1->ADD, oImage1
  oModel2 = OBJ_NEW('IDLgrModel')
  oModel2->ADD, oImage2
  
  oView1->ADD,oModel1
  oView2->ADD,oModel2
  ;计算添加层次关系
  IF (scr1[0] NE 0) OR (scr1[1] NE 0) THEN oScene->ADD,[oView2,oView1] ELSE $
    oScene->ADD,[oView1,oView2]
    
  oWindow->DRAW,oScene
  viewScale = 1.0
  ;
  state = PTR_NEW(  $
    { oImage1:oImage1, $
    mouseDown : 0 , $
    viewScale :viewScale , $
    wDraw:WDRAW   , $
    nowLocation:[0,0], $
    oWindow:oWindow , $
    oView1:oView1   , $
    oView2:oView2   , $
    oScene:oScene     , $
    oImage2:oImage2 })
  WIDGET_CONTROL, base, Set_uValue = State;
  ;
  XMANAGER,  'test_doubleScreen', base,/No_Block
  
END