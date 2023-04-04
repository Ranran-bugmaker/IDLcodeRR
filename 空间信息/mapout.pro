pro mapout
  output_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outpng\tatal.csv"
  openw, 1, output_file
  printf,1,"组别,idw_RMSE,idw_MAE,idw_MRE,idw_R2,ormin,ormax,vamin,vamax,kri_RMSE,kri_MAE,kri_MRE,kri_R2,ormin,ormax,vamin,vamax"
  for icsv = 0L, 4 do begin
    input_file_idw = 'R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outcsv\Idw_shp'+STRCOMPRESS(STRING(icsv+1), /REMOVE_ALL)+'.csv'
    input_file_kri = 'R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outcsv\Kriging_shp'+STRCOMPRESS(STRING(icsv+1), /REMOVE_ALL)+'.csv'
    data_idw=READ_CSV(input_file_idw,HEADER=heads_idw)
    data_kri=READ_CSV(input_file_kri,HEADER=heads_kri)
    
    
    or_idw=data_idw.FIELD5
    va_idw=data_idw.FIELD4
    x=or_idw
    y=va_idw
;    nx=[FLOOR(MIN(x)*0.9),CEIL(max(x)*1.1),FLOOR(MIN(y)*0.9),CEIL(max(y)*1.1)]
    nx=[6,38]
    mae_idw=TOTAL(ABS(va_idw-or_idw)) / N_ELEMENTS(or_idw)
    mre_idw=TOTAL(ABS(va_idw-or_idw)  / or_idw) / N_ELEMENTS(or_idw)
    rmse_idw=SQRT(TOTAL(ABS(va_idw-or_idw)) / N_ELEMENTS(or_idw))
    r=CORRELATE(x,y);协方差
    nametitle="第"+STRING(icsv+1,FORMAT='(i0)')+"组idw插值散点图"
    myplot=SCATTERPLOT(x,y,XRANGE=[MIN(nx),max(nx)],YRANGE=[MIN(nx),max(nx)],SYMBOL=24,SYM_SIZE=0.5$
      ,SYM_FILL_COLOR='b',SYM_FILLED=1,TITLE=nametitle,$
      xtitle='观测值/℃',ytitle='预测值/℃',DIMENSIONS=[800,800],FONT_SIZE=18)
    fit=LINFIT(x,y)
    fitx=[MIN(nx),max(nx)]
    namefit='y='+STRING(fit[1],FORMAT='(f0.4)')+'x+'+STRING(fit[0],FORMAT='(f0.4)')
    fitline=plot(fitx,fit[0]+fitx*fit[1],/overplot,thick=3,color='gold',name=namefit)
    a=[MIN(nx),max(nx)]
    myline=plot(a,a,/overplot,thick=3,name='1:1 line')
    err11=plot(a,a+0.05+0.15*a,/overplot,thick=3,linestyle=2,color='red')
    err11=plot(a,a-0.05-0.15*a,/overplot,thick=3,linestyle=2,color='red',font_size=15,name='error line')
;    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[myline,fitline,err11],POSITION=[0.9,0.3])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[myline],POSITION=[0.35,0.82250001])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[fitline],POSITION=[0.49,0.86000000])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[err11],POSITION=[0.553000,0.82125000])
    
    RR_idw=1  - TOTAL((va_idw-or_idw)^2)  / TOTAL(((TOTAL(or_idw)/N_ELEMENTS(or_idw)) -  or_idw)^2)
    stringa='RMSE='+STRING(rmse_idw,FORMAT='(f0.4)')+'  MAE  ='+STRING(mae_idw,FORMAT='(f0.4)')+$
      '!CMRE  ='+STRING(mre_idw,FORMAT='(f0.4)')+'  R!E2!N      ='+STRING(RR_idw,FORMAT='(f0.4)')
    text0=Text(0.17, 0.780,stringa , VERTICAL_ALIGNMENT=1.00000)
    myplot.Save,"R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outpng\group_idw_"+STRCOMPRESS(STRING(icsv+1), /REMOVE_ALL)+'.png',/BORDER
    myplot.Close
    
    
    
    or_kri=data_kri.FIELD5
    va_kri=data_kri.FIELD4
    x=or_kri
    y=va_kri
;    nx=[FLOOR(MIN(x)*0.9),CEIL(max(x)*1.1),FLOOR(MIN(y)*0.9),CEIL(max(y)*1.1)]
    mae_kri=TOTAL(ABS(va_kri-or_kri)) / N_ELEMENTS(or_kri)
    mre_kri=TOTAL(ABS(va_kri-or_kri)  / or_kri) / N_ELEMENTS(or_kri)
    rmse_kri=SQRT(TOTAL(ABS(va_kri-or_kri)) / N_ELEMENTS(or_kri))
    r=CORRELATE(x,y);协方差
    nametitle="第"+STRING(icsv+1,FORMAT='(i0)')+"组普通克里金插值散点图"
    myplot=SCATTERPLOT(x,y,XRANGE=[MIN(nx),max(nx)],YRANGE=[MIN(nx),max(nx)],SYMBOL=24,SYM_SIZE=0.5$
      ,SYM_FILL_COLOR='b',SYM_FILLED=1,TITLE=nametitle,$
      xtitle='观测值/℃',ytitle='预测值/℃',DIMENSIONS=[800,800],FONT_SIZE=18)
    fit=LINFIT(x,y)
    fitx=[MIN(nx),max(nx)]
    namefit='y='+STRING(fit[1],FORMAT='(f0.4)')+'x+'+STRING(fit[0],FORMAT='(f0.4)')
    fitline=plot(fitx,fit[0]+fitx*fit[1],/overplot,thick=3,color='gold',name=namefit)
    a=[MIN(nx),max(nx)]
    myline=plot(a,a,/overplot,thick=3,name='1:1 line')
    err11=plot(a,a+0.05+0.15*a,/overplot,thick=3,linestyle=2,color='red')
    err11=plot(a,a-0.05-0.15*a,/overplot,thick=3,linestyle=2,color='red',font_size=15,name='error line')
    ;    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[myline,fitline,err11],POSITION=[0.9,0.3])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[myline],POSITION=[0.35,0.82250001])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[fitline],POSITION=[0.49,0.86000000])
    lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[err11],POSITION=[0.553000,0.82125000])

    RR_kri=1  - TOTAL((va_kri-or_kri)^2)  / TOTAL(((TOTAL(or_kri)/N_ELEMENTS(or_kri)) -  or_kri)^2)
    stringa='RMSE='+STRING(rmse_kri,FORMAT='(f0.4)')+'  MAE  ='+STRING(mae_kri,FORMAT='(f0.4)')+$
      '!CMRE  ='+STRING(mre_kri,FORMAT='(f0.4)')+'  R!E2!N      ='+STRING(RR_kri,FORMAT='(f0.4)')
    text0=Text(0.17, 0.780,stringa , VERTICAL_ALIGNMENT=1.00000)
    myplot.Save,"R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outpng\group_kri_"+STRCOMPRESS(STRING(icsv+1), /REMOVE_ALL)+'.png',/BORDER
    myplot.Close
    PRINTF,1,STRING(icsv,FORMAT='(I2)')+','+$
      STRING(rmse_idw,FORMAT='(f0.4)')+','+STRING(mae_idw,FORMAT='(f0.4)')+','+STRING(mre_idw,FORMAT='(f0.4)')+','+STRING(RR_idw,FORMAT='(f0.4)')+','+$
      STRING(MIN(or_idw),FORMAT='(f0.4)')+','+STRING(max(or_idw),FORMAT='(f0.4)')+','+STRING(MIN(va_idw),FORMAT='(f0.4)')+','+STRING(max(va_idw),FORMAT='(f0.4)')+','+$
      STRING(rmse_kri,FORMAT='(f0.4)')+','+STRING(mae_kri,FORMAT='(f0.4)')+','+STRING(mre_kri,FORMAT='(f0.4)')+','+STRING(RR_kri,FORMAT='(f0.4)')+','+$
      STRING(MIN(or_kri),FORMAT='(f0.4)')+','+STRING(max(or_kri),FORMAT='(f0.4)')+','+STRING(MIN(va_kri),FORMAT='(f0.4)')+','+STRING(max(va_kri),FORMAT='(f0.4)')
    ha=ABS(va_idw-or_idw)
    hb=ABS(va_kri-or_kri)
    hc=HISTOGRAM(ha, NBINS=10)
    hd=HISTOGRAM(hb,NBINS=10)
    nametitle="第"+STRING(icsv+1,FORMAT='(i0)')+"组气温绝对误差图/℃"
    x=BARPLOT(hc,INDEX=0,NBARS=2,xtitle="绝对误差值/℃",ytitle="频数",NAME="IDW",TITLE=nametitle,DIMENSIONS=[800,800],font_size=15)
    y=BARPLOT(hd,INDEX=1,NBARS=2,NAME="O-Kriging",FILL_COLOR='r',/OVERPLOT);,PATTERN_SPACING=6,PATTERN_ORIENTATION=45,PATTERN_THICK=2
    lee=LEGEND(TARGET=[x,y],POSITION=[0.88000000,0.83875000],TRANSPARENCY=50,DEVICE=0)
    x.Save,"R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outpng\group_abs_"+STRCOMPRESS(STRING(icsv+1), /REMOVE_ALL)+'.png',/BORDER
    x.Close
  endfor

  close, 1
end