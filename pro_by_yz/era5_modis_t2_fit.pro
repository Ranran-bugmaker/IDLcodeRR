pro era5_modis_t2_fit
  ;输入文件设置
  era5_file= 'O:\coarse_data\GMM\adaptor.mars.internal-1666516627.146223-388-2-51421d36-d9f6-411c-ad25-aa461e3ad572.nc'
  modis_file='O:\coarse_data\GMM\MOD11C3.A2020001.061.2021005132339.hdf'
  landcover_file='O:\coarse_data\GMM\MCD12C1.A2020001.LC.tiff'
  modis_file_new='O:\coarse_data\GMM\MOD11C3.A2020032.061.2021006182041.hdf'
  t2m_data=ncdf_data_get(era5_file,'t2m')
  ;输出文件设置
  output_dif_file='O:\coarse_data\GMM\2020feb_t2m_dif_type.tiff'
  output_result_file='O:\coarse_data\GMM\2020feb_t2m_fine_type.tiff'
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
  ;读土地利用类型数据
  lc_data=read_tiff(landcover_file)
  lc_data_congrid=congrid(lc_data,1440,721)
  ;读二月MODIS地表温度
  lst_day=hdf4_data_get(modis_file_new,'LST_Day_CMG')
  lst_night=hdf4_data_get(modis_file_new,'LST_Night_CMG')
  lst_day_conv=float(lst_day)*0.02
  lst_night_conv=float(lst_night)*0.02
  lst_avr=(lst_day_conv+lst_night_conv)/((lst_day_conv gt 0)+(lst_night_conv gt 0))
  lst_avr_congrid_new=congrid(lst_avr,1440,721)
  ;读二月气温
  t2m_data_final_new=dblarr(1440,721)
  t2m_data_final_new[0:719,*]=t2m_data_conv[720:1439,*,1]
  t2m_data_final_new[720:1439,*]=t2m_data_conv[0:719,*,1]
  ;初始化气温估算结果变量
  t2m_dif=fltarr(1440,721)
  t2m_prediction=fltarr(1440,721)
  t2m_prediction_fine=fltarr(7200,3600)
  ;对土地利用类型循环，计算相关系数和回归系数
  error_acc=0.0
  valid_n_acc=0.0
  for lc_i=0,16 do begin
    valid_pos=where(~finite(lst_avr_congrid,/nan) and (lc_data_congrid eq lc_i))
    lst_avr_valid=lst_avr_congrid[valid_pos]
    t2m_valid=t2m_data_final[valid_pos]
    r=correlate(lst_avr_valid,t2m_valid)
    print,'Type '+strtrim(string(lc_i),2)
    print,'r='+string(r,format='(F0.3)')
    fit=linfit(lst_avr_valid,t2m_valid)
    print,'fit coef: '+string(fit,format='(2(F0.3,:,","))')
    ;对应土地利用类型下气温估算与误差计算
    valid_pos_new=where(~finite(lst_avr_congrid_new,/nan) and (lc_data_congrid eq lc_i),valid_n)
    t2m_prediction[valid_pos_new]=fit[1]*lst_avr_congrid_new[valid_pos_new]+fit[0]
    t2m_true=t2m_data_final_new[valid_pos_new]
    t2m_dif[valid_pos_new]=t2m_prediction[valid_pos_new]-t2m_true
    mae=total(abs(t2m_true-t2m_prediction[valid_pos_new]))/valid_n
    print,'MAE: '+string(mae,format='(F0.3)')
    error_acc+=total(abs(t2m_true-t2m_prediction[valid_pos_new]))
    valid_n_acc+=valid_n
    ;0.05°分辨率气温估算
    valid_pos_fine=where(~finite(lst_avr,/nan) and (lc_data eq lc_i))
    t2m_prediction_fine[valid_pos_fine]=fit[1]*lst_avr[valid_pos_fine]+fit[0]
  endfor
  mae_acc=error_acc/valid_n_acc
  print,'MAE_acc: '+string(mae_acc,format='(F0.3)')
  write_tiff,output_dif_file,t2m_dif,/float,geotiff=geo_info
  write_tiff,output_result_file,t2m_prediction_fine,/float,geotiff=geo_info_fine
end