PRO SENTINEL
  DATA_primary="R:\PROject_practice\DATA_primary\"
  DATA_todB="R:\PROject_practice\DATA_todB\"
  DATA_Mosaic="R:\PROject_practice\DATA_Mosaic\"
  DATA_masked="R:\PROject_practice\DATA_masked\"
  DATA_40='R:\PROject_practice\DATA_40\'
  TEMP="R:\PROject_practice\TEMP\"
  python_path="x:/Programx699/ARCGIS/Python27/ArcGIS10.8/python.exe"
  xls_path="R:\PROject_practice\DATA_xls\"
  png_path="R:\PROject_practice\DATA_png\"
  tjpy_path='R:\PROject_practice\DATA_python\xlssc.py'
  pic_path='R:\PROject_practice\DATA_python\pic.py'
  
  
  
;  file_list=file_search(DATA_primary+'*.zip',count=file_n)
;  
;  L_dB=file_basename(file_search(DATA_40+'*.zip'),'.zip')
;  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
;  foreach L, L_dB,i do begin
;    a=where(file_basename(file_list,'.zip') eq  L)
;    if (a eq  -1) then begin
;    endif else begin
;      pos[a]=1
;    endelse
;  endforeach
;  DO_list=file_list[where(pos lt  0)]
;  GD=FIX(STRMID(file_basename(DO_list),49,6),TYPE=3)
;  GD40=DO_list[where((((GD -73) mod 175)+1)  eq  40)]
;  pos=where((((GD -73) mod 175)+1)eq  40)
;  if (GD40[0]  ne  '' and  pos[0]  ne  -1) then begin
;    for im = 0L, N_ELEMENTS(GD40)-1 do begin
;      SPAWN,'xcopy '+GD40[im]+' '+DATA_40+'/s /y',res
;      print,res
;    endfor
;  endif else begin
;  endelse



  Processing="R:\PROject_practice\DATA_Graph\Pre-Processing.xml"
  Mosaic_path="R:\PROject_practice\DATA_Graph\Mosaic"
  Clip_path="R:\PROject_practice\DATA_Graph\Clip.xml"
  CSV_path="R:\PROject_practice\DATA_SHPorETC\Boundary_of_Fuyang_city\subset.csv"
  
  
;  if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;  SPAWN,'xcopy '+TEMP+' '+DATA_masked+'/s /y'
;  SPAWN,'rd '+TEMP+' /s /q',/HIDE
;  
;  
;  
;  SPAWN,'rd '+TEMP+' /s /q',/HIDE
;  file_list=file_search(DATA_40+'*.zip',count=file_n)
;  if (file_n  eq  0) THEN  file_n=1
;
;  L_dB=file_basename(file_search(DATA_todB+'*_NR_Orb_Cal_Spk_TC_dB.dim'),'_NR_Orb_Cal_Spk_TC_dB.dim')
;  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
;  foreach L, L_dB,i do begin
;    a=where(file_basename(file_list,'.zip') eq  L )
;    if (a eq  -1) then begin
;    endif else begin
;      pos[a]=1
;    endelse
;  endforeach
;  DO_list=file_list[where(pos lt  0 )];and STRMID(FILE_BASENAME(file_list[*],'.dim'),17,4) eq  '2019'
;  
;  
;  totaltime1=systime(1)
;  for im = 0L, N_ELEMENTS(DO_list)-1 do begin
;    if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;    if (min(pos) ne  -999) then begin
;      print,"数据已全部处理"
;    endif else begin
;      start_time=systime(1)
;      SPAWN,"gpt "+Processing+' -Pinput1='+DO_list[im]+' -Poutput='+TEMP+file_basename(DO_list[im],'.zip')+'_NR_Orb_Cal_Spk_TC_dB.dim',res,/HIDE
;      print,res[-1]
;      PRINT,file_basename(DO_list[im])+'_NR_Orb_Cal_Spk_TC_dB.dim'+'  已处理，等待内存清理，剩余 '+STRING(N_ELEMENTS(DO_list)-im,'(I02)')+'项 ，共  '+STRING(N_ELEMENTS(DO_list),'(I02)')+'项'
;      WAIT,10
;      SPAWN,'taskkill /im X:\Programx699\snap\bin\gpt.exe',/HIDE
;      SPAWN,'xcopy '+TEMP+' '+DATA_todB+' /s /y',res,/HIDE
;      print,res[-1]
;      end_time=systime(1)
;      print,'内存清理完成，预处理耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;    endelse
;    SPAWN,'rd '+TEMP+' /s /q',/HIDE
;  endfor
;  totaltime2=systime(1)
;  print,'预处理共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'
;  
;  
;  
;  
;  totaltime1=systime(1)
;  file_list=file_search(DATA_todB+'*_NR_Orb_Cal_Spk_TC_dB.dim',count=file_n)
;  L_MOS=file_search(DATA_Mosaic+'*.dim')
;  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
;  foreach L, L_MOS,i do begin
;    a=where(STRMID(file_basename(file_list,'.dim'),17,6) eq  STRMID(file_basename(L),0,6))
;    pos[a]=a
;  endforeach
;  DO_list=file_list[where(pos le  0)]
;  pos1=where(pos le  0)
;  data_time_date=INTARR(N_ELEMENTS(DO_list),2)
;  data_time_date[*,0]=STRMID(FILE_BASENAME(DO_list[*],'.dim'),17,4)
;  data_time_date[*,1]=STRMID(FILE_BASENAME(DO_list[*],'.dim'),21,2)
;  
;  yyyy=REFORM((data_time_date[*,0]))
;  yyyy=yyyy.Sort()
;  yybs=yyyy.Uniq()
;  mm=REFORM((data_time_date[*,1]))
;  mm=mm.Sort()
;  mmbs=mm.Uniq()
;  
;  tmp=''
;  PRINT,"镶嵌开始"
;  foreach y, yybs do begin
;    foreach m, mmbs do begin
;      xpos=where(data_time_date[*,0] eq y and data_time_date[*,1] eq  m)
;      xxx=DO_list[xpos]
;      if (min(pos) ne  -999) then begin
;        print,"Mosaic已处理"
;      endif else begin
;        L_pos=where(STRMID(file_basename(xxx,'_NR_Orb_Cal_Spk_TC_dB.dim'),23,2)gt  15)
;        L_list=xxx[L_pos]
;        F_pos=where(STRMID(file_basename(xxx,'_NR_Orb_Cal_Spk_TC_dB.dim'),23,2)le  15)
;        F_list=xxx[F_pos]
;        if (F_pos[0] eq  -1 or xpos[0] eq  -1 or  N_ELEMENTS(F_pos) eq  1) then begin
;        endif else begin
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'F'+'镶嵌开始'+'使用第'+STRING(N_ELEMENTS(F_list),'(i01)')+'序列'
;          start_time=systime(1)
;          if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;          tmp=''
;          for ix = 0L, N_ELEMENTS(F_list)-1 do begin
;            tmp+=' -Pinput'+STRING(ix+1,'(I01)')+'='+F_list[ix]
;          endfor
;          SPAWN,'gpt '+Mosaic_path+STRING(N_ELEMENTS(F_list),'(i01)')+'.xml'+tmp+' -Poutput='+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'F',res,/HIDE
;          print,res[-1]
;          if ~file_test(TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'L',/directory) then $
;            SPAWN,'xcopy '+CSV_path+' '+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'F'+'.data\vector_data\'+' /s /y',/HIDE
;          print,TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'F'+'完成'
;          SPAWN,'xcopy '+TEMP+' '+DATA_Mosaic+' /s /y',res,/HIDE
;          print,res[-1]
;          SPAWN,'rd '+TEMP+' /s /q',/HIDE
;          end_time=systime(1)
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'F'+'镶嵌耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;        endelse
;        
;        if (L_pos[0] eq  -1 or xpos[0] eq  -1 or  N_ELEMENTS(L_pos) eq  1) then begin
;        endif else begin
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'L'+'镶嵌开始'+'使用第'+STRING(N_ELEMENTS(L_list),'(i01)')+'序列'
;          start_time=systime(1)
;          if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;          tmp=''
;          for ix = 0L, N_ELEMENTS(L_list)-1 do begin
;            tmp+=' -Pinput'+STRING(ix+1,'(I01)')+'='+L_list[ix]
;          endfor
;          SPAWN,'gpt '+Mosaic_path+STRING(N_ELEMENTS(L_list),'(i01)')+'.xml'+tmp+' -Poutput='+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'L',res,/HIDE
;          print,res[-1]
;          if ~file_test(TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'L',/directory) then $
;            SPAWN,'xcopy '+CSV_path+' '+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'L'+'.data\vector_data\'+' /s /y',/HIDE
;          print,TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'L'+'完成'
;          SPAWN,'xcopy '+TEMP+' '+DATA_Mosaic+' /s /y',res,/HIDE
;          print,res[-1]
;          SPAWN,'rd '+TEMP+' /s /q',/HIDE
;          end_time=systime(1)
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'L'+'镶嵌耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;        endelse
;        if (F_pos[0] ne  -1 and L_pos[0] ne  -1 and xpos[0] ne  -1  and  N_ELEMENTS(F_pos) eq  1and  N_ELEMENTS(L_pos) eq  1) then begin
;          A_pos=xpos
;          A_list=xxx
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'A'+'镶嵌开始'+'使用第'+STRING(N_ELEMENTS(A_list),'(i01)')+'序列'
;          start_time=systime(1)
;          if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;          tmp=''
;          for ix = 0L, N_ELEMENTS(A_list)-1 do begin
;            tmp+=' -Pinput'+STRING(ix+1,'(I01)')+'='+A_list[ix]
;          endfor
;          SPAWN,'gpt '+Mosaic_path+STRING(N_ELEMENTS(A_list),'(i01)')+'.xml'+tmp+' -Poutput='+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'A',res,/HIDE
;          print,res[-1]
;          if ~file_test(TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'A',/directory) then $
;            SPAWN,'xcopy '+CSV_path+' '+TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'A'+'.data\vector_data\'+' /s /y',/HIDE
;          print,TEMP+STRING(y,'(I04)')+STRING(m,'(I02)')+'A'+'完成'
;          SPAWN,'xcopy '+TEMP+' '+DATA_Mosaic+' /s /y',res,/HIDE
;          print,res[-1]
;          SPAWN,'rd '+TEMP+' /s /q',/HIDE
;          end_time=systime(1)
;          print,STRING(y,'(I04)')+STRING(m,'(I02)')+'A'+'镶嵌耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;        endif else begin
;        endelse
;
;      endelse
;    endforeach
;  endforeach
;  totaltime2=systime(1)
;  print,'镶嵌共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'
;  
;  
;  totaltime1=systime(1)
;  SPAWN,'rd '+TEMP+' /s /q',/HIDE
;  file_list=file_search(DATA_Mosaic+'*.dim',count=file_n)
;  if (file_n  eq  0) THEN  file_n=1
;  L_Ma=file_basename(file_search(DATA_masked,'*',count = num,/test_directory))
;  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
;  foreach L, L_Ma,i do begin
;    a=where(file_basename(file_list,'.dim') eq  L)
;    if (a eq  -1) then begin
;    endif else begin
;      pos[a]=1
;    endelse
;  endforeach
;  DO_list=file_list[where(pos lt  0)]
;  PRINT,"转换开始"
;  for im = 0L, N_ELEMENTS(do_list)-1 do begin
;    if (min(pos) ne  -999) then begin
;      PRINT,'已全部转换'
;    endif else begin
;      print,FILE_BASENAME(DO_list[im],'.dim')+'转换开始,剩余 '+STRING(N_ELEMENTS(DO_list)-im-1,'(I02)')+'项 ，共  '+STRING(N_ELEMENTS(DO_list),'(I02)')+'项'
;      start_time=systime(1)
;      if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;      SPAWN,'gpt '+Clip_path+' -Pinput1='+DO_list[im]+' -Poutput='+TEMP+FILE_BASENAME(DO_list[im],'.dim')+'.hdr',res,/HIDE
;      print,res[-1]
;      SPAWN,'xcopy '+TEMP+' '+DATA_masked+' /s /y',res,/HIDE
;      print,res[-1]
;      SPAWN,'rd '+TEMP+' /s /q',/HIDE
;      end_time=systime(1)
;      print,FILE_BASENAME(DO_list[im],'.dim')+'转换耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;    endelse
;  endfor
;  totaltime2=systime(1)
;  print,'转换共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'



  totaltime1=systime(1)
  SPAWN,'rd '+TEMP+' /s /q'
  file_list=file_search(DATA_masked,'*',count = file_n,/test_directory)
  if (file_n  eq  0) THEN  file_n=1
  L_xls=file_basename(file_search(xls_path,'*',/test_directory))
  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
  foreach L, L_xls,i do begin
    a=where(file_basename(file_list) eq  L)
    if (a eq  -1) then begin
    endif else begin
      pos[a]=1
    endelse
  endforeach
  DO_list=file_list[where(pos lt  0)]
  PRINT,"统计开始"
  for im = 0L, N_ELEMENTS(do_list)-1 do begin
    if (min(pos) ne  -999) then begin
      PRINT,'已全部处理'
    endif else begin
      print,FILE_BASENAME(DO_list[im])+'开始,剩余 '+STRING(N_ELEMENTS(DO_list)-im-1,'(I02)')+'项 ，共  '+STRING(N_ELEMENTS(DO_list),'(I02)')+'项'
      start_time=systime(1)
      if ~file_test(TEMP,/directory) then file_mkdir,TEMP
      SPAWN,python_path+' '+tjpy_path+' '+temp+' '+DO_list[im],res,/HIDE
      print,res[-1]
      SPAWN,'xcopy '+TEMP+'*.xls '+xls_path+FILE_BASENAME(DO_list[im])+'\ /s /y',res,err,/HIDE
      print,res[-1]
      SPAWN,'rd '+TEMP+' /s /q',/HIDE
      end_time=systime(1)
      print,FILE_BASENAME(DO_list[im])+'统计完成耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
    endelse
  endfor
  totaltime2=systime(1)
  print,'输出共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'
  
  
;  totaltime1=systime(1)
;  SPAWN,'rd '+TEMP+' /s /q'
;  file_list=file_search(xls_path,'*',count = file_n,/test_directory)
;  if (file_n  eq  0) THEN  file_n=1
;  L_png=file_basename(file_search(png_path,'*',count = file_n,/test_directory))
;  pos=MAKE_ARRAY(file_n,/INTEGER,VALUE=-999)
;  foreach L, L_png,i do begin
;    a=where(file_basename(file_list) eq  L)
;    if (a eq  -1) then begin
;    endif else begin
;      pos[a]=1
;    endelse
;  endforeach
;  DO_list=file_list[where(pos lt  0)]
;  PRINT,"出图开始"
;  for im = 0L, N_ELEMENTS(do_list)-1 do begin
;    if (min(pos) ne  -999) then begin
;      PRINT,'已全部处理'
;    endif else begin
;      print,FILE_BASENAME(DO_list[im])+'开始,剩余 '+STRING(N_ELEMENTS(DO_list)-im-1,'(I02)')+'项 ，共  '+STRING(N_ELEMENTS(DO_list),'(I02)')+'项'
;      start_time=systime(1)
;      if ~file_test(TEMP,/directory) then file_mkdir,TEMP
;      title=strmid(FILE_BASENAME(DO_list[im]),0,4)+' '+strmid(FILE_BASENAME(DO_list[im]),4,2)
;      SPAWN,python_path+' '+pic_path+' '+xls_path+FILE_BASENAME(DO_list[im])+'\ '+FILE_BASENAME(DO_list[im])+' '+TEMP+' '+title,res,err,/HIDE
;      print,res[-1]
;      SPAWN,'xcopy '+TEMP+'*.png '+png_path+FILE_BASENAME(DO_list[im])+'\ /s /y',res,err,/HIDE
;      print,res[-1]
;      SPAWN,'rd '+TEMP+' /s /q',/HIDE
;      end_time=systime(1)
;      print,FILE_BASENAME(DO_list[im])+'耗时'+string((end_time-start_time)/60,FORMAT='(F0.2)')+'min'
;    endelse
;  endfor
;  totaltime2=systime(1)
;  print,'输出共用时:'+string((totaltime2-totaltime1)/60,FORMAT='(F0.2)')+'min'



END