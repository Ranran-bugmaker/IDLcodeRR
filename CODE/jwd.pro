pro jwd
  python_path='E:\桌面\jwd.py'
  dockml='E:\桌面\doc.kml'
  pythonexe_path='D:\Python\39\python.exe'
  txt=''
  txtline=FILE_LINES(dockml)
  txt=STRARR(txtline)
  OPENR,1,dockml
  READF,1,txt
  FREE_LUN,1
  txt=strtrim(txt,2)
;  DIY_jwd,txt,namelist
  
  txtsize=SIZE(txt,/N_ELEMENTS)
  if (txtsize  eq 1) then begin
    txt=STRSPLIT(txt,string(10b),/EXTRACT)
  endif
  group1="<Placemark>";+'([^*]{0,})'+"</Placemark>"
  group2="</Placemark>"
  txtergex=STREGEX(txt,group1, /SUBEXPR)
  pos1=WHERE(txtergex ne  -1)
  txtergex=STREGEX(txt,group2, /SUBEXPR)
  pos2=WHERE(txtergex ne  -1)
  
  
  openw,2,'E:\桌面\x.csv';,width=80000每一行,/append
  printf,2,"name,area"
  for ix = 0L, N_ELEMENTS(pos1)-1 do begin
    pos=ul64indgen(pos2[ix]-pos1[ix])+pos1[ix]
    name="<name>"+'([0-9]{0,})'+"</name>"
    txtergex=STREGEX(txt[pos],name, /SUBEXPR)
    namex=STREGEX(txt[WHERE(txtergex[0,*] ne  -1)+pos1[ix]],'>([0-9]{0,})<', /SUBEXPR,/EXTRACT)
    group3="<coordinates>";+'([^*]{0,})'+"</Placemark>"
    group4="</coordinates>"
    txtergex=STREGEX(txt[pos],group3, /SUBEXPR)
    pos3=WHERE(txtergex ne  -1)
    txtergex=STREGEX(txt[pos],group4, /SUBEXPR)
    pos4=WHERE(txtergex ne  -1)
    jwdx=txt[(pos4+pos3)/2+pos1[ix]]
    
    DIY_jwd,jwdx,res
;    SPAWN,pythonexe_path+' '+python_path+' '+'"'+jwdx+'"',res,dgs,/HIDE
    printf,2,namex[1],res,format='(I0,",",3(F0.3,:,","))'
  endfor
  free_lun,2
end