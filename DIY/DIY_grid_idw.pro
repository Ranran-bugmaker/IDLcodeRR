PRO DIY_grid_IDW,data_in,data_out,pointkey=pointkey,diskey=diskey,nullkey=nullkey,searchdiskey=searchdiskey

  
  if keyword_set(nullkey) then begin
    print,"空值输入错误，需要设置"
    RETURN
  endif
  if ~keyword_set(pointkey) then begin
    pointkey=12
  endif
  if ~keyword_set(nullkey) then begin
    nullkey=0
  endif
  if ~keyword_set(diskey) then begin
    diskey=20
  endif
  if ~keyword_set(searchdiskey) then begin
    searchdiskey=15
  endif

  DTsize=size(data_in)
  if (DTsize[0] ne 2) then BEGIN
    print,"输入错误，需二维数据"
    RETURN
  endif
  
  
  
  
  p=2
  data_box=data_in
  data_out=data_in*0
  start_time=systime(1)
  for xi = 0L, DTsize[1]-1 do begin
    for yi = 0L, DTsize[2]-1 do begin
      if (data_box[xi,yi] eq 0.0)then begin
      datatmp=data_in[(xi-searchdiskey)*((xi-searchdiskey)gt  0):(xi+searchdiskey)-((xi+searchdiskey)-DTsize[1]+1)*((xi+searchdiskey)gt (DTsize[1]-1)),$
        (yi-searchdiskey)*((yi-searchdiskey)gt  0):(yi+searchdiskey)-((yi+searchdiskey)-DTsize[2]+1)*((yi+searchdiskey)gt (DTsize[2]-1))]
      pos=where(datatmp ne  nullkey)
      if n_elements(pos)  gt  pointkey then begin
        pos2=array_indices(datatmp,pos)
        pos3=WHERE( ABS(pos2[0,*]-searchdiskey) le  searchdiskey and ABS(pos2[1,*]-searchdiskey) le  searchdiskey)
        
          if (n_elements(pos3) le pointkey) then begin
            BREAK
          endif
          xt=searchdiskey*((xi-searchdiskey)gt  0)
          yt=searchdiskey*((yi-searchdiskey)gt  0)
          dis=SQRT((pos2[0,pos3]-xt)^2+(pos2[1,pos3]-yt)^2)
          tmp=SORT(dis)
          dic=tmp[0:pointkey-1]
          xtmp=pos2[0,dic]
          ytmp=pos2[1,dic]
          Di=TOTAL(1/(SQRT((xtmp-xt)^2+(ytmp-yt)^2))^p)
          Zi=TOTAL(1/(SQRT((xtmp-xt)^2+(ytmp-yt)^2))^p*data_in[xtmp+xi-searchdiskey*((xi-searchdiskey)gt  0),ytmp+yi-searchdiskey*((yi-searchdiskey)gt  0)]*(1/Di))
;         zi=mean(data_in[xtmp,ytmp])
          data_out[xi,yi]=Zi
       endif
      endif  else begin
       data_out[xi,yi]=data_in[xi,yi]
      endelse
    endfor

  endfor
    end_time=systime(1)
    print,'Time consuming: '+strcompress(string(end_time-start_time))
  
END