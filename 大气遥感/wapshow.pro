;+
;
;@Author 冉炯涛
;	:Description:
;		 //TODO 读取wap数据并展示，未封装
;	:Date 2023-4-9 下午9:58:48
;	:Params:
;
;	:keywords:
;
;	:return:
;
;-


pro wapshow
  wap_1_path='R:\JX\dqyg\wap\FY3D_GNOSX_GBAL_L2_WAP_MLT_NUL_20230408_0252_G06XX_MS.NC'
  wap_2_path='R:\JX\dqyg\wap\FY3D_GNOSX_GBAL_L2_WAP_MLT_NUL_20230408_0253_G07XX_MS.NC'
  path=wap_2_path
  Alt=DIY_h4_info(path,"MSL_alt",KEY=0)
  Alt_units=DIY_h4_info(path,["MSL_alt","units"],KEY=2)
  Shum=DIY_h4_info(path,"Shum",KEY=0)
  Shum_units=DIY_h4_info(path,["Shum","units"],KEY=2)
  Temp=DIY_h4_info(path,"Temp",KEY=0)
  Temp_units=DIY_h4_info(path,["Temp","units"],KEY=2)
  lon=DIY_h4_info(path,"lon",KEY=1)
  lat=DIY_h4_info(path,"lat",KEY=1)
  title=DIY_h4_info(path,"title",KEY=1)
  
  year=DIY_h4_info(path,"year",KEY=1)
  month=DIY_h4_info(path,"month",KEY=1)
  day=DIY_h4_info(path,"day",KEY=1)
  hour=DIY_h4_info(path,"hour",KEY=1)
  minute=DIY_h4_info(path,"minute",KEY=1)
  second=DIY_h4_info(path,"second",KEY=1)
  
  
  
  img1=plot(Shum,Alt,xtitle= '比湿 '+Shum_units,AXIS_STYLE=2,$
    COLOR='b',DIMENSIONS=[706,948],$
    XRANGE=[-0.3,max(Shum)*1.05], $
    YRANGE=[-4,max(Alt)*1.05],name='比湿度大气廓线')
  ntemp=(Temp-min(Temp))*(max(Shum)-0.2)/(max(Temp)-min(Temp))
  img2=plot(ntemp,Alt,xtitle= '比湿 '+Shum_units,AXIS_STYLE=2,$
    COLOR='r',name='温　度大气廓线',POSITION=[0.12658594,0.21049552,0.93618386,0.93037128],/overplot)
  
;  img.ySTYLE=1
;  img.xSTYLE=1
;  img.xtickdir=1
;  img.ytickdir=1
;  img.YTICKINTERVAL=10
;  img.xMAJOR=-1
;  img.yMINOR=0
;  img.xMINOR=0
  
  ax = img2.AXES
  ;bottom X axis
  ax[0].TITLE = '比湿 '+Shum_units
  ax[0].MINOR = 5
  ax[0].tickdir=0
  ax[0].TICKLEN=0.02
  ax[0].color='b'
  
  ;left Y axis
  ax[1].TITLE = '高度 '+Alt_units
  ax[1].TICKINTERVAL=10
  ax[1].tickdir=0
  ax[1].TICKLEN=0.02
  ax[1].MINOR = 5
  ;top X axis
  ax[2].MINOR = 0 
  ax[2].MAJOR = 0
  ax[2].hide=1
  ;right Y axis
  ax[3].MINOR = 0
  ax[3].MAJOR = 0
  
  
  
  ytemp = AXIS('X', LOCATION="top", $
    TITLE='温度 '+Temp_units, $
    COORD_TRANSFORM=[min(Temp), (max(Temp)-min(Temp))/(max(Shum)-0.2)])
  ytemp.TICKFONT_NAME='Microsoft YaHei'
  ytemp.TICKINTERVAL=10
  ytemp.TEXTPOS=1
  ytemp.tickdir=1
  ytemp.TICKLEN=0.02
  ytemp.MINOR = 5
  ytemp.color='r'
  
  lg=LEGEND(TRANSPARENCY=100,LINESTYLE=6,TARGET=[img1,img2],POSITION=[0.92248457,0.14265677])
  lg.FONT_NAME='Microsoft YaHei'
  text0='经纬度：'+STRING(lon,FORMAT='(f0.2)')+' E,'+STRING(-1*lat,FORMAT='(f0.2)')+' S'
  a=text(0.103, 0.075,text0)
  time="时　间："+STRING(year,FORMAT='(I0)')+'年'+STRING(month,FORMAT='(I0)')+'月'+STRING(day,FORMAT='(I0)')+'日  '+STRING(hour,FORMAT='(I0)')+':'+STRING(minute,FORMAT='(I0)')+':'+STRING(second,FORMAT='(I0)')
  a=text(0.102, 0.105,time)
  img2.save,"R:\JX\dqyg\wap\wapread12.png",/BORDER
  img2.Close
END