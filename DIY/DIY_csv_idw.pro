pro DIY_csv_idw,InputFile,output,p,n,resDPI
  ;InputFile  输入文件
  ;output 输出路径
  ;p  距离幂
  ;n  选取计算点个数
  ;resDPI 分辨率
  if ~file_test(output,/directory) then file_mkdir,output
  data=read_csv(InputFile,header=Fname)
  FN=n_elements(Fname)
  for iii = 2, FN-1 do begin
    lonlist=data.(0)
    latlist=data.(1)
    dataT=data.(iii)

    data_col=CEIL((MAX(lonlist)-MIN(lonlist))/resDPI)
    data_line=CEIL((MAX(latlist)-MIN(latlist))/resDPI)
    data_box=FLTARR(data_col,data_line)
    data_box_out=FLTARR(data_col,data_line)
    for i = 0L, N_ELEMENTS(lonlist)-1 do begin
      poslon=FLOOR((lonlist[i]-MIN(lonlist))/resDPI)
      poslat=FLOOR((MAX(latlist)-latlist[i])/resDPI)
      data_box[poslon,poslat]=dataT[i]
    endfor
    for loni = 0L, data_col-1 do begin
      for lati = 0L, data_LINE-1 do begin
        lon=MIN(lonlist)+loni*resDPI
        lat=MAX(latlist)-lati*resDPI
        dis=SQRT((lon-lonlist)^2+(lat-latlist)^2)
        tmp=SORT(dis)
        dic=tmp[0:n-1]
        lontmp=lonlist[dic]
        lattmp=latlist[dic]
        if (data_box[loni,lati]  eq  0.0) then begin
          Di=TOTAL(1/(SQRT((lontmp-lon)^2+(lattmp-lat)^2))^p)
          Zi=TOTAL(1/(SQRT((lontmp-lon)^2+(lattmp-lat)^2))^p*dataT[dic]*(1/Di))
          data_box_out[loni,lati]=Zi
        endif else begin
          data_box_out[loni,lati]=data_box[loni,lati]
        endelse
      endfor
    endfor
    WRITE_TIFF,OutPut+Fname[iii]+".tif",data_box_out,/FLOAT
    PRINT,Fname[iii]+".tif"+"mission_ok"
  endfor
end