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

PRO USINGJAVA
  JObj      = OBJ_NEW("IDLJavaObject$java_display_image", "Java_display_image", $
    "IDL calling JAVA", $
    FILEPATH('avhrr.png', SUBDIRECTORY=['examples','data']), $
    720, 360)
END