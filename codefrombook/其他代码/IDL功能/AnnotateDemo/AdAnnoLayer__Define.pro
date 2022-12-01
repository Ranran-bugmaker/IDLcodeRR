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
;;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;ɾ�������Ӳ�
;
PRO AdAnnoLayer::DeleteAllLayer

    COMPILE_OPT IDL2

    oObj = self->Get(/All, Count = count)
    IF count GT 0 THEN BEGIN
       FOR i=0, count-1 DO $
         Obj_Destroy, oObj[i]
    ENDIF

END
;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-;
;�����Ӳ�
;
PRO AdAnnoLayer::Refresh

    COMPILE_OPT IDL2

    oAnnotate = self->Get(/All, Count = count)
    IF count EQ 0 THEN Return
    oSystem = self.oSystem
    oManager = oSystem.oManager
    oManager.oView->GetProperty, Dimensions = viewDim, Viewplane_Rect = myView
    ratio = myView[2]/viewDim[0]

    FOR i=0,count-1 DO BEGIN
       oAnnotate[i]->RefreshDraw, ratio = ratio
    ENDFOR

END
;


;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-;
;�����Ӳ�
;
PRO AdAnnoLayer::AddChild, object

    COMPILE_OPT IDL2

    ; �����ӵı�ע����������
    Self->Add, object, pos = 0

END
;
;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO AdAnnoLayer::Cleanup

    COMPILE_OPT IDL2

    self->IDLgrModel::Cleanup

END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;��ʼ��
;
FUNCTION AdAnnoLayer::Init  , $
    UName = uName           , $
    Value = value           , $
    Project = project       , $
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
PRO AdAnnoLayer__Define

    COMPILE_OPT IDL2

    void = {AdAnnoLayer                , $

        INHERITS IDLgrModel             , $

        ;����
        fileName        :    ''         , $
        uName           :    ''         , $

        ;����
        oSystem         : Obj_New()     , $
        project         : Obj_New()     , $
        oImage          : Obj_New()       }


END