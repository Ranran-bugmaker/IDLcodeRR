 ;+
 ;
 ;@Author 冉炯涛
 ;@Description //TODO 通过envi的glt来进行重投影,经纬度,pixelSize有最低线，使劲往小里写，tmppath临时文件夹，输出别往里放，
 ;@Date 2023-4-4 下午9:50:52
 ;@Param data,londata,latdata,outputname,tmppath,pixel_size=pixelSize
 ;@return
 ;
 ;-

pro DIY_GLT_warp,data,londata,latdata,outputname,tmppath,pixel_size=pixelSize
  if ~file_test(tmppath,/directory) then file_mkdir,tmppath
  sz=size(data)
  WRITE_TIFF, tmppath+"lon.tif", REFORM(londata,2,sz[-1]/2.0), /float
  WRITE_TIFF, tmppath+"lat.tif", REFORM(latdata,2,sz[-1]/2.0), /float
  WRITE_TIFF, tmppath+"tmp.tif", REFORM(data,2,sz[-1]/2.0), /float
  
  in_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)
  out_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)

  ENVI_OPEN_FILE, tmppath+"lon.tif", R_FID=lon_id
  ENVI_OPEN_FILE, tmppath+"lat.tif", R_FID=lat_id
  ENVI_OPEN_FILE, tmppath+"tmp.tif", R_FID=ds_id


  ENVI_DOIT, 'ENVI_GLT_DOIT', dims=dims, i_proj=in_prj, o_proj=out_prj, $
    out_name=tmppath+"glt.tif", pixel_size=pixelSize, rotation=0.0, $
    x_fid=lon_id, y_fid=lat_id, x_pos=0, y_pos=0, r_fid=glt_id
  print,pixelSize
  ENVI_DOIT, 'ENVI_GEOREF_FROM_GLT_DOIT', fid=ds_id, glt_fid=glt_id, $
    pos=0, out_name=outputname

  envi_file_mng, id=lon_id, /REMOVE
  envi_file_mng, id=lat_id, /REMOVE
  envi_file_mng, id=ds_id, /REMOVE
  envi_file_mng, id=glt_id, /REMOVE
  print,"GLT处理完成，文件已输出至"+outputname
  file_delete,tmppath,/RECURSIVE
;  file_delete, [tmppath+"lon.tif", tmppath+"lat.tif", tmppath+"glt.tif", tmppath+"tmp.tif"]
END