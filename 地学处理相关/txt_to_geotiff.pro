pro txt_to_geotiff
;将txt文件内数据转换为tiff，类似于插值
  txt_file='R:\IDL\resource\data\chapter_4\2013_year_aop.txt'
  openr,1,txt_file
  str=''
  readf,1,str 
  parameters=strsplit(str,' ',/extract)
  par_n=n_elements(parameters)
  line=file_lines(txt_file)-1
  data=fltarr(par_n,line)
  readf,1,data
  free_lun,1
  
  lon=data[0,*]
  lat=data[1,*]
  res=0.18
  for par_i=2,par_n-1 do begin
    out_tiff='D:\WorkSpace_IDL\resource\data\chapter_4\2013_year_aop.txt'+parameters[par_i]+'.tiff'
    target_data=data[par_i,*]    
    data_box_geo_generating,lon,lat,target_data,res,data_box_interp,geoinfo
    write_tiff,out_tiff,data_box_interp,geotiff=geoinfo,/float
  endfor  
end