pro gcsj_04
  RESTORE,'R:\PROject_practice\DATA_2csv\data.sav'
  RESTORE,'R:\PROject_practice\DATA_2csv\yandm.sav'
  names=["小麦","水体","建筑"]
  bandnames=["Gamma0_VH","Gamma0_VV","Sigma0_VH","Sigma0_VV","Gamma_diff","Gamma_ratio"]
  for shpi = 0L, 2L do begin
    for bndi = 0L, N_ELEMENTS(datav[0,0,0,*])-1 do begin
      xmax=max(datav[shpi,*,*,bndi])
      xmin=min(datav[shpi,*,*,bndi])
      all=xmax-xmin
      dtx=all*0.1
      p=plot([1,2,3,4,5,6,7,8,9],datav[shpi,0,*,bndi],DIMENSIONS=[1200,600],XRANGE=[0.5,9.5],YRANGE=[xmin-dtx,xmax+dtx])
      p.xtickinterval=1
      ;  p.xmajor=11
      p.color=fix(randomu(undefinevar,3)*255)
      p.title=bandnames[bndi]+names[shpi]
      p.xminor=0
      p.xtickname=s
      p.xticklen=0.03
      p.thick=3
      p.xtitle="时期"
      p.ytitle="强度值/DB"
      ;  p.ytickinterval=2
      p.color=[230,126,163]
      for pi = 1L, N_ELEMENTS(datav[shpi,*,0,0])-1 do begin
        p1=plot([1,2,3,4,5,6,7,8,9],datav[shpi,pi,*,bndi],/overplot)
        p1.color=fix(randomu(undefinevar,3)*255)
        p1.thick=3
      endfor
      p.save,"R:\PROject_practice\DATA_2csv\png\"+bandnames[bndi]+'-'+names[shpi]+'.png',/BORDER
      p.close
    endfor
  endfor


  for bndi = 0L, N_ELEMENTS(datav[0,0,0,*])-1 do begin
    data_xm=FLTARR(N_ELEMENTS(datav[0,0,*,0]))
    data_water=FLTARR(N_ELEMENTS(datav[1,0,*,0]))
    data_bulid=FLTARR(N_ELEMENTS(datav[2,0,*,0]))
    for timei = 0L, N_ELEMENTS(datav[0,0,*,0])-1 do begin
      data_xm[timei]=mean(datav[0,*,timei,bndi])
      data_water[timei]=mean(datav[1,*,timei,bndi])
      data_bulid[timei]=mean(datav[2,*,timei,bndi])
    endfor
    data_all=[data_xm,data_WATER,data_BULID]
    xmax=max(data_all)
    xmin=min(data_all)
    all=xmax-xmin
    dtx=all*0.1
    p=plot([1,2,3,4,5,6,7,8,9],DIMENSIONS=[1200,600],XRANGE=[0.5,9.5],YRANGE=[xmin-dtx,xmax+dtx])
    p.xtickinterval=1
    ;  p.xmajor=11
    p.title=bandnames[bndi]
    p.xminor=0
    p.xtickname=s
    p.xticklen=0.03
    p.thick=3
    p.xtitle="时期"
    p.ytitle="强度值/DB"

    p1=plot([1,2,3,4,5,6,7,8,9],data_xm,/overplot,color='g',thick=2,name="小麦均值曲线")
    p2=plot([1,2,3,4,5,6,7,8,9],data_water,/overplot,color='b',thick=2,name="水体均值曲线")
    p3=plot([1,2,3,4,5,6,7,8,9],data_bulid,/overplot,color='r',thick=2,name="建筑均值曲线")
    lg=LEGEND(TARGET=[p1,p2,p3],POSITION=[0.94,0.89],FONT_NAME='simsun')
    ;lg.FONT_NAME='华文楷体'
    p.translate,/reset
    p.position=[.07,.12,.82,.90]
    p.save,'R:\PROject_practice\DATA_2csv\png\'+bandnames[bndi]+"-mean.png",/BORDER
    p.close
  endfor


  ;  datan=list()
  ;  datan.add,mean(datav[0,*,0,0])
  ;
  ;  p=plot([1,2,3,4,5,6,7,8,9])

  ;  WRITE_TIFF,'R:\PROject_practice\TEMP\GVHA.tif',img,/FLOAT,GEOTIFF=geo
  print,"over"
end