;+
; :Description:
;    //TODO 读取云掩膜数据
; :parameters:
;
; :keywords:
;
; :return:
;
; :Author:  冉炯涛
; :Date 2023年4月18日 下午6:15:35
;-
pro cloud_mask
  mod35_path='R:\JX\dqyg\data4\MOD35_L2.A2008125.0320.005.2008126050344.hdf'
  mod03_path='R:\JX\dqyg\data4\MOD03.A2008125.0320.005.2008125132121.hdf'
  data=DIY_h4_info(mod35_path,'Cloud_Mask')
  data=data[*,*,0]
  ds=size(data)
  data=data.ToBinary(WIDTH=8)
  Lon=DIY_h4_info(mod35_path,'Longitude')
  Lat=DIY_h4_info(mod35_path,'Latitude')
;  x=data.ToInteger()
  diff=MAKE_ARRAY(ds[1],ds[2])
  for si = 0L, N_ELEMENTS(data)-1 do begin
    cflag=fix(STRMID(data[si],0,1))
    if (cflag eq 1) then begin
      diff[si]=fix(DIY_string_2_byte(STRMID(data[si],1,2))+1,TYPE=INT)
    endif else begin
      diff[si]=0B
    endelse
  endfor
  lon_n=Congrid(Lon,ds[1],ds[2],/INTERP)
  lat_n=Congrid(Lat,ds[1],ds[2],/INTERP)
  DIY_GLT_warp,diff,LON=lon_n,LAT=lat_n,"R:\JX\dqyg\data4\out0.dat",PIXEL_SIZE=0.02
End