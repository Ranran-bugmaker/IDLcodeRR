function modis_grid_geo_transform,modis_file,target_data,helpme=helpme
  if keyword_set(helpme) then begin
    print,'函数功能为返回MODIS grid数据中每个像元的对应经纬度'
    print,'输入参数：'
    print,'modis_file：待生成经纬度坐标的modis正弦投影文件名'
    print,'target_data：待做投影转换的目标数据'
    print,'返回值：'
    print,'文件每个像元的对应的经纬度坐标结果数组，其中第0列为经度，第1列为纬度'
    return,0
  endif
  
  data_size=size(target_data)

  sd_id=hdf_sd_start(modis_file,/read)
  gindex=hdf_sd_attrfind(sd_id,'StructMetadata.0')
  hdf_sd_attrinfo,sd_id,gindex,data=metadata

  ul_start_pos=strpos(metadata,'UpperLeftPointMtrs')
  ul_end_pos=strpos(metadata,'LowerRightMtrs')
  ul_info=strmid(metadata,ul_start_pos,ul_end_pos-ul_start_pos)
  ul_info_spl=strsplit(ul_info,'=(,)',/extract)
  ul_prj_x=double(ul_info_spl[1])
  ul_prj_y=double(ul_info_spl[2])

  lr_start_pos=strpos(metadata,'LowerRightMtrs')
  lr_end_pos=strpos(metadata,'Projection')
  lr_info=strmid(metadata,lr_start_pos,lr_end_pos-lr_start_pos)
  lr_info_spl=strsplit(lr_info,'=(,)',/extract)
  lr_prj_x=double(lr_info_spl[1])
  lr_prj_y=double(lr_info_spl[2])

  sin_resolution=(lr_prj_x-ul_prj_x)/(data_size[1])
  proj_x=dblarr(data_size[1],data_size[2])
  proj_y=dblarr(data_size[1],data_size[2])
  for col_i=0,data_size[1]-1 do proj_x[col_i,*]=ul_prj_x+(sin_resolution*col_i)
  for line_i=0,data_size[2]-1 do proj_y[*,line_i]=ul_prj_y-(sin_resolution*line_i)

  sin_prj=map_proj_init('sinusoidal',/gctp,sphere_radius=6371007.181d,center_longitude=0.0d,false_easting=0.0d,false_northing=0.0d)
  geo_loc=map_proj_inverse(proj_x,proj_y,map_structure=sin_prj)
  return,geo_loc
end