Pro GPS_DEM
 ;定义DEM和GPS数据的路径,其中gps是以shapefile存储的点数据
  demfile=’D:\IDLWorkspace\GPS\Data\dem_data’
  shapefile=’D:\IDLWorkspace\GPS\Data\gps.shp’
   Compile_opt strictarr
  ; 开始ENVI批处理
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, LOG_FILE = ‘batch.log’
  
  ENVI_OPEN_DATA_FILE,demfile,r_fid=fid, /ESRI_GRID ;读取ESRI arcview GRID 格式
  
  ENVI_FILE_QUERY,fid,ns=ns,nl=nl,dims=dims
  dem=envi_get_data(fid=fid,dims=dims,pos=0)
  mapinfo=ENVI_GET_MAP_INFO(fid=fid)
  ;DEM的起始点
  start_X=(mapinfo.mc)[2]
  start_y=(mapinfo.mc)[3]
  ;DEM栅格大小
  cell_size=(mapinfo.ps)[0]
  
  oshp=OBJ_NEW(’IDLffShape’,shapefile,/update)
  oshp->GetProperty,n_Entities=n_ent,N_ATTRIBUTES=n_attr
  
  For i=0,n_ent-1 Do Begin
    ent=oshp->GetEntity(i)
    attr=oshp->GetAttributes(i)
    
    bound=ent.bounds
    ;GPS坐标
    x=bound[0]
    y=bound[1]
    ;GPS 高程值
    gps=attr.(1) ;1表示高程值存放在第二个字段中
    pos_x=FIX((x-start_x)/cell_size)
    pos_y=FIX((start_y-y)/cell_size)
    ;print,fix(pos_x)+1,fix(pos_y)+1
    data=dem[pos_x,pos_y] ;GPS对应的DEM栅格值
    
    attr.(2)=data-gps ;差值，2表示差值结果存放在第3个字段中，该字段必须提前存在
    
    oshp->SetAttributes,i,attr ;写入
    oshp->DestroyEntity,ent
  Endfor
  OBJ_DESTROY,oshp
  
  ; 结束ENVI批处理
  ENVI_BATCH_EXIT