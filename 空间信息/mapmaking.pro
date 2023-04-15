pro mapmaking
  data_path='R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outtif\'
  outpath='R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outpng\'
  range=[5,35]
  file_list=file_search(data_path,'*.tif')
  file_n=n_elements(file_list)
  a=READ_TIFF(file_list[0],GEOTIFF=geo1)
  dz=SIZE(a)
  TA=FLTARR(dz[1],dz[2])
  TA[WHERE(a eq  -3.4028235e+038)]=!VALUES.F_NAN
  TB=FLTARR(dz[1],dz[2])
  TB[WHERE(a eq  -3.4028235e+038)]=!VALUES.F_NAN
  FOR i=0L,file_n-1,1 DO BEGIN
    a=READ_TIFF(file_list[i],GEOTIFF=geo1)
    a[WHERE(a eq  -3.4028235e+038)]=!VALUES.F_NAN
    dz=SIZE(a)
    geokeys={$
    w:geo1.MODELTIEPOINTTAG[4],$
    a:geo1.MODELTIEPOINTTAG[3],$
    d:dz[1]*geo1.MODELPIXELSCALETAG[0] + geo1.MODELTIEPOINTTAG[3],$
    s:geo1.MODELTIEPOINTTAG[4]-dz[2]*geo1.MODELPIXELSCALETAG[1]}
    loadct, 33
    TVLCT, r, g, b, /get
    color_table = BYTARR(3, 256)
    color_table[0, *] = r
    color_table[1, *] = g
    color_table[2, *] = b
;    color_table[*, 0] = [255, 255, 255]  ;Custom colorbar
;    1078.242314/0.01
    names={$
    Idw_shp:"IDW插值结果",$
    Kriging_shp:"O-Kriging插值结果"$
    }
    x=FILE_BASENAME(file_list[i],'.tif')
    if (strmid(x,0,STRLEN(x)-1) eq "Idw_shp") then begin
      titles= '第' + strmid(x,0,1,/REVERSE_OFFSET) +"组"+names.idw_shp
      TA+=a
    endif else begin
      titles= '第' + strmid(x,0,1,/REVERSE_OFFSET) +"组"+names.Kriging_shp
      TB+=a
    endelse

    img=image(ROTATE(a,7),rgb_table=color_table,TITLE=titles,IMAGE_LOCATION=[geokeys.a,geokeys.s],$
      POSITION=[0.1,0.15,0.9,0.95],DIMENSIONS=[800,650],$
      image_dimensions=[ (geokeys.d-geokeys.a) , (geokeys.w-geokeys.s)],/overplot)
    imgmi=MAP('Geographic',LIMIT=[geokeys.s-1,geokeys.a-1,geokeys.w+1,geokeys.d+1],$
      /BOX_AXES,/overplot)
    migrid=imgmi.MAPGRID
    migrid.linestyle=6
    migrid.GRID_LONGITUDE=10
    migrid.label_position=0
    migrid.BOX_AXES = 1
    migrid.GRID_LATITUDE=2
    migrid.GRID_LONGITUDE=2
    migrid['Latitudes'].LABEL_ANGLE = 90
    migrid['Longitudes'].LABEL_ANGLE = 0
    img.MAX_VALUE=range[1]
    img.MIN_VALUE=range[0]
    

    ; add colorbar
    c = COLORBAR(TARGET=img, ORIENTATION=0,TITLE="气温/℃",POSITION=[0.12,0.08,0.88,0.12],font_name = 'Microsoft Yahei');
    c.RANGE=range
    c.BORDER=0
    c.TICKDIR= 1
    c.TEXTPOS = 0
    c.MAJOR=11
    c.TAPER=1
    ;save plot in jpg format with resolution
    Img.save,outpath+titles+'.png',/BORDER
    img.Close
  endfor
  TA[WHERE(TA ne  -3.4028235e+038)]=TA[WHERE(TA ne  -3.4028235e+038)]/5
  img=image(ROTATE(TA,7),rgb_table=color_table,TITLE="平均IDW插值结果",IMAGE_LOCATION=[geokeys.a,geokeys.s],$
    POSITION=[0.1,0.15,0.9,0.95],DIMENSIONS=[800,650],$
    image_dimensions=[ (geokeys.d-geokeys.a) , (geokeys.w-geokeys.s)],/overplot)
    imgmi=MAP('Geographic',LIMIT=[geokeys.s-1,geokeys.a-1,geokeys.w+1,geokeys.d+1],$
    /BOX_AXES,/overplot)
  migrid=imgmi.MAPGRID
  migrid.linestyle=6
  migrid.GRID_LONGITUDE=10
  migrid.label_position=0
  migrid.BOX_AXES = 1
  migrid.GRID_LATITUDE=2
  migrid.GRID_LONGITUDE=2
  migrid['Latitudes'].LABEL_ANGLE = 90
  migrid['Longitudes'].LABEL_ANGLE = 0
  img.MAX_VALUE=range[1]
  img.MIN_VALUE=range[0]
  c = COLORBAR(TARGET=img, ORIENTATION=0,TITLE='气温/℃',POSITION=[0.12,0.08,0.88,0.12],font_name = 'Microsoft Yahei');
  c.RANGE=range
  c.BORDER=0
  c.TICKDIR= 1
  c.TEXTPOS = 0
  c.MAJOR=11
  c.TAPER=1
  Img.save,outpath+"平均IDW插值结果"+'.png',/BORDER
  
  
  
  TB[WHERE(TB ne  -3.4028235e+038)]=TB[WHERE(TB ne  -3.4028235e+038)]/5
  img=image(ROTATE(TB,7),rgb_table=color_table,TITLE="平均O-Kriging插值结果",IMAGE_LOCATION=[geokeys.a,geokeys.s],$
    POSITION=[0.1,0.15,0.9,0.95],DIMENSIONS=[800,650],$
    image_dimensions=[ (geokeys.d-geokeys.a) , (geokeys.w-geokeys.s)],/overplot)
  imgmi=MAP('Geographic',LIMIT=[geokeys.s-1,geokeys.a-1,geokeys.w+1,geokeys.d+1],$
    /BOX_AXES,/overplot)
  migrid=imgmi.MAPGRID
  migrid.linestyle=6
  migrid.GRID_LONGITUDE=10
  migrid.label_position=0
  migrid.BOX_AXES = 1
  migrid.GRID_LATITUDE=2
  migrid.GRID_LONGITUDE=2
  migrid['Latitudes'].LABEL_ANGLE = 90
  migrid['Longitudes'].LABEL_ANGLE = 0
  img.MAX_VALUE=range[1]
  img.MIN_VALUE=range[0]
  c = COLORBAR(TARGET=img, ORIENTATION=0,TITLE='气温/℃',POSITION=[0.12,0.08,0.88,0.12],font_name = 'Microsoft Yahei');
  c.RANGE=range
  c.BORDER=0
  c.TICKDIR= 1
  c.TEXTPOS = 0
  c.MAJOR=11
  c.TAPER=1
  Img.save,outpath+"平均O-Kriging插值结果"+'.png',/BORDER
  img.Close
  
  
  TC=TA-TB
  img=image(ROTATE(TC,7),rgb_table=color_table,TITLE="俩种插值结果差值空间分布",IMAGE_LOCATION=[geokeys.a,geokeys.s],$
    POSITION=[0.1,0.15,0.9,0.95],DIMENSIONS=[800,650],$
    image_dimensions=[ (geokeys.d-geokeys.a) , (geokeys.w-geokeys.s)],/overplot)
  imgmi=MAP('Geographic',LIMIT=[geokeys.s-1,geokeys.a-1,geokeys.w+1,geokeys.d+1],$
    /BOX_AXES,/overplot)
  migrid=imgmi.MAPGRID
  migrid.linestyle=6
  migrid.GRID_LONGITUDE=10
  migrid.label_position=0
  migrid.BOX_AXES = 1
  migrid.GRID_LATITUDE=2
  migrid.GRID_LONGITUDE=2
  migrid['Latitudes'].LABEL_ANGLE = 90
  migrid['Longitudes'].LABEL_ANGLE = 0
  print,max(TA,/NAN),min(TA,/NAN)
  img.MAX_VALUE=3
  img.MIN_VALUE=-3
  c = COLORBAR(TARGET=img, ORIENTATION=0,TITLE='气温/℃',POSITION=[0.12,0.08,0.88,0.12],font_name = 'Microsoft Yahei');
  c.RANGE=[-3,3]
  c.BORDER=0
  c.TICKDIR= 1
  c.TEXTPOS = 0
  c.MAJOR=11
  c.TAPER=1
  Img.save,outpath+"俩种插值结果差值空间分布"+'.png',/BORDER
  img.Close
  
end