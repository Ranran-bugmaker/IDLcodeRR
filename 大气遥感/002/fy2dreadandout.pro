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

  ENVI_OPEN_FILE,datpath,R_FID=lonlatid
  envi_file_query, lonlatid, dims=dims,FNAME=fname,NB=nb,NL=nl,NS=ns,SENSOR_TYPE=sensorType
  lon=ENVI_GET_DATA(FID=lonlatid,DIMS=dims,POS=0)
  lon[where(lon eq 300.0)]=!VALUES.F_NAN
  lon=lon+86.5
  lat=ENVI_GET_DATA(FID=lonlatid,DIMS=dims,POS=1)
  lat[where(lat eq 300.0)]=!VALUES.F_NAN
  arrdata=[lon+86.5,lat]
  
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
  
  data_col=size(IR2data)
  pos=where((lon ge 73) and (lon le 136) and (lat ge 3) and (lat le 54),count)
  
  DIY_GLT_warp,tmp[pos],lon[pos],lat[pos],"R:\JX\dqyg\sy2\out.tif",tmppath,PIXEL_SIZE=0.2
  ENVI_BATCH_EXIT
END