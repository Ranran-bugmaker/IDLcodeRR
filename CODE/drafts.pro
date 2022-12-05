pro Drafts
  RESTORE,'R:\PROject_practice\DATA_2csv\datav.sav'
  RESTORE,'R:\PROject_practice\DATA_2csv\yandm.sav'
  names=["小麦","水体","建筑"]
  bandnames=["Gamma0_VH","Gamma0_VV","Sigma0_VH","Sigma0_VV","Gamma_diff","Gamma_ratio"]
  csv_path='R:\PROject_practice\DATA_2csv\'
  
  timesnames=''
  for fis = 0L, N_ELEMENTS(s)-1 do timesnames+=s[fis]+','
  
  
  for shpi = 0L, 2L do begin
    for bandi = 0L, 5L do begin
      OPENw,lun,csv_path+names[shpi]+'-'+bandnames[bandi]+'.csv',/GET_LUN
      FREE_LUN,lun
      OPENw,lun,csv_path+names[shpi]+'-'+bandnames[bandi]+'.csv',/GET_LUN,/APPEND
      fistline=bandnames[bandi]+','+timesnames
      PRINTF,lun,fistline
      for enti = 0L, N_ELEMENTS(datav[shpi,*,0,bandi])-1 do begin
        sss=string(enti+1,FORMAT='(F0.5)')+','
        for ti = 0L, N_ELEMENTS(datav[shpi,enti,*,bandi])-1 do begin
          sss+=string(datav[shpi,enti,ti,bandi],FORMAT='(F0.5)')+','
        endfor
      PRINTF,lun,sss
      endfor
      FREE_LUN,lun
    endfor
  endfor
  print,"over"
end