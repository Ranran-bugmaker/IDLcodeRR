;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
function createNightImage, nightImage, time=time, imageXsize=imageXsize, imageYsize=imageYsize
  ;creates a night time image of the earth with different
  ;transparencies for the three twilights.

  if not keyword_set(time) then time=systime(/julian)
  
  getsunpos,julian=time,sunLat=sunLat, sunLon=sunLon
  longitude = rebin(findgen(361),361,181)
  latitude = rebin( transpose(findgen(181)-90.0),361,181)
  sunLat = fltarr(361L*181L) + sunLat
  sunLon = fltarr(361L*181L) + sunLon
  ;get the earth central angle
  Lon2 = reform(longitude, 361L*181L)
  Lat2 = reform(latitude, 361L*181L)
  londiff = abs(sunLon-Lon2)
  
  ECA = acos(sin(sunLat*!dtor)*sin(Lat2*!dtor) + $
    cos(sunLat*!dtor)*cos(Lat2*!dtor)*cos(londiff*!dtor))/!dtor
    
  ECA = reform(ECA,361,181)
  night = byte(congrid(ECA,imageXsize,imageYsize))
  ;transparency is a function of sun angle
  ind = where(night lt 90b)
  night[ind]=0b   ;light
  ind = where( night gt 108b)
  night[ind] = 255b ;true night
  ind = where( (night ge 90b) and (night lt 96b))
  night[ind] = 64b  ;civil twilight
  ind = where( (night ge 96b) and (night lt 102b))
  night[ind] = 128b ;nautical twilight
  ind = where( (night ge 102b) and (night le 108b))
  night[ind] = 192b ;astronomical twilight
  
  tempImage = [nightImage,reform(night,1,imageXsize,imageYsize)]
  
  return, tempImage
end