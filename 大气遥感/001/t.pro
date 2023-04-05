;+
;
;@Author 冉炯涛
;@Description //TODO 红外波段反演亮温
;@Date 2023-4-4 下午1:09:49
;@Param
;@return
;
;-

pro T
  ;红外波段反演亮温
  ref=DIY_h4_info('R:\JX\dqyg\sy1\data\MOD021KM.A2008125.0320.005.2009283065904.hdf','EV_1KM_Emissive')
  
  for i=0,1353 do begin
    for j=0,2029 do begin
      ref[i,j,10]=(ref[i,j,10]+1577.34)*0.000840022
    endfor
  endfor

  Td=fltarr(1354,2030)
  k1=1304.413871
  k2=729.541636

  for i=0,1353 do begin
    for j=0,2029 do begin
      Td[i,j]=k1/alog(1.0+k2/ref[i,j,10])
    endfor
  endfor

  print,'Td[617,680]:',Td[617,680]-273

end
