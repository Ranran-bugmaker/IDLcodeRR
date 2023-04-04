pro pj_cty
  res=0.06
  degree=5
  control_point_percent=0.1
  
  input='R:\IDL\resource\MOD11B3'
  output='R:\IDL\resource\MOD11B3\cty\'
  if~file_test(input,/directory) then begin
    print,'输入路径不存在'
    return
  endif
  if~file_test(output,/directory) then file_mkdir,output
  ;找一行几幅图
  file_list=file_search(input,'*.hdf',count=file_n)
  file_name=strmid(file_basename(file_list),9,7)
  file_h=strmid(file_basename(file_list),18,2)
  file_v=strmid(file_basename(file_list),21,2)
  filename_uniq=file_name.uniq()
  fileh_uniq=file_h.uniq()
  filev_uniq=file_v.uniq()
  print,fileh_uniq[10]
  ncol=n_elements(fileh_uniq)
  nline=n_elements(filev_uniq)
  ;找x，y方向的分辨率
  sd_id=hdf_sd_start(file_list[0],/read)
  gindex=hdf_sd_attrfind(sd_id,'StructMetadata.0')
  hdf_sd_attrinfo,sd_id,gindex,data=metadata

  xres_pos=strpos(metadata,'XDim')
  yres_pos=strpos(metadata,'YDim')
  info=strmid(metadata,xres_pos,yres_pos-xres_pos)
  xinfo_spl=strsplit(info,'=',/extract)
  xdim=fix(xinfo_spl[1])
  
  yresd_pos=strpos(metadata,'YDim')
  ul_pos=strpos(metadata,'UpperLeftPointMtrs')
  lr_info=strmid(metadata,yresd_pos,ul_pos-yresd_pos)
  yinfo_spl=strsplit(lr_info,'=',/extract)
  ydim=fix(yinfo_spl[1])
  ;创建数组
  data_arr=fltarr(xdim*ncol,ydim*nline)
  for file_i=0,file_n-1 do begin
    data_temp=hdf4_data_get(file_list[file_i],'LST_Day_6km')
    scale=hdf4_attdata_get(file_list[file_i],'LST_Day_6km','scale_factor')
    range=hdf4_attdata_get(file_list[file_i],'LST_Day_6km','valid_range')
    data_temp=(data_temp ge range[0] and data_temp le range[1])*data_temp*scale[0]
    data_temp=data_temp*data_temp/data_temp
    col=file_h[file_i]
    line=file_v[file_i]
    cs=col-fix(fileh_uniq[0])
    ls=line-fix(filev_uniq[0])
    data_arr[cs*xdim:(cs+1)*xdim-1,ls*ydim:(ls+1)*ydim-1]=data_temp
  endfor
  
  sd_id=hdf_sd_start(file_list[0],/read)
  gindex=hdf_sd_attrfind(sd_id,'StructMetadata.0')
  hdf_sd_attrinfo,sd_id,gindex,data=metadata
  ul_start_pos=strpos(metadata,'UpperLeftPointMtrs')
  ul_end_pos=strpos(metadata,'LowerRightMtrs')
  ul_info=strmid(metadata,ul_start_pos,ul_end_pos-ul_start_pos)
  ul_info_spl=strsplit(ul_info,'=(,)',/extract)
  ul_prj_x=double(ul_info_spl[1])
  ul_prj_y=double(ul_info_spl[2])
  
  sd_id=hdf_sd_start(file_list[file_n-1],/read)
  gindex=hdf_sd_attrfind(sd_id,'StructMetadata.0')
  hdf_sd_attrinfo,sd_id,gindex,data=metadata
  lr_start_pos=strpos(metadata,'LowerRightMtrs')
  lr_end_pos=strpos(metadata,'Projection')
  lr_info=strmid(metadata,lr_start_pos,lr_end_pos-lr_start_pos)
  lr_info_spl=strsplit(lr_info,'=(,)',/extract)
  lr_prj_x=double(lr_info_spl[1])
  lr_prj_y=double(lr_info_spl[2])

  data_size=size(data_arr)
  sin_resolution=(lr_prj_x-ul_prj_x)/(data_size[1])
  proj_x=dblarr(data_size[1],data_size[2])
  proj_y=dblarr(data_size[1],data_size[2])
  for col_i=0,data_size[1]-1 do proj_x[col_i,*]=ul_prj_x+(sin_resolution*col_i)
  for line_i=0,data_size[2]-1 do proj_y[*,line_i]=ul_prj_y-(sin_resolution*line_i)
  sin_prj=map_proj_init('sinusoidal',/gctp,sphere_radius=6371007.181d,center_longitude=0.0d,false_easting=0.0d,false_northing=0.0d)
  geo_loc=map_proj_inverse(proj_x,proj_y,map_structure=sin_prj)
  help,geo_loc,data_arr
  data_warp,data_arr,geo_loc[0,*],geo_loc[1,*],res,degree,control_point_percent,warp_data,geo_info

  write_tiff,output+'w.tiff',warp_data,/float,geotiff=geo_info
  print,'结束！'
   
end