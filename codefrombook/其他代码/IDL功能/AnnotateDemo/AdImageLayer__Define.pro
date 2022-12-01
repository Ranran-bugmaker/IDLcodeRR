;+
;  ゞIDL殻會譜柴〃
;   -方象辛篇晒嚥ENVI屈肝蝕窟
;        
; 幣箭旗鷹
;
; 恬宀: 境刔売
;
; 選狼圭塀��sdlcdyq@sina.com
;-
;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;�塋祥赦駑勅�
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

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;裂更
;
PRO AdImageLayer::Cleanup

    COMPILE_OPT IDL2

    self->IDLgrModel::Cleanup

END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;兜兵晒
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

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;協吶
;
PRO AdImageLayer__Define

    COMPILE_OPT IDL2

    void = {AdImageLayer                , $

        INHERITS IDLgrModel             , $

        ;歌方
        fileName        :    ''         , $
        uName           :    ''         , $

        ;斤��
        oSystem         : Obj_New()     , $
        project         : Obj_New()     , $
        oImage          : Obj_New()       }


END