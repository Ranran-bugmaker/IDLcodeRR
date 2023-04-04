;+
;
;@Author 冉炯涛
;@Description //TODO 风云2D产品读取及出图
;@Date 2023-4-4 下午6:20:24
;@Param
;@return
;
;-
pro FY2Dreadandout
  
  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init
  
  hdfpath='R:\JX\dqyg\sy2\FY2D_FDI_ALL_NOM_20100101_2330.hdf'
  datpath='R:\JX\dqyg\sy2\NOM_ITG_2288_2288(0E0N)_LE.dat'
  tmppath='R:\JX\dqyg\sy2\tmp\'
  
  ;
;  data=read_binary(datpath,TEMPLATE=tp)
;  swap_endian_inplace,data, /SWAP_IF_BIG_ENDIAN
;  OPENR,1,datpath
;  nl=file_lines(datpath)
;  readf,1,tmp
;  readu,1,tmp
;  CLOSE,1
  
  openr,1,datpath
  arrdata=fltarr(2288,2288,2)
  readu,1,arrdata
  swap_endian_inplace,arrdata, /SWAP_IF_BIG_ENDIAN
  CLOSE,1
  
  hdfpath='R:\JX\dqyg\sy2\FY2D_FDI_ALL_NOM_20100101_2330.hdf'
  file_id = H5F_OPEN(hdfpath)
  

  
  
  ;读取红外波段信息（以红外2波段为例）
  IR2dataname=H5D_OPEN(file_id,'NOMChannelIR2')
  IR2data=H5D_READ(IR2dataname)

  ;读取波段对应的定标表
  CAL2dataname=H5D_OPEN(file_id,'CALChannelIR2')
  CAL2data=H5D_READ(CAL2dataname)
  
  IR2data[where(IR2data eq 65535.0)]=!VALUES.F_NAN
  IR2data=fix(IR2data)
  tmp=FLOAT(IR2data)
  tmp[*]=!VALUES.F_NAN
  for n = 1L, N_ELEMENTS(CAL2data)-1 do tmp[where(IR2data eq n)]=CAL2data[n]
  
  
  lon=arrdata[*,*,0]+86.5
  lon[where(lon eq 386.50000)]=!VALUES.F_NAN
  lat=arrdata[*,*,1]
  lat[where(lat eq 386.50000)]=!VALUES.F_NAN
  
  data_col=size(IR2data)
  pos=where((lon ge 73) and (lon le 136) and (lat ge 13) and (lat le 54),count)
  
  DIY_GLT_warp,tmp[pos],lon[pos],lat[pos],"R:\JX\dqyg\sy2\tmp.tif",tmppath,PIXEL_SIZE=0.02
;  WRITE_TIFF, tmppath+"lon.tif", REFORM(lon[pos],4,162285), /float
;  WRITE_TIFF, tmppath+"lat.tif", REFORM(lat[pos],4,162285), /float
;  WRITE_TIFF, tmppath+"tmp.tif", REFORM(tmp[pos],4,162285), /float
;
;;  pos_col=pos mod data_col[1]
;;  pos_line=pos/data_col[1]
;;  col_min=min(pos_col)
;;  col_max=max(pos_col)
;;  line_min=min(pos_line)
;;  line_max=max(pos_line)
;
;
;;  chinalonlat=tmp[col_min:col_max,line_min:line_max]
;  
;  
;;  data_warp,chinalonlat,lat[col_min:col_max,line_min:line_max],lon[col_min:col_max,line_min:line_max],$
;;    0.04,5,0.3,warped_band3,geo_info
;    in_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)
;    out_prj = ENVI_PROJ_CREATE(/GEOGRAPHIC)
;    
;    ENVI_OPEN_FILE, tmppath+"lon.tif", R_FID=lon_id
;    ENVI_OPEN_FILE, tmppath+"lat.tif", R_FID=lat_id
;    ENVI_OPEN_FILE, tmppath+"tmp.tif", R_FID=ds_id
;
;    
;    ENVI_DOIT, 'ENVI_GLT_DOIT', dims=dims, i_proj=in_prj, o_proj=out_prj, $
;      out_name=tmppath+"glt.tif", pixel_size=0.2, rotation=0.0, $
;      x_fid=lon_id, y_fid=lat_id, x_pos=0, y_pos=0, r_fid=glt_id
;    print,dims
;    ENVI_DOIT, 'ENVI_GEOREF_FROM_GLT_DOIT', fid=ds_id, glt_fid=glt_id, $
;      pos=0, out_name="R:\JX\dqyg\sy2\tmp.tif"
;
;    envi_file_mng, id=lon_id, /REMOVE
;    envi_file_mng, id=lat_id, /REMOVE
;    envi_file_mng, id=ds_id, /REMOVE
;    envi_file_mng, id=glt_id, /REMOVE
;    print, 123
;
;    file_delete, [tmppath+"lon.tif", tmppath+"lat.tif", tmppath+"glt.tif", tmppath+"tmp.tif"]
    
    
END