pro py
  TEMP="R:\PROject_practice\TEMP\"
  python_path="x:/Programx699/ARCGIS/Python27/ArcGIS10.8/python.exe"
  xls_path="R:\PROject_practice\DATA_xls\"
  png_path="R:\PROject_practice\DATA_png\"
  tjpy_path='R:\PROject_practice\DATA_python\xlssc.py'
  pic_path='R:\PROject_practice\DATA_python\pic.py'
  
  totaltime1=systime(1)
  file_list=file_search(xls_path,'*',count = file_n,/test_directory)
  DO_list=file_list
  PRINT,"出图开始"
  for im = 0L, N_ELEMENTS(do_list)-1 do begin
    print,FILE_BASENAME(DO_list[im])+'开始,剩余 '+STRING(N_ELEMENTS(DO_list)-im-1,'(I02)')+'项 ，共  '+STRING(N_ELEMENTS(DO_list),'(I02)')+'项'
    start_time=systime(1)
    if ~file_test(TEMP,/directory) then file_mkdir,TEMP
    title=strmid(FILE_BASENAME(DO_list[im]),0,4)+' '+strmid(FILE_BASENAME(DO_list[im]),4,2)
    SPAWN,python_path+' '+pic_path+' '+xls_path+FILE_BASENAME(DO_list[im])+'\ '+FILE_BASENAME(DO_list[im])+' '+TEMP+' '+title,res,err,/HIDE
    print,res[-1]
    SPAWN,'xcopy '+TEMP+'*.png '+png_path+FILE_BASENAME(DO_list[im])+'\ /s /y',res,err,/HIDE
    print,res[-1]
    SPAWN,'rd '+TEMP+' /s /q',/HIDE
    end_time=systime(1)
    print,FILE_BASENAME(DO_list[im])+'耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
  endfor
  totaltime2=systime(1)
  print,'输出共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'
end