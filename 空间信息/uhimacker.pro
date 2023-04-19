;+
;
;	:Author:	冉炯涛
;	:Description:
;		 //TODO 批量化读取Landsat数据并处理UHI
;	:Date 2023年4月13日 下午11:08:14
;	:Params:
;
;	:keywords:
;
;	:return:
;
;-

pro UHImacker
  E=envi(/headless)
  
  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init
  start_time=systime(1)
  out_path="R:\JX\kjxxx\suibian xie de mingzi\out\"
  tmp_path="R:\JX\kjxxx\suibian xie de mingzi\tmp\"
  data_path='R:\JX\kjxxx\suibian xie de mingzi\'
  shp_path='R:\JX\cdutm48minout.shp'
  ; 1:覆写  0:不覆写
  overwrite=0
  ; 1:中间文件删除  0:不删除
  bool_del=0
  
  if ~file_test(data_path+"VECTORcmutm.xml") then BEGIN
    ; ------------------------------------------------
    ; 矢量记录转为 ROI - Convert Vector Records to ROI
    ; ------------------------------------------------
    print,"矢量转ROI"
    VECTORcmutm=ENVI.OpenVector(shp_path)
    task_1 = ENVITask('VectorRecordsToROI')
    task_1.input_vector = VECTORcmutm
    task_1.output_roi_uri = data_path+"VECTORcmutm.xml"
    task_1.Execute
    VECTORcmutm.close
  endif
  
  ;打开ROI
  VECTOR_subset=ENVI.OpenROI(data_path+"VECTORcmutm.xml")
;  if (overwrite eq 1) then begin
;      if file_test(tmp_path,/directory) then file_delete,tmp_path,/RECURSIVE
;      if file_test(out_path,/directory) then file_delete,out_path,/RECURSIVE
;  endif else begin
;  endelse

  if ~file_test(tmp_path,/directory) then file_mkdir,tmp_path
  if ~file_test(out_path,/directory) then file_mkdir,out_path
  MTL_txt_file=FILE_SEARCH(data_path,"*_MTL.txt")

  year_tmp=hash()
  for imtl = 0L, N_ELEMENTS(MTL_txt_file)-1 do begin
    start_time1=systime(1)
    landsat=8
    ; -----------------------------
    ; 处理MTL方便读取
    ; -----------------------------
    print,"处理MTL.txt"
    mtltxtname=MTL_txt_file[imtl]
    mtltxtline=FILE_LINES(mtltxtname)
    mtltxt=STRARR(mtltxtline)
    OPENR,1,mtltxtname
    READF,1,mtltxt
    FREE_LUN,1
    mtltxt[WHERE(STRMATCH(mtltxt, 'GROUP = LANDSAT_METADATA_FILE', /FOLD_CASE) EQ 1)]="GROUP = L1_METADATA_FILE"
    mtltxt[WHERE(STRMATCH(mtltxt, 'END_GROUP = LANDSAT_METADATA_FILE', /FOLD_CASE) EQ 1)]="END_GROUP = L1_METADATA_FILE"
    if (WHERE(STRMATCH(mtltxt, '    SPACECRAFT_ID = "LANDSAT_9"', /FOLD_CASE) EQ 1) ne -1) then landsat=9
    mtltxt[WHERE(STRMATCH(mtltxt, '    SPACECRAFT_ID = "LANDSAT_9"', /FOLD_CASE) EQ 1)]='    SPACECRAFT_ID = "LANDSAT_8"'
    OPENW,2,mtltxtname
    PRINTF,2,mtltxt,/IMPLIED_PRINT
    FREE_LUN,2
    PRINT,mtltxtname
    
    ; -----------------------------
    ; 处理投影
    ; -----------------------------
    print,"计算投影文件"
    jsonname=FILE_DIRNAME(MTL_txt_file[imtl])+'\'+FILE_BASENAME(MTL_txt_file[imtl],'.txt')+".json"
    if (~file_test(jsonname)) then begin
      jsonname=FILE_DIRNAME(MTL_txt_file[imtl])+'\'+FILE_BASENAME(MTL_txt_file[imtl],'.txt')+".xml"
      tmp= XML_PARSE(jsonname)
      tmp1=JSON_SERIALIZE(tmp)
      json_struct=JSON_Parse(tmp1,/TOARRAY)
    endif else begin
      jsonline=FILE_LINES(jsonname)
      json=STRARR(jsonline)
      OPENR,1,jsonname
      READF,1,json
      FREE_LUN,1
      json_struct=JSON_Parse(json,/TOARRAY)
    endelse
    PIX_SIZE_REFLECTIVE_JSON=[FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","GRID_CELL_SIZE_REFLECTIVE"]),$
      FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","GRID_CELL_SIZE_REFLECTIVE"])]
    
    LL_projection_pos=[FLOAT(json_struct['LANDSAT_METADATA_FILE','PROJECTION_ATTRIBUTES','CORNER_UL_PROJECTION_X_PRODUCT']),$
      FLOAT(json_struct['LANDSAT_METADATA_FILE','PROJECTION_ATTRIBUTES','CORNER_UL_PROJECTION_Y_PRODUCT'])]
    DATA_time=json_struct["LANDSAT_METADATA_FILE","IMAGE_ATTRIBUTES","DATE_ACQUIRED"]+'T'+json_struct["LANDSAT_METADATA_FILE","IMAGE_ATTRIBUTES","SCENE_CENTER_TIME"]
    CoordSys = ENVICoordSys(COORD_SYS_CODE=32648)
    
    
    ; -----------
    ; 获取大气数据
    ; -----------
    print,"联网获取大气剖面数据"
    TIMESTAMPTOVALUES,DATA_time,YEAR=year,MONTH=month,DAY=day,HOUR=hour,MINUTE=minu,SECOND=sec
    date=[year,month,day]
    time=[hour,minu,fix(sec)]
    DATA_date=STRCOMPRESS(STRJOIN(date,"-"),/REMOVE_ALL)+" "+STRCOMPRESS(STRJOIN(time,"-"),/REMOVE_ALL)+"Z"
    if (overwrite eq 1) then BEGIN
      done_file=FILE_SEARCH(tmp_path,DATA_date+'*')
      if file_test(done_file[0]) then file_delete,done_file,/QUIET
    endif
    
    if (file_test(tmp_path+DATA_date+"_BT_subset.dat")) then begin
      namekay="Y_"+STRCOMPRESS(STRING(year),/REMOVE_ALL)
      if ~(year_tmp.haskey(namekay)) then begin
        year_tmp[namekay]=tmp_path+DATA_date+"_BT_subset.dat"
      endif else begin
        tmp=year_tmp[namekay]
        year_tmp[namekay]=[tmp,tmp_path+DATA_date+"_BT_subset.dat"]
      endelse
      PRINT,tmp_path+DATA_date+"_BT_subset.dat"+"  已经存在，跳过并记录"
      CONTINUE
    endif else begin
      done_file=FILE_SEARCH(tmp_path,DATA_date+'*')
      if file_test(done_file[0]) then file_delete,done_file,/QUIET
    endelse
    
    
    
    centerlat=(FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","CORNER_UL_LAT_PRODUCT"])+FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","CORNER_LL_LAT_PRODUCT"]))/2
    centerlon=(FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","CORNER_UL_LON_PRODUCT"])+FLOAT(json_struct["LANDSAT_METADATA_FILE","PROJECTION_ATTRIBUTES","CORNER_LR_LON_PRODUCT"]))/2
    hostname="atmcorr.gsfc.nasa.gov"
    hostpath="cgi-bin/atm_corr.pl"
    if (month le 9 and month gt 4) then begin
      stdatm_option=1
    endif else begin
      stdatm_option=2
    endelse
  
    params="year="+STRCOMPRESS(STRING(year),/REMOVE_ALL)+$
    "&month="+STRCOMPRESS(STRING(month),/REMOVE_ALL)+$
    "&day="+STRCOMPRESS(STRING(day),/REMOVE_ALL)+$
    "&hour="+STRCOMPRESS(STRING(hour),/REMOVE_ALL)+$
    "&minute="+STRCOMPRESS(STRING(minu),/REMOVE_ALL)+$
    "&thelat="+STRCOMPRESS(STRING(centerlat),/REMOVE_ALL)+$
    "&thelong="+STRCOMPRESS(STRING(centerlon),/REMOVE_ALL)+$
    "&profile_option=2"+$
    "&stdatm_option="+STRCOMPRESS(STRING(stdatm_option),/REMOVE_ALL)+$
    "&L57_option="+STRCOMPRESS(STRING(landsat),/REMOVE_ALL)+$
    "&altitude="+$
    "&pressure="+$
    "&temperature="+$
    "&rel_humid="+$
    "&user_email=mimi0tope%40126.com"
    
    httpclient = OBJ_NEW('IDLnetURL')
    httpclient->SetProperty, URL_HOSTNAME=hostname,URL_PATH=hostpath,URL_QUERY=params
    strings = httpclient->Get(/STRING_ARRAY)
    if (N_ELEMENTS(strings) le 1) then begin
      print,"数据接收错误0"
      CONTINUE
    endif else begin
    endelse
    data=STRSPLIT(strings[4],'>',/EXTRACT)
    if (N_ELEMENTS(data) le 1) then begin
      print,"数据接收错误"
      CONTINUE
    endif else begin
    endelse

    data=data[[WHERE(STRMATCH(data, '*.*', /FOLD_CASE) EQ 1)]]
    datax=STREGEX(data,"[0-9]\.[0-9]*",/EXTRACT)
    BAAT=float(datax[-3])
    EBUR=float(datax[-2])
    EBDR=float(datax[-1])
    PRINT,BAAT,EBUR,EBDR
    
    
    Projection_Ref = ENVIStandardRasterSpatialRef( $
      COORD_SYS_CODE=CoordSys.COORD_SYS_CODE, $
      ROTATION=0, $
      PIXEL_SIZE=PIX_SIZE_REFLECTIVE_JSON, $
      TIE_POINT_PIXEL=[0,0], $
      TIE_POINT_MAP=LL_projection_pos)
      
    ;-----------------------------
    ;打开Landsat8
    ;-----------------------------
    print,"打开Landsat8文件"
    raster_1 = ENVI.OpenRaster(mtltxtname)
    
    ; ----------------------------------
    ; 多光谱辐射定标 - Radiometric Calibration
    ; ----------------------------------
    print,"多光谱定标"
    task_2 = ENVITask('RadiometricCalibration')
    task_2.input_raster = raster_1[0]
    task_2.scale_factor = 0.1
    task_2.output_raster_uri = tmp_path+DATA_date+"_mult.tfw"
    task_2.Execute
  
    ; ----------------------------------
    ; 红外辐射定标 - Radiometric Calibration
    ; ----------------------------------
    print,"红外辐射定标"
    task_1 = ENVITask('RadiometricCalibration')
    task_1.input_raster = raster_1[3]
    task_1.output_raster_uri = tmp_path+DATA_date+"_HW_RC.tfw"
    task_1.Execute
    
    ; ----------------------------
    ; 导出为 ENVI - Export to ENVI
    ; ----------------------------
    print,"BIL格式转换"
    tmp=envi.OpenRaster(tmp_path+DATA_date+"_mult.tfw")
    task_1 = ENVITask('ExportRasterToENVI')
    task_1.input_raster = tmp
    task_1.interleave = 'BIL'
    task_1.data_ignore_value = -9999.0
    task_1.output_raster_uri = tmp_path+DATA_date+"_multBIL.dat"
    task_1.Execute
    tmp.close
    
    ; -----------------------------------
    ; QUAC - Quick Atmospheric Correction
    ; -----------------------------------
    print,"快速大气校正"
    tmp=envi.OpenRaster(tmp_path+DATA_date+"_multBIL.dat")
    task_1 = ENVITask('QUAC')
    task_1.input_raster = tmp
    task_1.sensor = 'Landsat TM/ETM/OLI'
    task_1.output_raster_uri = tmp_path+DATA_date+"_multBIL_FLAASHED.dat"
    task_1.Execute
    tmp.close
    
        ;  IDLHydrate(TYPE='ENVIRASTER', JSON_Parse('{' + $
        ;    '    "url": "R:\\JX\\kjxxx\\suibian xie de mingzi\\multBIL_FLAASHED.dat",' + $
        ;    '    "factory": "URLRaster",' + $
        ;    '    "auxiliary_url": ["R:\\JX\\kjxxx\\suibian xie de mingzi\\multBIL_FLAASHED.hdr", "R:\\JX\\kjxxx\\suibian xie de mingzi\\multBIL_FLAASHED.dat.enp"]' + $
        ;    '}' ))  
    
    ; -----------------------------
    ; Band Math NDVI
    ; -----------------------------
    print,"计算NDVI"
    tmp=ENVI.OpenRaster(tmp_path+DATA_date+"_multBIL_FLAASHED.dat")
    task_1 = ENVITask('PixelwiseBandMathRaster')
    task_1.input_raster = tmp
    task_1.expression = '(float(b5)-float(b4))/(float(b5)+float(b4))'
    task_1.data_ignore_value = -9999.0
    task_1.output_raster_uri = tmp_path+DATA_date+"_NDVI.dat"
    task_1.Execute
    
    ; -----------------------------
    ; Band Math MNDWI
    ; -----------------------------
    print,"计算MNDWI"
    task_1 = ENVITask('PixelwiseBandMathRaster')
    task_1.input_raster = tmp
    task_1.expression = '(float(b3)-float(b6))/(float(b3)+float(b6))'
    task_1.data_ignore_value = -9999.0
    task_1.output_raster_uri = tmp_path+DATA_date+"_MNDWI.dat"
    task_1.Execute
    tmp.close
    
  ;  ndvi_pro=ENVI.OpenRaster('R:\JX\kjxxx\suibian xie de mingzi\test0NDVI.dat',SPATIALREF_OVERRIDE=Projection_Ref)
    print,"重投影计算结果"
    ndvi_pro=ENVI.OpenRaster(tmp_path+DATA_date+"_NDVI.dat",SPATIALREF_OVERRIDE=Projection_Ref)
    ndvi_pro.METADATA.UpdateItem,"BAND NAMES","NDVI"
    ndvi_pro_repro=ENVIRaster(ndvi_pro.GetData(),URI=tmp_path+DATA_date+"_NDVI_PROED.dat",METADATA=ndvi_pro.METADATA,SPATIALREF=Projection_Ref)
    ndvi_pro_repro.Save
    ndvi_pro.Close
    ndvi_pro_repro.Close
    
    mndwi_pro=ENVI.OpenRaster(tmp_path+DATA_date+"_MNDWI.dat",SPATIALREF_OVERRIDE=Projection_Ref)
    mndwi_pro.METADATA.UpdateItem,"BAND NAMES","MNDWI"
    mndwi_pro_repro=ENVIRaster(mndwi_pro.GetData(),URI=tmp_path+DATA_date+"_MNDWI_PROED.dat",METADATA=mndwi_pro.METADATA,SPATIALREF=Projection_Ref)
    mndwi_pro_repro.Save
    mndwi_pro.Close
    mndwi_pro_repro.Close
    
    print,"开始反演温度"
    raster_10=envi.OpenRaster(tmp_path+DATA_date+"_MNDWI_PROED.dat")
    mndwi_data=raster_10.getdata()
    mndwi_data[where(mndwi_data eq raster_10.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    raster_10.close
    
    raster_9=envi.OpenRaster(tmp_path+DATA_date+"_NDVI_PROED.dat")
    ndvi_data=raster_9.getdata()
    Pv=FLTARR(raster_9.NCOLUMNS,raster_9.NROWS)
    Pv[where(ndvi_data eq raster_9.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    suf=FLTARR(raster_9.NCOLUMNS,raster_9.NROWS)
    suf[where(ndvi_data eq raster_9.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    ndvi_data[where(ndvi_data eq raster_9.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    tmpmetadata=raster_9.METADATA
    
    
    pv[where(ndvi_data gt 0.7)]=1
    pv[where(ndvi_data lt 0.05)]=0
    pv[where(ndvi_data ge 0.05 and ndvi_data le 0.7)]= (ndvi_data[where(ndvi_data ge 0.05 and ndvi_data le 0.7)]-0.05)/(0.7-0.05)
    suf[where(ndvi_data gt 0.1)]=0.986;0.9625+0.0614*pv[where(ndvi_data gt 0.1)]-0.0461*pv[where(ndvi_data gt 0.1)]^2
    suf[where(ndvi_data le 0.1 and mndwi_data gt 0.1)]=0.995
    suf[where(ndvi_data le 0.1 and mndwi_data le 0.1)]=0.970;0.9589+0.086*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]-0.0671*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]^2
    print,"地表比辐射率计算"
    tmpmetadata.UpdateItem,"BAND NAMES","Surface Reflectance"
    tmpmetadata.UpdateItem,"DESCRIPTION","地表比辐射率计算结果"
    Raster = ENVIRaster(suf, URI=tmp_path+DATA_date+"_SR.dat",SPATIALREF=Projection_Ref,METADATA=tmpmetadata)
    Raster.Save
    Raster.Close
    
  
    
    raster_2=envi.OpenRaster(tmp_path+DATA_date+"_HW_RC.tfw")
    HW_data=raster_2.getdata()
    band10_data=REFORM(HW_data[*,*,0])
    band10_data[where(band10_data eq raster_2.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    raster_2.close
    
    band10_k1=float(json_struct["LANDSAT_METADATA_FILE","LEVEL1_THERMAL_CONSTANTS","K1_CONSTANT_BAND_10"])
    band10_k2=float(json_struct["LANDSAT_METADATA_FILE","LEVEL1_THERMAL_CONSTANTS","K2_CONSTANT_BAND_10"])
    ;
    ;
    ;
    print,"计算同温度黑体亮度"
    Blackbody_Radiation=(band10_data-EBUR-BAAT*(1-suf)*EBDR)/(BAAT*suf)
    tmpmetadata.UpdateItem,"BAND NAMES","Blackbody_Radiation"
    tmpmetadata.UpdateItem,"DESCRIPTION","同温度下的黑体辐射亮度"
    Raster = ENVIRaster(Blackbody_Radiation, URI=tmp_path+DATA_date+"_BR.dat",SPATIALREF=Projection_Ref,METADATA=tmpmetadata)
    Raster.Save
    Raster.Close
    ;
    ;
    ;
    print,"计算地表温度"
    brightness_temperature=(band10_k2)/alog(band10_k1/Blackbody_Radiation+1)-273
    tmpmetadata.UpdateItem,"BAND NAMES","brightness_temperature"
    tmpmetadata.UpdateItem,"DESCRIPTION","单位为摄氏度的地表温度"
    Raster = ENVIRaster(brightness_temperature, URI=tmp_path+DATA_date+"_BT_OR.dat",SPATIALREF=Projection_Ref,METADATA=tmpmetadata)
    Raster.Save
    Raster.Close
    raster_9.close
    
    ; ----------------------------------------------------
    ; 根据 ROI 创建裁剪范围数组 - Create Subrects from ROI
    ; ----------------------------------------------------
    print,"准备裁剪范围"
    rasterin=ENVI.OpenRaster(tmp_path+DATA_date+"_BT_OR.dat")
    task_3 = ENVITask('CreateSubrectsFromROI')
    task_3.input_roi = VECTOR_subset
    task_3.input_raster = rasterin
    task_3.Execute
    
    ; ------------------------
    ; 栅格裁剪 - Subset Raster
    ; ------------------------
    print,"开始裁剪"
    task_1 = ENVITask('SubsetRaster')
    task_1.sub_rect = task_3.subrects
    task_1.input_raster = rasterin
    task_1.bands = [0]
    task_1.output_raster_uri = tmp_path+DATA_date+"_BT_subset.dat"
    task_1.Execute
    rasterin.close
    
    namekay="Y_"+STRCOMPRESS(STRING(year),/REMOVE_ALL)
    if ~(year_tmp.haskey(namekay)) then begin
      year_tmp[namekay]=tmp_path+DATA_date+"_BT_subset.dat"
    endif else begin
      tmp=year_tmp[namekay]
      year_tmp[namekay]=[tmp,tmp_path+DATA_date+"_BT_subset.dat"]
    endelse
    
    if (bool_del eq 1) then BEGIN
      done_file=FILE_SEARCH(tmp_path,DATA_date+'*')
      if file_test(done_file[0]) then file_delete,done_file,/QUIET
    endif
    end_time1=systime(1)
    PRINT,"单幅温度反演运行完成，耗时"+strcompress(string((end_time1-start_time1)/60))+"min"
;    if file_test(tmp_path,/directory) then file_delete,tmp_path,/RECURSIVE
  endfor
  VECTOR_subset.close
  end_time=systime(1)
  json_all_path=tmp_path+"all_data_path.json"
  tmp1=JSON_SERIALIZE(year_tmp)
  OPENW,2,json_all_path
  PRINTF,2,tmp1,/IMPLIED_PRINT
  FREE_LUN,2
  PRINT,"总温度反演运行完成，耗时"+strcompress(string((end_time-start_time)/60))+"min"
  
  start_time=systime(1)
  ; ----------------------------------
  ; 构建镶嵌栅格 - Build Mosaic Raster
  ; ----------------------------------
  jsontxtline=FILE_LINES(json_all_path)
  jsontxt=STRARR(jsontxtline)
  OPENR,1,json_all_path
  READF,1,jsontxt
  FREE_LUN,1
  json_struct=JSON_Parse(jsontxt,/TOSTRUCT)
  mosaiced=List()
  for ij = 0L, N_TAGS(json_struct)-1 do begin
    start_time1=systime(1)
    tmp=envi.OpenRaster(json_struct.(ij)[0])
    str_tmp=STRSPLIT(FILE_BASENAME(json_struct.(ij)[0],"*.dat"),'-',/EXTRACT)
    str_month=[str_tmp[0],str_tmp[1]]
    for ipos = 1L, N_ELEMENTS(json_struct.(ij))-1 do begin
      tmp=[tmp,envi.OpenRaster(json_struct.(ij)[ipos])]
      str_tmp=STRSPLIT(FILE_BASENAME(json_struct.(ij)[ipos],"*.dat"),'-',/EXTRACT)
      str_month=[str_month,str_tmp[1]]
    endfor
    PRINT,N_ELEMENTS(json_struct.(ij)),STRJOIN(str_month,'-')
    if file_test(out_path+STRJOIN(str_month,'-')+"_Mosaiced.dat") then file_delete,out_path+STRJOIN(str_month,'-')+"_Mosaiced.dat"
    task_1 = ENVITask('BuildMosaicRaster')
    task_1.input_rasters =tmp
    task_1.color_matching_method = 'Histogram Matching'
    task_1.color_matching_statistics = 'Overlapping Area'
    task_1.feathering_method = 'None'
    task_1.seamline_method = 'Geometry'
    task_1.output_raster_uri = out_path+STRJOIN(str_month,'-')+"_Mosaiced.dat"
    task_1.Execute
    Mosaiced_R=ENVI.OpenRaster(out_path+STRJOIN(str_month,'-')+"_Mosaiced.dat")
    if file_test(out_path+STRJOIN(str_month,'-')+"_Mosaiced.tif") then file_delete,out_path+STRJOIN(str_month,'-')+"_Mosaiced.tif"
    task_2 = ENVITask('ExportRasterToTIFF')
    task_2.input_raster=Mosaiced_R
    task_2.INTERLEAVE='BIP'
    task_2.DATA_IGNORE_VALUE=-9999.0
    task_2.output_raster_uri=out_path+STRJOIN(str_month,'-')+"_Mosaiced.tif"
    task_2.Execute
    Mosaiced_R.close
    mosaiced.Add,out_path+STRJOIN(str_month,'-')+"_Mosaiced.tif"
    end_time1=systime(1)
    PRINT,"单幅镶嵌运行完成，耗时"+strcompress(string((end_time1-start_time1)/60))+"min"
  endfor 
  end_time=systime(1)
  PRINT,"总镶嵌运行完成，耗时"+strcompress(string((end_time-start_time)/60))+"min"
  
  for index = 0L, N_ELEMENTS(mosaiced)-1 do begin
    data=READ_TIFF(mosaiced[index],GEOTIFF=mapinfo)
    meand=MEAN(data)
    datanew=(data*1.0-meand)/meand
    WRITE_TIFF,out_path+FILE_BASENAME(mosaiced[index],'_Mosaiced.tif')+"_UHI.tif",datanew,GEOTIFF=mapinfo,/FLOAT
  endfor
  DataColl = E.Data
  Rasters = DataColl.Get(/RASTER)
  for index = 0L, DataColl.Count()-1 do DataColl.Remove,Rasters[index]
  

END