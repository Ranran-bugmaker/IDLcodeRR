;+
;  ��IDL������ơ�
;   -���ݿ��ӻ���ENVI���ο���
;        
; ʾ������
;
; ����: ������
;
; ��ϵ��ʽ��sdlcdyq@sina.com
;-
;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�
;
;��ͼ����ı��С
;
PRO ADDraw::Resize, newx, newy

    COMPILE_OPT IDL2

    newx = newx > 0
    Widget_Control, self.drawID, Draw_XSize = newx, Draw_YSize = newy, $
                        XSize = newx, YSize = newy

    self.drawSize = [newx, newy]

END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;������ͼ
;
PRO ADDraw::Create

    COMPILE_OPT IDL2

    oSystem = self.oSystem

    self.drawID = Widget_Draw(self.parent   , $
        UName = 'ADDraw::'+self.uName       , $
        Retain = 0                          , $
        XSize = self.drawSize[0]            , $
        YSize = self.drawSize[1]            , $
        Scr_XSize = self.drawSize[0]        , $
        Scr_YSize = self.drawSize[1]        , $
        Graphics_Level = 2                  , $
        /App_Scroll                         , $
        /Button_Events                      , $
        /Keyboard_Events                    , $
        /Wheel_Events                       , $
        /Expose_Events                      , $
        /Motion_Events                     )

    Widget_Control, self.drawID, Get_Value = oWindow
    self.oWindow = oWindow

    oColor = [0,0,0]
    self.oScene = Obj_New('IDLgrScene', Color = oColor)
    self.oWindow->SetProperty, Graphics_Tree = self.oScene
    self.oWindow->SetCurrentCursor, 'ARROW'

END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�
;
;�¼�����
;
PRO ADDraw::HandleEvent, event

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    IF Tag_Names(event, /Structure_Name) EQ 'WIDGET_DRAW' THEN BEGIN
           IF event.type EQ 4 THEN BEGIN
              self.oWindow->Draw
           ENDIF
    ENDIF

    IF Obj_Valid(oSystem.oManager) THEN oSystem.oManager->HandleEvent, event
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO ADDraw::Cleanup

    COMPILE_OPT IDL2


END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;��ʼ��
;
FUNCTION ADDraw::Init, OSystem = oSystem ,$
                            Parent = parent ,$
                            UName = uName   , $
                            XSize = xSize, $
                            YSize = ySize

    COMPILE_OPT IDL2

    self.parent = parent
    self.oSystem = oSystem
    self.drawSize = [xSize, ySize]
    self.uName = uName

    self->Create

    Return, 1
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO ADDraw__Define

    COMPILE_OPT IDL2

    void = {ADDraw                      , $

         ;ϵͳ����
         parent         :   0           , $
         drawSize       :  DblArr(2)    , $
         drawBase       :   0           , $
         drawID         :   0           , $
         uName          :   ''          , $

         ;ϵͳ����
         oSystem        :  Obj_New()    , $
         oScene         :  Obj_New()    , $
         oWindow        :  Obj_New()      $
            }

END