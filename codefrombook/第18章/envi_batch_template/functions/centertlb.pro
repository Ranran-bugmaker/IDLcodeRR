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
;屏幕组件居中设置
;
PRO CenterTLB, tlb, x, y, NoCenter=nocenter

  Compile_Opt StrictArr

  geom = Widget_Info(tlb, /Geometry)

  IF N_Elements(x) EQ 0 THEN xc = 0.5 ELSE xc = Float(x[0])
  IF N_Elements(y) EQ 0 THEN yc = 0.5 ELSE yc = 1.0 - Float(y[0])
  center = 1 - Keyword_Set(nocenter)
  ;
  oMonInfo = OBJ_NEW('IDLsysMonitorInfo')
  rects = oMonInfo -> GetRectangles(Exclude_Taskbar=exclude_Taskbar)
  pmi = oMonInfo -> GetPrimaryMonitorIndex()
  OBJ_DESTROY, oMonInfo

  screenSize =rects[[2, 3], pmi]

  ; Get_Screen_Size()
  IF screenSize[0] GT 2000 THEN screenSize[0] = screenSize[0]/2 ; Dual monitors.
  xCenter = screenSize[0] * xc
  yCenter = screenSize[1] * yc

  xHalfSize = geom.Scr_XSize / 2 * center
  yHalfSize = geom.Scr_YSize / 2 * center

  XOffset = 0 > (xCenter - xHalfSize) < (screenSize[0] - geom.Scr_Xsize)
  YOffset = 0 > (yCenter - yHalfSize) < (screenSize[1] - geom.Scr_Ysize)

  Widget_Control, tlb, XOffset=XOffset, YOffset=YOffset
END

Pro AnimateTlb, tlb, scr_xsize, scr_ysize, updown=updown

  Compile_Opt StrictArr

  if Keyword_Set(updown) then begin
   nStep = 20
   Widget_Control, tlb, scr_ysize=1
   for i=0, nStep-1 do begin
     Widget_Control, tlb, $
           scr_xsize=(i+1)*scr_xsize/Float(nStep), $
           scr_ysize=(i+1)*scr_ysize/Float(nStep)
   endfor
  endif

End