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
;ENVI现有菜单上添加菜单示例
PRO MY_PROCESS_DEFINE_BUTTONS, buttonInfo
  COMPILE_OPT IDL2
  ;在Basic Tools下第一个Preprocessing最后添加New Tools的菜单
  ENVI_DEFINE_MENU_BUTTON, buttonInfo, VALUE = 'New Tools', $
    /MENU, REF_VALUE = 'Preprocessing', REF_INDEX = 0, $
    POSITION = 'last'
  ;在新菜单New Tools下添加子菜单Tool 1
  ENVI_DEFINE_MENU_BUTTON, buttonInfo, VALUE = 'Tool 1', $
    UVALUE = 'tool 1', EVENT_PRO = 'my_process_event', $
    REF_VALUE = 'New Tools'    
END
;
;;ENVI主菜单添加菜单示例
;PRO MY_PROCESS_DEFINE_BUTTONS, buttonInfo
;  COMPILE_OPT IDL2
;  ;在主菜单Basic Tools的后面添加菜单"My Menu"
;  ENVI_DEFINE_MENU_BUTTON, buttonInfo, $
;    value = 'My Menu', /menu, $
;    ref_value = 'Basic Tools', $
;    /sibling, position = 'after'
;
;  ;在My Menu菜单最后添加菜单option1，事件响应程序为my_process
;  ENVI_DEFINE_MENU_BUTTON, buttonInfo, $
;    value = 'Option 1', uvalue = 'option 1', $
;    event_pro = 'my_process', $
;    ref_value = 'My Menu', position = 'last'
;
;  ;在My Menu菜单最后添加菜单option2，事件响应程序为my_process
;  ENVI_DEFINE_MENU_BUTTON, buttonInfo, $
;    value = 'Option 2', uvalue = 'option 2', $
;    event_pro = 'my_process', $
;    ref_value = 'My Menu', position = 'last'
;
;  ;在My Menu菜单最后添加菜单option3，显示分隔线，事件响应程序为my_process
;  ENVI_DEFINE_MENU_BUTTON, buttonInfo, $
;    value = 'Option 3', uvalue = 'option 3', $
;    event_pro = 'my_process_event', $
;    ref_value = 'My Menu', position = 'last', $
;    /separator
;END


;ENVI功能扩展函数
PRO MY_PROCESS,event
  COMPILE_OPT IDL2
  ;
  ENVI_SELECT,title='请选择一个文件',fid=in_fid
  IF(in_fid EQ -1) THEN RETURN
  ENVI_FILE_QUERY,in_fid,ns=ns,nl=nl,nb=nb,fname=fname
  tmp = DIALOG_MESSAGE(fname,/info)
END

