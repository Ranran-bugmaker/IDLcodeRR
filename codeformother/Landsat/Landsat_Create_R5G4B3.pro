PRO Landsat_Create_R5G4B3
  workspace='D:\Python\GLOF\landsat\'
  outpath='D:\Python\GLOF\output\'
  dirs=file_search(workspace,'*',/test_directory)
  compile_opt strictarr
  envi,/restory_base_save_files
  envi_batch_init, LOG_FILE = 'batch.log',/NO_STATUS_WINDOW
  
  for i=0,n_elements(dirs)-1 do begin
    filelist=file_search(dirs[i],'*B50.tif',count=count)
    if count eq 1 then begin
    file_band5=filelist[0]
    file_band4=strmid(file_band5,0,strlen(file_band5)-6)+'40.TIF'
    file_band3=strmid(file_band5,0,strlen(file_band5)-6)+'30.TIF'
    print,file_band5
    print,file_band4
    print,file_band3
    envi_open_file,file_band5,r_fid=fid5
    envi_open_file,file_band4,r_fid=fid4
    envi_open_file,file_band3,r_fid=fid3
    envi_file_query,fid5,dims=dims_5
    envi_file_query,fid4,dims=dims_4
    envi_file_query,fid3,dims=dims_3
    basename=file_basename(file_band5)
    out_proj = envi_get_projection(fid=fid5,pixel_size=out_ps) 
    ENVI_DOIT, 'ENVI_LAYER_STACKING_DOIT',DIMS=[[dims_5],[dims_4],[dims_3]],$
        FID=[fid5,fid4,fid3], /IN_MEMORY,$
        INTERP=0, OUT_BNAME=['band5','band4','band3'],out_ps=out_ps,out_proj=out_proj,pos=[0,0,0],$
        OUT_DT=1,R_FID=rfid

    envi_file_query,rfid,dims=dims,ns=ns
    
    out_filename=outpath+strmid(basename,0,strlen(basename)-8)+'.TIF'
    ENVI_OUTPUT_TO_EXTERNAL_FORMAT,DIMS=dims,FID=rfid,$
         OUT_BNAME=['band5','band4','band3'],OUT_NAME=out_filename, POS=[0,1,2], /TIFF
;    ENVI_OUTPUT_TO_EXTERNAL_FORMAT,DIMS=[[dims_5],[dims_4],[dims_3]],FID=[fid5,fid4,fid3],$
;         OUT_BNAME=['band5','band4','band3'],OUT_NAME=out_filename, POS=[[0],[0],[0]], /TIFF 
    
    endif
  endfor

  envi_batch_exit

end