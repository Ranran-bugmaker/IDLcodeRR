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
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

PRO Costage5, event

  WIDGET_CONTROL, event.top, get_uvalue=state
  
  ;now unhide the polygons
  state.oBridge->Execute,"oNose->setProperty, hide=0"
  state.oBridge->Execute,"oLeftEye->setProperty, hide=0"
  state.oBridge->Execute,"oRightEye->setProperty, hide=0"
  
  WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
  state.oBridge->Execute,"for i=0,178,1 do begin oTopModel->rotate, [0,1,0],-1 & xObjview, refresh=tlb
  
  WIDGET_CONTROL, state.wText, set_value='IT IS SANTA!'
  
  state.oBridge->Execute,"displayText = ['HO! HO! HO! Merry Christmas!','From Kling Research and Software, inc']
  state.oBridge->Execute,"oFont = obj_new('IDLgrFont','Times*Bold*italic',size=20)
  state.oBridge->Execute,"oText = obj_new('IDLgrText',string=displayText,render=0, " + $
    "location=[[-15,-12],[-15,-17]],color=[0,255,0],font = oFont, align=0.5,/onglass)
  state.oBridge->Execute,"oTopModel->add, oText & xObjview, refresh=tlb"
  
  RETURN & END
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  PRO Costage4, event
  
    WIDGET_CONTROL, event.top, get_uvalue=state
    
    ;Left arm
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oMod6l->translate,-13,-16,0 & oMod6l->rotate, [0,1,0],1 & oMod6l->translate,13,16,0 & oMod9l->translate,-13,-5.5,0 & oMod9l->rotate, [0,1,0],1  & oMod9l->translate,13,5.5,0 & xObjview, refresh=tlb
    
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oLeftModel->translate,-6,13,0 & oLeftModel->rotate, [0,1,0],1 & oLeftModel->translate,6,-13,0 & xObjview, refresh=tlb
    
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oMod8l->translate,-3,0,0 &  oMod8l->rotate, [-1,1,0],1 & oMod8l->translate,3,0,0 & xObjview, refresh=tlb
    
    state.oBridge->Execute,"for i=0,178,1 do begin oMod7l->translate,-6,12,0 & oMod7l->rotate, [1,0,0],1 & oMod7l->translate,6,-12,0 & xObjview, refresh=tlb ;wait, 0.01
    
    ;RIGHT ARM
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oMod6r->translate,16,-13,0 & oMod6r->rotate, [1, 0, 0],-1 & oMod6r->translate,-16,13,0 & oMod9r->translate,5.5,-13,0 & oMod9r->rotate, [1, 0, 0],-1 & oMod9r->translate,-5.5,13,0 ;wait, 0.01 & xObjview, refresh=tlb
    
    
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oRightModel->translate,-13,-6,0 & oRightModel->rotate, [1,0,0],-1 & oRightModel->translate,13,6,0 & xObjview, refresh=tlb
    
    
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oMod8r->translate,0,-3,0 & oMod8r->rotate, [1,-1,0],-1 & oMod8r->translate,0,3,0 & xObjview, refresh=tlb ;wait, 0.01
    
    WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
    state.oBridge->Execute,"for i=0,178,1 do begin oMod7r->translate,12,-6,0 & oMod7r->rotate, [0,1,0],-1 & oMod7r->translate,-12,6,0 & xObjview, refresh=tlb
    
    WIDGET_CONTROL, state.wText,set_value=['We are really close to being done.']
    ;change the button label and event handler
    WIDGET_CONTROL, event.id , set_value='Stage 5', event_pro='coStage5'
    
    RETURN & END
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    PRO Costage3, event
    
      WIDGET_CONTROL, event.top, get_uvalue=state
      ;this resets the orientation
      state.oBridge->Execute,"widget_control, tlb, get_uvalue=pState"
      state.oBridge->Execute, "(*pState).oObjViewWid->onrealize"
      state.oBridge->Execute,"(*pState).oObjViewWid->onexpose"
      
      WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
      state.oBridge->Execute,"for i=0,178,1 do begin oTopModel->rotate, [0,1,0],-1 & xObjview, refresh=tlb
      
      WIDGET_CONTROL, state.wText,set_value=['Now it looks like a bird.']
      ;change the button label and event handler
      WIDGET_CONTROL, event.id , set_value='Stage 4', event_pro='coStage4'
      
      RETURN & END
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      PRO Costage2, event
      
        WIDGET_CONTROL, event.top, get_uvalue=state
        
        WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
        state.oBridge->Execute,"help,oMod3"
        state.oBridge->Execute,"for i=0,177,1 do begin oMod3->translate,-6.0,-6.0,0 & oMod3->rotate, [1, -1, 0], 1 & oMod3->translate,6.0,6.0,0 & xObjview, refresh=tlb
        
        WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
        state.oBridge->Execute,"for i=0,178,1 do begin oMod5->translate,-13,-13,0 & oMod5->rotate, [1,-1,0],-1 & oMod5->translate,13,13,0 & xObjview, refresh=tlb
        
        WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
        state.oBridge->Execute,"for i=0,178,1 do begin oMod4->translate,-10.5,-10.5,0 & oMod4->rotate, [1,-1,0],-1  & oMod4->translate,10.5,10.5,0 & xObjview, refresh=tlb
        
        WIDGET_CONTROL, state.wText,set_value=['Go ahead and rotate it to get a better look','Is it a rocket?']
        ;change the button label and event handler
        WIDGET_CONTROL, event.id , set_value='Stage 3', event_pro='coStage3'
        
        RETURN & END
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        PRO Costart, event
        
          WIDGET_CONTROL, event.top, get_uvalue=state
          
          state.oBridge->Execute,"@christmasorigami_init",/nowait
          ;we have to give the bridge time to execute
          WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
          state.oBridge->Execute,"for i=0,178,1 do begin oMod1->translate,6.5,6.5,0 & oMod1->rotate, [1,-1,0],-1 & oMod1->translate,-6.5,-6.5,0 & xObjview, refresh=tlb",/nowait
          WHILE (state.oBridge->Status() EQ 1) DO WAIT, 0.1
          state.oBridge->Execute," for i=0,178,1 do begin oMod2->translate,13.5, 13.5,0 & oMod2->rotate, [1,-1,0],1 & oMod2->translate, -13.5, -13.5,0 & xObjview, refresh=tlb",/nowait
          
          WIDGET_CONTROL, state.wText,set_value=['So, any ideas?',"It really isn't that hard"]
          ;change the button label and event handler
          WIDGET_CONTROL, event.id , set_value='Stage 2', event_pro='coStage2'
          
          RETURN & END
          
          ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
          
          PRO Cocleanup, base
          
            WIDGET_CONTROL, base, get_uvalue=state
            OBJ_DESTROY, state.oBridge
            
            RETURN & END
            
            ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
            
            PRO Christmasorigami
              ;demonstrates how a fairly complex object model can mimic paper folding
            
              wBase = WIDGET_BASE(title='Christmas Origami', column=1)
              wText = WIDGET_TEXT(wBase, value=['See if you can guess what this is!'], ysize=5, xsize=40)
              wStart = WIDGET_BUTTON(wBase, value='Start', event_pro='coStart')
              
              WIDGET_CONTROL, wBase, /realize
              
              oBridge = OBJ_NEW('IDL_IDLbridge')
              
              state = {wBase:wBase, wText:Wtext, wStart:wStart, oBridge:oBridge}
              
              WIDGET_CONTROL, wBase, set_uvalue=state
              
              Xmanager,'christmasOrigami',wBase,/no_block, cleanup='coCleanup'
              
              RETURN & END
