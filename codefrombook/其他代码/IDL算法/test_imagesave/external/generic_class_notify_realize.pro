;+
; This routine is called when the TLB widget of any object-based TLB
; is realized. In turn, the ::NOTIFY_REALIZE method of the class whose
; object reference is stored in the specified ID is called.
;
; @Param
;   ID {in}{required}{type=structure}
;     The widget ID of the widget containing the self reference
;     in its UVALUE at the time of widget realization.
;
; @Examples <pre>
;   TLB = Widget_Base(CWParent, UValue = self)
;   UValueBase = Widget_Base(TLB, UName = 'UValueBase', $
;     UValue = self, $
;     Event_Pro = 'Generic_Class_Event', $
;     Kill_Notify = 'Generic_Class_Kill_Notify', $
;     Notify_Realize = 'Generic_Class_Notify_Realize')
;   Widget_Control, TLB, /Realize </pre>
;
; @Uses
;   objref->Notify_Realize
;
; @History
;   February, 2003 : JLP, RSI
;-
Pro Generic_Class_Notify_Realize, ID

	Compile_Opt StrictArr

	On_Error, 2

	Widget_Control, ID, Get_UValue = self

	If (N_elements(self) ne 0) then Begin
	    If (Obj_Valid(self)) then Begin
	        self->Notify_Realize, ID
	    EndIf
	EndIf
End