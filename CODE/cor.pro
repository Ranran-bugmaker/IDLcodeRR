pro cor
  extract_lon=116.40
  extract_lat=39.90
  doyf_threshold=30.0/1440.0
  mod04_dir='R:\IDL\resource\MYD04_Aeronet_Compare\'
  aeronet_file= 'R:\IDL\resource\20180101_20181231_Beijing.lev20'
  out_file='R:\IDL\resource\res.csv'
  openw,1,out_file;,width=80000每一行,/append
  PRINTF,1,'时间,地基观测值,卫星产品值'
  aeronet_data=read_csv(aeronet_file,n_table_header=6,header=var_name)
  doy_pos=where(var_name eq 'Day_of_Year(Fraction)')
  aod_pos=where(var_name eq 'AOD_500nm')
  ae_pos=where(var_name eq '500-870_Angstrom_Exponent')
  tt_pos=where(var_name eq 'Triplet_Variability_500')
  aeronet_doyf_data=aeronet_data.(doy_pos)
  aeronet_aod_data_500=aeronet_data.(aod_pos)
  aeronet_ae_data=aeronet_data.(ae_pos)
  aeronet_tt_data=aeronet_data.(tt_pos)
  gr_res=list()
  sr_res=list()
  mod04_list=file_search(mod04_dir+'*.hdf',count=file_n)
  for file_i=0,file_n-1 do begin
    ;时间匹配+-30
    modis_doy=float(strmid(file_basename(mod04_list[file_i]),14,3))
    modis_fraction=(float(strmid(file_basename(mod04_list[file_i]),18,2))*60.0+$
      float(strmid(file_basename(mod04_list[file_i]),20,2)))/1440.0
    modis_doyf=modis_doy+modis_fraction
    doyf_dif=abs(modis_doyf-aeronet_doyf_data)
    doyf_pos=where(doyf_dif le doyf_threshold,pos_n)
    ;空间匹配
    if pos_n le 1 then continue
    aod_data=hdf4_data_get(mod04_list[file_i],'Image_Optical_Depth_Land_And_Ocean')
    aod_sf=hdf4_attdata_get(mod04_list[file_i],'Image_Optical_Depth_Land_And_Ocean','scale_factor')
    aod_data_conv=float(aod_data)*aod_sf[0]
    lon_data=hdf4_data_get(mod04_list[file_i],'Longitude')
    lat_data=hdf4_data_get(mod04_list[file_i],'Latitude')
    distance=sqrt((lon_data-extract_lon)^2.0+(lat_data-extract_lat)^2.0)
    pos=where(distance eq min(distance))
    ;空间匹配结果
    target_aod=aod_data_conv[pos[0]]
    ;时间+-30，500nm匹配结果
    aeornet_aod_550=mean(aeronet_aod_data_500[doyf_pos]*(500.0/550.0)^aeronet_tt_data[doyf_pos])
    CALDAT,JULDAY(1,modis_doyf,2018),mm,dd
    if (distance[pos[0]] le 0.1) and (target_aod gt 0.0) then begin
      printf,1,'2018年'+STRING(mm,FORMAT='(I2)')+"月"+STRING(dd,FORMAT='(I2)')+"日"+','+STRING(aeornet_aod_550,FORMAT='(f0.3)')+','+STRING(target_aod,FORMAT='(f0.3)')
      gr_res.add,aeornet_aod_550
      sr_res.add,target_aod
    endif
  endfor
  x=gr_res.toarray()
  y=sr_res.toarray()
  n=N_ELEMENTS(x)
  r=CORRELATE(x,y)
  myplot=SCATTERPLOT(x,y,XRANGE=[0,1],YRANGE=[0,1],SYMBOL=23,SYM_SIZE=2$
    ,SYM_FILL_COLOR='CORAL',SYM_FILLED=1,TITLE='biubiubibu',$
    xtitle='AERONET AOD(550nm)',ytitle='Satellite AOD(550nm)',DIMENSIONS=[800,800],$
    name='point'+STRTRIM(STRING(N_ELEMENTS(x)),2)+',R='+STRING(r,FORMAT='(f0.3)'))
  fit=LINFIT(x,y)
  fitx=[0,1]
  PRINTF,1,'a,'+STRING(fit[1],FORMAT='(f0.3)')+',b,'+STRING(fit[0],FORMAT='(f0.3)')
  fitline=plot(fitx,fit[0]+fitx*fit[1],/overplot,thick=3,color='light green',name='fitline')
  a=[0,1]
  myline=plot(a,a,/overplot,thick=3,name='1:1 line')
  ;误差线，x取值时y的误差范围
  err11=plot(a,a+0.05+0.15*a,/overplot,thick=3,linestyle=2,color='red')
  err11=plot(a,a-0.05-0.15*a,/overplot,thick=3,linestyle=2,color='red',font_name='times',font_size=18,name='error line')
  lg=LEGEND(TARGET=[myplot,myline,fitline,err11],POSITION=[0.9,0.3])
  myplot.Save,"R:\IDL\resource\mm.png",/BORDER
  myplot.Close
  ee=0
  eel=0
  eeb=0
  for im = 0L, n-1 do begin
    if y[im]gt(x[im]+0.05+0.15*x[im]) then begin
      eeb+=1
    endif else if y[im]le(x[im]-0.05-0.15*x[im]) then begin
      eel+=1
    endif else  BEGIN
      ee+=1
    endelse
  endfor
  PRINTF,1,'>EE,EE,<EE'
  PRINTF,1,STRING(eeb*100.0/n,FORMAT='(f0.1)')+','+STRING(ee*100.0/n,FORMAT='(f0.1)')+','+STRING(eel*100.0/n,FORMAT='(f0.1)')
  PRINTf,1,'R,'+STRING(r,FORMAT='(f0.3)')
  PRINTF,1,'RMSE,'+STRING((SQRT(TOTAL((x-y))^2)/n),FORMAT='(f0.3)')
  free_lun,1
end