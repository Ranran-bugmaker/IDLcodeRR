pro point
;  初始化envi
  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init

  for ishp = 0L, 4 do begin
    
    ; 打开点.shp
    shp_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outshp\out_"+STRCOMPRESS(STRING(ishp+1), /REMOVE_ALL)+'.shp'
    shp_obj = obj_new('IDLffShape', shp_file)
    shp_obj.GetProperty, n_entities=ent_n,n_attributes=att_n,attribute_info=att_info
    enumlist=shp_obj.GetAttributes(/ALL);获取所有属性表内容

    ; 打开栅格.tif
    raster_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outtif\Idw_shp"+STRCOMPRESS(STRING(ishp+1), /REMOVE_ALL)+'.tif'

    ; 创建输出txt文件
    output_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outcsv\Idw_shp"+STRCOMPRESS(STRING(ishp+1), /REMOVE_ALL)+'.csv'
    openw, 1, output_file
    

    printf,1,"fid,lon,lat,value,or"
    ENVI_OPEN_FILE,raster_file,r_fid=fid
    ENVI_FILE_QUERY, fid, dims=dims;some parameters will be used to get data
    
    image_proj = ENVI_GET_PROJECTION(fid = fid)
    
    geo_proj = ENVI_PROJ_CREATE(/geo)
    
    mapinfo=ENVI_GET_MAP_INFO(fid=fid)
    
    ULlat=mapinfo.MC(3);Y is latitude
    ULlon=mapinfo.MC(2);X is longtude
    ;2. Pixel Size
    Xsize=mapinfo.PS(0)
    Ysize=mapinfo.PS(1)
    for index = 0L, N_ELEMENTS(enumlist)-1 do begin
      Lat=enumlist[index].(2);站点纬度
      Lon=enumlist[index].(1);站点经度
      envi_convert_projection_coordinates,lon,lat,geo_proj,xmap,ymap,image_proj
      ;将站点的地图坐标转换为文件坐标
      envi_convert_file_coordinates,fid,xf,yf,xmap,ymap
      sample = FIX(ABS((xmap- ULlon)/Xsize));abs is determin the positive value, fix is get integer number
      line = FIX(ABS((ymap - ULlat)/Ysize))

      DN_data= ENVI_GET_DATA(fid = fid,dims = dims,pos = 0)
      value=DN_data[sample,line]
      if (value ge  0) then begin
        printf, 1, STRING(enumlist[index].(0),FORMAT='(i0)')+','+STRING(lon,FORMAT='(f0.5)')+','+STRING(lat,FORMAT='(f0.3)')+','+STRING(value,FORMAT='(f0.3)')+','+STRING(enumlist[index].(3),FORMAT='(f0.3)')
      ENDIF
    endfor
    close, 1
    
    ; 打开栅格.tif
    raster_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outtif\Kriging_shp"+STRCOMPRESS(STRING(ishp+1), /REMOVE_ALL)+'.tif'

    ; 创建输出txt文件
    output_file = "R:\JX\kjxxx\实验五 气温空间插值方法比较分析\out\outcsv\Kriging_shp"+STRCOMPRESS(STRING(ishp+1), /REMOVE_ALL)+'.csv'
    openw, 1, output_file

    printf,1,"fid,lon,lat,value,or"
    ENVI_OPEN_FILE,raster_file,r_fid=fid
    ENVI_FILE_QUERY, fid, dims=dims;some parameters will be used to get data
    
    image_proj = ENVI_GET_PROJECTION(fid = fid)
    
    geo_proj = ENVI_PROJ_CREATE(/geo)
    
    mapinfo=ENVI_GET_MAP_INFO(fid=fid)
    
    ULlat=mapinfo.MC(3);Y is latitude
    ULlon=mapinfo.MC(2);X is longtude
    ;2. Pixel Size
    Xsize=mapinfo.PS(0)
    Ysize=mapinfo.PS(1)
    for index = 0L, N_ELEMENTS(enumlist)-1 do begin
      Lat=enumlist[index].(2);站点纬度
      Lon=enumlist[index].(1);站点经度
      envi_convert_projection_coordinates,lon,lat,geo_proj,xmap,ymap,image_proj
      ;将站点的地图坐标转换为文件坐标
      envi_convert_file_coordinates,fid,xf,yf,xmap,ymap
      sample = FIX(ABS((xmap- ULlon)/Xsize));abs is determin the positive value, fix is get integer number
      line = FIX(ABS((ymap - ULlat)/Ysize))
      DN_data= ENVI_GET_DATA(fid = fid,dims = dims,pos = 0)
      value=DN_data[sample,line]
      if (value ge  10e-10) then begin
        printf, 1, STRING(enumlist[index].(0),FORMAT='(i0)')+','+STRING(lon,FORMAT='(f0.5)')+','+STRING(lat,FORMAT='(f0.3)')+','+STRING(value,FORMAT='(f0.3)')+','+STRING(enumlist[index].(3),FORMAT='(f0.3)')
      endif else begin
      endelse
    endfor
    close, 1
  endfor
  e.Close
end