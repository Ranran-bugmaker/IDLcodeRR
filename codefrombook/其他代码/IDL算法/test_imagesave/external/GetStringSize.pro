;
;
;
Function GetStringSize, str, fontname=fontname

	Compile_Opt Strictarr

    tlb = Widget_Base()
    if N_Elements(fontname) eq 0 then $
    	strsize = Widget_Info(tlb, STRING_SIZE=str) $
    else strsize = Widget_Info(tlb, STRING_SIZE=[str, fontname])
;    Print, strsize
;          113          13
    Widget_Control, tlb, /Destroy

	Return, strsize
End