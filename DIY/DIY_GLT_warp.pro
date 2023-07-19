 ;+
 ;
 ;@Author 冉炯涛
 ;@Description //TODO 通过envi的glt来进行重投影,经纬度,pixelSize有最低线，使劲往小里写，tmppath临时文件夹，输出别往里放，
 ;@Date 2023-4-4 下午9:50:52
 ;@Param 
 ;@return
 ;
 ;-

 ;+
 ;
 ;@Author 冉炯涛
 ;	:Description:
 ;		 //TODO TODOlist
 ;	:Date 2023年4月13日 下午8:40:54
 ;	:Params:
 ;  data,londata,latdata,outputname,tmppath,pixel_size=pixelSize
 ;	:keywords:
 ;
 ;	:return:
 ;
 ;-

function findBestMatrix,arr
  n = n_elements(arr)
  min_missing = n
  for i = 2L, n/2L do begin
    if ((n mod i) eq 0) then begin
      j = n/i
      matrix = reshape(arr, [i, j])
      missing = total(isnan(matrix))
      if (missing lt min_missing) then begin
        min_missing = missing
        best_matrix = matrix
      endif
    endif
  endfor
  return, best_matrix
end

pro DIY_GLT_warp,data,lon=londata,lat=latdata,outputname,pixel_size=pixelSize
  compile_opt idl2
  e=ENVI(/headless)
  ENVI,/restore_base_save_files
  envi_batch_init
  
  tmppath=FILE_DIRNAME(ENVI.GETTEMPORARYFILENAME(/CLEANUP_ON_EXIT),/MARK_DIRECTORY)
  if ~file_test(tmppath,/directory) then file_mkdir,tmppath
  sz=size(data)
  a=tmppath+'lon.tif'
  PRINT,a
  b=tmppath+'lat.tif'
  PRINT,b
  c=tmppath+'data.tif'
  PRINT,c
;  ar = ENVIRaster(londata,URI=a,DATA_IGNORE_VALUE=-9999.0)
;  ar.Save
;  br = ENVIRaster(londata,URI=b,DATA_IGNORE_VALUE=-9999.0)
;  br.Save
;  cr = ENVIRaster(londata,URI=c,DATA_IGNORE_VALUE=-9999.0)
;  cr.Save
  WRITE_TIFF, a, londata, /float
  WRITE_TIFF, b, latdata, /float
  WRITE_TIFF, c, data, /float
  
  in_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)
  out_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)
  ENVI_OPEN_FILE, a, R_FID=lon_id
  ENVI_OPEN_FILE, b, R_FID=lat_id
  ENVI_OPEN_FILE, c, R_FID=ds_id

  glt=tmppath+'glt.tif'
  PRINT,glt
  ENVI_DOIT, 'ENVI_GLT_DOIT', dims=dims, i_proj=in_prj, o_proj=out_prj, $
    out_name=glt, pixel_size=pixelSize, rotation=0.0, $
    x_fid=lon_id, y_fid=lat_id, x_pos=0, y_pos=0, r_fid=glt_id
  print,pixelSize
  ENVI_DOIT, 'ENVI_GEOREF_FROM_GLT_DOIT', fid=ds_id, glt_fid=glt_id, $
    pos=0,BACKGROUND=!values.F_NAN, out_name=outputname ;tmppath+'tmp.dat'
  
;  envi_open_file,tmppath+'tmp.dat',r_fid = ifid
;  envi_file_query,ifid ,dims = dims,nb = nb
;  ENVI_OUTPUT_TO_EXTERNAL_FORMAT, $
;    dims = dims,pos = lindgen(nb),out_name = outputname,/tiff,fid = ifid
;  envi_file_mng,id = ifid,/remove,/delete
  
  envi_file_mng, id=lon_id, /REMOVE,/DELETE
  envi_file_mng, id=lat_id, /REMOVE,/DELETE
  envi_file_mng, id=ds_id, /REMOVE,/DELETE
  envi_file_mng, id=glt_id, /REMOVE,/DELETE
  file_delete,tmppath,/RECURSIVE
  print,"GLT处理完成，文件已输出至"+outputname
;  file_delete, [tmppath+"lon.tif", tmppath+"lat.tif", tmppath+"glt.tif", tmppath+"tmp.tif"]
  ENVI.CleanupTemporaryWorkspace
  ENVI.Close
END