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
;
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
PRO _MainSystem_Event, event

    COMPILE_OPT IDL2

    tlbUName = Widget_Info(event.top, /UName)


    CASE tlbUName OF
       'wBase' : BEGIN
         Widget_Control, event.top, Get_UValue = oSystem

         oSystem->HandleEvent, event
       END
       'annotate' : BEGIN
         Widget_Control, event.top, Get_UValue = oDGAnnotate

         oDGAnnotate->HandleEvent, event
       END
    ELSE :
    ENDCASE

END
