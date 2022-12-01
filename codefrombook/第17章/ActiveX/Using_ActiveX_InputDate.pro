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

;-----------------------------------------------------------------
;
;Center TLB
;
PRO CENTERTLB, tlb, x, y, NoCenter=nocenter
  COMPILE_OPT strictarr
  
  IF N_ELEMENTS(x) EQ 0 THEN xc = 0.5 ELSE xc = FLOAT(x[0])
  IF N_ELEMENTS(y) EQ 0 THEN yc = 0.5 ELSE yc = 1.0 - FLOAT(y[0])
  center = 1 - KEYWORD_SET(nocenter)
  
  screenSize = GET_SCREEN_SIZE()
  IF screenSize[0] GT 2000 THEN screenSize[0] = screenSize[0]/2 ; Dual monitors.
  xCenter = screenSize[0] * xc
  yCenter = screenSize[1] * yc
  
  geom = WIDGET_INFO(tlb, /Geometry)
  xHalfSize = geom.SCR_XSIZE / 2 * center
  yHalfSize = geom.SCR_YSIZE / 2 * center
  
  XOffset = 0 > (xCenter - xHalfSize) < (screenSize[0] - geom.SCR_XSIZE)
  YOffset = 0 > (yCenter - yHalfSize) < (screenSize[1] - geom.SCR_YSIZE)
  WIDGET_CONTROL, tlb, XOffset=XOffset, YOffset=YOffset
  
END
;-----------------------------------------------------------------
;
;Dialog_SelectDate响应事件
;
;
PRO DIALOG_SELECTDATE_EVENT,ev
  COMPILE_OPT idl2
  
  WIDGET_CONTROL,ev.TOP,get_uvalue = pState    ;
  
  uName = WIDGET_INFO(ev.ID,/UName)
  PRINT,uName
  
  CASE uName OF
    'dateSelect': BEGIN
      ;
      IF ev.EVENT_NAME EQ 'SelChange' THEN BEGIN
        (*pstate).NOWDATE = CALACTIVEXDATE((*pstate).OACTIVEXCONTROL)
      ENDIF
    END
    'apply': BEGIN
      ;
      WIDGET_CONTROL,ev.TOP,/Destroy
    END
    
    ELSE:
  ENDCASE
  
END
;-----------------------------------------------------------------
FUNCTION DIALOG_SELECTDATE, title
  ;
  IF N_ELEMENTS(title) EQ 0 THEN title  = 'Select Date'
  ;当前分辨率，图像界面居中
  DEVICE,GET_SCREEN_SIZE=screenSize
  xCenter=screenSize[0]/2
  yCenter=screenSize[1]/2
  tlb=WIDGET_BASE(TITLE=title, $
    /Column, $
    TLB_FRAME_ATTR=1, $
    /Base_Align_Center)
  controlBase=WIDGET_BASE(tlb,/FRAME)
  control=WIDGET_ACTIVEX(controlBase,'{232E456A-87C3-11D1-8BE3-0000F8754DA1}',$
    uName = 'dateSelect', $
    xsize = 185, $
    ySize =160)
  ;
  wControl = WIDGET_BASE(tlb)
  wApply = WIDGET_BUTTON(wControl,value = '确定',$
    uName ='apply')
  geom=WIDGET_INFO(tlb,/GEOMETRY)
  xHalfSize=geom.SCR_XSIZE/2
  yHalfSize=geom.SCR_YSIZE/2
  WIDGET_CONTROL,tlb,XOFFSET=(xCenter-xHalfSize),YOFFSET=(yCenter-yHalfSize)
  WIDGET_CONTROL,tlb,/REALIZE
  ;obtain the main root object reference:
  WIDGET_CONTROL,control,GET_VALUE=oActiveXControl
  ;设置默认选择日期为当前日期
  nowDate = CALACTIVEXDATE(oActiveXControl)
  ;create state structure to store information needed by the other event handling procedures:
  pState=PTR_NEW({oActiveXControl:oActiveXControl, $
    nowDate : nowDate},/No_Copy)
    
  WIDGET_CONTROL,tlb,Set_uvalue = pState
  
  XMANAGER,'Dialog_SelectDate',tlb
  selectDate  = (*pstate).NOWDATE
  ;
  PTR_FREE,pState  ;
  PRINT,selectDate
  RETURN,selectDate
  
;
END
;-----------------------------------------------------------------
;
;计算ActiveXdate为string类型的日期
; result: 2008-08-08
FUNCTION  CALACTIVEXDATE, oActiveXControl
  oActiveXControl->GETPROPERTY,year = year,month = month,day = day
  ; month, day, year
  date = STRTRIM(STRING(year),2)+'-'+STRTRIM(STRING(month),2)+'-'+STRTRIM(STRING(day),2)
  RETURN,date
END
;-----------------------------------------------------------------
;WriteBy DYQ
;调用Windows组件来选择日期

PRO USING_ACTIVEX_INPUTDATE_EVENT,ev
  ;
  COMPILE_OPT idl2
  uName = WIDGET_INFO(ev.ID,/uName)
  IF uName EQ 'select' THEN BEGIN
    ;
    sDate = DIALOG_SELECTDATE('日期选择')
    ;
    tmp = DIALOG_MESSAGE('选择的是：'+sDate,/info)
  ENDIF
END
;-----------------------------------------------------------------
;界面调用示例
;
PRO USING_ACTIVEX_INPUTDATE
  COMPILE_OPT idl2
  wTlb = WIDGET_BASE()
  wButton = WIDGET_BUTTON(wTlb,value ='日期选择', uName = 'select')
  CENTERTLB,wtlb
  WIDGET_CONTROL,wTlb,/Realize
  ;
  XMANAGER,'Using_ActiveX_InputDate',wTlb,/No_Block
END
