;=======================================================================
;本程序需要在IDL环境下运行，可在IDL6.X-7.x环境下的测试。
;请尽量不要修改程序文件名称，如需修改，请将程序名称与程序文件名称保持一致，否则会导致程序无法正常运行。
;Author:wulizong
;data:2006-7
;e-mail:wulizong@lzb.ac.cn
;中国科学院寒区旱区环境与工程研究所
;History:v0.1  /2006-7-30:export shapefile using 'ENVI_EVF_TO_SHAPEFILE' Routines
;        v0.2  /2006-7-30:export shapefile using IDL's 'IDLffShape' object,only read attribute of aster data
;        v0.3.1/2006-8-6:增加处理错误的代码
;        v0.4  /2007-2-1:在filename字段中只存储文件名，去掉了前面的路径，可以保证filename长度不会过长
;        v0.5  /2007-12-10:优化了部分，修订了输出shapefile文件无法在arcgis中打开的问题,
;               增加了aster所属UTM分区的字段和aster中心位置字段

;===========说明=====================
;图像四个角的位置信息是存放在hdf的全局属性表中，具体的表达格式如下
;GROUP                  = SCENEFOURCORNERS

;      OBJECT                 = UPPERLEFT
;        NUM_VAL              = 2
;        VALUE                = (37.5778999276982, 103.791291574291)
;      END_OBJECT             = UPPERLEFT
;
;      OBJECT                 = UPPERRIGHT
;        NUM_VAL              = 2
;        VALUE                = (37.4517375704332, 104.621551361705)
;      END_OBJECT             = UPPERRIGHT
;
;      OBJECT                 = LOWERLEFT
;        NUM_VAL              = 2
;        VALUE                = (37.0196378138701, 103.661625220573)
;      END_OBJECT             = LOWERLEFT
;
;      OBJECT                 = LOWERRIGHT
;        NUM_VAL              = 2
;        VALUE                = (36.8943161860939, 104.485971865434)
;      END_OBJECT             = LOWERRIGHT
;
;END_GROUP              = SCENEFOURCORNERS

;=======================================================================
Pro aster_footprint

  ;*****************修改文件输入输出设置**************************
  workspace='D:\IDLWorkspace\aster\data\'                       ;Aster影像的存放地址
  logfile='D:\IDLWorkspace\aster\data\errlog.txt'               ;运行日志文件名及其存储位置
  shapefile='D:\IDLWorkspace\aster\data\ASTER_L1A_Indexmap.shp' ;输出的shapefile文件名及其存储位置
  boundary_file='D:\IDLWorkspace\boundary\boundary_poly.shp'
  ;*************************************************************
  
  filelist=FILE_SEARCH(workspace+'*.hdf',count=n)
  If n Eq 0 Then Begin
    PRINT,'no hdf file'
    RETURN
  Endif
  
  ;打开错误日志文件，准备往里面写信息
  OPENW,lun,logfile,/get_lun
  ;打开中国边界数据，用于判断aster位于那个省份
  obound=OBJ_NEW('IDLffShape',boundary_file)
  obound->GetProperty,N_Entities=n_bound_ent
  
  oshp=OBJ_NEW('IDLffShape',shapefile,/update,ENTITY_TYPE=5)
  ;创建shape属性表文件
  oshp->AddAttribute, 'ID', 3, 4,PRECISION=0
  oshp->AddAttribute, 'FileName',7, 50,PRECISION=0
  oshp->AddAttribute, 'FileSize',7,10,PRECISION=0
  oshp->AddAttribute, 'Cent_Lon',5,8,PRECISION=4
  oshp->AddAttribute, 'Cent_Lat',5,8,PRECISION=4
  oshp->AddAttribute, 'UTM_Zone',7,8,PRECISION=0
  oshp->AddAttribute, 'Province',7,20,PRECISION=0
  
  entity={IDL_SHAPE_ENTITY}
  entity.SHAPE_TYPE = 5
  j=0L
  
  For i=0,n-1 Do Begin
    fileid=HDF_OPEN(filelist[i],/read) ;测试hdf数据是否有效，是否可以打开，如果不能打开则将文件名记录到日志文件中
    If (fileid Eq -1) Then Begin
      PRINT,'The error file name is: ' + filelist[i]
      PRINTF,  lun,filelist[i]+'can not open!'
      Continue
    Endif Else Begin
      hdfid=HDF_SD_START(filelist[i],/read);打开hdf格式的文件,获取id值
      
      metaindex=HDF_SD_ATTRFIND(hdfid,'productmetadata.0')               ;
      
      HDF_SD_ATTRINFO,hdfid,metaindex,DATA=meta;获取的元数据存储在mete变量中
      HDF_SD_END,hdfid
      HDF_CLOSE,fileid
      ;四角坐标
      firstpos=STRPOS(meta,'SCENEFOURCORNERS')
      lastpos=STRPOS(meta,'SCENEFOURCORNERS',/REVERSE_SEARCH)
      Scene4Corners=STRMID(meta,firstpos,lastpos-firstpos)
      ;提取4个角坐标的字符
      upperleft=STRMID(Scene4Corners,STRPOS(Scene4Corners,'UPPERLEFT'),STRPOS(Scene4Corners,'UPPERLEFT',/REVERSE_SEARCH)-STRPOS(Scene4Corners,'UPPERLEFT'))
      upperright=STRMID(Scene4Corners,STRPOS(Scene4Corners,'UPPERRIGHT'),STRPOS(Scene4Corners,'UPPERRIGHT',/REVERSE_SEARCH)-STRPOS(Scene4Corners,'UPPERRIGHT'))
      lowerleft=STRMID(Scene4Corners,STRPOS(Scene4Corners,'LOWERLEFT'),STRPOS(Scene4Corners,'LOWERLEFT',/REVERSE_SEARCH)-STRPOS(Scene4Corners,'LOWERLEFT'))
      lowerright=STRMID(Scene4Corners,STRPOS(Scene4Corners,'LOWERRIGHT'),STRPOS(Scene4Corners,'LOWERRIGHT',/REVERSE_SEARCH)-STRPOS(Scene4Corners,'LOWERRIGHT'))
      
      ;提取经纬度值,注意元数据中坐标是以(y,x)表示的
      upperleft_x=FLOAT(STRMID(upperleft,STRPOS(upperleft,',')+1,STRPOS(upperleft,')')-STRPOS(upperleft,',')-1))
      upperleft_y=FLOAT(STRMID(upperleft,STRPOS(upperleft,'(')+1,STRPOS(upperleft,',')-STRPOS(upperleft,'(')-1))
      
      upperright_x=FLOAT(STRMID(upperright,STRPOS(upperright,',')+1,STRPOS(upperright,')')-STRPOS(upperright,',')-1))
      upperright_y=FLOAT(STRMID(upperright,STRPOS(upperright,'(')+1,STRPOS(upperright,',')-STRPOS(upperright,'(')-1))
      
      lowerleft_x=FLOAT(STRMID(lowerleft,STRPOS(lowerleft,',')+1,STRPOS(lowerleft,')')-STRPOS(lowerleft,',')-1))
      lowerleft_y=FLOAT(STRMID(lowerleft,STRPOS(lowerleft,'(')+1,STRPOS(lowerleft,',')-STRPOS(lowerleft,'(')-1))
      
      lowerright_x=FLOAT(STRMID(lowerright,STRPOS(lowerright,',')+1,STRPOS(lowerright,')')-STRPOS(lowerright,',')-1))
      lowerright_y=FLOAT(STRMID(lowerright,STRPOS(lowerright,'(')+1,STRPOS(lowerright,',')-STRPOS(lowerright,'(')-1))
      ;图幅中心点坐标
      firstpos=STRPOS(meta,'SCENECENTER')
      lastpos=STRPOS(meta,'SCENECENTER',/REVERSE_SEARCH)
      center_string=STRMID(meta,firstpos,lastpos-firstpos)
      
      ;提取经纬度值,注意元数据中坐标是以(y,x)表示的
      center_x = FLOAT(STRMID(center_string,STRPOS(center_string,',')+1,STRPOS(center_string,')')-STRPOS(center_string,',')-1))
      center_y = FLOAT(STRMID(center_string,STRPOS(center_string,'(')+1,STRPOS(center_string,',')-STRPOS(center_string,'(')-1))
      
      Zone = STRTRIM(STRING(FIX(center_x/6)+31),2)
      ;判断aster属于那个省份,要经过两层判断，
      ;省界与aster边界有几种关系，1）aster图框包含在某一省界内，2）省界与aster省界相交，3）某一省界包含在aster图框范围
      
      name='中国以外区域'
      points=[[upperleft_x,upperleft_y],[upperright_x,upperright_y],[lowerleft_x,lowerleft_y],[lowerright_x,lowerright_y]]
      oROI_1=OBJ_NEW('IDLanROI',[[upperleft_x,upperleft_y],[upperright_x,upperright_y],$
        [lowerleft_x,lowerleft_y],[lowerright_x,lowerright_y],[upperleft_x,upperleft_y]])
      For k =0,n_bound_ent-1 Do Begin
        bound_ent=obound->Getentity(k)
        vert=*(bound_ent.vertices)
        index=oROI_1->ContainsPoints(vert)
        res=WHERE(index Eq 1,num )
        If num Gt 0 Then Begin
          bound_attr=obound->GetAttributes(k)
          temp_name=bound_attr.(6)             ;6代表省名所在的字段序号，如果不是使用程序提供的边界数据，需要重新设定该序号
          name=[name,temp_name]
        Endif
        oROI = OBJ_NEW('IDLanROI',vert)
        index=oROI->ContainsPoints(points)
        res=WHERE(index Eq 1,num )
        
        If num Gt 0 Then Begin
          bound_attr=obound->GetAttributes(k)
          temp_name=bound_attr.(6)             ;6代表省名所在的字段序号，如果不是使用程序提供的边界数据，需要重新设定该序号
          name=[name,temp_name]
        Endif
      Endfor
      
      If N_ELEMENTS(name) Gt 1 Then Begin
        name=name[1:*]
        name=name[UNIQ(name,SORT(name))]
        
      Endif 
      
      province_name =''
      For k=0,N_ELEMENTS(name)-1 Do Begin
        if  k eq 0 then province_name=name[k] else $
          province_name=province_name+','+name[k]
      Endfor
      
      
      ;写入shapefile
      
      attr= oshp->GetAttributes(/ATTRIBUTE_STRUCTURE)
      entity.ISHAPE = j
      entity.N_VERTICES=5
      
      entity.bounds=[MIN([upperleft_x,upperright_x,lowerleft_x,lowerright_x],max=max_x),$
        MIN([upperleft_y,upperright_y,lowerleft_y,lowerright_y],max=max_y),0,0,$
        max_x,max_y,0,0]
      pvertice=[upperleft_x,upperleft_y,upperright_x,upperright_y,$
        lowerright_x,lowerright_y,lowerleft_x,lowerleft_y,upperleft_x,upperleft_y]
        
      entity.VERTICES=PTR_NEW(pvertice,/no_copy)
      
      basename=FILE_BASENAME(filelist[i])
      fileinfo=FILE_INFO(filelist[i])
      filesize=STRTRIM(STRING((fileinfo.size)/1024.0/1024.0),2)
      
      attr.(0) = j
      attr.(1) = basename
      attr.(2) = filesize+' Mb'
      attr.(3) = center_x
      attr.(4) = center_y
      attr.(5) = zone
      attr.(6) = province_name
      oshp->PutEntity,entity
      oshp->SetAttributes,j,attr
      j=TEMPORARY(j)+1
    Endelse
  Endfor
  oshp->DestroyEntity, entity
  OBJ_DESTROY, oshp;释放对象
  OBJ_DESTROY,obound
  FREE_LUN,lun
  print,'=====end====='
End