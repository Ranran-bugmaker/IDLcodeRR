;+
;	:Description:
;		 //TODO 读取云掩膜数据
;	:parameters:
;
;	:keywords:
;
;	:return:
;
;	:Author:	冉炯涛
;	:Date 2023年4月18日 下午6:15:35
;-
pro cloud_mask
  mod35_path='R:\JX\dqyg\data4\MOD35_L2.A2008125.0320.005.2008126050344.hdf'
  mod03_path='R:\JX\dqyg\data4\MOD03.A2008125.0320.005.2008125132121.hdf'
  data=DIY_h4_info(mod35_path,'Cloud_Mask')
  data=data[*,*,0]
  data=data.ToBinary(WIDTH=8)
  ds=size(data)
  Lon=DIY_h4_info(mod03_path,'Longitude')
  Lat=DIY_h4_info(mod03_path,'Latitude')
  x=data.ToInteger()
  for si = 0L, N_ELEMENTS(data)-1 do begin
    zflag=fix(STRMID(data[si],0,0))
    s=STRMID(data[si],0,3)
    a=00000000B
    
    b=byte(fix(STRMID(data[si],0,3),TYPE=1))
    b&&a
    STRPUT,a,s,8-3
  endfor

  WRITE_TIFF,"R:\JX\dqyg\data4\out0.tif",diff,/FLOAT
End