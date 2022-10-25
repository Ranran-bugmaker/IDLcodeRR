pro histogram_drawing_batch
  hist_xmin=260.0;直方图x轴最小值
  hist_xmax=320.0;直方图x轴最大值
  hist_ymin=0;直方图y轴最小值
  hist_ymax=40;直方图y轴最大值
  
  input_directory='R:\IDL\resource\data\chapter_2\chapter_0/';tiff文件所在的输入路径
  subset_directory='R:\IDL\resource\data\chapter_2\chapter_0/subset/';裁剪结果输出路径
  output_directory='R:\IDL\resource\data\chapter_2\chapter_0/subset/png/';直方图结果输出路径
  shp_file='R:\IDL\resource\data\chapter_2\chapter_0/sichuan_county_wgs84.shp';裁剪用矢量文件名
  if ~file_test(subset_directory,/directory) then file_mkdir,subset_directory;裁剪路径不存在则建立文件夹
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory;直方图输出路径不存在则建立文件夹
  file_list=file_search(input_directory+'*.tiff',count=file_n);搜索文件并统计数理
  for file_i=0,file_n-1 do begin;循环裁剪和直方图制图
    subset_file=subset_directory+FILE_BASENAME(file_list[file_i],'.tiff')+'_subest.tiff'
    barpng=output_directory+FILE_BASENAME(file_list[file_i],'.tiff')+'_subest.png'
    name_split=STRSPLIT(FILE_BASENAME(file_list[file_i],'.tiff'),'_',/EXTRACT)
    subset_by_shp,file_list[file_i],shp_file,subset_file
    data=read_tiff(subset_file)
    data=data*data/data
    data_stats=where(data gt 0,valid_pixel_num)
    data_hist=histogram(data,min=hist_xmin,max=hist_xmax,binsize=5.0)
    x=findgen(13)*5+260.0
    data_hist_freq=data_hist*100.0/float(valid_pixel_num)
    bar=barplot(x,data_hist_freq,/histogram,xrange=[hist_xmin,hist_xmax],yrange=[hist_ymin,CEIL(max(data_hist_freq)/5)*5],xtickinterval=5,$
      xtitle='地表温度 (K)',ytitle='像元数量占比 (%)',title='四川地区地表温度统计直方图 ('+name_split[0]+'年'+name_split[1]+'月)',$
      font_name='Kaiti',font_size='18',fill_color='yellow green',thick=2,dimension=[800,800])
    bar.Save,barpng
    bar.Close
  endfor
end