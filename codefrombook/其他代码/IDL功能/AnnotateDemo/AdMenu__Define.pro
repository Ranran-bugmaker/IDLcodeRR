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
;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》
;
;暇汽並周侃尖沫哈
;
PRO AdMenu::HandleEvent, operator, event

  COMPILE_OPT IDL2
  
  oSystem = self.OSYSTEM
  oDraw = project.ODRAW
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;幹秀暇汽
;
PRO AdMenu::Create

  COMPILE_OPT IDL2
  
  self.MENUID = WIDGET_BUTTON(self.PARENT , $
    Value = '暇汽')
    
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;裂更
;
PRO AdMenu::CLEANUP

  COMPILE_OPT IDL2
  
END

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;兜兵晒
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

;》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》》-
;
;協吶
;
PRO ADMENU__DEFINE

  COMPILE_OPT IDL2
  
  void = {AdMenu                    , $
    ;写覚議幻窃
  
    ;狼由歌方
    parent      :   0           , $
    tlb          : 0             , $
    rootDir       :  ''             , $
    menuID        :  LONARR(5,20,10)   , $
    
    ;狼由斤��
    oSystem       :  OBJ_NEW()       $
    
    }
    
END