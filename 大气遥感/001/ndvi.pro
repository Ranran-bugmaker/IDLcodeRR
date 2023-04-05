;+
;
;@Author 冉炯涛
;@Description //TODO 读取hdf文件下反射率数据并计算ndvi
;@Date 2023-3-28 下午6:45:28
;@Param none
;@return none
;
;-

pro ndvi

  ref=DIY_h4_info('R:\JX\dqyg\sy1\data\MOD021KM.A2008125.0320.005.2009283065904.hdf','EV_250_Aggr1km_RefSB')
  refsize=SIZE(ref)
  
  for i=0,refsize[1]-1 do begin
    for j=0,refsize[2]-1 do begin
      ref[i,j,0]=ref[i,j,0]*0.000995036
      ref[i,j,1]=ref[i,j,1]*0.000995036
    endfor
  endfor

  ndvio=fltarr(refsize[1],refsize[2])

  for i=0,refsize[1]-1 do begin
    for j=0,refsize[2]-1 do begin
      ndvio[i,j]=float((ref[i,j,1]-ref[i,j,0]))/(ref[i,j,1]+ref[i,j,0])
    endfor
  endfor
  loadct, 33
  TVLCT, r, g, b, /get
  color_table = BYTARR(3, 256)
  color_table[0, *] = r
  color_table[1, *] = g
  color_table[2, *] = b
  
  range=[-1,1]
  ndvio[WHERE(ndvio gt 2)]=!VALUES.F_NAN
  img=image(ROTATE(ndvio,7),rgb_table=color_table,TITLE="NDVI指数图",$
    POSITION=[0.1,0.2,0.9,0.9],DIMENSIONS=[800,800])
  img.MAX_VALUE=range[1]
  img.MIN_VALUE=range[0]
  c = COLORBAR(TARGET=img, ORIENTATION=0,TITLE='NDVI',POSITION=[0.12,0.08,0.88,0.12],font_name = 'Microsoft Yahei');
  c.RANGE=range
  c.BORDER=0
  c.TICKDIR= 1
  c.TEXTPOS = 0
  c.MAJOR=11
  c.TAPER=1
  img.save,'E:\桌面\image.png',/BORDER
  img.Close
;  WRITE_TIFF,"R:\JX\dqyg\sy1\data\ndvi.tif",ndvi,/FLOAT
end
