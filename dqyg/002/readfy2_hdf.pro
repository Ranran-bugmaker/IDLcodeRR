pro readfy2_hdf

  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init

  ;读取FY2经纬度信息
  data=read_binary('R:\JX\dqyg\sy2\NOM_ITG_2288_2288(0E0N)_LE.dat',template=template)
  filepath=file_search('R:\JX\dqyg\sy2\NOM_ITG_2288_2288(0E0N)_LE.dat',count=num)
  openr,1,filepath
  arrdata=fltarr(2288,2288,2)
  readu,1,arrdata
  swap_endian_inplace,arrdata, /SWAP_IF_BIG_ENDIAN
  print,size(data)

  hdfpath='R:\JX\dqyg\sy2\FY2D_FDI_ALL_NOM_20100101_2330.hdf'
  file_id = H5F_OPEN(hdfpath)

  ;读取红外波段信息（以红外2波段为例）
  IR2dataname=H5D_OPEN(file_id,'NOMChannelIR2')
  IR2data=H5D_READ(IR2dataname)

  ;读取波段对应的定标表
  CAL2dataname=H5D_OPEN(file_id,'CALChannelIR2')
  CAL2data=H5D_READ(CAL2dataname)
  
  
;  IR2data=DIY_h5_info(hdfpath,'NOMChannelIR2')
;
;  ;读取波段对应的定标表
;  CAL2data=DIY_h5_info(hdfpath,'CALChannelIR2')
  IR2data1=float(IR2data)

  openw,3,'R:\JX\dqyg\sy2\fy.txt'

  ;将定标表进行替换并将经纬度及其数据整合。
  R2data=fltarr(2288,2288,3)
  for i=0,2287 do begin
    for j=0,2287 do begin
      for n=0,1023 do begin
        if (IR2data1[i,j] eq n) then IR2data1[i,j]=CAL2data[n]
      endfor
      R2data[i,j,0]=arrdata[i,j,0]+86.5 ;经度的说明请查看 Readme for FY latlon.txt
      R2data[i,j,1]=arrdata[i,j,1]
      R2data[i,j,2]=IR2data1[i,j]
      ;printf,3,R2data[i,j,0],R2data[i,j,1],R2data[i,j,2]
    endfor
  endfor

  ;将数据写入txt  中国的经纬度范围  经度73-136  纬度13-54
  for i=0,2287 do begin
    for j=0,2287 do begin
      if (R2data[i,j,2] lt 65535) then begin
        if (R2data[i,j,0] ge 73) and (R2data[i,j,0] le 136) and (R2data[i,j,1] ge 13) and (R2data[i,j,1] le 54) then begin
          printf,3,R2data[i,j,0],R2data[i,j,1],R2data[i,j,2]
        endif
      endif
    endfor
  endfor
  
  close,3

end