pro average_by_shpfile_batch
  input_directory='R:\IDL\resource\data\chapter_2\chapter_0/';tiff文件所在的输入路径
  shp_directory='R:\IDL\resource\data\chapter_2\chapter_0\shp_out\';用shp_polygon_extract代码提取出的分区县shp文件输入路径
  output_directory='R:\IDL\resource\data\chapter_2\chapter_0\stat_result\';结果输出路径
  output_csv=output_directory+'average_result.csv';统计结果csv文件名
  if ~(file_test(output_directory,/directory)) then file_mkdir,output_directory

  tiff_file_list=file_search(input_directory+'*.tiff',count=tiff_file_n)
  par_name=strsplit(file_basename(tiff_file_list),'_',/extract)
  par_name_array=par_name.toarray()
  shp_file_list=file_search(shp_directory,'*.shp',count=shp_file_n)
  average_record=fltarr(tiff_file_n,shp_file_n)
  openw,1,output_csv
  date_str='year_'+par_name_array[*,0]+'_'+par_name_array[*,1]
  format_h='(A,",",'+strtrim(string(tiff_file_n),2)+'(A,:,","))'
  format_str='(A,",",'+strtrim(string(tiff_file_n),2)+'(F0.3,:,","))'
  print,format_h,' ',format_str
  print,'county',date_str,format=format_h
  printf,1,'county',date_str,format=format_h

  for tiff_file_i=0,tiff_file_n-1 do begin
    
    for shp_file_i=0,shp_file_n-1 do begin
      subset_name=output_directory+file_basename(shp_file_list[shp_file_i],'.shp')+'_'+$
        file_basename(tiff_file_list[tiff_file_i],'.tiff')
      subset_by_shp,tiff_file_list[tiff_file_i],shp_file_list[shp_file_i],subset_name;裁剪
      ;均值处理
      data=read_tiff(subset_name)
      data=data*data/data;去除0值
      data_mean=mean(data,/nan)
      average_record[tiff_file_i,shp_file_i]=data_mean;算均值
      
      
      
    endfor
  endfor

  for shp_file_i=0,shp_file_n-1 do begin
     printf,1,file_basename(shp_file_list[shp_file_i],'.shp'),average_record[*,shp_file_i],format=format_str
  endfor
  free_lun,1
end