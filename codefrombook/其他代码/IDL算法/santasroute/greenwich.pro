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
function GREENWICH,JULDATE,NHOUR,NMIN,SEC
  ;+
  ;********************************************************************************
  ;
  ;     COMPUTES THE GREENWICH HOUR ANGLE IN MEAN OF DATE COORDINATE
  ;     SYSTEM. FORMULATION IS BASED ON THE NEW DEFINITION OF UNIVERSAL
  ;     TIME. SEE ASTRONOMY AND ASTROPHYSICS,VOLUME 105,PAGES 359-361,
  ;     1982; OR SEE ANY ASTRONOMICAL ALMANAC SINCE 1984.
  ;
  ;     INPUT:
  ;       JULDATE     JULIAN DATE REFERENCE TIME
  ;!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ; if you pass this in from julday make sure that you subtract 0.5 from it
  ;!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ;       NHOUR       ELAPSED HOURS FROM REFERENCE
  ;       MIN         ELAPSED MINUTES FROM REFERENCE
  ;       SEC         ELAPSED SECONDS FROM REFERENCE
  ;
  ;     OUTPUT:
  ;       GHAR        GREENWICH HOUR ANGLE (RADIANS)
  ;
  ; **Important note, JULDATE must be at midnight!
  ;*********************************************************************************
  ; WILL ACCEPT A TIME VECTOR for the minutes (min) variable
  ;-

  NHOUR=LONG(NHOUR)
  NMIN=LONG(NMIN)
  ;
  ROT = 7.29211585529d-05
  TWOPI = 2.d * !dpi
  rad_per_deg = !dpi / 180.d
  T = DOUBLE((JULDATE-2451545.0d)/36525.0d)
  GHAR = (24110.54841d + 8640184.812866d* T + (0.093104d * T^2.) $
    - ((6.2d-6) * T^3.)) / 240.0d * rad_per_deg $
    + (NHOUR * 3600.d + NMIN * 60.d + SEC) * ROT
  GHAR = (GHAR MOD TWOPI) + TWOPI
  GHAR = GHAR MOD TWOPI
  ;
  RETURN,ghar
END
