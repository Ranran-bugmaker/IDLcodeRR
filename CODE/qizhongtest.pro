PRO qizhongtest
  input_directory='R:\IDL\resource\MOD11B3\'
  out='R:\IDL\resource\res\'
  tmp_path='R:\temp\'
  if ~file_test(out,/directory) then file_mkdir,out
  if ~file_test(tmp_path,/directory) then file_mkdir,tmp_path
  file_list=file_search(input_directory+'*.hdf',count=file_n)
  data_time_date=STRARR(file_n,3)
  orgin_data=FLTARR(file_n,200,200)
  data=FLTARR(file_n,200,200)
  ULPP=DBLARR(file_n,2)
  LONSC=DBLARR(file_n,200,200)
  LATSC=DBLARR(file_n,200,200)
  start_time=systime(1)
  for i = 0L, file_n-1 do begin
    
    attributee_txt = DIY_h4_info(file_list[i],"CoreMetadata.0",KEY=1)
    DIY_Attributes_txt,attributee_txt,attributee_txt2,NAME="RANGEBEGINNINGDATE",IDCODE="OBJECT"
    DIY_Attributes_txt,attributee_txt2,date_time,IDCODE="VALUE",/KEY
    data_time_date[i,0]=STRMID(date_time[1],0,4)
    data_time_date[i,1]=STRMID(date_time[1],5,2)
    data_time_date[i,2]=STRMID(date_time[1],8,2)
    orgin_data[i,*,*]=DIY_h4_info(file_list[i],"LST_Day_6km")
    DIMS=size(REFORM(orgin_data[i,*,*]))
    scale_factor=DIY_h4_info(file_list[i],['LST_Day_6km','scale_factor'],KEY=2)
    orgin_data[i,*,*]=(orgin_data[i,*,*] ne  0)*scale_factor[0]*orgin_data[i,*,*]
    point=DIY_h4_info(file_list[i],"StructMetadata.0",KEY=1)
    DIY_Attributes_txt,point,point2,IDCODE="UpperLeftPointMtrs",/KEY
    ULP=DOUBLE(STRSPLIT(point2[1],',',/EXTRACT))
    ULPP[I,*]=ULP
    DIY_Attributes_txt,point,point2,IDCODE="LowerRightMtrs",/KEY
    LRP=DOUBLE(STRSPLIT(point2[1],',',/EXTRACT))
    x=DBLARR(2,2)
    y=DBLARR(2,2)
    x_dpi=abs(ULP[0]-LRP[0])/DIMS[1]
    x[0,*]=ULP[0]
    x[1,*]=LRP[0]
    y[*,0]=ULP[1]
    y[*,1]=LRP[1]
    geo_sin_box_x=DBLARR(DIMS[1],DIMS[2])
    geo_sin_box_y=DBLARR(DIMS[1],DIMS[2])
    geo_sin_box_x=CONGRID(x,DIMS[1],DIMS[2],/INTERP,/MINUS_ONE)
    geo_sin_box_y=CONGRID(y,DIMS[1],DIMS[2],/INTERP,/MINUS_ONE)
    sinproj=MAP_PROJ_INIT('sinusoidal',/GCTP,SPHERE_RADIUS=6371007.181,CENTER_LONGITUDE=0.0,FALSE_EASTING=0.0,FALSE_NORTHING=0.0)
    geo_loc=MAP_PROJ_INVERSE(geo_sin_box_x,geo_sin_box_y,MAP_STRUCTURE=sinproj)
    geo_cgs_lon=geo_loc[0,*]
    geo_cgs_lat=geo_loc[1,*]
    
    ;REFORM(geo_loc[1,*],DIMS[1],DIMS[2])
    if (max(geo_loc[0,*])-min(geo_loc[0,*]))  gt 350  then begin
      if (MEAN(geo_cgs_lon)  gt  0) then begin
        geo_cgs_lon[where(geo_cgs_lon le  0)]=geo_cgs_lon[where(geo_cgs_lon le  0)]*(-1)
      endif else begin
      endelse
    endif else begin
    endelse
    
    
;    
    DIY_data_warp,REFORM(orgin_data[i,*,*]),REFORM(geo_cgs_lon),REFORM(geo_cgs_lat),0.05,5,1,datatmp2,geo_info
    write_tiff,tmp_path+STRING(data_time_date[i,0])+STRING(data_time_date[i,1])+STRING(data_time_date[i,2])+STRING(i,'(I03)')+'.tiff',$
      datatmp2,/FLOAT,geotiff=geo_info
    print,tmp_path+STRING(data_time_date[i,0])+STRING(data_time_date[i,1])+STRING(data_time_date[i,2])+STRING(i,'(I03)')
  endfor


  end_time=systime(1)
  print,'Time consuming: '+strcompress(string(end_time-start_time))
  print,"投影完成"
  
  yyyy=REFORM((data_time_date[*,0]))
  yyyy=yyyy.Sort()
  yybs=yyyy.Uniq()
  mm=REFORM((data_time_date[*,1]))
  mm=mm.Sort()
  mmbs=mm.Uniq()

  foreach y, yybs do begin
    foreach m, mmbs do begin
      DIY_jiont_grid,REFORM(orgin_data[where(data_time_date[*,0] eq y and data_time_date[*,1] eq  m),*,*]),$
        REFORM(ULPP[where(data_time_date[*,0] eq y and data_time_date[*,1] eq  m),0]),$
        REFORM(ULPP[where(data_time_date[*,0] eq y and data_time_date[*,1] eq  m),1]),data,min=min,max=max
      write_tiff,out+STRING(y,FORMAT='(i04)')+'-'+STRING(m,FORMAT='(i02)')+'_gird.tiff',data,/FLOAT
      xX=DBLARR(2,2)
      yX=DBLARR(2,2)
      DIMS=SIZE(data)
      xX[0,*]=min[0]
      xX[1,*]=max[0]
      yX[*,0]=min[1]
      yX[*,1]=max[1]
      geo_sin_box_x=CONGRID(Xx,DIMS[1],DIMS[2],/INTERP,/MINUS_ONE)
      geo_sin_box_y=CONGRID(yX,DIMS[1],DIMS[2],/INTERP,/MINUS_ONE)
      sinproj=map_proj_init('sinusoidal',/gctp,sphere_radius=6371007.181d,center_longitude=0.0d,false_easting=0.0d,false_northing=0.0d)
      geo_loc=MAP_PROJ_INVERSE(geo_sin_box_x,geo_sin_box_y,MAP_STRUCTURE=sinproj)
      geo_cgs_lon=ROTATE(REFORM(geo_loc[0,*],DIMS[1],DIMS[2]),7)
      geo_cgs_lat=ROTATE(REFORM(geo_loc[1,*],DIMS[1],DIMS[2]),7)
      if (max(geo_loc[0,*])-min(geo_loc[0,*]))  gt 350  then begin
        if (MEAN(geo_cgs_lon)  gt  0) then begin
          geo_cgs_lon[where(geo_cgs_lon le  0)]=180
        endif else begin
        endelse
      endif else begin
      endelse
      DIY_data_warp,data,geo_cgs_lon,geo_cgs_lat,0.05,5,0.1,datatmp2,geo_info
      write_tiff,out+STRING(y,FORMAT='(i04)')+'-'+STRING(m,FORMAT='(i02)')+'_gird_TY.tiff', datatmp2,/FLOAT,geotiff=geo_info
    endforeach
  endforeach

  
  
  file_list=file_search(tmp_path+'*.*',count=file_n)
  data_time_date=INTARR(file_n,2)
  data_time_date[*,0]=STRMID(FILE_BASENAME(file_list[*],'.tif'),0,4)
  data_time_date[*,1]=STRMID(FILE_BASENAME(file_list[*],'.tif'),4,2)
  yyyy=REFORM((data_time_date[*,0]))
  yyyy=yyyy.Sort()
  yybs=yyyy.Uniq()
  mm=REFORM((data_time_date[*,1]))
  mm=mm.Sort()
  mmbs=mm.Uniq()

  foreach y, yybs do begin
    foreach m, mmbs do begin
      DIY_joint,file_list[where(data_time_date[*,0] eq y and data_time_date[*,1] eq  m)],data,geo
      DIY_grid_IDW,data,data2,NULLKEY=0,POINTKEY=15,SEARCHDISKEY=3
      write_tiff,out+STRING(y,FORMAT='(i04)')+'-'+STRING(m,FORMAT='(i02)')+'_cgs.tiff',data2,/FLOAT,geotiff=geo
    endforeach
  endforeach

  
  if file_test(tmp_path,/directory) then file_delete,tmp_path,/RECURSIVE
  print,"okk!"
END