;+
; This routine is called when an event occurs in any object-based TLB.
; In turn, the ::EVENT method of the class whose object reference is
; stored in the EVENT.HANDLER's UVALUE is called.
;
; @Param
;   Event {in}{required}{type=structure}
;     Any sort of IDL GUI event
;
; @Examples <pre>
;   Widget_Control, TLB, Set_UValue = self, $
;     Event_Pro = 'Generic_Class_Event'
;   XMANAGER, 'GENERIC_CLASS', TLB </pre>
;
; @History
;   June, 2001 : JLP, RSI
;-
Pro Generic_Class_Event, Event

   COMPILE_OPT STRICTARR

   Widget_Control, Event.Handler, Get_UValue = oSelf

   If (N_elements(oSelf) eq 1) then Begin
     If (Obj_Valid(oSelf)) then Begin
   ;
   ; A class that uses this routine must have a method
   ; named "::EVENT".
   ;
      oSelf->Event, Event
     EndIf
   EndIf
End