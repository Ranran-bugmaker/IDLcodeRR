; Code generated by IDL 8.5.
  restore, "R:\IDL\CODE_IDL\Default\CODE\mycode.sav"
  x0 = data['x0']
  y0 = data['y0']
  x1 = data['x1']
  y1 = data['y1']

  plot0 = Plot(x0, y0, $  ; <- Data required
    YRANGE=[-4.0000000,68.142449], $
    XRANGE=[-0.20000000,4.6978606], $
    XTEXT_COLOR=[0,0,255], $
    YTICKVALUES=[0.00000000,10.000000,20.000000,30.000000,40.000000,50.000000,60.000000], $
    YTICKNAME=['0','10','20','30','40','50','60'], $
    YMINOR=5, $
    YTITLE='高度 km', $
    XMINOR=5, $
    XTITLE='比湿 g/kg', $
    YTICKINTERVAL=10.000000, $
    COLOR='blue', $
    NAME='比湿度大气廓线', $
    DIMENSIONS=[706,948], $
    XCOLOR=[0,0,255], $
    POSITION=[0.12658594,0.21049552,0.93618386,0.93037128])
 
  plot1 = Plot(x1, y1, $  ; <- Data required
    XTEXT_COLOR=[0,0,255], $
    OVERPLOT=plot0, $
    YTICKVALUES=[0.00000000,10.000000,20.000000,30.000000,40.000000,50.000000,60.000000], $
    YTICKINTERVAL=10.000000, $
    YTICKNAME=['0','10','20','30','40','50','60'], $
    YMINOR=5, $
    XMINOR=5, $
    COLOR='red', $
    NAME='温　度大气廓线', $
    XCOLOR=[0,0,255])
 
  legend0 = Legend(TRANSPARENCY=100, $
    THICK=2.00000, $
    FONT_NAME='Microsoft YaHei', $
    TARGET=[plot0,plot1], $
    POSITION=[0.92248457,0.14265677])
 
  text0 = Text(0.103, 0.075, '经纬度：165.05 E,54.92 S')
 
  text1 = Text(0.102, 0.105, '时　间：2023年4月8日  2:52:56')

end