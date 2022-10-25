pro DIY_jiont_grid,data,x,y,data_out,min=UL,max=LR,KEY=KEY


  print,"开始gird拼接"
  UL=FLTARR(2)
  LR=FLTARR(2)
  dsz=size(data)
  file_n=dsz[1]
  xmin=min(x)
  UL[0]=xmin
  xmax=max(x)
  LR[0]=xmax
  ymin=min(y)
  UL[1]=ymin
  ymax=max(y)
  LR[1]=ymax
  hv=1111950.519766D
  strx=FLOOR((xmin)/hv)
  stry=FLOOR((ymin)/hv)
  xlist=FLOOR((xmax-xmin)/hv)
  ylist=FLOOR((ymax-ymin)/hv)
  
  
  
  data_box_geo_col=(xlist+1)*dsz[2]
  data_box_geo_line=(ylist+1)*dsz[3]
  data_box_geo_sum=fltarr(data_box_geo_col,data_box_geo_line)
  data_box_geo_num=fltarr(data_box_geo_col,data_box_geo_line)
  for file_i=0,file_n-1 do begin
    data_size=size(REFORM((data[file_i,*,*])))
    data_col=data_size[1]
    data_line=data_size[2]
    
    if ~keyword_set(KEY) then begin
      datatmp=ROTATE(REFORM(data[file_i,*,*]),7)
    endif else begin
      datatmp=REFORM(data[file_i,*,*])
    endelse

    
    col_start=(FLOOR(x[file_i]/hv)-strx)*data_col
    col_end=col_start+data_col-1
    line_start=(FLOOR(y[file_i]/hv)-stry)*data_line
    line_end=line_start+data_line-1
    data_box_geo_sum[col_start:col_end,line_start:line_end]+=datatmp
    data_box_geo_num[col_start:col_end,line_start:line_end]+=(datatmp gt 0.0)
  endfor
  data_box_geo_num=(data_box_geo_num gt 0.0)*data_box_geo_num+(data_box_geo_num eq 0.0)
  data_out=data_box_geo_sum/data_box_geo_num
  if ~keyword_set(KEY) then begin
    data_out=ROTATE(data_out,7)
  endif
  PRINT,"结束"
END