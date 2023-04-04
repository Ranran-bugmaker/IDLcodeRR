pro modis_cwv_cal
  file_name='O:/coarse_data/chapter_5/MYD021KM.A2013278.0525.006.2013278174924.hdf'
  cloud_name='O:\coarse_data\chapter_5\MYD35_L2.A2013278.0525.006.2014103014542.hdf'
  res=0.01
  c1_17=0.876
  c1_18=0.795
  c1_19=0.796
  c2_17=0.124
  c2_18=0.205
  c2_19=0.204
  data_250=modis_caldata_get(file_name,'EV_250_Aggr1km_RefSB','reflectance_scales','reflectance_offsets')
  data_500=modis_caldata_get(file_name,'EV_500_Aggr1km_RefSB','reflectance_scales','reflectance_offsets')
  data_1000=modis_caldata_get(file_name,'EV_1KM_RefSB','reflectance_scales','reflectance_offsets')
  
  band2=reform(data_250[*,*,1])
  data_250=!null
  band5=reform(data_500[*,*,2])
  data_500=!null
  band17=reform(data_1000[*,*,11])
  band18=reform(data_1000[*,*,12])
  band19=reform(data_1000[*,*,13])
  data_1000=!null
  
  icibr_17=band17/(c1_17*band2+c2_17*band5)
  icibr_18=band18/(c1_18*band2+c2_18*band5)
  icibr_19=band19/(c1_19*band2+c2_19*band5)
  pwv_17=(0.02-1.013*alog(icibr_17))^2
  pwv_18=(0.022-1.077*alog(icibr_18))^2
  pwv_19=(0.027-1.334*alog(icibr_19))^2
  pwv=0.326*pwv_17+0.369*pwv_18+0.566*pwv_19
  
  cloud_data=hdf4_data_get(cloud_name,'Cloud_Mask')
  cloud_data_0=reform(cloud_data[*,*,0])
  cloud_size=size(cloud_data_0)
  cloud_data_binary=bytarr(cloud_size[1],cloud_size[2],8)
  cloud_data_us=(cloud_data_0 ge 0)*cloud_data_0+(cloud_data_0 lt 0)*(abs(cloud_data_0)+128)
  for layer_i=0,7 do begin
    cloud_data_binary[*,*,layer_i]=cloud_data_us mod 2
    cloud_data_us=cloud_data_us/2
  endfor
  cloud_result=(cloud_data_binary[*,*,0] eq 1) and (cloud_data_binary[*,*,1] eq 0) and (cloud_data_binary[*,*,2] eq 0)
  clear_result=cloud_result eq 0
  pwv_clear=pwv*clear_result
  
  lon_data=hdf4_data_get(file_name,'Longitude')
  lat_data=hdf4_data_get(file_name,'Latitude')
  lon_data_congrid=congrid(lon_data,cloud_size[1],cloud_size[2],/interp)
  lat_data_congrid=congrid(lat_data,cloud_size[1],cloud_size[2],/interp)
  data_glt,lon_data_congrid,lat_data_congrid,pwv_clear,res,pwv_clear_rpj,geo_info_rpj
  write_tiff,'D:/pwv_clear_rpj.tiff',pwv_clear_rpj,/float,geotiff=geo_info_rpj
end