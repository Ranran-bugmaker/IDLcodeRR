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
;界面关闭响应程序
PRO WIDGET_EXAMPLES_CLEANUP, tlb
  ;获取uValue
  WIDGET_CONTROL,tlb,get_uvalue=pstate
  ;因是指针，故需要销毁
  PTR_FREE, pState
END
;界面事件响应程序
PRO  WIDGET_EXAMPLES_EVENT, event

  ;获得顶base的uvalue，即组件信息指针结构体
  WIDGET_CONTROL,event.TOP,get_uvalue=pstate
  
  CASE TAG_NAMES(event,/STRUCTURE_NAME) OF
    ;关闭事件
    'WIDGET_KILL_REQUEST': BEGIN
      ;提示是否关闭
      tmp = DIALOG_MESSAGE('确认关闭？',$
        title ='关闭系统',/question)
      IF tmp EQ 'Yes' THEN BEGIN
        ;注意销毁之前创建的指针
        WIDGET_CONTROL,event.TOP,get_uValue = pState
        PTR_FREE, pState
        ;销毁界面
        WIDGET_CONTROL,event.TOP,/destroy
        RETURN
      ENDIF
      RETURN
    END
    ;draw区域
    'WIDGET_DRAW': BEGIN
    
      CASE event.TYPE OF
        ;注意不同的类型对应的不同的事件
        ;键盘和鼠标等各自事件的结构体内容
        0: BEGIN
          CASE event.PRESS OF
            1: value = '左键按下'
            2: value = '中键按下'
            4: BEGIN
              value = '右键按下'
              ;弹出右键菜单
              WIDGET_DISPLAYCONTEXTMENU, event.ID, event.X, $
                event.Y, (*pState).CONTEXTBASE  
            END
            ELSE: PRINT,event.PRESS
          ENDCASE
        END
        1: BEGIN
          CASE event.RELEASE OF
            1: value = '左键释放'
            2: value = '中键释放'
            4: value = '右键释放'
            ELSE: PRINT,event.RELEASE
          ENDCASE
        END
        2: value = '鼠标移动'
        7: BEGIN
          IF event.CLICKS GT 0 THEN value='滚轮前滚' $
          ELSE value='滚轮后滚'
        END
        4:  BEGIN
          value = '暴露事件'
          ;设置显示组件的大小
          drawSize  = WIDGET_INFO((*pState).MYDRAW,/Geom)
          ;适应性显示
          TVSCL,CONGRID(DIST(400),drawSize.XSIZE,drawSize.YSIZE)
        END
        5: value = 'key = ' +STRTRIM(STRING(event.CH),2)
        6: value = 'key = ' +STRTRIM(STRING(event.CH),2)
        ELSE:PRINT,event.TYPE
      ENDCASE
      ;
      WIDGET_CONTROL,(*pstate).TEXT1,set_value= value
    END
    ELSE:
  ENDCASE
  
  ;获取当前组件的uName
  uName = WIDGET_INFO(event.ID,/uname)
  ;点击了界面上按钮
  IF uName EQ 'button' THEN BEGIN
    tmp = DIALOG_MESSAGE((*pState).TESTSTR,/Infor)
  ENDIF
  ;点击了右键菜单中的按钮
  IF uName EQ 'contexButton1' THEN tmp = DIALOG_MESSAGE('右键菜单1',/infor)
  IF uName EQ 'contexButton2' THEN tmp = DIALOG_MESSAGE('右键菜单2',/infor)
  ;修改界面大小
  IF uName EQ 'tlb' THEN BEGIN
    ;显示组件大小适应程序大小
    drawXSize = event.X -(*pState).DRAWSPACE[0]
    drawYSize = event.Y -(*pState).DRAWSPACE[1]
    ;设置tlb大小(可忽略，因Draw组件后面已经设置了大小)
    WIDGET_CONTROL,event.TOP,xSize = event.X,ySize = event.Y
    ;设置显示组件的大小
    WIDGET_CONTROL,(*pState).MYDRAW,xsize = drawXSize, ySize = drawYSize
    ;适应性显示
    TVSCL,CONGRID(DIST(400),drawXSize,drawYSize)
  ENDIF
END
;
PRO WIDGET_EXAMPLES

  ; 创建一个主Base窗体
  base1 = WIDGET_BASE(TITLE='界面程序示例', $
    mBar = mBar , $
    uname ='tlb', $
    ;按行排列
    /COLUMN, $
    
    ;重设置大小时产生事件
    /TLB_SIZE_EVENTS,$
    ;关闭时产生事件
    /TLB_KILL_REQUEST_EVENTS)
  ;创建系统菜单
  wFile = WIDGET_BUTTON(mbar,value = '文件(&F)')
  wOpen = WIDGET_BUTTON(wFile, value = '打开(&O)')
  wExit  = WIDGET_BUTTON(wFile, value = '退出(&E)', $
    ;添加分隔线
    /Separator)
  ;创建一个按钮
  base2=WIDGET_BASE(base1,/row)
  label1=WIDGET_LABEL(base2,$
    value='当前事件：')
  text1=WIDGET_TEXT(base2, $
    xSize =10)
  button = WIDGET_BUTTON(base2,$
    value ='按钮', $
    uName ='button')
  mydraw=WIDGET_DRAW(base1,$
    retain=0,$
    ;设置大小
    xsize=400,$
    ysize=400,$
    ;滚轮时产生事件
    /wheel_events,$
    ;点击按钮时产生事件
    /button_events,$
    ;暴露（从遮挡到最前显示时）时产生事件
    /expose_events,$
    ;鼠标移动时产生事件
    /motion_events,$
    ;键盘敲击时事件
    /keyboard_events,$
    ;设置组件的uName，即名字。
    uname='mydraw')
  ;例示
  WIDGET_CONTROL, base1, /REALIZE
  ;创建右键菜单界面
  contextBase = WIDGET_BASE(mydraw, /CONTEXT_MENU)
  ;右键菜单中菜单选项
  button1 = WIDGET_BUTTON(contextBase, $
    VALUE='右键菜单1', $
    uname = 'contexButton1')    
  button2 = WIDGET_BUTTON(contextBase, $
    VALUE='右键菜单2', $
    uname = 'contexButton2')    
    
  ;获取系统初始化颜色模式
  DEVICE, Get_Decomposed = oriD
  ;显示伪彩色图像
  DEVICE, decomposed =0
  ;载入系统颜色表
  LOADCT,23
  ;显示一个400*400的方形图像
  imgData = DIST(400)
  TVSCL,imgData
  
  ;获取组件的大小信息
  sz = WIDGET_INFO(base1,/geom)
  drawSZ = WIDGET_INFO(myDraw,/geom)
  ;显示区域与主界面的边界间隔
  drawSpace = [sz.XSIZE,sz.YSIZE] - [drawSZ.XSIZE,drawSZ.YSIZE]
  
  ;创建结构体，包含各个组件ID和参数
  state={label1:label1,$
    contextBase: contextBase, $
    text1:text1,$
    oriD: oriD, $
    imgData : imgData , $
    drawSpace: drawSpace, $
    testStr  : '初始字符串!',$
    mydraw:mydraw}
  ;创建指针
  pstate=PTR_NEW(state,/no_copy)
  ;将指针信息存到tlb的uvalue中保存
  WIDGET_CONTROL,base1,set_uvalue=pstate
  ;关联产生事件
  
  XMANAGER, 'WIDGET_EXAMPLES', base1, $
    cleanup = 'WIDGET_EXAMPLES_CLEANUP',/NO_BLOCK
;也可用这个方式:直接指定事件程序,event_handler ='abc'
    
END

