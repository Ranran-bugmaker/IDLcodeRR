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
PRO SWINDOW,xsize, ysize, xvis=xvis, yvis=yvis, retain=retain, title=title, wid=wid
  ; xsize & ysize represent the actual size of the image that is to be displayed
  ; xvis & yvis determine the actual visible window size. If xvis/yvis are > xsize/ysize,
  ; scrollbars are added to the window.
  IF N_ELEMENTS(xvis) EQ 0 THEN xvis=700
  IF N_ELEMENTS(yvis) EQ 0 THEN yvis=500
  ; Make sure the viewing area is not larger than the actual image.
  xvis = xsize < xvis
  yvis = ysize < yvis
  
  SLIDE_IMAGE,show=0, slide=wid, xsize=xsize, ysize=ysize, xvis=xvis, yvis=yvis, $
    title=title, retain=retain
  WSET,wid
  
END



; *****************************************************************************
PRO newcols,bw_flag
  ;
  ; bw_flag = 0; white text on black background
  ; bw_flag = 1; black text on white background
  ;
  if n_elements(bw_flag) eq 0 then bw_flag = 0
  
  COMMON colors, orig_red, orig_green, orig_blue, tred, tgreen, tblue
  loadct,0
  
  reds=bytarr(40) & grns=bytarr(40) & blues=bytarr(40)
  
  reds=[40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 20, 47, 73, 99, 125, 163, $
    200, 218, 235, 240, 245, 235, 224, 240, 255, 255, 255, 255, 255, $
    255, 255, 220, 185, 150, 130, 105, 70]
    
  grns=[1, 1, 65,110,115,120,130,140,171,202,229,255,255,255,255,255,255,$
    255,255,255,255,255,255,255,240,224,187,150,133,115,98, 80, 60, $
    40, 32, 24, 15,  1,  1,  1]
    
  blues=[120,155,165,175,188,200,214,228,242,255,255,255,198,140,153,165,$
    178,190,170,150,135,120, 90, 60, 30,  1, 60,120,113,105, 98, 80, $
    68, 45, 30, 15,  1,  1,  1,  1]
    
  ;r2=bytarr(160) & g2=bytarr(160) & b2=bytarr(160)
    
  bb=findgen(160)/4.0
  r2=interpolate(reds,bb)
  g2=interpolate(grns,bb)
  b2=interpolate(blues,bb)
  
  
  FOR i=0L, 159 DO BEGIN  ;fill out with shades of gray to (12,254)
    ;k=i*4
    ;j=k+4
    tred(i)  = r2(i)
    tgreen(i) = g2(i)
    tblue(i) = b2(i)
  ENDFOR
  
  tred(0) = 0   & tblue(0) = 0  & tgreen(0) = 0 ; index 0 - black
  tred(1) = 255   & tblue(1) = 255  & tgreen(1) = 255 ; index 1 - white
  if (bw_flag) then begin
    tred(1) = 0   & tblue(1) = 0  & tgreen(1) = 0 ; index 1 - black
    tred(0) = 255   & tblue(0) = 255  & tgreen(0) = 255 ; index 0 - white
  endif
  
  Tvlct, tred, tgreen, tblue
  
  RETURN
END ; newcols

; *****************************************************************************

;-----------------------------------------------------------------------
;This example illustrates the use of PARTICLE_TRACE to create streamlines
; that will be drawn with PLOTS in direct graphics so that they can be
; projected based on the specified map projection
pro xstream,xs,ys

  xs=2
  ys=2
  
  device,decompose=0
  ;loadct,12
  newcols
  ; The number of grid cells in the x/y directions
  nx=128
  ny=64
  ; The grid cell increment at which to calculate the particle trace
  xstep=xs & ystep=ys
  
  ; Define the arrays to hold the input data
  u=fltarr(nx,ny) & v=fltarr(nx,ny)
  
  ; Open and read the U/V wind fields
  openr,1,file_dirname(routine_filepath('xstream'))+path_sep()+'usurf.dat'
  readu,1,u
  close,1
  openr,1,file_dirname(routine_filepath('xstream'))+path_sep()+'vsurf.dat'
  readu,1,v
  close,1
  
  
  ; Open a window with slider bars
  screen_size = GET_SCREEN_SIZE()
  swindow,800,800,xvis=screen_size[0]-50,yvis=screen_size[1]-100
  ;window,xs=1200,ys=1200
  
  ; Define the array that get passed to PARTICLE_TRACE. Add one
  ; element in the x-direction to account for the wrap around at
  ; 180.0 E/W longitude
  data=FLTARR(2,nx+1,ny)
  uu=fltarr(nx+1,ny)
  vv=fltarr(nx+1,ny)
  uu(0,0) = u
  vv(0,0) = v
  uu(128,*) = u(0,*)
  vv(128,*) = v(0,*)
  help,u,v,uu,vv
  data(0,0:128,0:63) = rotate(uu,7)
  data(1,0:128,0:63) = rotate(vv,7)
  ;data(0,nx,0:63) = u(0,*)
  ;data(1,nx,0:63) = v(0,*)
  
  
  nseeds = 2*LONG(((nx+1)*ny)/(xstep*ystep))
  seeds = FLTARR(nseeds)
  iseed=0L
  for i=0,nx do $
    for j=0,ny-1 do begin
    if( ((i mod xstep) eq 0) and ((j mod ystep) eq 0) and (iseed lt (nseeds-2)) ) then begin
      seeds[iseed] = FLOAT(i)
      seeds[iseed+1] = FLOAT(j)
      iseed = iseed+2
    end
  end
  
  maxIterations=100
  stepSize=.5
  width=.5 ;ribbon thickness
  
  PARTICLE_TRACE,data,seeds,outverts,outconn, $
    MAX_ITERATIONS=maxIterations, MAX_STEPSIZE=stepSize,  $
    INTEGRATION=0,ANISOTROPY=[1,1]
    
    
  MAXsegs=n_elements(outconn)
  MaxVerts = n_elements(outverts)
  ;
  Cindex = 0L
  erase,0
  map_set,0.0,0.0,/ortho,xmargin=[0,0],ymargin=[0,0],/cont,/horizon ;,e_horizon={fill:1,color:1}
  ;mask=tvrd()
  ;mask(where(mask eq 255))=1
  ;stop
  speed1=bytscl(congrid(sqrt(uu*uu+vv*vv),645,320,/interp),top=150)
  img=map_image(speed1,startx,starty)
  tv,img,startx,starty
  
  map_continents,/fill, color=0
  map_grid,color=160
  map_set,0.0,0.0,/ortho,/noerase,/horizon, /clip, color=0,xmargin=[0,0],ymargin=[0,0],mlinethick=2
  
  MapoutvertsX=-180.0 + (360.0 *(outverts[0,*]/129.0))
  MapoutvertsY=-90.0 + (180.0 *(outverts[1,*]/64.0))
  
  while(Cindex) lt MaxSegs do begin
    Numsegs=outconn(Cindex)
    Cindex = Cindex + 1
    i1=outconn[Cindex]
    i2=outconn[Cindex+NumSegs-1]
    plots,MapoutvertsX[i1:i2],MapoutvertsY[i1:i2],/data,color=1
    Cindex=Cindex+Numsegs
  endwhile
  
  
end