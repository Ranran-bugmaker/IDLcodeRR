
;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》
;
;麼完笥並周侃尖
;
PRO MainSystem::HandleEvent, event

    COMPILE_OPT IDL2

    IF Tag_Names(event, /Structure_Name) EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
       status = Dialog_Message('購液處幣罷周', $
               /Question)
       IF status EQ 'Yes'THEN Widget_Control, event.top, /Destroy
        Return
    ENDIF

    UName = Widget_Info(event.id, /UName)
     print,UName

    CASE UName OF
       'wBase' : BEGIN
            newx = (event.x - 6) > 0
            newy = (event.y - 25 - 20 - 6) > 0
            widget_control, event.top, xsize=event.x, ysize=event.y

            self.oManager->ConfigViewRange
            (self.oDraw).oWindow->Draw

       END
       ELSE : BEGIN
         sPos = Strpos(UName, '::')
         sLen = StrLen(UName)
         iFaceClass = Strmid(UName, 0, sPos)
         iFaceOp = Strmid(UName, sPos+2, sLen-sPos-2)
         ;
         IF iFaceClass EQ 'ADDraw' THEN self.oDraw->HandleEvent, event
         IF iFaceClass EQ 'ITCifMenu' THEN self.oMenu->HandleEvent, iFaceOp, event
         IF iFaceClass EQ 'AdTool' THEN self.oTool->HandleEvent, event
         IF iFaceClass EQ 'ITCifImage' THEN self.dg_Image->HandleEvent, event

         IF iFaceClass EQ 'ITCifPanel' THEN self.oPanel->HandleEvent, event
         IF iFaceClass EQ 'ITCifSwitch' THEN self.oSwitch->HandleEvent, event
         IF iFaceClass EQ 'ITCdgManager' THEN BEGIN
             rootTree = Widget_Info(event.id, /Tree_Root)
             uName = Widget_Info(rootTree, /UName)
             uName = (Strsplit(uName, '::', /Extract))[1]
             IF uName EQ 'curr' THEN BEGIN
                 self.oCurrDGManager->HandleEvent, event
                 self.currentPrj = self.oCurrDataManage
             ENDIF ELSE BEGIN
                 self.oHistDGManager->HandleEvent, event
                 self.currentPrj = self.oHistDataManage
             ENDELSE
         ENDIF
       ENDELSE
    ENDCASE
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》
;
;廣過完笥砿尖
;
PRO MainSystem::StartXManager

    COMPILE_OPT IDL2

    XManager, 'AnnoDemo', self.tlb, /No_Block, Event_Handler = '_MainSystem_Event',$
            Cleanup = '_MainSystem_Cleanup'
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》
;
;幹秀順中
;
PRO MainSystem::Create

    COMPILE_OPT IDL2

    self.tlb = Widget_Base(UName ='wBase',$
        UValue = self                   , $
        Title = self.title              , $
        MBar = mBar                     , $
        SPACE = 0                       , $
        Map = 0                         , $
        /Column                         , $
        /Tlb_Kill_Request_Events        , $
        /Tlb_Size_Events                  )

    Widget_Control, self.tlb, /Realize

    self.foreColor = (Widget_Info(self.tlb, /System_Colors)).face_3D
    ;幹秀暇汽
    self.oMenu = Obj_New('AdMenu', mBar, OSystem = self)

    ;幹秀住札垢醤生
    self.oTool = Obj_New('AdTool', OSystem = self, parent = self.tlb)
    subBase = Widget_Base(self.tlb      , $
        SPACE = 0                       , $
        XPAD = 0                        , $
        YPAD = 0                        , $
        /Row                              )

    ;兜兵晒扮議完笥寄弌-IDL6.4念議井云,^_^ Copy From CG.^_^
    Device, Get_Screen_Size = screenSize
    xsize = screenSize[0] * 0.999 - 6
    ysize = screenSize[1] * 0.9 - 25 - 20 - 6
    ;
    ;麼中医TLB
    drawBase = Widget_Base(subBase      , $
        SPACE = 0                       , $
        XPAD = 0                        , $
        YPAD = 0                        , $
        /Column                           )
    ;
    oStatus = Widget_Base(self.tlb      , $
        xSize = xSize, ySize = 25         )

    self.oDraw = Obj_New('ADDraw'       , $
        OSystem = self                  , $
        Parent = drawBase               , $
        UName = 'draw'                  , $
        XSize = xsize               , $
        YSize = ysize                 )
    ;
    self.oManager = Obj_New('ADDGManage', $
                   OSystem = self       , $
                   oDraw = self.oDraw   , $
                   UName = 'dataManage')

    Widget_Control, self.tlb, Map = 1
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;裂更
;
PRO MainSystem::Cleanup

    COMPILE_OPT IDL2

    orgTable = BIndgen(256,3)
    Tvlct, orgTable

    Device, Decomposed=self.decomposed
    ;
    Obj_Destroy, self.oMenu
    Obj_Destroy, self.oTool
    Obj_Destroy, self.oDraw
    Obj_Destroy, self.oManager

END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;兜兵晒
;
FUNCTION MainSystem::Init, Title = title, RootDir = rootDir

    COMPILE_OPT IDL2

    Device, Get_Decomposed = decomposed
    self.decomposed = decomposed
    Device, Decomposed = 0

    self.rootDir = rootDir
    self.title = title
    ;塘崔狼由
    self->Create
    ;購選並周
    self->StartXManager

    Return, 1
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;協吶
;
PRO MainSystem__define

    COMPILE_OPT IDL2

    void = {MainSystem                  , $
           ;写覚議幻窃

            ;狼由歌方
            decomposed  :       0       , $
            rootDir     :     ''        , $
            title       :     ''        , $
            signColor   :   IntArr(3)   , $
            foreColor   :   IntArr(3)   , $

            tlb         :    0L         , $
            subBase     :    0L         , $

            ;狼由斤��
            oMenu       :   Obj_New()   , $
            oTool       :   Obj_New()   , $
            oDraw       :   Obj_New()   , $
            oManager    :   Obj_New()     $
            }

END