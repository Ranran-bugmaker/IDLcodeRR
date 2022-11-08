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
  
end