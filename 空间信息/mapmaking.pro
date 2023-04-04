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
;    geokeys=[geo1.MODELTIEPOINTTAG[4],geo1.MODELTIEPOINTTAG[3],dz[1]*geo1.MODELPIXELSCALETAG[0] + geo1.MODELTIEPOINTTAG[3],geo1.MODELTIEPOINTTAG[4]-dz[2]*geo1.MODELPIXELSCALETAG[1]]
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
      
;    xaxis=axis(0,LOCATION=[geokeys.a,geokeys.s],axis_range=[0 , 500],coord_transform=[-geokeys.a*107.8242314,107.8242314],TICKDIR=1,TITLE='(km)')
;    img.mapgrid.CLIP=1
    
;    ,MINOR=0, MAJOR=3
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
;    mapgrid.CLIP=1
;    img=image(ROTATE(a,7),rgb_table=color_table,grid_units=2,$
;      $;max(lon)-min(lon)   max(lat)-min(lat)image_dimensions=[ (geokeys[2]-geokeys[1])*1.2 , (geokeys[0]-geokeys[3])*1.2 ],
;      LONGITUDE_MIN=geokeys[1],LONGITUDE_MAX=geokeys[2],$;min(lon),min(lat)IMAGE_LOCATION=[geokeys[1],geokeys[3]],
;      GEOTIFF=geo1,$;YRANGE=[geokeys[1]-2 , geokeys[2]+2 ],
;      POSITION=[0.1,0.15,0.9,0.95],DIMENSIONS=[800,800],/overplot)
;      img.mapgrid.CLIP=1

    
;    marsDiameter = 6792 ; km
;
;    scaleFactor = marsDiameter/400 ; km/pixel
;
;    ax1 = AXIS('x', LOCATION=70, $
;      TITLE='(km)', $
;      /DATA, $
;      AXIS_RANGE=[0, 600], $
;      COORD_TRANSFORM=[-195, 1] * scaleFactor, $
;      MINOR=0, MAJOR=3)
        
;    img.MAPGRID = MAPGRID(COLOR="red", $
;       FILL_COLOR="yellow", TRANSPARENCY=100, $
;       LONGITUDE_MIN=geokeys[1], LONGITUDE_MAX=geokeys[2], $
;       LATITUDE_MIN=geokeys[3], LATITUDE_MAX=geokeys[0], $
;       GRID_LONGITUDE=2, GRID_LATITUDE=2, $
;       LABEL_SHOW=0)
;;      limit=[geokeys[1]*1.2,geokeys[2]*0.8,geokeys[0]*1.2,geokeys[3]*0.8],


;  img.MAPGRID.LONGITUDE_MIN=geokeys[1]-5
;  img.MAPGRID.GRID_LONGITUDE=1
    ;set colormap limits
    img.MAX_VALUE=range[1]
    img.MIN_VALUE=range[0]
;    ;Change the figure title, grid type, axis text direction, and color bar form
;;    img.title = 'Date:'+strmid(file_basename(filearr),16,8)
;    
;;    img=MAPGRID(HIDE=0)
;    img.mapgrid.label_position=0
;;    img.mapgrid.font_name='Palatino'
;
;    img.mapgrid.linestyle=6
;    img.MAPGRID.BOX_COLOR = 'k'
;    img.MAPGRID.BOX_ANTIALIAS=0
;    
;    
;    img.mapgrid.horizon_thick=0
;
;    img['Latitudes'].LABEL_ANGLE = 90
;    img['Longitudes'].LABEL_ANGLE = 0
    

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
    ; save as GeoTIFF
;    ;Write geographic information structure
;    geo_info={$
;      MODELPIXELSCALETAG:[0.01,0.01,0.0],$
;      MODELTIEPOINTTAG:[0.0,0.0,0.0,min(lon),max(lat),0.0],$
;      GTMODELTYPEGEOKEY:2,$
;      GTRASTERTYPEGEOKEY:1,$
;      GEOGRAPHICTYPEGEOKEY:4326,$
;      GEOGCITATIONGEOKEY:'GCS_WGS_1984'}
;
;    ;write GeoTIFF
;    WRITE_TIFF,outpath+'SCHAP.AOD.D001.A'+strmid(file_basename(filearr),16,8)+'.tif',reverse(transpose(output_AOD),2),/float, geotiff=geo_info
;    ;Close nc file ID
;    NCDF_CLOSE, file_ID
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
  
end