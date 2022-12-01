;+
;  《IDL程序设计》
;   -数据可视化与ENVI二次开发
;        
; 示例代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;-
;+
; :Description:
;   Runs FX in batch with input and output filenames specificed by command line arguments.
; :Author:
;   Benjamin D. Kamphaus
; :Requires:
;   ENVI license
; :Copyright:
;   ITT Visual Information Solutions
;  Modified By DYQ
;   2011年5月5日
;-
PRO ENVI_FX, folder, ruleSetFilename, outFolder
  COMPILE_OPT idl2, hidden
  ;初始化ENVI二次开发模式
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT;如不希望出现ENVI进度条则添加"/No_Status_Window"
  ;定义输入数据的搜索扩展名
  fileExtension='tif'
  ;如果输入为空则返回
  IF (folder EQ '') THEN RETURN
  ;搜索输入文件
  imgFiles=FILE_SEARCH(folder,'*.'+fileExtension,/FOLD_CASE,COUNT=count)
  ;参数是否满足输入要求
  ruleFileExist = FILE_TEST(ruleSetFilename)
  outFolderExist = FILE_TEST(outFolder,/directory)
  IF (count EQ 0)OR ~ruleFileExist OR ~outFolderExist THEN BEGIN
    void=DIALOG_MESSAGE(['不存在要处理的文件:',$
      '',folder])
    RETURN
  ENDIF
  
  ;根据文件个数依次循环操作
  FOR i = 0 ,(count-1) DO BEGIN
    ;文件打开与基本信息查询
    ENVI_OPEN_FILE, imgFiles[i], R_FID=fid
    IF (fid EQ -1) THEN BEGIN
      CONTINUE
    ENDIF
    ENVI_FILE_QUERY, fid, DIMS=dims, NS=ns, NL=nl, NB=nb
    pos = LINDGEN(nb)
    ;定义输出文件名
    shpFile=outFolder+path_sep()+FILE_BASENAME(imgFiles[i],fileExtension)+'shp'
    ;执行ENVI的Feature Extraction功能
    ENVI_DOIT, 'ENVI_FX_DOIT', fid=fid, dims=dims, pos=pos, scale_level=40.0, merge_level=95.0, $
      ruleset_filename=ruleSetFilename, vector_filename=shpFile, smoothing_threshold=0.0, $
      r_fid=r_fid
      
  ENDFOR
  
END