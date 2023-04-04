pro omi_no2_output

  start_time=systime(1)
  print,'冉炯涛2020043023，实验二程序2.1版';等后面扔图片里面，目前不会
  in_path='D:\WorkSpace_IDL\resource\data\chapter_2\chapter_2\NO2\'
  out_path='D:\WorkSpace_IDL\resource\data\chapter_2\chapter_2\NO2\result\'
  out_E_N=file_test(out_path,/directory)
  if out_E_N eq 0 then begin
    file_mkdir,out_path
  endif

  filelist=file_search(in_path,'*NO2*.he5')
  file_n=n_elements(filelist)
  group_1='/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/';no2图像文件组名
  group_2='/HDFEOS/ADDITIONAL/FILE_ATTRIBUTES/';拍摄时间组名
  group_3='/HDFEOS/GRIDS/ColumnAmountNO2/'
  year='GranuleYear';拍摄年份
  month='GranuleMonth';拍摄月份
  day='GranuleDay';拍摄当月第几日
  target_data='ColumnAmountNO2TropCloudScreened';目标图像文件
  dataset_name=group_1+target_data
  
  ;获取指定目标图像像素宽度x，y，批量处理相同数据所以获取一个数据值就行
  lon=data_info(filelist[0],group_3,'NumberOfLongitudesInGrid')
  lat=data_info(filelist[0],group_3,'NumberOfLatitudesInGrid')
  ;数组初始化
  data_total_month=fltarr(lon,lat,12)
  data_valid_month=fltarr(lon,lat,12)
  data_total_season=fltarr(lon,lat,4)
  data_valid_season=fltarr(lon,lat,4)
  data_total_year=fltarr(lon,lat,2)
  data_valid_year=fltarr(lon,lat,2)
  month_out=['01','02','03','04','05','06','07','08','09','10','11','12']
  season_list=[3,0,0,0,1,1,1,2,2,2,3,3]
  season_out=['spring','summer','autumn','winter']
  
;  获取年份按序列表方便查找
  tmparr=lon64arr(file_n)
  for i=0,file_n-1 do begin
    tmparr[i]=data_info(filelist[i],group_2,year)
  endfor
  year_list=tmparr(sort(tmparr))
  year_list=year_list(uniq(year_list))
  
  
  for file_i=0,file_n-1 do begin
    
    data_temp=h5_data_get(filelist[file_i],dataset_name)
    data_temp=((data_temp gt 0.0)*data_temp/!const.NA)*(10.0^10.0);转mol/km2
    data_temp=rotate(data_temp,7)

    layer_i=data_info(filelist[file_i],group_2,month)-1
    year_i=data_info(filelist[file_i],group_2,year)-year_list[0]
    
    data_total_month[*,*,layer_i]+= data_temp
    data_valid_month[*,*,layer_i]+= (data_temp gt 0.0)

    
    data_total_season[*,*,season_list[layer_i]]+=data_temp
    data_valid_season[*,*,season_list[layer_i]]+=(data_temp gt 0.0)
    data_total_year[*,*,year_i]+=data_temp
    data_valid_year[*,*,year_i]+=data_temp
    
  endfor
;  计算平均值
  data_valid_month=(data_valid_month gt 0.0)*data_valid_month+(data_valid_month eq 0.0)*(1.0)
  data_avr_month=data_total_month/data_valid_month
  data_valid_season=(data_valid_season gt 0.0)*data_valid_season+(data_valid_season eq 0.0)*(1.0)
  data_avr_season=data_total_season/data_valid_season
  data_valid_year=(data_valid_year gt 0.0)*data_valid_year+(data_valid_year eq 0.0)*(1.0)
  data_avr_year=data_total_year/data_valid_year
  

;geoinfo,为geotiff提供地理信息
  geo_info={$
    MODELPIXELSCALETAG:[0.25,0.25,0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,-180.0,90.0,0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102,$
    GEOGSEMIMAJORAXISGEOKEY:6378137.0,$
    GEOGINVFLATTENINGGEOKEY:298.25722}
    
  for month_i=0,11 do begin
    out_name=out_path+'month_avr_'+month_out[month_i]+'.tiff'
    write_tiff,out_name,data_avr_month[*,*,month_i],/float,geotiff=geo_info
  endfor

  for season_i=0,3 do begin
    out_name=out_path+'season_avr_'+season_out[season_i]+'.tiff'
    write_tiff,out_name,data_avr_season[*,*,season_i],/float,geotiff=geo_info
  endfor

  for year_i=0,1 do begin
    out_name=out_path+'year_avr_'+string(year_list[year_i],format='(I04)')+'.tiff'
    write_tiff,out_name,data_avr_year[*,*,year_i],/float,geotiff=geo_info
  endfor
;  没想到省略方式

  end_time=systime(1)
  print,'Processing is end, the totol time consumption is:'+strcompress(string(end_time-start_time))+' s.'
end