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
pro getSunPos, year=year, month=month, day=day, hour=hour, minute=minute, $
    seconds=seconds, julian=julian, distance=distance, $
    trueLong=trueLong, appLong=appLong, $
    semiDiam=semiDiam,  trueRA=trueRA,$
    appRA=appRA, trueDec=trueDec, appDec=appDec, $
    sunLat=sunLat, sunLon=sunLon, carrington=carrington, $
    beta=beta, theta=theta,appDecl=appDecl
  ;-------------------------------------------------------------
  ;+
  ; Name:
  ;   getSunPos
  ; Purpose:
  ;   Computes geocentric physical ephemeris of the sun and returns positions
  ;   in several coordinate systems
  ; Inputs:
  ;   year = year.
  ;   month = month number.
  ;   day = monthday number.
  ;   hour = hour
  ;   minute = minutes
  ;   seconds = seconds
  ; OR
  ;   julian = julian day number. NOTE: this is not corrected for local time
  ;            offset. The user must do this!
  ;
  ; Keywords
  ; gmtCorrection = local time offset from greenwich.
  ;                 default is for east coast of the USA.
  ;         DIST = distance in AU.
  ;         SD = semidiameter of disk in arc seconds.
  ;         TRUE_LONG = true longitude (deg).
    
  ;         APP_LONG = apparent longitude (deg).
    
  ;         TRUE_RA = true RA (hours).
  ;         TRUE_DEC = true Dec (deg).
  ;         APP_RA = apparent RA (hours).
  ;         APP_DEC = apparent Dec (deg).
  ;         LAT0 = latitude at center of disk (deg).
  ;         LONG0 = longitude at center of disk (deg).
  ;         PA = position angle of rotation axis (deg).
  ;    CARRINGTON = Carrington rotation number.
  ;   ECF = ECF coordinates in units of earth Radii
  ; NOTES:
  ;       Notes: based on the book Astronomical Algorithms, by Jean Meeus.
  ;       With some equations taken from Sun.pro by Ray Stearner
  ; MODIFICATION HISTORY:
  ;       Ronn Kling, January 1999
  ;-
  ;-------------------------------------------------------------
    
    
    
  ;if no correction sent in then assume time is zulu time
  if not keyword_set(gmtCorrection) then gmtCorrection=0.0
  if not keyword_set(day) then day=1.0
  if not keyword_set(hour) then hour=0.0
  if not keyword_set(seconds) then seconds=0.0
  ;If julian date is sent in the calc the corrsponding data so the we can adjust by gmtCorrection
  if  keyword_set(julian) then CALDAT, Julian, Month, Day, Year, Hour, Minute, Seconds
  
  julian = JULDAY(Month, Day, Year, Hour + gmtCorrection, Minute, Seconds)
  
  
  ;make a double precision degrees to radian conversion
  dtor = !dpi/180.0d
  ;set the astronomical unit conversion
  AU = 1.4959787d010
  
  ;get the heliocentric coordinates for the earth
  helioCentric, julian, /earth, L=L, B=B, R=R, /degrees
  
  theta = L + 180.0d ;geocentric longitude
  beta = B * (-1.d)  ;geocentric latitude
  
  ;convert to J2000
  
  ;need the julian centuries from 1900.0
  centuries = (julian - 2451545.0d0)/36525.0d0
  lambdaPrime = theta - 1.397d*centuries - 0.00031d*centuries^2.
  deltaTheta = -0.09033d/3600.d ;convert  to decimal degrees
  deltaBeta = 0.03916d * (cos(lambdaPrime*dtor) - sin(lambdaPrime*dtor))
  theta = theta + deltaTheta  ;true ecliptic longitude
  beta = beta + (deltaBeta/3600.d) ;true ecliptic latitude
  trueLong = theta ;return value
  trueLat = beta
  
  ;mean obliquity of the ecliptic (deg)  pg 147 eq 22.2     ;
  obliq = 23.439291d0 - 0.01300416d0*centuries - 0.00000164d0*centuries^2 $
    + 0.0000005036d0*centuries^3
    
  ;use the high accuracy true longitude with an approx to get the apparent longitude
  omega = 259.18d0 - 1934.142d0*centuries         ; Degrees
  appLong = trueLong - 0.00569d0 - 0.00479d0*sin(omega*dtor)
  ;now find the apparent right ascension and declination
  appRaan = atan( ( (sin(appLong*dtor) * cos(obliq*dtor)) - (tan(trueLat*dtor) * sin(obliq*dtor))) $
    ,cos(appLong*dtor) )
  appDecl = asin( (sin(trueLat*dtor) * cos(obliq*dtor)) + $
    (cos(trueLat*dtor) * sin(obliq*dtor) * sin(appLong*dtor) ))
  ;have to get the julian day at midnight so have to do the trick of truncating
  ;it and subtracting .5
  gha = GREENWICH(double(long(julian))- .5d , hour + gmtCorrection, minute, seconds)
  
  ;------  Subsolar point  ------------
  sunLat = appDecl/dtor
  sunLon = (appRaan - gha)/dtor
  count = 1
  while count ne 0 do begin
    indices = where( sunLon lt 0, count)
    if count gt 0 then sunLon[indices] = sunLon[indices] + 360.0d
  endwhile
  
  ;get the Carrington rotation number if keyword present
  if arg_present(carrington) then carrington = (1./27.2753D0)*(julian-2398167.d0) + 1.d0
  
  
  
  return
end

