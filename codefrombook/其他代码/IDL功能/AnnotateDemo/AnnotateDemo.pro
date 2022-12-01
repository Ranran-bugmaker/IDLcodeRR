;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;2008-7-25
;Write By DYQ
;
PRO AnnotateDemo
    ;
    COMPILE_OPT idl2
    Device, Get_Screen_Size = screenSize

    Cd, Current = rootDir

    oSystem = Obj_New('mainSystem'  , $
            Title = '标注演示软件'  , $
         RootDir = rootDir            )

END