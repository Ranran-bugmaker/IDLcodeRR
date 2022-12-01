;+
; This routine is called when any object-based
; TLB is destroyed, either via the system menu
; or via WIDGET_CONTROL, /DESTROY.  In general it
; will not be called directly by the user's code
; but will be specified via the KILL_NOTIFY keyword
; to WIDGET_CONTROL.
;
; <p>
; The ::Destruct method is called on the object reference.</p>
;
; @Examples <pre>
;	Widget_Control, TLB, Set_UValue = self
;	Widget_Control, TLB, Kill_Notify = 'Generic_Class_Kill_Notify'
;	Widget_Control, TLB, Event_Pro = 'Generic_Class_Event'
;	XManager, 'Generic_Class', TLB </pre>
;
; @Param
;	ID {in}{required}{type=long}
;		The widget ID of the top-level base containing
;		the "self" reference.
; @History
;	February, 2002 : JLP, RSI
;-
Pro Generic_Class_Kill_Notify, ID

	Compile_Opt StrictArr

	Widget_Control, ID, Get_UValue = self

	If (N_elements(self) eq 1) then Begin
		If (Obj_Valid(self)) then Begin
	;
	; Any class that uses this routine must
	; have a method named "::DESTRUCT".
	;
			self->Destruct
		EndIf
	EndIf
End