;创建ASTER缩略图的程序,v0.1
;缩略图采用Aster band1,band2,band3组合，大小为原数据可见光部分的5/1，如要改变缩略图的大小，请调整程序中的datasize
;datasize=size(red)/5,可以采用固定值
;本程序需在IDL环境下运行，请编译后直接运行，然后从打开窗口中选取文件。生成的缩略图放在原来的ASTER文件目录中，
;文件名与原文件相同,后缀为.jpg
;Author:wulizong
;Create data:2006-8-6
;History:
;        v0.1:只适合ASTER L1A数据
;        v0.2:适合ASTER L1B和ASTER L1A 数据
pro asterthumbnail
  Compile_opt strictarr
  workspace = 'D:\IDLWorkspace\aster\data\'
  filelist=FILE_SEARCH(workspace+'*.hdf',count=n)

  For i=0,n-1 Do Begin
    outfile=filelist[i]+'.jpg'
    fileid=HDF_OPEN(filelist[i],/read)
    If(fileid Eq -1) Then Begin
      PRINT,'The Error File Name is: '+filename[i]
      Continue
    Endif
    hdfid=HDF_SD_START(filelist[i],/read)
    ;Create a arrary variable to story the datasets name
    CATCH, Error_status
    ;This statement begins the error handler:
    If Error_status Ne 0 Then Begin
      PRINT, 'Error index: ', Error_status
      PRINT, 'Error message: ', !ERROR_STATE.MSG
      PRINT, 'the error file is:'+filename[i]
      Continue
    Endif
    ;获取hdf中的变量名称
    varnames = ''

    HDF_SD_FILEINFO, hdfid, n_vars, n_glo_atts
    print,filelist[i]
    print,n_vars
    ;=====for L1A========
    ;Aster L1A数据产品有194个变量,而L1B只有26个变量
    ;Aster L1A中所有波段的变量名都为'ImageData'
    ;Aster L1B中前3个波段的名称分别为ImageData1,ImageData2,ImageData3N

    If (n_vars Gt 26) Then Begin
      index=WHERE(varnames Eq 'ImageData')
      index_r=index[0]
      index_g=index[0]
      index_b=index[0]
    Endif else begin
    	index_r=HDF_SD_NAMETOINDEX(hdfid,'ImageData1')
      index_g=HDF_SD_NAMETOINDEX(hdfid,'ImageData2')
      index_b=HDF_SD_NAMETOINDEX(hdfid,'ImageData3N')
    endelse

    ;读取数据
    datasetid_r=HDF_SD_SELECT(hdfid,index_r)
    datasetid_g=HDF_SD_SELECT(hdfid,index_g)
    datasetid_b=HDF_SD_SELECT(hdfid,index_b)
    ;Get data
    HDF_SD_GETDATA,datasetid_r,red
    HDF_SD_GETDATA,datasetid_g,green
    HDF_SD_GETDATA,datasetid_b,blue
    ;get data info
    datasize=SIZE(red)/5

    thumbnail=BYTARR(3,datasize[1],datasize[2])
    thumbnail[0,*,*]=CONGRID(blue,datasize[1],datasize[2])
    thumbnail[1,*,*]=CONGRID(green,datasize[1],datasize[2])
    thumbnail[2,*,*]=CONGRID(red,datasize[1],datasize[2])

    HDF_SD_END,hdfid
    HDF_CLOSE,fileid

    window,xsize=datasize[1],ysize=datasize[2],/free,/pixmap
    tvscl,thumbnail,/order
    WRITE_JPEG,outfile,tvrd(true=1),TRUE = 1,QUALITY = 100,/order
  Endfor
  PRINT,'programe is end'
End