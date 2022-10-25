pro DIY_pinjie,output,file,name
  ;对系列geotiff图像进行拼接
  ;output 输出目录
  ;file 文件列表
  ;name 文件名
  start_time=systime(1)
  out_E_N=file_test(output,/directory)
  if out_E_N eq 0 then begin
    file_mkdir,output
  endif
  file_n=n_elements(file)
  lonminlist=fltarr(file_n)
  latmaxlist=fltarr(file_n)
  lonmaxlist=fltarr(file_n)
  latminlist=fltarr(file_n)
  for file_i=0,file_n-1 do begin
    data=read_tiff(file[file_i],geotiff=geo_info)
    resolution_tag=geo_info.(0)
    geo_tag=geo_info.(1)
    data_size=size(data)
    lonminlist[file_i]=geo_tag[3]
    lonmaxlist[file_i]=lonminlist[file_i] + data_size[1]*resolution_tag[0]
    latmaxlist[file_i]=geo_tag[4]
    latminlist[file_i]=latmaxlist[file_i] - data_size[2] *resolution_tag[1]
  endfor
  lonminlist=lonminlist.Sort()
  lonmaxlist=lonmaxlist.sort()
  latminlist=latminlist.sort()
  latmaxlist=latmaxlist.Sort()

  ;
  data_box_geo_col=ceil((lonmaxlist[-1]-lonminlist[0])/resolution_tag[0])
  data_box_geo_line=ceil((latmaxlist[-1]-latminlist[0])/resolution_tag[1])
  data_box_geo_sum=fltarr(data_box_geo_col,data_box_geo_line)
  data_box_geo_num=fltarr(data_box_geo_col,data_box_geo_line)
  for file_i=0,file_n-1 do begin
    data=read_tiff(file[file_i],geotiff=geo_info)
    data_size=size(data)
    data_col=data_size[1]
    data_line=data_size[2]
    resolution_tag=geo_info.(0)
    geo_tag=geo_info.(1)

    col_start=floor(abs(geo_tag[3]-lonminlist[0])/resolution_tag[0])
    col_end=col_start+data_col-1
    line_start=floor(abs(latmaxlist[-1]-geo_tag[4])/resolution_tag[1])
    line_end=line_start+data_line-1
    data_box_geo_sum[col_start:col_end,line_start:line_end]+=data
    data_box_geo_num[col_start:col_end,line_start:line_end]+=(data gt 0.0)
  endfor
  data_box_geo_num=(data_box_geo_num gt 0.0)*data_box_geo_num+(data_box_geo_num eq 0.0)
  data_box_geo_avr=data_box_geo_sum/data_box_geo_num

  geo_info={$
    MODELPIXELSCALETAG:[ resolution_tag[0], resolution_tag[1],0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,lonminlist[0],latmaxlist[-1],0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}

  write_tiff,output+name+".tif",data_box_geo_avr,geotiff=geo_info,/float
  end_time=systime(1)
  print,'Time consuming: '+strcompress(string(end_time-start_time))
end