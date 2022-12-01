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
;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;��ʾͼ���ļ�
;
PRO AdImageLayer::ShowImage, fileName = file

    COMPILE_OPT IDL2

    self.fileName = file
    oManager = (self.oSystem).oManager
    ;
    IF ~Obj_Valid(self.oImage) THEN BEGIN
        self.oImage = Obj_New('IDLgrImage')
        self->Add,self.oImage
    ENDIF
    ;
    data = READ_IMAGE(file)
    ;
    sz = SIZE(data)
    IF sz[0] EQ 3 THEN BEGIN
        ;
        oManager.viewXSize = sz[2]
        oManager.viewYSize = sz[3]

    ENDIF ELSE IF sz[0] EQ 2 THEN BEGIN
        ;
        oManager.viewXSize = sz[1]
        oManager.viewYSize = sz[2]
    ENDIF
     ;
    self.oImage->SetProperty,data = data
    ;
    oManager->ConfigViewRange


END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO AdImageLayer::Cleanup

    COMPILE_OPT IDL2

    self->IDLgrModel::Cleanup

END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;��ʼ��
;
FUNCTION AdImageLayer::Init ,  $
    UName = uName            , $
    Value = value            , $
    Project = project        , $
    Parent = parent

    COMPILE_OPT IDL2

    IF (self->IDLgrModel::Init(_Extra=extra) NE 1) THEN Return, 0

    self.project = project
    self.oSystem = parent.oSystem
    self.uName = uName
    ;
    parent->Add,self
    Return, 1
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO AdImageLayer__Define

    COMPILE_OPT IDL2

    void = {AdImageLayer                , $

        INHERITS IDLgrModel             , $

        ;����
        fileName        :    ''         , $
        uName           :    ''         , $

        ;����
        oSystem         : Obj_New()     , $
        project         : Obj_New()     , $
        oImage          : Obj_New()       }


END