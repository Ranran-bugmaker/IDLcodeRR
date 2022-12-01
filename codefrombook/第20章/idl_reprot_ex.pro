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
PRO IDL_Reprot_Ex

  tlb = WIDGET_BASE(xsize = 400,ysize =300)
  WIDGET_CONTROL,tlb,/real
  ;
  ;IDL的iTools自带进度条
  prsbar = IDLITWDPROGRESSBAR(GROUP_LEADER = tlb,title ='进度',CANCEL=cancelIn)
  FOR i=0,99 DO BEGIN
    ;判断是否点击取消
    IF WIDGET_INFO(prsbar,/valid) THEN  BEGIN
      IDLITWDPROGRESSBAR_SETVALUE,prsbar,i
    ENDIF ELSE BEGIN
      tmp = DIALOG_MESSAGE('点击了取消,当前进度位置'+STRING(i)+'%',/info)
      BREAK
    ENDELSE
    ;等待0.1秒
    WAIT,0.1
  ENDFOR
  Widget_Control,tlb,/destroy
  
END