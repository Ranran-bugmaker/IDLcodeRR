pro era5_modis_t2_fitRRRR
  ;输入文件设置
  era5_file= 'R:\IDL\resource\03\adaptor.mars.internal-1666516627.146223-388-2-51421d36-d9f6-411c-ad25-aa461e3ad572.nc'
  modis_file='R:\IDL\resource\03\MOD11C3.A2020001.061.2021005132339.hdf'
  landcover_file='R:\IDL\resource\03\MCD12C1.A2020001.LC.tiff'
  modis_file_n='R:\IDL\resource\03\MOD11C3.A2020032.061.2021006182041.hdf'
  t2m_data=ncdf_data_get(era5_file,'t2m')
  ;输出文件设置
  output_dif_file='R:\IDL\resource\03\2020feb_t2m_dif_type.tiff'
  output_result_file='R:\IDL\resource\03\2020feb_t2m_fine_type.tiff'
  ;对MODIS数据预处理
  lst_day=hdf4_data_get(modis_file,'LST_Day_CMG')
  lst_night=hdf4_data_get(modis_file,'LST_Night_CMG')
  lst_day_conv=float(lst_day)*0.02
  lst_night_conv=float(lst_night)*0.02
  lst_avr=(lst_day_conv+lst_night_conv)/((lst_day_conv gt 0)+(lst_night_conv gt 0))
  lst_avr_congrid=congrid(lst_avr,1440,721)
  ;对ERA-5数据预处理
  sf=ncdf_attdata_get(era5_file,'t2m','scale_factor')
  ao=ncdf_attdata_get(era5_file,'t2m','add_offset')
  t2m_data_conv=t2m_data*sf+ao
  t2m_data_final=dblarr(1440,721)
  t2m_data_final[0:719,*]=t2m_data_conv[720:1439,*,0]
  t2m_data_final[720:1439,*]=t2m_data_conv[0:719,*,0]
  ;geotiff结构体定义
  geo_info={$
    MODELPIXELSCALETAG:[0.25,0.25,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,-180.0,90.0,0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGANGULARUNITSGEOKEY:9102}
  geo_info_fine={$
    MODELPIXELSCALETAG:[0.05,0.05,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,-180.0,90.0,0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGANGULARUNITSGEOKEY:9102}

  ;
  lc_data=READ_TIFF(landcover_file)
  lc_data_con=CONGRID(lc_data,1440,721)
  ;
  lst_day=hdf4_data_get(modis_file_n,'LST_Day_CMG')
  lst_night=hdf4_data_get(modis_file_n,'LST_Night_CMG')
  lst_day_conv=float(lst_day)*0.02
  lst_night_conv=float(lst_night)*0.02
  lst_avr=(lst_day_conv+lst_night_conv)/((lst_day_conv gt 0)+(lst_night_conv gt 0))
  lst_avr_congrid_n=congrid(lst_avr,1440,721)
  ;
  ;
  t2m_data_final_n=dblarr(1440,721)
  t2m_data_final_n[0:719,*]=t2m_data_conv[720:1439,*,1]
  t2m_data_final_n[720:1439,*]=t2m_data_conv[0:719,*,1]
  ;
  prediction=FLTARR(1440,721)
  prediction_fine=FLTARR(7200,3600)
  diff=t2m_data_final
  err_acc=0
  n_acc=0
  for lc_i = 0L,16 do begin
    valid_pos=where(~FINITE(lst_avr_congrid,/NAN)and(lc_data_con  eq  lc_i))
    lst_avr_valid=lst_avr_congrid[valid_pos]
    t2m_valid=t2m_data_final[valid_pos]
    r=CORRELATE(lst_avr_valid,t2m_valid)
    PRINT,'type'+STRTRIM(STRING(lc_i))
    print,'r='+string(r,FORMAT='(f0.3)')
    fit=LINFIT(lst_avr_valid,t2m_valid)
    print,'fit  coef:'+string(fit,FORMAT='(f0.3)')
    valid_pos_n=where(~FINITE(lst_avr_congrid,/NAN)and(lc_data_con  eq  lc_i),valid_n)
    prediction[valid_pos_n]=fit[1]*lst_avr_congrid_n[valid_pos_n]+fit[0]
    oringe=t2m_data_final_n[valid_pos_n]
    diff[valid_pos_n]=prediction[valid_pos_n]-oringe
    mae=TOTAL(abs(oringe-prediction[valid_pos_n]))/valid_n
    PRINT,'mae'+STRING(mae,FORMAT='(f0.3)')
    err_acc+=TOTAL(abs(oringe-prediction[valid_pos_n]))
    n_acc+=valid_n
    ;
    pos_fine=where(~FINITE(lst_avr,/NAN)and(lc_data  eq  lc_i))
    prediction_fine[pos_fine]=fit[1]*lst_avr[pos_fine]+fit[0]
  endfor
  ;
  WRITE_TIFF,output_dif_file,diff,/FLOAT,GEOTIFF=geo_info
  WRITE_TIFF,output_result_file,prediction_fine,/FLOAT,GEOTIFF=geo_info_fine
end