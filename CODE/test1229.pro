pro test1229
  Rpath="R:\DATA_sen1\"
  output="R:\DATA_sen1\DATA_db\"
  xmlpath='R:\DATA_sen1\cs.xml'
  
  flist=FILE_SEARCH(Rpath+'*.zip',count=file_n)
  
  for fi = 0L, file_n-1 do begin
    out=output  + FILE_BASENAME(flist[fi],'.zip')+".dim"
    SPAWN,"gpt "+xmlpath+' -Pinput1='+flist[fi] + ' -Poutput='+out,res,/HIDE
    print,res[-1]
  endfor
  print,'----over----'
end