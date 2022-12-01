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
;IDLDrawWidget组件下的测试IDL与C#的数组参数传递
PRO EXCHANGEARR,arr,oriArr= oriArr
  tmp = DIALOG_MESSAGE(STRING(arr),/infor,$
    title ='IDL Show Dialog_Message')
  oriArr = arr
  arr = arr+3
END
