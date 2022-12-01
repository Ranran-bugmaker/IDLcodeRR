;程序信息
;ver 1.1
;date:2008-3-16
;Author:wulizong
;e-mail:wulizong@lzb.ac.cn
;中国科学院寒区旱区环境与工程研究所
;甘肃省兰州市东岗西路320号 邮编：730000
;电话：0931-4967298
;本程序受到国家基金委西部生态与环境数据中心和科技部地球系统科学数据共享网联合资助
;=========程序使用说明================================================================
;
;1.程序运行条件本程序需要在IDL+ENVI的环境下执行
;2.切割范围，数据存放地址等参数，请在Gimms_Clip程序块中修改
;3.数据的存放结构
;4.工作目录结构：如果工作目录不同，本程序可能无法正常执行
;数据目录/
;        input/     －－原始数据路径，默认名称为input,如果文件夹名称改变，请在程序中也相应改变
;             1981/
;             1982/
;             1983/
;             1984/
;             1985/
;             1986/
;             ..../
;        output/    －－输出数据路径，默认名称为output,如果文件夹名称改变，请在程序中也相应改变
;              1981/
;              1982/
;              1983/
;              1984/
;              1985/
;              1986/
;              ..../

;※※※※※※※程序修改历史※※※※※※※※※※
;v1.1 2008-3-16 程序基于从Gimms FTP站点上下载的原始数据上运行的，需要首先解压缩，然后再切割
;v1.0 2007-8-1  基于已经转换好的ENVI格式的全球数据进行切割的，不能对其它格式的数据进行读取

;代码部分
;请在此处定义程序运行所需的变量
PRO Def_Globalvar
    Comman_black

END
Function SourceRoot

  Compile_opt StrictArr

  HELP, Calls = Calls
  UpperRoutine = (StrTok(Calls[1], ' ', /Extract))[0]
  Skip = 0
  CATCH, ErrorNumber
  If (ErrorNumber Ne 0) Then Begin
    CATCH, /Cancel
    ThisRoutine = ROUTINE_INFO(UpperRoutine, /Functions, /Source)
    Skip = 1
  Endif
  If (Skip Eq 0) Then Begin
    ThisRoutine = ROUTINE_INFO(UpperRoutine, /Source)
    If (thisRoutine.Path Eq '') Then Begin
      MESSAGE,'',/traceback
    Endif
  Endif
  CATCH,/cancel
  If (STRPOS(thisroutine.path,PATH_SEP()) Eq -1 ) Then Begin
    CD, current=current
    sourcePath = FILEPATH(thisrouitine.path, root=current)
  Endif Else Begin
    sourcePath = thisroutine.path
  Endelse
  Root = STRMID(sourcePath, 0, STRPOS(sourcePath, PATH_SEP(), /Reverse_Search) + 1)
  RETURN, Root
End

Pro Gimms_Clip    ;文件名必须与程序名相同，否则无法编译


  ;=====设置工作目录路径=====
  inpath='d:\Gimms\input\'
  ;=====定义输出文件路径=====
  outpath='d:\Gimms\output\'
  ;设置切割范围需要切割的感兴趣区域
  ;=================以下为西部数据中心默认的中国子区范围====================
  west_x=70           ;西至     单位：度
  south_y=15          ;南至
  east_x=140          ;东至
  north_y=55          ;北至


  ;开始ENVI批处理模式
  envi, /restore_base_save_files
  envi_batch_init, log_file='batch.txt'
  ;搜索GIMMS数据

  Foldlist=FILE_SEARCH(inpath+'*',/TEST_DIRECTORY,count=num_folder);搜索文件夹

  For i=0,num_folder-1 Do Begin
    ;在输出文件夹中创建子目录
    CD,outpath
    pathpos=STRPOS(foldlist[i],'\',/REVERSE_SEARCH)
    Subdir=STRMID(foldlist[i],pathpos+1,4)
    FILE_MKDIR, Subdir    ;Create a subdirectory

    filelist=FILE_SEARCH(Foldlist[i]+'*.img',count=n)   ;获取图像文件名称
    For j=0,n-1 Do Begin
      filename=foldlist[i]+'\'+filelist[j]
      PRINT,filename
      envi_open_file, filename, r_fid=fid
      If (fid Eq -1) Then Begin
        envi_batch_exit
        RETURN
      Endif
      envi_file_query, fid, ns=ns, nl=nl, nb=nb
      dims = [-1, 0, ns-1, 0, nl-1]
      pos  = LINDGEN(nb)
      out_name = outpath+STRMID(foldlist[i],pathpos+1,4)+'\'+filelist[j]
      ;===================被切割数据信息=======================================
      ;以下信息从头文件中读取，注意起始点的经纬度不是-180度和-90度
      resolution=0.07272             ;分辨率,单位:度
      start_x=-179.55302900                  ;西至     单位：度
      start_y=90.03636360                   ;南至
      ;ENVI/IDL起始点是从左上角开始的
      start_sample=ROUND((west_x-start_x)/resolution)
      end_sample=ROUND((east_x-start_x)/resolution)
      start_line=ROUND((start_y-north_y)/resolution)
      end_line=ROUND((start_y-south_y)/resolution)
      ;执行切割操作
      envi_doit, 'resize_doit',$
        fid=fid, pos=pos, dims=[-1,start_sample,end_sample,start_line,end_line],$
        ;dims=[-1, 3432,4394,483,1032], $
        interp=0, rfact=[1,1],out_name=out_name, r_fid=r_fid
      ;输出缩略图
      data = ENVI_GET_DATA(fid=fid, dims=dims, pos=0)
      ; TV,data
      WRITE_JPEG,out_name+'.jpg',data,/order,QUALITY=100
    Endfor
  Endfor

  envi_batch_exit     ;退出批处理模式
End