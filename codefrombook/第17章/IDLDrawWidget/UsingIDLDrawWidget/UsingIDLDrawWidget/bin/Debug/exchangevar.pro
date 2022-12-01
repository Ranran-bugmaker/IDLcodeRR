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
;IDLDrawWidget组件下的测试IDL与C#的变量参数传递
PRO EXCHANGEVAR,var = var
  tmp = DIALOG_MESSAGE(var,/infor, $
    title ='IDL Show Dialog_Message')
  var = StrTrim(var,2)+' com from IDL'
END

