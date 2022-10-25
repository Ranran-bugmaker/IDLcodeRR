pro modis_msy_average
  input_directory='R:/modis/modis_chengdu/mod04_3k/geo_out/mosaic/'
  output_directory='R:/modis/modis_chengdu/mod04_3k/geo_out/msy_average/'
  if ~file_test(input_directory,/directory) then begin
    print,'输入路径不存在！'
    return
  endif
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory
  month_str=string(indgen(12)+1,format='(I02)')
  season_str=['spring','summer','autumn','winter']
  
  file_list=file_search(input_directory+'*.tif',count=file_n)
  if file_n eq 0 then begin
    print,'输入路径下无指定后缀的文件！'
    return
  endif
  file_year=strmid(file_basename(file_list),0,4)
  year_uniq=file_year.uniq()
  file_month=strmid(file_basename(file_list),4,2)
  
  for year_i=0,n_elements(year_uniq)-1 do begin
    out_name='year_'+year_uniq[year_i]+'_average.tiff'
    file_pos=where(file_year eq year_uniq[year_i])
    geotiff_file_average,file_list[file_pos],avr_data,avr_geoinfo
    write_tiff,output_directory+out_name,avr_data,/float,geotiff=avr_geoinfo
  endfor
  print,'年均值计算完成！'
  
  for month_i=0,n_elements(month_str)-1 do begin
    out_name='month_'+month_str[month_i]+'_average.tiff'
    file_pos=where(file_month eq month_str[month_i])
    geotiff_file_average,file_list[file_pos],avr_data,avr_geoinfo
    write_tiff,output_directory+out_name,avr_data,/float,geotiff=avr_geoinfo
  endfor
  print,'月均值计算完成！'
  
  for season_i=0,n_elements(season_str)-1 do begin
    out_name='season_'+season_str[season_i]+'_average.tiff'
    if season_i eq 0 then file_pos=where(file_month eq month_str[2] or file_month eq month_str[3] or file_month eq month_str[4])
    if season_i eq 1 then file_pos=where(file_month eq month_str[5] or file_month eq month_str[6] or file_month eq month_str[7])
    if season_i eq 2 then file_pos=where(file_month eq month_str[8] or file_month eq month_str[9] or file_month eq month_str[10])
    if season_i eq 3 then file_pos=where(file_month eq month_str[11] or file_month eq month_str[0] or file_month eq month_str[1])
    geotiff_file_average,file_list[file_pos],avr_data,avr_geoinfo
    write_tiff,output_directory+out_name,avr_data,/float,geotiff=avr_geoinfo
  endfor
  print,'季均值计算完成！'
  
  print,'程序运行结束！'
end