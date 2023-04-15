pro readandout
  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init
  datapath='R:\JX\dqyg\sy3\MOD05_L2.A2008125.0320.005.2008126075028.hdf'
  localpath='R:\JX\dqyg\sy3\MOD03.A2008125.0320.005.2008125132121.hdf'
  
  data=DIY_h4_info(datapath,'Water_Vapor_Near_Infrared')
  scale=DIY_h4_info(datapath,['Water_Vapor_Near_Infrared','scale_factor'],KEY=2)
  fill_value=DIY_h4_info(datapath,['Water_Vapor_Near_Infrared','_FillValue'],KEY=2)
  
  data[WHERE(data eq fill_value[0])]=!VALUES.F_NAN
  dataout=(data+1000)*scale[0]
  
  data1=DIY_h4_info(datapath,'Water_Vapor_Infrared')
  scale1=DIY_h4_info(datapath,['Water_Vapor_Infrared','scale_factor'],KEY=2)
  fill_value1=DIY_h4_info(datapath,['Water_Vapor_Infrared','_FillValue'],KEY=2)
  
  data1[WHERE(data1 eq fill_value1[0])]=!VALUES.F_NAN
  dataout1=(data1+1000)*scale1[0]
  
  Lon=DIY_h4_info(localpath,'Longitude')
  Lat=DIY_h4_info(localpath,'Latitude')
  
  Lon1=DIY_h4_info(datapath,'Longitude')
  Lat1=DIY_h4_info(datapath,'Latitude')
  
  DIY_GLT_warp,dataout,lon,lat,"R:\JX\dqyg\sy3\out.tif","R:\JX\dqyg\sy3\tmp\",PIXEL_SIZE=0.02
  DIY_GLT_warp,dataout1,lon1,lat1,"R:\JX\dqyg\sy3\out1.tif","R:\JX\dqyg\sy3\tmp\",PIXEL_SIZE=0.2
  
  ENVI_OPEN_FILE,"R:\JX\dqyg\sy3\out.tif",R_FID=aid
  envi_file_query, aid, dims=dims,FNAME=fname,NB=nb,NL=nl,NS=ns,SENSOR_TYPE=sensorType
  a=ENVI_GET_DATA(FID=aid,DIMS=dims,POS=0)
  
;  a=READ_TIFF("R:\JX\dqyg\sy3\out.tif",GEOTIFF=geoinfo)
  a[WHERE(a eq 0)]=!VALUES.F_NAN
  a=a-1000*scale[0]
  map_info = envi_get_map_info(fid=aid)
  envi_file_mng,id = aid,/remove,/delete
  WRITE_TIFF,"R:\JX\dqyg\sy3\out000000.tif",a,/FLOAT,GEOTIFF=map_info.PROJ
  
  ENVI_OPEN_FILE,"R:\JX\dqyg\sy3\out1.tif",R_FID=aid
  envi_file_query, aid, dims=dims,FNAME=fname,NB=nb,NL=nl,NS=ns,SENSOR_TYPE=sensorType
  a=ENVI_GET_DATA(FID=aid,DIMS=dims,POS=0)
  
;  a=READ_TIFF("R:\JX\dqyg\sy3\out1.tif",GEOTIFF=geoinfo)
  a[WHERE(a eq -0)]=!VALUES.F_NAN
  a=a-1000*scale[0]
  map_info = envi_get_map_info(fid=aid)
  envi_file_mng,id = aid,/remove,/delete
  WRITE_TIFF,"R:\JX\dqyg\sy3\out0000001.tif",a,/FLOAT,GEOTIFF=map_info.PROJ
  
END