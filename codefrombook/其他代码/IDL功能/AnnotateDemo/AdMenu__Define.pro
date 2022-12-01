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
;�˵��¼���������
;
PRO AdMenu::HandleEvent, operator, event

  COMPILE_OPT IDL2
  
  oSystem = self.OSYSTEM
  oDraw = project.ODRAW
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;�����˵�
;
PRO AdMenu::Create

  COMPILE_OPT IDL2
  
  self.MENUID = WIDGET_BUTTON(self.PARENT , $
    Value = '�˵�')
    
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO AdMenu::CLEANUP

  COMPILE_OPT IDL2
  
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;��ʼ��
;
FUNCTION AdMenu::INIT, parent, OSystem = oSystem


  COMPILE_OPT IDL2
  
  IF ~KEYWORD_SET(menuArr) THEN menuArr = STRARR(1,10,50)
  
  self.PARENT = parent
  
  self.OSYSTEM = oSystem
  
  self.TLB = oSystem.TLB
  self.ROOTDIR = oSystem.ROOTDIR
  
  self->CREATE
  
  RETURN, 1
END

;�աաաաաաաաաաաաաաաաաաաաաաաաաաաաաաա�-
;
;����
;
PRO ADMENU__DEFINE

  COMPILE_OPT IDL2
  
  void = {AdMenu                    , $
    ;�̳еĸ���
  
    ;ϵͳ����
    parent      :   0           , $
    tlb          : 0             , $
    rootDir       :  ''             , $
    menuID        :  LONARR(5,20,10)   , $
    
    ;ϵͳ����
    oSystem       :  OBJ_NEW()       $
    
    }
    
END