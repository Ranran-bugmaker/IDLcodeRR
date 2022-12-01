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
PRO MY_VELOVECT,U,V,X,Y, Missing = Missing, Length = length, Dots = dots,  $
    Color=color, CLIP=clip, NOCLIP=noclip, OVERPLOT=overplot, _EXTRA=extra
  ;
  ON_ERROR,2                      ;Return to caller if an error occurs
  s = SIZE(u)
  t = SIZE(v)
  IF s[0] NE 2 THEN BEGIN
    baduv:   MESSAGE, 'U and V parameters must be 2D and same size.'
  ENDIF
  IF TOTAL(ABS(s[0:2]-t[0:2])) NE 0 THEN GOTO,baduv
  ;
  IF N_PARAMS(0) LT 3 THEN x = FINDGEN(s[1]) ELSE $
    IF N_ELEMENTS(x) NE s[1] THEN BEGIN
    badxy:                  MESSAGE, 'X and Y arrays have incorrect size.'
  ENDIF
  IF N_PARAMS(1) LT 4 THEN y = FINDGEN(s[2]) ELSE $
    IF N_ELEMENTS(y) NE s[2] THEN GOTO,badxy
  ;
  IF N_ELEMENTS(missing) LE 0 THEN missing = 1.0e30
  IF N_ELEMENTS(length) LE 0 THEN length = 1.0
  
  mag = SQRT(u^2.+v^2.)             ;magnitude.
  ;Subscripts of good elements
  nbad = 0                        ;# of missing points
  IF N_ELEMENTS(missing) GT 0 THEN BEGIN
    good = WHERE(mag LT missing)
    IF KEYWORD_SET(dots) THEN bad = WHERE(mag GE missing, nbad)
  ENDIF ELSE BEGIN
    good = LINDGEN(N_ELEMENTS(mag))
  ENDELSE
  
  ugood = u[good]
  vgood = v[good]
  x0 = MIN(x)                     ;get scaling
  x1 = MAX(x)
  y0 = MIN(y)
  y1 = MAX(y)
  x_step=(x1-x0)/(s[1]-1.0)   ; Convert to float. Integer math
  y_step=(y1-y0)/(s[2]-1.0)   ; could result in divide by 0
  
  maxmag=MAX([MAX(ABS(ugood/x_step)),MAX(ABS(vgood/y_step))])
  sina = length * (ugood/maxmag)
  cosa = length * (vgood/maxmag)
  ;
  IF N_ELEMENTS(title) LE 0 THEN title = ''
  ;--------------  plot to get axes  ---------------
  IF N_ELEMENTS(color) EQ 0 THEN color = !p.COLOR
  IF N_ELEMENTS(noclip) EQ 0 THEN noclip = 1
  x_b0=x0-x_step
  x_b1=x1+x_step
  y_b0=y0-y_step
  y_b1=y1+y_step
  IF (not KEYWORD_SET(overplot)) THEN BEGIN
    IF N_ELEMENTS(position) EQ 0 THEN BEGIN
      PLOT,[x_b0,x_b1],[y_b1,y_b0],/nodata,/xst,/yst, $
        color=color, _EXTRA = extra
    ENDIF ELSE BEGIN
      PLOT,[x_b0,x_b1],[y_b1,y_b0],/nodata,/xst,/yst, $
        color=color, _EXTRA = extra
    ENDELSE
  ENDIF
  IF N_ELEMENTS(clip) EQ 0 THEN $
    clip = [!x.CRANGE[0],!y.CRANGE[0],!x.CRANGE[1],!y.CRANGE[1]]
  ;
  r = 0.1                          ;len of arrow head
  angle = 2.5 * !dtor            ;Angle of arrowhead
  st = r * SIN(angle)             ;sin 22.5 degs * length of head
  ct = r * COS(angle)
  ;
  FOR i=0l,N_ELEMENTS(good)-1 DO BEGIN     ;Each point
    x0 = x[good[i] MOD s[1]]        ;get coords of start & end
    dx = sina[i]
    x1 = x0 + dx
    y0 = y[good[i] / s[1]]
    dy = cosa[i]
    y1 = y0 + dy
    xd=x_step
    yd=y_step
    PLOTS,[x0,x1,x1-(ct*dx/xd-st*dy/yd)*xd, $
      x1,x1-(ct*dx/xd+st*dy/yd)*xd], $
      [y0,y1,y1-(ct*dy/yd+st*dx/xd)*yd, $
      y1,y1-(ct*dy/yd-st*dx/xd)*yd], $
      color=color,clip=clip,noclip=noclip
  ENDFOR
  IF nbad GT 0 THEN $             ;Dots for missing?
    PLOTS, x[bad MOD s[1]], y[bad / s[1]], psym=3, color=color, $
    clip=clip,noclip=noclip
END



PRO POLAR_MAP

  DEVICE, decomposed=0
  
  OPENR, 1, FILEPATH('worldelv.dat', subdir = ['examples','data'])
  elev = BYTARR(360,360)
  READU, 1, elev
  CLOSE, 1
  
  
  WINDOW, 1, xsize=750, ysize=700
  LOADCT, 13
  TVLCT, 255, 255, 255, 237
  
  MAP_SET,  /ORTHO, -90, 0, 0, /ISOTROPIC, color=0
  MAP_HORIZON, COLOR=40, FILL=1 ; Blue horizon
  MAP_CONTINENTS, /COASTS, COLOR=237, /fill
  
  !X.THICK = 1 & !Y.THICK = !X.THICK
  !P.THICK = 1
  !X.WINDOW = [0,1]
  !Y.WINDOW = [0,1]
  px = !X.WINDOW * !D.X_VSIZE
  py = !Y.WINDOW * !D.Y_VSIZE
  
  sz=SIZE(elev)
  
  x=0.5+FINDGEN(360) & y=-89.75+FINDGEN(360)/2.
  CONTOUR,elev,x,y, XSTYLE=1, YSTYLE=1, $
    POSITION=[px(0), py(0), px(0)+sz(1)-1, $
    py(0)+sz(2)-1], $
    NLEVELS=8,/overplot,c_colors=FINDGEN(8)*10+92
    
    
  nn=10
  u = RANDOMU(seed, nn, nn)
  v = RANDOMU(seed, nn, nn)
  MY_VELOVECT, u, v, INDGEN(nn)*55, INDGEN(nn)*2-80, COLOR=250, /OVERPLOT, LENGTH=7.0
  
  MAP_GRID, latdel = 30, londel = 30, COLOR=0
  MAP_GRID, latdel = 360, londel = 90, COLOR=30, GLINESTYLE=0
  
END