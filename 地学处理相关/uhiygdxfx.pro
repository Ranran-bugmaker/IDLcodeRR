;+
;
; :Author:  冉炯涛
; :Description:
;    //TODO 读取数据并处理UHI
; :Date 2023年4月13日 下午11:08:14
; :Params:
;
; :keywords:
;
; :return:
;
;-
pro UHIygdxfx
  E=envi(/headless)

  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init
  start_time=systime(1)
  out_path="R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RESS\out\"
  tmp_path="R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RESS\tmp\"
  data_path='R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RESS\'
  shp_path='R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RESS\resROI.shp'
  ;shp1_path='R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RESS\cdutm48.shp'
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
  
  if ~file_test(tmp_path,/directory) then file_mkdir,tmp_path
  if ~file_test(out_path,/directory) then file_mkdir,out_path
  
  DATA_time='2017-06-15T09:23:00.0000000Z'
  for imtl = 0L, 1 do begin
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
    
    
    raster_10000 = ENVI.OpenRaster('R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RTETCM\Shanghai - 副本.dat')
    Projection_Ref=raster_10000.SPATIALREF
    
    
    centerlat=31.172356
    centerlon=121.419089
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
    "&L57_option="+STRCOMPRESS(STRING(8),/REMOVE_ALL)+$
    "&altitude="+$
    "&pressure="+$
    "&temperature="+$
    "&rel_humid="+$
    "&user_email=mimi0tope%40126.com"
    
;    httpclient = OBJ_NEW('IDLnetURL')
;    httpclient->SetProperty, URL_HOSTNAME=hostname,URL_PATH=hostpath,URL_QUERY=params
;    strings = httpclient->Get(/STRING_ARRAY)
;    if (N_ELEMENTS(strings) le 1) then begin
;      print,"数据接收错误0"
;      CONTINUE
;    endif else begin
;    endelse
;    data=STRSPLIT(strings[4],'>',/EXTRACT)
;    if (N_ELEMENTS(data) le 1) then begin
;      print,"数据接收错误"
;      CONTINUE
;    endif else begin
;    endelse
;
;    data=data[[WHERE(STRMATCH(data, '*.*', /FOLD_CASE) EQ 1)]]
;    datax=STREGEX(data,"[0-9]\.[0-9]*",/EXTRACT)
;    BAAT=float(datax[-3])
;    EBUR=float(datax[-2])
;    EBDR=float(datax[-1])
    BAAT=float(0.82)
    EBUR=float(1.42)
    EBDR=float(2.38)
    PRINT,BAAT,EBUR,EBDR
    
    
    
    
    
    ; -----------------------------
    ; Band Math NDVI
    ; -----------------------------
    print,"计算NDVI"
    tmp=ENVI.OpenRaster('R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RTETCM\Shanghai.dat')
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

;    ;  ndvi_pro=ENVI.OpenRaster('R:\JX\kjxxx\suibian xie de mingzi\test0NDVI.dat',SPATIALREF_OVERRIDE=Projection_Ref)
    print,"重投影计算结果"
    ndvi_pro=ENVI.OpenRaster(tmp_path+DATA_date+"_NDVI.dat",SPATIALREF_OVERRIDE=Projection_Ref)
    ndvi_pro.METADATA.UpdateItem,"BAND NAMES","NDVI"
    ndvi_pro_repro=ENVIRaster(ndvi_pro.GetData(),URI=tmp_path+DATA_date+"_NDVI_PROED.dat",METADATA=ndvi_pro.METADATA,SPATIALREF=Projection_Ref)
    ndvi_pro_repro.Save
    ndvi_pro.Close
    ndvi_pro_repro.Close

    mndwi_pro=ENVI.OpenRaster(tmp_path+DATA_date+"_MNDWI.dat",SPATIALREF=Projection_Ref)
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
;    suf[where(ndvi_data gt 0.1)]=0.986;0.9625+0.0614*pv[where(ndvi_data gt 0.1)]-0.0461*pv[where(ndvi_data gt 0.1)]^2
;    suf[where(ndvi_data le 0.1 and mndwi_data gt 0.1)]=0.995
;    suf[where(ndvi_data le 0.1 and mndwi_data le 0.1)]=0.970;0.9589+0.086*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]-0.0671*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]^2
;    suf[where(ndvi_data gt 0.1)]=0.986;0.9625+0.0614*pv[where(ndvi_data gt 0.1)]-0.0461*pv[where(ndvi_data gt 0.1)]^2
;    suf[where(ndvi_data le 0.1 and mndwi_data gt 0.1)]=0.995
;    suf[where(ndvi_data le 0.1 and mndwi_data le 0.1)]=0.970;0.9589+0.086*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]-0.0671*pv[where(ndvi_data le 0.1 and mndwi_data le 0.1)]^2
    suf=(suf lt 0.2) * 0.973 + ((suf ge 0.2) and (suf le 0.5)) * (0.004 * pv + 0.986) + (suf ge 0.5) * 0.986
    print,"地表比辐射率计算"
    tmpmetadata.UpdateItem,"BAND NAMES","Surface Reflectance"
    tmpmetadata.UpdateItem,"DESCRIPTION","地表比辐射率计算结果"
    Raster = ENVIRaster(suf, URI=tmp_path+DATA_date+"_SR.dat",SPATIALREF=Projection_Ref,METADATA=tmpmetadata)
    Raster.Save
    Raster.Close



    raster_2=envi.OpenRaster('R:\YGDXFX\Practice\Practice-2 城市热岛效应评估\实验数据\RTETCM\Shanghairhw.dat')
    HW_data=raster_2.getdata()
    band10_data=REFORM(HW_data[*,*,0])
    band10_data[where(band10_data eq raster_2.METADATA["DATA IGNORE VALUE"])]=!VALUES.F_NAN
    raster_2.close

    band10_k1=744.89
    band10_k2=1321.08
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
    
    raster_10000.Close
  endfor
  
end