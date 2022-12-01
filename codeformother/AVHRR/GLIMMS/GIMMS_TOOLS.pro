;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	03/29/2008 19:14.32
;
pro TopBase_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    Widget_Info(wWidget, FIND_BY_UNAME='TopBase'): begin
    end
    Widget_Info(wWidget, FIND_BY_UNAME='FileSelect_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OpenGIMMS, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='Boundary_DROPLIST'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DROPLIST' )then $
        Set_Boundary, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='OutFormate_DROPLIST'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DROPLIST' )then $
        Set_OutFormate, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='Run_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Run, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='Quit_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Cancle, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='OutPath_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Set_Outpath, Event
    end
    else:
  endcase

end

pro TopBase, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'GIMMS_TOOLS_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  TopBase = Widget_Base( GROUP_LEADER=wGroup, UNAME='TopBase'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=621 ,SCR_YSIZE=426  $
      ,NOTIFY_REALIZE='InitShow' ,TITLE='GIMMS Tools for ENVI'  $
      ,SPACE=3 ,XPAD=3 ,YPAD=3)


  FilePath_TEXT = Widget_Text(TopBase, UNAME='FilePath_TEXT'  $
      ,XOFFSET=100 ,YOFFSET=2 ,SCR_XSIZE=451 ,SCR_YSIZE=29 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  FileSelect_BUTTON = Widget_Button(TopBase,  $
      UNAME='FileSelect_BUTTON' ,XOFFSET=554 ,YOFFSET=1 ,SCR_XSIZE=57  $
      ,SCR_YSIZE=32 ,/ALIGN_CENTER ,VALUE='选择')


  WID_LABEL_0 = Widget_Label(TopBase, UNAME='WID_LABEL_0' ,XOFFSET=3  $
      ,YOFFSET=10 ,SCR_XSIZE=96 ,SCR_YSIZE=20 ,/ALIGN_LEFT  $
      ,VALUE='GIMMS所在目录：')


  Main_BASE = Widget_Base(TopBase, UNAME='Main_BASE' ,XOFFSET=1  $
      ,YOFFSET=44 ,SCR_XSIZE=392 ,SCR_YSIZE=346 ,TITLE='IDL' ,SPACE=3  $
      ,XPAD=3 ,YPAD=3)


  Boundary_DROPLIST = Widget_Droplist(Main_BASE,  $
      UNAME='Boundary_DROPLIST' ,XOFFSET=90 ,YOFFSET=2 ,SCR_XSIZE=290  $
      ,SCR_YSIZE=25)


  OutFormate_DROPLIST = Widget_Droplist(Main_BASE,  $
      UNAME='OutFormate_DROPLIST' ,XOFFSET=98 ,YOFFSET=225  $
      ,SCR_XSIZE=287 ,SCR_YSIZE=26)


  WID_LABEL_5 = Widget_Label(Main_BASE, UNAME='WID_LABEL_5'  $
      ,YOFFSET=6 ,SCR_XSIZE=86 ,SCR_YSIZE=17 ,/ALIGN_RIGHT  $
      ,VALUE='设置切割范围：')


  Boundary_BASE = Widget_Base(Main_BASE, UNAME='Boundary_BASE'  $
      ,FRAME=1 ,XOFFSET=5 ,YOFFSET=37 ,SCR_XSIZE=378 ,SCR_YSIZE=176  $
      ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_LABEL_1 = Widget_Label(Boundary_BASE, UNAME='WID_LABEL_1'  $
      ,XOFFSET=174 ,YOFFSET=4 ,SCR_XSIZE=28 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='北')


  North_TEXT = Widget_Text(Boundary_BASE, UNAME='North_TEXT'  $
      ,XOFFSET=131 ,YOFFSET=29 ,SCR_XSIZE=109 ,SCR_YSIZE=31 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_3 = Widget_Label(Boundary_BASE, UNAME='WID_LABEL_3'  $
      ,XOFFSET=335 ,YOFFSET=87 ,SCR_XSIZE=31 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='东')


  WID_LABEL_2 = Widget_Label(Boundary_BASE, UNAME='WID_LABEL_2'  $
      ,XOFFSET=2 ,YOFFSET=86 ,SCR_XSIZE=27 ,SCR_YSIZE=19  $
      ,/ALIGN_RIGHT ,VALUE='西')


  West_TEXT = Widget_Text(Boundary_BASE, UNAME='West_TEXT'  $
      ,XOFFSET=35 ,YOFFSET=79 ,SCR_XSIZE=89 ,SCR_YSIZE=31 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_4 = Widget_Label(Boundary_BASE, UNAME='WID_LABEL_4'  $
      ,XOFFSET=170 ,YOFFSET=119 ,SCR_XSIZE=14 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='南')


  East_TEXT = Widget_Text(Boundary_BASE, UNAME='East_TEXT'  $
      ,XOFFSET=236 ,YOFFSET=79 ,SCR_XSIZE=94 ,SCR_YSIZE=31 ,XSIZE=20  $
      ,YSIZE=1)


  South_TEXT = Widget_Text(Boundary_BASE, UNAME='South_TEXT'  $
      ,XOFFSET=128 ,YOFFSET=136 ,SCR_XSIZE=110 ,SCR_YSIZE=31  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_6 = Widget_Label(Main_BASE, UNAME='WID_LABEL_6'  $
      ,XOFFSET=8 ,YOFFSET=228 ,SCR_XSIZE=84 ,SCR_YSIZE=23  $
      ,/ALIGN_LEFT ,VALUE='设置输出格式：')


  OutPath_TEXT = Widget_Text(Main_BASE, UNAME='OutPath_TEXT'  $
      ,XOFFSET=99 ,YOFFSET=266 ,SCR_XSIZE=285 ,SCR_YSIZE=24  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  Run_BUTTON = Widget_Button(Main_BASE, UNAME='Run_BUTTON'  $
      ,XOFFSET=52 ,YOFFSET=306 ,SCR_XSIZE=88 ,SCR_YSIZE=33  $
      ,/ALIGN_CENTER ,VALUE='运行')


  Quit_BUTTON = Widget_Button(Main_BASE, UNAME='Quit_BUTTON'  $
      ,XOFFSET=180 ,YOFFSET=305 ,SCR_XSIZE=96 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='取消')


  OutPath_BUTTON = Widget_Button(Main_BASE, UNAME='OutPath_BUTTON'  $
      ,XOFFSET=4 ,YOFFSET=259 ,SCR_XSIZE=85 ,SCR_YSIZE=28  $
      ,/ALIGN_CENTER ,VALUE='设置输出目录')


  Message_BASE = Widget_Base(TopBase, UNAME='Message_BASE'  $
      ,XOFFSET=396 ,YOFFSET=44 ,SCR_XSIZE=217 ,SCR_YSIZE=348  $
      ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  Message_TEXT = Widget_Text(Message_BASE, UNAME='Message_TEXT'  $
      ,FRAME=1 ,XOFFSET=1 ,YOFFSET=4 ,SCR_XSIZE=213 ,SCR_YSIZE=342  $
      ,/SCROLL ,/NO_NEWLINE ,/WRAP ,XSIZE=20 ,YSIZE=1)

  Widget_Control, /REALIZE, TopBase

  XManager, 'TopBase', TopBase, /NO_BLOCK

end
;
; Empty stub procedure used for autoloading.
;
pro GIMMS_TOOLS, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  TopBase, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
