;作者:吴立宗
;邮箱:wulizong@lzb.ac.cn
;目的:AVHRR PathFinder 很少有人用了,从网上下载的数据一般是Goode投影的，但一般下载文件只有数据没有头文件，常规软件很难打开
;    这是程序给AVHRR PathFinder数据添加头文件并转为Envi .img格式的程序
;    另外，附带生产缩略图
;     本程序需要调用ENVI过程
;代码修改日志:
;2007-7-8 非常粗糙的一个程序，弄够干自己的活了。
Pro AVHRR_PathFinder_add_header_file
  Compile_opt strictarr
  ;输入文件地址
  workspace='D:\10days_ASIA\AVHRR_ASIA_NDVI_10_day\'
  ;输出文件地址
  outpath='D:\10days_ASIA\AVHRR_ASIA_NDVI_10_day_ENVI\'
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, LOG_FILE = 'batch.log'
  
  Filelist=FILE_SEARCH(workspace,'*.*',count=count)
  image=BYTARR(1004,565)
  Start_lon=70.11246
  Start_lat=56.40732
  
  basename=FILE_BASENAME(filelist)
  year_str=STRMID(basename,20,2)
  HELP,year_str
  year_str=year_str[uniq(year_str,SORT(year_str))]
  year=STRARR(N_ELEMENTS(year_str))
  For i=0,N_ELEMENTS(year_str)-1 Do Begin
    If STRMID(year_str[i],0,1) Eq '0' Then Begin
      year[i]='20'+year_str[i]
    Endif Else Begin
      year[i]='19'+year_str[i]
    Endelse
    FILE_MKDIR,outpath+year[i]
  Endfor
  
  For i=0,count-1 Do Begin
    filename=filelist[i]
    basename=FILE_BASENAME(filename)
    year_str=STRMID(basename,20,2)
    
    If STRMID(year_str,0,1) Eq '0' Then Begin
      year='20'+year_str
    Endif Else Begin
      year='19'+year_str
    Endelse
    
    OPENR,lun,filename,/get_lun
    READU,lun,image
    FREE_LUN,lun
    
    outname=outpath+year+'\'+FILE_BASENAME(filename)+'.img'
    ProjName=envi_translate_projection_name(24)
    
    PARAMS=[6370997.00,24]
    units= envi_translate_projection_units('Meters')
    Proj=ENVI_PROJ_CREATE(name=projname,type=24,datum='',Params=params,units=units)
    
    Goode=Map_proj_init('Interrupted Goode',datum='Sphere',/GCTP,SPHERE_RADIUS=6370997.00 )
    Goode_xy=MAP_PROJ_FORWARD(Start_lon,Start_lat,MAP_STRUCTURE=Goode)    
    
    mapinfo=ENVI_MAP_INFO_CREATE(name=projname,datum='',params=Params,proj=proj,$
      PS=[8000,8000],MC=[0,0,Goode_xy],units=units)
    ;print,proj.params
    ENVI_WRITE_ENVI_FILE,image,out_dt=1,ns=1004,nl=565,out_name=outname,$
      map_info=mapinfo,r_fid=fid     
    ;
    WRITE_JPEG,outname+'.jpg',image,/order
    
  Endfor
  
  
  ; Exit ENVI
  ENVI_BATCH_EXIT
  PRINT,'end'
End