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
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
PRO _MainSystem_Cleanup, tlb

    COMPILE_OPT IDL2

    tlbUName = Widget_Info(tlb, /UName)

    CASE tlbUName OF
       'wBase' : BEGIN
         Widget_Control, tlb, Get_UValue = oSystem

         IF N_Elements(oSystem) EQ 0 THEN Heap_GC ELSE Obj_Destroy, oSystem
       END
    ELSE :
    ENDCASE

END