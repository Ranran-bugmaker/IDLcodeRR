function h5_data_get,file_name,dataset_name
  file_id=h5f_open(file_name)
  dataset_id=h5d_open(file_id,dataset_name)
  data=h5d_read(dataset_id)
  h5d_close,dataset_id
  h5f_close,file_id
  return,data
  data=!null
end

pro omi_no2_average_calculating
  ;输入输出路径设置
  start_time=systime(1)
  in_path='O:/coarse_data/chapter_2/NO2/'
  out_path='O:/coarse_data/chapter_2/NO2/average/'
  dir_test=file_test(out_path,/directory)
  if dir_test eq 0 then begin
    file_mkdir,out_path
  endif
  filelist=file_search(in_path,'*NO2*.he5')
  file_n=n_elements(filelist)
  group_name='/HDFEOS/GRIDS/ColumnAmountNO2/Data Fields/'
  target_dataset='ColumnAmountNO2TropCloudScreened'
  dataset_name=group_name+target_dataset
  ;print,dataset_name
  
  ;月份存储数组初始化
  data_total_month=fltarr(1440,720,12)
  data_valid_month=fltarr(1440,720,12)
  
  ;季节存储数组初始化
  data_total_season=fltarr(1440,720,4)
  data_valid_season=fltarr(1440,720,4)
  
  ;处理年份设置、年份存储数组初始化
  year_start=2017
  year_n=2
  data_total_year=fltarr(1440,720,year_n)
  data_valid_year=fltarr(1440,720,year_n)
  
  for file_i=0,file_n-1 do begin
    
  endfor
  
  month_out=['01','02','03','04','05','06','07','08','09','10','11','12']
  season_out=['spring','summer','autumn','winter']
  year_out=['2017','2018']
  
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
    
  

  end_time=systime(1)
  print,'Processing is end, the totol time consumption is:'+strcompress(string(end_time-start_time))+' s.'
end
