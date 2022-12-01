;+
;  《IDL程序设计》
;   -数据可视化与ENVI二次开发
;        
; 示例代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;-

; Copyright (c) 1999, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	MAP3D
;
; PURPOSE:
;	This object serves as a graphical representation of an sphere
;	with a lat/lon coordinate system and possible continental outlines.
;   	subclasses from the IDLgrModel and ORB class.
;
; CATEGORY:
;	Object graphics.
;
; CALLING SEQUENCE:
;	To initially create:
;	       	oMap3D = OBJ_NEW('Map3D')
;
;	To retrieve a property value:
;		oMap3D->GetProperty
;
;	To set a property value:
;		oMap3d->SetProperty
;
;
;	To destroy:
;		OBJ_DESTROY, oMap3D
;
; KEYWORD PARAMETERS:
;   Map3D::INIT:
;	<Note that keywords accepted by IDLgrModel::Init and/or
;	 IDLgrPolygon::Init are also accepted here.>
;   CONTINENTS: Set this keyword to a nonzero value to draw continental
;           outlines on the sphere
;   USA: Set this keyword to a nonzero value to draw the outlines of the states
;           on the sphere
;   RIVERS: Set this keyword to a nonzero value to draw the rivers on the
;           sphere
;   COUNTRIES; Set this keyword to a nonzero value to draw the country outlines
;           on the sphere
;   COASTS: Set this keyword to a nonzero value to draw the coasts on the
;           sphere
;   HIRES:  Set this keyword to a nonzero value to attemp to use the
;           high resolution coastline maps that included in IDL
;   MAPCOLOR: Set this keyword to an RGB triple or INDEX color for any
;           outlines that will go on the sphere
;   FILL:   Set this keyword to fill in the continental boundries. CONTINENTS
;           must also be set
;   LINESTYLE: The linestyle of the continental outlines (def = 0 (solid))
;   LINETHICK: The thickness of the continental outlines (def = 1 pixel)
;   POS:    A three-element vector, [x,y,z], specifying the position
;           of the center of the orb, measured in data units .
;	    Defaults to [0,0,0].
;   RADIUS: A floating point number representing the radius of the
;           orb (measured in data units).  The default is 1.0.
;   DENSITY: A floating point number representing the density at which
;           the vertices should be generated along the surface of the
;           orb.  The default is 1.0.
;   TEX_COORDS: Set this keyword to a nonzero value if texture map
;           coordinates are to be generated for the orb.
;
;   MAP3D::GETPROPERTY:
;	POS:	Set this keyword to a named variable that upon return will
;		contain a three-element vector, [x,y,z], specifying the
;		position of the center of the orb, measured in data units .
;	RADIUS: Set this keyword to a named variable that upon return will
;		contain a floating point number representing the radius of the
;               orb (measured in data units).
;	DENSITY: Set this keyword to a named variable that upon return will
;		contain a floating point number representing the density at
;		which the vertices are generated along the surface of the
;               orb.
;	CITIES / CONTINENTS / RIVERS / COASTS / USA / HIRES / MAPCOLOR
;
;   MAP3D::SETPROPERTY:
;	<Note that keywords accepted by IDLgrModel::SetProperty and/or
;	 IDLgrPolygon::SetProperty are also accepted here.>
;	POS:	A three-element vector, [x,y,z], specifying the position
;               of the center of the orb. Defaults to [0,0,0].
;	RADIUS: A floating point number representing the radius of the
;               orb (measured in data units).  The default is 1.0.
;	DENSITY: A floating point number representing the density at which
;               the vertices should be generated along the surface of the
;               orb.  The default is 1.0.
;       CITIES / CONTINENTS / RIVERS / COASTS / USA / HIRES / MAPCOLOR
;
; EXAMPLE:
;	Create a 3D map centered at the origin with a radius of 0.5 with continental
;       outlines drawn in blue.
;		oMap3d = OBJ_NEW('Orb', POS=[0,0,0], RADIUS=0.5, /CONT, MAPCOLOR = [0,0,255])
;
; MODIFICATION HISTORY:
; 	Written by:	BL, December 1997.
;-

;----------------------------------------------------------------------------
; MAP3D::INIT
;
; Purpose:
;  Initializes an map3d object.
;
;  This function returns a 1 if initialization is successful, or 0 otherwise.



FUNCTION map3d::INIT, $
    FILL = fill, 			$
    USA = usa, 			$
    RIVERS = rivers, 		$
    COASTS = coasts, 		$
    CITIES = cities, 		$
    CONTINENTS = cont, 		$
    COUNTRIES = countries, 		$
    HIRES = hires, 			$
    LIMIT = limit, 			$
    MAPCOLOR = color, 		$
    MLINESTYLE = linestyle, 	$
    MLINETHICK = linethick, 	$
    _EXTRA = extra
    
  ; process the keywords and set the properties
    
  self.USA  =     KEYWORD_SET(usa)
  self.RIVERS =   KEYWORD_SET(rivers)
  self.COASTS =   KEYWORD_SET(coasts)
  self.CONT =     KEYWORD_SET(cont)
  self.COUNTRIES = KEYWORD_SET(countries)
  self.HIRES =    KEYWORD_SET(hires)
  self.CITIES =   KEYWORD_SET(cities)
  
  ; More keywords
  
  IF N_ELEMENTS(fill) THEN self.FILL = fill
  IF N_ELEMENTS(linestyle) THEN self.LINESTYLE = linestyle
  IF N_ELEMENTS(linethick) THEN self.LINETHICK = linethick ELSE self.LINETHICK = 1
  IF (N_ELEMENTS(limit) GE 1) THEN self.LIMIT = PTR_NEW(limit) $
  ELSE self.LIMIT = PTR_NEW(0)
  
  ; Take care of the limit if set
  ; This object does not support limits yet. In the future we
  ; will take the limit and zoom the globe in on that area. For
  ; now limits are not supported
  
  IF N_ELEMENTS(limit) EQ 4 THEN BEGIN
    l = limit
  ENDIF ELSE IF !map.LL_BOX(0) NE !map.LL_BOX(2) OR $
    !map.LL_BOX(1) NE !map.LL_BOX(3) THEN BEGIN
    l = !map.LL_BOX
  ENDIF ELSE BEGIN
    l = [-90., -360., 90., 360.]
  ENDELSE
  self.LATMIN = l(0) & self.LONMIN = l(1)
  self.LATMAX = l(2) & self.LONMAX = l(3)
  
  ; Take care of the map color
  
  IF (N_ELEMENTS(color) GE 1) THEN self.MAPCOLOR = PTR_NEW(color) $
  ELSE self.MAPCOLOR = PTR_NEW([0,0,255])
  
  IF (self.USA+self.COUNTRIES+self.COASTS+self.RIVERS EQ 0) AND $
    N_ELEMENTS(self.CONT) EQ 0 THEN self.CONT = 1
    
  ; call the init method of the ORB object to set up planet
  ; and call the init method of the model object that ORB
  ; creates. The model object that orb creates will be
  ; used to store the polylines and polygons that this
  ; object creates
    
  status = self->ORB::INIT(_EXTRA = extra)
  IF (status NE 1) THEN BEGIN
    MESSAGE, 'ERROR initializing map3d object', /CONTINUE
    RETURN, 0
  ENDIF
  
  ; call CreateExtra to create the extra structure that
  ; will be used when creating polylines and polygons
  self->CREATEEXTRA
  
  ; The object definition contains a placeholder for an object, we
  ; will use it to hold the model for the map lines
  self.OMAPMODEL = OBJ_NEW('IDLgrModel')
  
  ; call BuildMap to start the procedure of creating the map
  self->BUILDMAP
  
  RETURN, 1
END

;**

PRO map3d::RemoveAll

  objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
  IF (N_ELEMENTS(objs) GT 0) THEN OBJ_DESTROY, objs
  self.USA=0
  self.RIVERS=0
  self.CONT=0
  self.COASTS=0
  self.CITIES=0
  self.COUNTRIES=0
  
END


PRO map3d::SetProperty, 	$
    USA = usa, 		$ ; draw only
    FILL = fill, 		$ ; redraw all
    CONTINENTS = cont, 	$ ; draw only
    COUNTRIES = countries,  $ ; draw only
    CITIES = cities, 	$ ; draw only - not fully supported
    RIVERS = rivers, 	$ ; draw only
    MAPCOLOR = mapcolor, 	$ ; change polylines/polygons
    MLINETHICK = linethick, $ ; change polylines/polygons
    MLINESTYLE = linestyle, $ ; change polygons/polygons
    HIRES = hires, 		$ ; redraw all
    _EXTRA=e
    
  ; Pass along extraneous keywords to
  ; the superclass
  self->ORB::SETPROPERTY, _EXTRA=e
  
  ; Check all the possible items that
  ; we can draw on a map
  ; If the corresponding property is
  ; set, call the method
  ; that draws the continents
  ; USA lines
  IF (N_ELEMENTS(usa) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (usa EQ 0) THEN BEGIN
    PRINT, 'will remove the usa'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'USA') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.USA = 0
  ENDIF ELSE IF (KEYWORD_SET(usa)) THEN BEGIN
    PRINT, 'drawing usa'
    IF (not self.USA) THEN BEGIN
      self.USA = 1
      self->DRAWUSA
    ENDIF
  ENDIF
  
  ; Continents
  IF (N_ELEMENTS(cont) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (cont EQ 0) THEN BEGIN
    PRINT, 'will remove the continents'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'CONTINENTS') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.CONT = 0
  ENDIF ELSE IF (KEYWORD_SET(cont)) THEN BEGIN
    PRINT,'drawing continents'
    IF (not self.CONT) THEN BEGIN
      self.CONT = 1
      self->DRAWCONTINENTS
    ENDIF
  ENDIF
  
  ; Countries
  IF (N_ELEMENTS(countries) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (countries EQ 0) THEN BEGIN
    PRINT, 'will remove the countries'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'BOUNDARIES') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.COUNTRIES = 0
  ENDIF ELSE IF (KEYWORD_SET(countries)) THEN BEGIN
    PRINT,'drawing countries'
    IF (not self.COUNTRIES) THEN BEGIN
      self.COUNTRIES = 1
      self->DRAWCOUNTRIES
    ENDIF
  ENDIF
  
  ; Rivers
  IF (N_ELEMENTS(rivers) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (rivers EQ 0) THEN BEGIN
    PRINT, 'will remove the rivers'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'RIVERS') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.RIVERS = 0
  ENDIF ELSE IF (KEYWORD_SET(rivers)) THEN BEGIN
    PRINT, 'drawing rivers'
    IF (not self.RIVERS) THEN BEGIN
      self.RIVERS = 1
      self->DRAWRIVERS
    ENDIF
  ENDIF
  
  ; Cities
  IF (N_ELEMENTS(cities) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (cities EQ 0) THEN BEGIN
    PRINT, 'will remove the cites'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRTEXT', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'CITIES') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.CITIES = 0
  ENDIF ELSE IF (KEYWORD_SET(cities)) THEN BEGIN
    IF (not self.CITIES) THEN BEGIN
      self.CITIES = 1
      self->DRAWCITIES
    ENDIF
  ENDIF
  
  ; Coasts
  IF (N_ELEMENTS(coasts) EQ 0) THEN BEGIN
  ; do nothing
  ENDIF ELSE IF (coasts EQ 0) THEN BEGIN
    PRINT, 'will remove the coasts'
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO BEGIN
      objs[i]->GETPROPERTY, UVALUE = uval
      IF (N_ELEMENTS(uval) GT 0) THEN BEGIN
        IF (STRUPCASE(uval) EQ 'COASTS') THEN BEGIN
          OBJ_DESTROY, objs[i]
        ENDIF
      ENDIF
    ENDFOR
    self.COASTS = 0
  ENDIF ELSE IF (KEYWORD_SET(coasts)) THEN BEGIN
    IF (not self.COASTS) THEN BEGIN
      self.COASTS = 1
      self->DRAWCOASTS
    ENDIF
  ENDIF
  
  
  ; Hires - if changed then must redraw
  ; the whole map
  IF (KEYWORD_SET(hires)) THEN BEGIN
    IF (not self.HIRES) THEN BEGIN
      self.HIRES = 1
      self->BUILDMAP
    ENDIF
  ENDIF
  
  ; Fill - if changed then must redraw
  ; the whole map
  IF (N_ELEMENTS(fill) GE 1) THEN BEGIN
    IF (fill NE self.FILL) THEN BEGIN
      self.FILL = fill
      self->BUILDMAP
    ENDIF
  ENDIF
  
  ; We want to manipulate the mapcolor, thickness, and linestyle after any
  ; possible rebuilding of the model from a change in the resolution
  ; or filling
  IF ((N_ELEMENTS(mapcolor) EQ 1) OR (N_ELEMENTS(mapcolor) EQ 3)) THEN BEGIN
    ; get all the polyline objects from the model
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO objs[i]->SETPROPERTY, COLOR = mapcolor
  ENDIF
  
  IF (N_ELEMENTS(linethick) EQ 1) THEN BEGIN
    ; get all the polyline objects from the model
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO objs[i]->SETPROPERTY, THICK = linethick
  ENDIF
  
  IF (N_ELEMENTS(linestyle) EQ 1) THEN BEGIN
    ; get all the polyline objects from the model
    objs = self.OMAPMODEL->GET(ISA = 'IDLGRPOLYLINE', /ALL)
    FOR i = 0, N_ELEMENTS(objs) - 1 DO objs[i]->SETPROPERTY, LINESTYLE = linestyle
  ENDIF
  
  
END

;----------------------------------------------------------------------------
; MAP3D::GETPROPERTY
;
; Purpose:
;  Retrieves the value of properties associated with the map3d object.
;

PRO map3D::GetProperty, 	$
    CONTINENT = cont, 	$
    USA = usa, 		$
    COUNTRIES = countries, 	$
    RIVERS = rivers, 	$
    COASTS = coasts, 	$
    CITIES = cities, 	$
    MAPCOLOR = mapcolor, 	$
    MLINESTYLE = linestyle, $
    MLINETHICK = linethick, $
    HIRES = hires, 		$
    LIMIT = limit, 		$
    MAPMODEL = mapmodel, 	$
    COLOR = color, 		$ ; orb method's polygon
    TRANSFORM = transform, 	$ ; orb method's model
    _EXTRA=e
    
  ; NOTE: until IDL 5.1 we cannot pass _EXTRA by reference so we must call
  ; the GetProperty methods of superclass objects one at a time
    
  IF (ARG_PRESENT(color)) THEN self.OPOLY->GETPROPERTY, COLOR = color
  IF (ARG_PRESENT(transform)) THEN self->IDLGRMODEL:: GetProperty, TRANSFORM = transform
  
  cont = self.CONT
  usa = self.USA
  countries = self.COUNTRIES
  rivers = self.RIVERS
  coasts = self.COASTS
  cities = self.CITIES
  mapcolor = *self.MAPCOLOR
  linestyle = self.LINESTYLE
  linethick = self.LINETHICK
  hires = self.HIRES
  limit = *self.LIMIT
  mapmodel = self.OMAPMODEL
  
END

;----------------------------------------------------------------------------
; MAP3D::PLOT
;
; Purpose:
;  Plot lat/lon pairs on the 3D globe
;  USAGE: map3d::PLOT, lon, lat
;
;  Note: This routine does not address the drawing of points
;        that follow the sphere closely. More code needs to be added to
;        insure the polylines are fit along the globe instead of going
;        through the globe.
;        To use properly, many points must be given to insure that the points
;        along the globe

FUNCTION map3d::PLOT, lon, lat, _EXTRA = extra

  ; given a set of lat and lon coords, plot on the globe

  ; get the xyz points of the data

  xyz = self->LLTOXYZ(lat, lon, self.RADIUS)
  
  oPloTLine = OBJ_NEW('IDLgrPolyline', $
    xyz[1,*], $
    xyz[0,*], $
    xyz[2,*], $
    _EXTRA = extra)
  self.OMAPMODEL->ADD, oPlotLine
  RETURN, oPlotLine
  
END

;----------------------------------------------------------------------------
; MAP3D::DrawText
;
; Purpose:
;  Given a string, and a lat and lon pair, put the string on the globe and
;  return the text object that was created. Optionally a font object can be
;  passed as a keyword instead of the defauly font of Helvetica 12
;

FUNCTION map3d::DrawText, text, lat, lon, $
    FONT = ofont, $
    _EXTRA = extra
    
  IF (N_PARAMS() NE 3) THEN BEGIN
    MESSAGE,'ERROR: DrawText requires three arguments', /CONTINUE
    RETURN, OBJ_NEW()
  ENDIF
  
  IF (not OBJ_VALID(ofont)) THEN BEGIN
    ofont = OBJ_NEW('IDLgrFont', 'Helvetica', SIZE = 10)
  ENDIF
  
  ; get the x,y,z value of the text
  
  xyz = self->LLTOXYZ(lat, lon, self.RADIUS)
  
  oText = OBJ_NEW('IDLgrText', STRING(text), $
    LOCATION = [xyz[1,0], xyz[0,0], xyz[2,0]], $
    FONT = ofont, $
    _EXTRA = extra)
    
  self.OMAPMODEL->ADD, oText
  
  RETURN, oText
END

;----------------------------------------------------------------------------
; MAP3D::DrawEquator
;
; Purpose:
;  Draw a line at 0 degress latitude on the globe
;

FUNCTION map3d::DrawEquator

  tlat = [0.0, 0.0, 0.0, 0.0]
  tlon = [0.0, 90.0, 180.0, 270.0]
  
  tlat = FLTARR(360)
  tlon = FINDGEN(360)+1.0
  
  RETURN, self->PLOT(tlon, tlat, COLOR = [255,0,0])
  
END

;----------------------------------------------------------------------------
; MAP3D::DrawPrime
;
; Purpose:
;  Draw a line at 0 degress longitude on the globe
;

FUNCTION map3d::DrawPrime

  tlat = FLTARR(360, /NOZERO)
  tlon = FLTARR(360, /NOZERO)
  
  tlon[0:179] = 0
  tlon[180:359] = -180.0
  tlat[180:359] = ( tlat[0:179] = FINDGEN(180) - 90.0 )
  
  RETURN, self->PLOT(tlon, tlat, COLOR = [0,255,0])
  
END

;----------------------------------------------------------------------------
; MAP3D::Polyfill
;
; Purpose:
;  Draw a filled polygon on the globe, given a lon and lat pair
;

FUNCTION map3d::POLYFILL, lon, lat, _EXTRA = extra

  ; given a set of lat and lon coords, plot on the globe

  ; get the xyz points of the data

  xyz = self->LLTOXYZ(lat, lon)
  
  oPolyFill = OBJ_NEW('IDLgrPolygon', $
    xyz[1,*], $
    xyz[0,*], $
    xyz[2,*], $
    _EXTRA = extra)
  self->ADD, oPolyFill
  
  RETURN, oPolyFill
END

;----------------------------------------------------------------------------
; MAP3D::SetReject
;
; Purpose:
;  Set the reject property of the polygon object that contains the sphere.
;  REJECT = 1 means the lines on the other side of the sphere from the
;  users eye will not be visible
;  REJECT = 0 means the lines on the other side of the sphere from the
;  users eye will be seen
;

PRO map3d::SetReject, reject
  self.OPOLY->SETPROPERTY, REJECT = reject
END

;----------------------------------------------------------------------------
; MAP3D::XYZtoLL
;
; Purpose:
;  Given X, Y, Z point(s) on the globe, convert to lat and lon coords
;

FUNCTION map3d::XYZtoLL, x, y, z

  ; given x, y, z in spherical coords, return
  ; an array of lat and lon

  x = x - self.POS[0]
  y = y - self.POS[1]
  z = z - self.POS[2]
  
  lat = !RaDeg * ACOS(z / SQRT(x^2 + y^2 + z^2))
  lon = !RaDeg * ATAN(y,x)
  
  lon = lon + (-90.0)
  lat = (lat + (-90.0)) * (-1.0)
  
  RETURN, [lat,lon]
END

;----------------------------------------------------------------------------
; MAP3D::LLtoXYZ
;
; Purpose:;  Given lat/lon pair(s) and an optional radius, return an array of
;            xyz datapoints
;

FUNCTION map3d::LLtoXYZ, lat, lon, radius

  ; given lat(s) and lon(s) and an optional radius
  ; return an array of xyz datapoints

  IF (N_PARAMS() EQ 2) THEN BEGIN
    rad = self.RADIUS
  ENDIF ELSE IF (N_PARAMS() EQ 3) THEN BEGIN
    rad = FLOAT(radius)
  ENDIF ELSE BEGIN
    MESSAGE, 'ERROR: 2 or 3 parameters required'
    RETURN,0
  ENDELSE
  
  ; make sure the the lat and lon arrays have the same number of elements
  IF (N_ELEMENTS(lat) NE N_ELEMENTS(lon)) THEN BEGIN
    MESSAGE, 'ERROR: lat and lon must contain the same number of elements'
    RETURN,0
  ENDIF
  
  ; create a 3D array to hold the lat/lon/rad
  xyz=FLTARR(3,N_ELEMENTS(lat), /NOZERO)
  
  lat = ABS(lat + (-90))
  
  ; latitude
  xyz[0,*] = (FLOAT(rad) * COS(!DtoR * (-(lon))) * (SIN(!DtoR * lat))) + self.POS[0]
  ; longitude
  xyz[1,*] = (FLOAT(rad) * SIN(!DtoR * (-(lon))) * (SIN(!DtoR * lat))) + self.POS[1]
  ; Z value
  xyz[2,*] = (FLOAT(rad) * COS(!DtoR * lat)) + self.POS[2]
  
  RETURN, xyz
  
END

;----------------------------------------------------------------------------
; MAP3D::GetIndex
;
; Purpose:
;  Read the index files of the mapping databases that are included with IDL
;

FUNCTION map3d::GetIndex,indx, error
  ;
  ; Used to read in the index file for
  ; each map data file.  On successful completion, error is set to 0.
  ;

  OPENR, lun, indx, /xdr, /get_lun, error = error
  IF error NE 0 THEN RETURN, 0		;File not there or unreadable
  
  segments=0L
  READU, lun, segments
  
  dx_map=REPLICATE({ fptr:0L, npts:0L,latmax:0.,latmin:0.,$
    lonmax:0.,lonmin:0. }, segments )
    
  READU, lun, dx_map
  FREE_LUN, lun
  FREE_LUN,lun
  
  RETURN, dx_map
END

;----------------------------------------------------------------------------
; MAP3D::Do_Segments
;
; Purpose:
;  Read the low or high resolution mapping databases and create IDLgrPolylines
;  for each segment
;

PRO map3d::Do_Segments, $
    fnames, $
    name
    
  ; Output a segment file:
  ; fnames = [lowresname, hiresname]
  ; name = description for error message (boundaries, rivers, etc
    
    
  lun = -1
  
  ; subdirectory, the maps are in !dir + /resource/maps/low or /resource/maps/high
  sub = (['low', 'high'])[self.HIRES]
  
  
  ; file names for the index and data files for the maps
  fndx = FILEPATH(fnames[self.HIRES]+'.ndx', SUBDIR=['resource','maps',sub])
  dat =  FILEPATH(fnames[self.HIRES]+'.dat', SUBDIR=['resource','maps',sub])
  
  ; open and read the index file of the map file requested
  ndx = self->GETINDEX(fndx, error)		;OPEN it
  
  ; if there is no problem opening the index file then open up the data file
  IF error EQ 0 THEN OPENR, lun, dat,/xdr,/stream, /get, error = error
  
  ; if there is an error that probably means that the user tried to open up
  ; a hi res map that was not installed. Try the low res as a fallback
  IF (error NE 0) AND self.HIRES THEN BEGIN
    MESSAGE, 'High Res Map File: '+name+' not found, trying low res.', /INFO
    fndx = FILEPATH(fnames[0]+'.ndx', SUBDIR=['resource','maps','low'])
    dat =  FILEPATH(fnames[0]+'.dat', SUBDIR=['resource','maps','low'])
    ndx = self->GETINDEX(fndx, error)		;OPEN it
  ENDIF			;Hires
  
  ; open up the data file if has not yet been opened
  IF ( lun LT 0 ) THEN OPENR, lun, dat,/xdr,/stream, /get, error = error
  IF ( error NE 0 ) THEN MESSAGE, 'Map file:'+fnames[self.HIRES]+' not found'
  
  ; Output a bunch of segments from a standard format file.
  lonmin = self.LONMIN
  lonmax = self.LONMAX
  latmin = self.LATMIN
  latmax = self.LATMAX
  
  test_lon = ((lonmax-lonmin) MOD 360.) NE 0.0
  test_lat = lonmin GT -90. OR lonmax LT 90.
  
  
  ; Prune segments if bounds are set.
  IF (test_lon AND test_lat) THEN BEGIN
    subs = WHERE((ndx.LATMIN LT latmax) AND (ndx.LATMAX GT latmin) AND $
      ((ndx.LONMIN LT lonmax) AND (ndx.LONMAX GT lonmin)), count)
    IF count NE 0 THEN ndx = ndx(subs)
  ENDIF ELSE IF (test_lon) THEN BEGIN
    subs = WHERE((ndx.LONMIN LT lonmax) AND (ndx.LONMAX GT lonmin), count)
    IF count NE 0 THEN ndx = ndx(subs)
  ENDIF ELSE IF (test_lat) THEN BEGIN
    subs = WHERE((ndx.LATMIN LT latmax) AND (ndx.LATMAX GT latmin), count)
    IF (count NE 0) THEN ndx = ndx(subs)
  ENDIF ELSE count = N_ELEMENTS(ndx)
  
  ; ************** Draw the segments ***************************
  ;
  
  IF (count GT 0) THEN BEGIN
    FOR i=0, count-1 DO BEGIN
      POINT_LUN, lun, ndx[i].FPTR
      IF (ndx[i].NPTS GE 2) THEN BEGIN
        xy=FLTARR(2,ndx[i].NPTS, /NOZERO)
        READU,lun,xy
        IF (self.FILL) THEN BEGIN
        
          xyz = self->LLTOXYZ(xy[0,*], xy[1,*])
          
          oPolyGon = OBJ_NEW('IDLgrPolygon', $
            xyz[1,*], $
            xyz[0,*], $
            xyz[2,*], $
            UVALUE = name, $
            _EXTRA = *self.EXTRA)
            
          self.OMAPMODEL->ADD, oPolyGon
          
        ENDIF ELSE BEGIN
        
          xyz = self->LLTOXYZ(xy[0,*], xy[1,*])
          
          oPolyLine = OBJ_NEW('IDLgrPolyline', $
            xyz[1,*], $
            xyz[0,*], $
            xyz[2,*], $
            UVALUE = name, $
            _EXTRA = *self.EXTRA)
            
          self.OMAPMODEL->ADD, oPolyLine
          
        ENDELSE
      ENDIF
    ENDFOR
  ENDIF
  
  FREE_LUN, lun
  
END

;----------------------------------------------------------------------------
; MAP3D::CreateExtra
;
; Purpose:
;  Create the _extra structure that will be passed when the IDLgrPolylines
;  or IDLgrPolygons are created in Map3D::Do_Segments
;

PRO map3d::CreateExtra


  tags = ['COLOR','LINESTYLE','THICK']
  values = [*self.MAPCOLOR, self.LINESTYLE, self.LINETHICK]
  
  self.EXTRA = PTR_NEW(CREATE_STRUCT(tags,$
    *self.MAPCOLOR, self.LINESTYLE, self.LINETHICK))
END

;----------------------------------------------------------------------------
; MAP3D::BuildMap
;
; Purpose:
;  Called from the init method, this method actually determines what other
;  methods are to be called to Build the initial map
;

PRO map3d::BuildMap

  ij = 0			;Default = continents only
  
  ; Make sure that the map model is cleaned out before starting a new
  ; map
  
  OBJ_DESTROY, self.OMAPMODEL
  self.OMAPMODEL = OBJ_NEW('IDLgrModel')
  
  ; Rivers
  IF (self.RIVERS) THEN self->DRAWRIVERS
  
  ; Countries
  IF (self.COUNTRIES NE 0) THEN self->DRAWCOUNTRIES
  
  ; Coasts
  IF (self.COASTS NE 0) THEN self->DRAWCOASTS
  
  ; Continents
  IF (self.CONT NE 0) OR (self.FILL NE 0) THEN self->DRAWCONTINENTS
  
  ; Cities
  IF (self.CITIES NE 0) THEN self->DRAWCITIES
  
  ; USA
  IF (self.USA NE 0) THEN self->DRAWUSA
  
  ; add the map model to the inherited model for orb
  self->ADD, self.OMAPMODEL
  
END

;----------------------------------------------------------------------------
; MAP3D::DrawRivers
;
; Purpose:
;  Create the polylines read from the rivers database
;

PRO map3D::DrawRivers

  IF (self.RIVERS NE 0) THEN BEGIN
    self->DO_SEGMENTS, $
      ['rlow', 'rhigh'], $
      'Rivers'
      
  ENDIF
  
END

;----------------------------------------------------------------------------
; MAP3D::DrawCountries
;
; Purpose:
;  Create the polylines read from the countries database
;

PRO map3D::DrawCountries

  IF (self.COUNTRIES NE 0) THEN BEGIN
    self->DO_SEGMENTS, $
      ['blow', 'bhigh'], $
      'Boundaries'
      
  ENDIF
END

;----------------------------------------------------------------------------
; MAP3D::DrawCoasts
;
; Purpose:
;  Create the polylines read from the coasts database
;

PRO map3D::DrawCoasts

  IF (self.COASTS NE 0) THEN BEGIN
    self->DO_SEGMENTS, $
      ['clow', 'chigh'], $
      'Coasts'
      
  ENDIF
END

;----------------------------------------------------------------------------
; MAP3D::Drawcontinents
;
; Purpose:
;  Create the polylines read from the continents database
;

PRO map3D::DrawContinents

  IF (self.CONT NE 0) OR (self.FILL NE 0) THEN BEGIN
    self->DO_SEGMENTS, $
      ['plow', 'phigh'], $
      'Continents'
  ENDIF
END

;----------------------------------------------------------------------------
; MAP3D::DrawCities
;
; Purpose:
;  Create the text objects to mark where the cities in the IDL cities database
;  are located
;

PRO map3d::DrawCities, NAME = cityname

  ; open up the cities file
  file = FILEPATH(subdir = ['examples','demo','demodata'], 'cities.dat')
  OPENR, lun, file, /get_lun
  
  ; Read all the cities in the city file if the name keyword
  ; is set then only plot that city
  lat = 0.0
  lon = 0.0
  name = ''
  WHILE (not EOF(lun)) DO BEGIN
    READF, lun, lat, lon, name
    
    IF (N_ELEMENTS(cityname) GE 1) THEN BEGIN
      IF (STRUPCASE(name) EQ STRUPCASE(cityname)) THEN BEGIN
        a = self->DRAWTEXT(name, lat, lon, $
          COLOR = [255,0,0], $
          UPDIR = [0.0,1.0,0.0], $
          BASELINE = [1.0,0.0,0.0], $
          UVALUE = 'cities', $
          FONT = OBJ_NEW('IDLgrFont', 'HELVETICA', SIZE = 6))
      ENDIF
    ENDIF ELSE BEGIN
      a = self->DRAWTEXT(name, lat, lon, $
        COLOR = [255,0,0], $
        UPDIR = [1.0,1.0,0.0], $
        BASELINE = [1.0,0.0,0.0], $
        UVALUE = 'cities', $
        FONT = OBJ_NEW('IDLgrFont', 'HELVETICA', SIZE = 6))
    ENDELSE
  ENDWHILE
  FREE_LUN, lun
  
END

;----------------------------------------------------------------------------
; MAP3D::DrawUSA
;
; Purpose:
;  Create the polylines read from the usa database
;

PRO map3D::DrawUSA

  ;States in USA, a different file
  IF (self.CONT) THEN ij = 2 ELSE ij = 1
  map_file=FILEPATH('supmap.dat',subdir=['resource','maps'])
  OPENR, lun, /get, map_file,/xdr,/stream
  npts = 0L
  
  ; 	cont us_only  both
  
  fbyte = [ 0, 71612L, 165096L]
  nsegs = [ 283, 325, 594 ]
  
  POINT_LUN, lun, fbyte[ij]
  
  FOR i=1,nsegs[ij] DO BEGIN	;Draw each segment
    READU, lun, npts,maxlat,minlat,maxlon,minlon
    npts = npts / 2		;# of points
    xy = FLTARR(2,npts)
    READU, lun, xy
    IF (maxlat LT self.LATMIN) OR (minlat GT self.LATMAX) THEN GOTO,skipit
    IF ((maxlon LT self.LONMIN) OR (minlon GT self.LONMAX)) THEN BEGIN
      IF (self.LONMAX GT 180. AND maxlon + 360. GE self.LONMIN) THEN GOTO, goon
      GOTO, skipit
    ENDIF
    goon:
    xyz = self->LLTOXYZ(xy[0,*], xy[1,*])
    
    IF (self.FILL) THEN BEGIN
    
      oPolyGon = OBJ_NEW('IDLgrPolygon', $
        xyz[1,*], $
        xyz[0,*], $
        xyz[2,*], $
        UVALUE = 'usa', $
        _EXTRA = *self.EXTRA)
        
    ENDIF ELSE BEGIN
      oPolyLine = OBJ_NEW('IDLgrPolyline', $
        xyz[1,*], $
        xyz[0,*], $
        xyz[2,*], $
        UVALUE = 'usa', $
        _EXTRA = *self.EXTRA)
    ENDELSE
    self.OMAPMODEL->ADD, oPolyLine
    ;plots,xy[1,*],xy[0,*],zvalue,NOCLIP=0,_EXTRA=extra,/data
    skipit:
  ENDFOR
  FREE_LUN, lun
  
END

;----------------------------------------------------------------------------
; MAP3D::CleanUp
;
; Purpose:
;  Perform cleanup on the Map3D object when obj_destroy is called.
;

PRO map3d::CLEANUP

  self->ORB::CLEANUP
  
  PTR_FREE, self.MAPCOLOR
  PTR_FREE, self.EXTRA
  PTR_FREE, self.LIMIT
  OBJ_DESTROY, self.OMAPMODEL
  
END

;******************************************************************

PRO MAP3D__DEFINE

  ; NOTE: the color property must be a pointer since the user
  ;       should be able to pass an index or RGB to the object

  map3Ddef = {MAP3D,   		$
    FILL:0, 		$
    USA:0,			$
    RIVERS:0, 		$
    CONT:0, 		$
    COASTS:0, 		$
    CITIES:0, 	 	$
    COUNTRIES:0,     	$
    LINESTYLE:0,     	$
    LINETHICK:0,     	$
    HIRES:0,	 	$
    EXTRA:PTR_NEW(), 	$
    MAPCOLOR:PTR_NEW(), 	$
    LIMIT:PTR_NEW(), 	$
    latmin: 0.0, 	 	$
    lonmin: 0.0, 	 	$
    latmax: 0.0,     	$
    lonmax: 0.0,     	$
    oMapModel:OBJ_NEW(), 	$
    INHERITS ORB}
    
END


; Copyright (c) 1999, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	MAP3D_DEMO
;
; PURPOSE:
;	This widget program demonstrates the use of the map3d object and object
;   graphics in general
;
; CATEGORY:
;	Object graphics / Widget programming
;
; CALLING SEQUENCE:
;	To begin
;       map3d_demo
;
;
; KEYWORD PARAMETERS:
;
;   CONTINENTS: Set this keyword to a nonzero value to draw continental
;           outlines on the sphere
;   USA: Set this keyword to a nonzero value to draw the outlines of the states
;           on the sphere
;   RIVERS: Set this keyword to a nonzero value to draw the rivers on the
;           sphere
;   COUNTRIES; Set this keyword to a nonzero value to draw the country outlines
;           on the sphere
;   COASTS: Set this keyword to a nonzero value to draw the coasts on the
;           sphere
;   HIRES:  Set this keyword to a nonzero value to attemp to use the
;           high resolution coastline maps that included in IDL
;   MAPCOLOR: Set this keyword to an RGB triple or INDEX color for any
;           outlines that will go on the sphere
;   FILL:   Set this keyword to fill in the continental boundries. CONTINENTS
;           must also be set
;   LINESTYLE: The linestyle of the continental outlines (def = 0 (solid))
;   LINETHICK: The thickness of the continental outlines (def = 1 pixel)
;   POS:    A three-element vector, [x,y,z], specifying the position
;           of the center of the orb, measured in data units .
;	    Defaults to [0,0,0].
;   RADIUS: A floating point number representing the radius of the
;           orb (measured in data units).  The default is 1.0.
;   DENSITY: A floating point number representing the density at which
;           the vertices should be generated along the surface of the
;           orb.  The default is 1.0.
;   TEX_COORDS: Set this keyword to a nonzero value if texture map
;           coordinates are to be generated for the orb.
;
;
; EXAMPLE:
;	Start up the GUI with a 3D map centered at the origin with a radius of 0.5 with continental
;       outlines drawn in blue.
;		map3d_demo, POS=[0,0,0], RADIUS=0.5, /CONT, MAPCOLOR = [0,0,255]
;
; MODIFICATION HISTORY:
; 	Written by:	BL, December 1997.
;-

;----------------------------------------------------------------------------
; Animate_eh
;
; Purpose:
;  Event handling for the animation property sheet
;

PRO ANIMATE_EH, event

  ; Animate_eh.pro - handle events related to the animation of the surface

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  ptr = PTR_NEW(info, /NO_COPY)
  
  ; search for the appropriate event based on the uvalue from the widget
  ; that caused the event
  
  CASE uval OF
  
    'animTimer': BEGIN
      IF ((*ptr).ANIMATE.LOOP) THEN BEGIN
      
        ; rotate the model
      
        (*ptr).OBJ.OMODEL->ROTATE, $
          [(*ptr).ANIMATE.XAXIS,(*ptr).ANIMATE.YAXIS,(*ptr).ANIMATE.ZAXIS], $
          (*ptr).ANIMATE.INCREMENT
          
        ; redraw the model
          
        (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
        
        ; set off the timer
        
        WIDGET_CONTROL, (*ptr).ANIMATE.DELAY, GET_VALUE = delay
        WIDGET_CONTROL, (*ptr).ANIMATE.BASE, TIMER = delay
        
      ENDIF
      
    END
    
    'startanim': BEGIN
      WIDGET_CONTROL, (*ptr).ANIMATE.DELAY, GET_VALUE = delay
      WIDGET_CONTROL, (*ptr).ANIMATE.BASE, TIMER = delay
      WIDGET_CONTROL, (*ptr).ANIMATE.INCTEXT, GET_VALUE = temp
      (*ptr).ANIMATE.INCREMENT = FIX(temp(0))
      
      (*ptr).ANIMATE.LOOP = 1
    END
    
    'stopanim': BEGIN
      (*ptr).ANIMATE.LOOP = 0
    END
    
    'xanim': BEGIN
      (*ptr).ANIMATE.XAXIS = event.SELECT
    END
    
    'yanim': BEGIN
      (*ptr).ANIMATE.YAXIS = event.SELECT
    END
    
    'zanim': BEGIN
      (*ptr).ANIMATE.ZAXIS = event.SELECT
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = *ptr
END

;----------------------------------------------------------------------------
; Color_eh
;
; Purpose:
;  Event handling for the color property sheet
;

PRO COLOR_EH, event

  ; Color_eh.pro - handle events related to the skirt of the surface

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  ptr = PTR_NEW(info, /NO_COPY)
  
  ; search for the appropriate event based on the uvalue from the widget
  ; that caused the event
  
  CASE uval OF
  
    'predef': BEGIN
      WIDGET_CONTROL, (*ptr).COLOR.RGBBASE, MAP = 0
      WIDGET_CONTROL, (*ptr).COLOR.PREDEFBASE, MAP = 1
    END
    
    'rgb': BEGIN
      WIDGET_CONTROL, (*ptr).COLOR.RGBBASE, MAP = 1
      WIDGET_CONTROL, (*ptr).COLOR.PREDEFBASE, MAP = 0
    END
    
    'fcolor': BEGIN
      (*ptr).OBJ.OEARTHMAP->SETPROPERTY, $
        COLOR = (*ptr).COLOR.COLORVALS[*, event.INDEX]
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
      
      WIDGET_CONTROL, (*ptr).COLOR.RGBFG, SET_VALUE = (*ptr).COLOR.COLORVALS[*,event.INDEX]
      
    END
    
    'bcolor': BEGIN
      (*ptr).OBJ.OVIEW->SETPROPERTY, $
        COLOR = (*ptr).COLOR.COLORVALS[*, event.INDEX]
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
      
      WIDGET_CONTROL, (*ptr).COLOR.RGBBG, SET_VALUE = (*ptr).COLOR.COLORVALS[*,event.INDEX]
      
    END
    
    'fgcolor': BEGIN
      WIDGET_CONTROL, (*ptr).COLOR.RGBFG, GET_VALUE = colors
      (*ptr).OBJ.OEARTHMAP->SETPROPERTY, COLOR = colors
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
    END
    
    'bgcolor': BEGIN
      WIDGET_CONTROL, (*ptr).COLOR.RGBBG, GET_VALUE = colors
      (*ptr).OBJ.OVIEW->SETPROPERTY, COLOR = colors
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = *ptr
  
END

;----------------------------------------------------------------------------
; light _eh
;
; Purpose:
;  Event handling for the light property sheet
;

PRO LIGHT_EH, event

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  CASE uval OF
  
    'light1': BEGIN
      info.OBJ.OLIGHT1->SETPROPERTY, HIDE = 1 - event.SELECT
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    'light2':  BEGIN
      info.OBJ.OLIGHT2->SETPROPERTY, HIDE = 1 - event.SELECT
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    'light3':  BEGIN
      info.OBJ.OLIGHT3->SETPROPERTY, HIDE = 1 - event.SELECT
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    'light1color': BEGIN
      WIDGET_CONTROL, event.ID, get_value = rgb
      info.OBJ.OLIGHT1->SETPROPERTY, COLOR = rgb
    END
    'light2color': BEGIN
      WIDGET_CONTROL, event.ID, get_value = rgb
      info.OBJ.OLIGHT2->SETPROPERTY, COLOR = rgb
    END
    'light3color': BEGIN
      WIDGET_CONTROL, event.ID, get_value = rgb
      info.OBJ.OLIGHT3->SETPROPERTY, COLOR = rgb
    END
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, get_uvalue = info
  
END

;----------------------------------------------------------------------------
; map _eh
;
; Purpose:
;  Event handling for the mapping property sheet
;

PRO MAP_EH, event

  WIDGET_CONTROL, event.ID, get_uvalue = uval
  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.TOP, /HOURGLASS
  
  CASE uval OF
  
    'removeall': BEGIN
    
      info.OBJ.OEARTHMAP->REMOVEALL
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    'reject': BEGIN
      info.OBJ.OEARTHMAP->SETREJECT, event.SELECT
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'changemap': BEGIN
      WIDGET_CONTROL, event.ID, get_value = item
      cmd = 'info.obj.oEarthMap->SetProperty, '+item+' = '+STRTRIM(event.SELECT,2)
      a = EXECUTE(cmd)
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'changecolor': BEGIN
      WIDGET_CONTROL, event.ID, get_value = rgb
      info.OBJ.OEARTHMAP->SETPROPERTY, MAPCOLOR = rgb
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'linestyle': BEGIN
      info.OBJ.OEARTHMAP->SETPROPERTY, MLINESTYLE = event.INDEX
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'linethick': BEGIN
      WIDGET_CONTROL, event.ID, get_value = thick
      info.OBJ.OEARTHMAP->SETPROPERTY, MLINETHICK = thick
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = info
END

;----------------------------------------------------------------------------
; output _eh
;
; Purpose:
;  Event handling for the output property sheet
;

PRO OUTPUT_EH, event


  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  CASE uval OF
  
    'vrml': BEGIN
      ; read the filename from the text widget
      WIDGET_CONTROL, info.OUTPUT.FILETEXT, get_value = fname
      IF (fname[0] EQ '' OR fname[0] EQ ' ') THEN BEGIN
        a = DIALOG_MESSAGE(['No File name entered','Enter a valid filename'], /INFO)
        GOTO, setback
      ENDIF
      info.OBJ.OVRML->SETPROPERTY, filename = fname[0]
      ;, $
      ; 	graphicstree = info.obj.oview
      info.OBJ.OVRML->DRAW, info.OBJ.OVIEW
      
    END
    
    'filebrowse': BEGIN
      file = DIALOG_PICKFILE(/NOCONFIRM, $
        /MUST_EXIST, $
        /WRITE, $
        FILE = 'mapimage.'+info.OUTPUT.IMAGETYPE)
      IF (file NE '' AND file NE ' ') THEN BEGIN
        WIDGET_CONTROL, info.OUTPUT.FILETEXT, set_value = file
      ENDIF
    END
    'filetext': BEGIN
    
    END
    
    'imagetype': BEGIN
      WIDGET_CONTROL, event.ID, get_value = temp
      info.OUTPUT.IMAGETYPE = temp
    END
    
    'imagego': BEGIN
    
      ; hourglass
      WIDGET_CONTROL, event.TOP, /hourglass
      
      ; read the image from the window
      oImage = info.OBJ.OWINDOW->READ()
      
      ; read the filename from the text widget
      WIDGET_CONTROL, info.OUTPUT.FILETEXT, get_value = fname
      IF (fname[0] EQ '' OR fname[0] EQ ' ') THEN BEGIN
        a = DIALOG_MESSAGE(['No File name entered','Enter a valid filename'], /INFO)
        GOTO, setback
      ENDIF
      
      ; get the image data from the image object
      oImage->GETPROPERTY, DATA = img
      inf = SIZE(img)
      
      ; check the desired output type and write out an image of that type
      CASE info.OUTPUT.IMAGETYPE OF
        'GIF': BEGIN
          IF (inf[0]) EQ 2 THEN BEGIN
            WRITE_GIF, fname[0], img
          ENDIF ELSE IF (inf[0] EQ 3) THEN BEGIN
            img = COLOR_QUAN(img, 1, r, g, b)
            WRITE_GIF, fname[0], img, r, g, b
          ENDIF
        END
        'JPG': BEGIN
          IF (inf[0]) EQ 2 THEN BEGIN
            WRITE_JPEG, fname[0], img
          ENDIF ELSE IF (inf[0] EQ 3) THEN BEGIN
            WRITE_JPEG, fname[0], img, TRUE = 1
          ENDIF
        END
        'BMP': BEGIN
          IF (inf[0]) EQ 2 THEN BEGIN
            WRITE_BMP, fname[0], img
          ENDIF ELSE IF (inf[0] EQ 3) THEN BEGIN
            img = COLOR_QUAN(img, 1, r, g, b)
            WRITE_BMP, fname[0], img, r, g, b
          ENDIF
        END
        'TIF': WRITE_TIFF, fname[0], img
        'PICT': BEGIN
          IF (inf[0]) EQ 2 THEN BEGIN
            WRITE_PICT, fname[0], img
          ENDIF ELSE IF (inf[0] EQ 3) THEN BEGIN
            img = COLOR_QUAN(img, 1, r, g, b)
            WRITE_PICT, fname[0], img, r, g, b
          ENDIF
        END
      ENDCASE
      
      WIDGET_CONTROL, event.TOP, hourglass = 0
    END
    
    'printsetup': BEGIN
      a = DIALOG_PRINTERSETUP(info.OBJ.OPRINTER)
    END
    
    'print': BEGIN
      a = DIALOG_PRINTERSETUP(info.OBJ.OPRINTER)
      IF (a NE 0) THEN BEGIN
        info.OBJ.OPRINTER->DRAW, info.OBJ.OVIEW
        info.OBJ.OPRINTER->NEWDOCUMENT
      ENDIF
    END
    
  ENDCASE
  
  setback:
  WIDGET_CONTROL, event.TOP, set_uvalue = info
END


;----------------------------------------------------------------------------
; properties_eh
;
; Purpose:
;  Event handling for the main property sheet window
;

PRO PROPERTIES_EH, event

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  CASE uval OF
    'props': BEGIN
    
      WIDGET_CONTROL, info.DATA.PROPBASE[info.DATA.CURRENTPROPSHEET], MAP = 0
      WIDGET_CONTROL, info.DATA.PROPBASE[event.INDEX], MAP = 1
      info.DATA.CURRENTPROPSHEET = event.INDEX
      
    END
    ELSE:
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = info
END

;----------------------------------------------------------------------------
; rotate_eh
;
; Purpose:
;  Event handling for the rotation property sheet
;
PRO ROTATE_EH, event

  ; Rotate_eh.pro - handle events related to the rotation of the globe

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  ptr = PTR_NEW(info, /NO_COPY)
  
  ; search for the appropriate event based on the uvalue from the widget
  ; that caused the event
  
  CASE uval OF
  
    'zoomit': BEGIN
      ZoomVal = event.VALUE - (*ptr).ROTATE.ZOOMSLIDERVAL
      (*ptr).ROTATE.ZOOMSLIDERVAL = event.VALUE
      
      scaleval = 2^(zoomVal/20.0)
      
      (*ptr).OBJ.OMODEL->SCALE, scaleval, scaleval, scaleval
      
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
    END
    
    'cpad': BEGIN
      CASE 1 OF
        event.NORTH: (*ptr).OBJ.OMODEL->TRANSLATE, 0.0, 0.1, 0.0
        event.SOUTH: (*ptr).OBJ.OMODEL->TRANSLATE, 0.0, -0.1, 0.0
        event.EAST: (*ptr).OBJ.OMODEL->TRANSLATE, 0.1, 0.0, 0.0
        event.WEST: (*ptr).OBJ.OMODEL->TRANSLATE, -0.1, 0.0, 0.0
        event.NEAST: (*ptr).OBJ.OMODEL->TRANSLATE, 0.1, 0.1, 0.0
        event.NWEST: (*ptr).OBJ.OMODEL->TRANSLATE, -0.1, 0.1, 0.0
        event.SEAST: (*ptr).OBJ.OMODEL->TRANSLATE, 0.1, -0.1, 0.0
        event.SWEST: (*ptr).OBJ.OMODEL->TRANSLATE, -0.1, -0.1, 0.0
        event.RESET: BEGIN
          (*ptr).OBJ.OMODEL->SETPROPERTY, $
            TRANSFORM = (*ptr).DATA.DEFTRANS
            
          ; draw the view back to the window
            
          (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
        END
      ENDCASE
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
    END
    
    'rotate': BEGIN
      WIDGET_CONTROL, (*ptr).ROTATE.XROT, GET_VALUE = tempx
      WIDGET_CONTROL, (*ptr).ROTATE.YROT, GET_VALUE = tempy
      WIDGET_CONTROL, (*ptr).ROTATE.ZROT, GET_VALUE = tempz
      
      (*ptr).OBJ.OMODEL->ROTATE, [1,0,0], tempx
      (*ptr).OBJ.OMODEL->ROTATE, [0,1,0], tempy
      (*ptr).OBJ.OMODEL->ROTATE, [0,0,1], tempz
      
      WIDGET_CONTROL, (*ptr).ROTATE.XROT, $
        SET_VALUE = 0
      WIDGET_CONTROL, (*ptr).ROTATE.YROT, $
        SET_VALUE = 0
      WIDGET_CONTROL, (*ptr).ROTATE.ZROT, $
        SET_VALUE = 0
        
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = *ptr
END


;----------------------------------------------------------------------------
; text_eh
;
; Purpose:
;  Event handling for the text property sheet
;

PRO TEXT_EH, event

  ; text_eh.pro - handle events related to the text on the surface

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  ptr = PTR_NEW(info, /NO_COPY)
  
  ; search for the appropriate event based on the uvalue from the widget
  ; that caused the event
  
  CASE uval OF
  
    'Xtext':
    
    'Ytext':
    
    'textcolor':
    
    'fontsize': BEGIN
      (*ptr).TEXT.FONTSIZE = FIX((*ptr).TEXT.FONTSIZES[event.INDEX])
    END
    
    'choosefont': BEGIN
      (*ptr).TEXT.FONT = event.INDEX
    END
    
    'threed': BEGIN
      IF (event.SELECT) THEN BEGIN
        (*ptr).TEXT.ONGLASS = 0
      ENDIF ELSE BEGIN
        (*ptr).TEXT.ONGLASS = 1
      ENDELSE
    END
    
    'addtext': BEGIN
      WIDGET_CONTROL, (*ptr).TEXT.ADDTEXT, GET_VALUE = temp
      addstring = STRTRIM(temp(0), 2)
      
      fontname = (*ptr).TEXT.FONTNAMES[(*ptr).TEXT.FONT]
      
      WIDGET_CONTROL, (*ptr).TEXT.LOCX, GET_VALUE = temp
      xloc = temp
      WIDGET_CONTROL, (*ptr).TEXT.LOCY, GET_VALUE = temp
      yloc = temp
      
      WIDGET_CONTROL, (*ptr).TEXT.TEXTCOLOR, GET_VALUE = textcolor
      r = textcolor[0] & g = textcolor[1] & b = textcolor[2]
      
      (*ptr).OBJ.OFONT->SETPROPERTY, $
        NAME = fontname, $
        SIZE = (*ptr).TEXT.FONTSIZE
      (*ptr).OBJ.OTEXT[(*ptr).TEXT.CURTEXT] = $
        (*ptr).OBJ.OEARTHMAP->DRAWTEXT(addstring, yloc, xloc, $
        COLOR = [r,g,b], $
        ONGLASS = (*ptr).TEXT.ONGLASS, $
        FONT = oFont)
        
      (*ptr).OBJ.OWINDOW->DRAW, (*ptr).OBJ.OVIEW
      
      (*ptr).TEXT.CURTEXT = (*ptr).TEXT.CURTEXT + 1
      
    END
    
  ENDCASE
  WIDGET_CONTROL, event.TOP, SET_UVALUE = *ptr
END


;----------------------------------------------------------------------------
; transform_eh
;
; Purpose:
;  Event handling for the transformations property sheet
;

PRO TRANSFORM_EH, event

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  WIDGET_CONTROL, event.ID, get_uvalue = uval
  
  CASE uval OF
  
    'setdefault': BEGIN
      WIDGET_CONTROL, info.TRANSFORMS.TRANSTABLE, get_value = t
      info.DATA.DEFTRANS = t
    END
    
    'transformtable': BEGIN
    
      WIDGET_CONTROL, info.TRANSFORMS.TRANSTABLE, get_value = t
      info.OBJ.OMODEL->SETPROPERTY, TRANSFORM = t
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'transformtimer': BEGIN
    
      info.OBJ.OMODEL->GETPROPERTY, TRANSFORM = t
      WIDGET_CONTROL, info.TRANSFORMS.TRANSTABLE, SET_VALUE = t
      WIDGET_CONTROL, info.TRANSFORMS.TRANSLABEL, TIMER = 4.0
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = info
END



;----------------------------------------------------------------------------
; MAP3D_EVENT
;
; Purpose:
;  Event handling for the map3d_demo
;.

PRO MAP3D_DEMO_EVENT, event

  WIDGET_CONTROL, event.TOP, get_uvalue = info
  
  CASE (TAG_NAMES(event, /STRUCTURE_NAME)) OF
    'WIDGET_DRAW': BEGIN
    
      ; take care of events in the draw area
      xform = info.OBJ.OTRACK->UPDATE(event, TRANSFORM = new)
      IF (xform NE 0) THEN BEGIN
        info.OBJ.OMODEL->GETPROPERTY, TRANSFORM = old
        info.OBJ.OMODEL->SETPROPERTY, TRANSFORM = old # new
        info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
      ENDIF
      
      CASE event.TYPE OF
        0: BEGIN
          IF (event.CLICKS EQ 2) THEN BEGIN
            objs = info.OBJ.OWINDOW->SELECT(info.OBJ.OVIEW, [event.X, event.Y])
            
            sz = SIZE(objs)
            IF (sz[sz[0]+1] EQ 11) THEN BEGIN
              FOR i = 0,N_ELEMENTS(objs)-1 DO BEGIN
                HELP, objs[i]
                IF (OBJ_CLASS(objs[i]) EQ 'IDLGRTEXT') THEN BEGIN
                  info.OBJ.OEARTHMAP->REMOVE, objs[i]
                  info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
                ENDIF
              ENDFOR
            ENDIF
            info.DATA.MOUSEBUTTON = 0b
          ENDIF ELSE BEGIN
            info.DATA.MOUSEBUTTON = BYTE(event.PRESS)
            info.OBJ.OWINDOW->SETPROPERTY, QUALITY = 0
          ENDELSE
        END
        1: BEGIN
        
        
          info.DATA.MOUSEBUTTON = 0b
          info.OBJ.OWINDOW->SETPROPERTY, QUALITY = 2
          info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
        END
        2: BEGIN
          pick = info.OBJ.OWINDOW->PICKDATA(info.OBJ.OVIEW, $
            info.OBJ.OMODEL, $
            [event.X, event.Y], $
            dataxyz)
            
          IF (pick NE 0) THEN BEGIN
          
            x = dataxyz[0]
            y = dataxyz[1]
            z = dataxyz[2]
            
            ll = info.OBJ.OEARTHMAP->XYZTOLL(x, y, z)
            
            ;lat = !RaDeg * acos(z / sqrt(x^2 + y^2 + z^2))
            ;lon = !RaDeg * atan(y,x)
            
            ;lon = lon + (-90.0)
            ;lat = (lat + (-90.0)) * (-1.0)
            
            status = 'LAT: '+STRTRIM(ll[0])+'   LON: '+STRTRIM(ll[1],2)
            WIDGET_CONTROL, info.DATA.STATUSLABEL, SET_VALUE = status
            IF (info.DATA.MOUSEBUTTON EQ 4b) THEN BEGIN
              WIDGET_CONTROL, info.TEXT.LOCX, SET_VALUE = ll[1]
              WIDGET_CONTROL, info.TEXT.LOCY, SET_VALUE = ll[0]
            ENDIF
            
          ENDIF
        END
        3:
        4: BEGIN
          info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
        END
      ENDCASE
    END
    
    'WIDGET_BASE': BEGIN
    
      ; resize events on the top-level base
      WIDGET_CONTROL, event.TOP, /HOURGLASS
      
      info.DATA.XDIM = event.X
      info.DATA.YDIM = event.Y - 10
      
      drawID = WIDGET_INFO(event.TOP, /CHILD)
      WIDGET_CONTROL, drawID, $
        DRAW_XSIZE = info.DATA.XDIM, $
        DRAW_YSIZE = info.DATA.YDIM - 10
      info.OBJ.OWINDOW->DRAW, info.OBJ.OVIEW
    END
    
    'WIDGET_KILL_REQUEST': BEGIN
    
      ; the system close button / menu item is selected
      ; destroy all the objects
    
      ;for p = 0, n_tags(info.obj) - 1 do obj_destroy, info.obj.(p)
    
      WIDGET_CONTROL, event.TOP, /DESTROY
      
      RETURN
    END
    
  ENDCASE
  
  WIDGET_CONTROL, event.TOP, set_uvalue = info
END


;+
; NAME: cw_rgbslide
;
;
;
; PURPOSE: create a compound widget that contains three sliders
;          each with a range of 0 to 255 and labeled RED, GREEN,
;          and BLUE, respectively
;
; CATEGORY: Compound Widgets
;
;
;
; CALLING SEQUENCE: ID = CW_RGBSLIDE(parent)
;
;
;
; INPUTS: parent - widget ID of the parent of this compound widget
;
;
;
; OPTIONAL INPUTS: none
;
;
;
; KEYWORD PARAMETERS: ROW - line the sliders up next to each other
;                     COLUMN - the sliders will lay out top to bottom
;                     FRAME - draw a frame around the sliders
;
; OUTPUTS: ID - the widget ID of the compound widget
;
;
;
; OPTIONAL OUTPUTS: Event structure from the widget
;           {CW_RGBSLIDE_EVENT, ID:0L, TOP:0L, HANDLER:0L, $
;                               R:0, G:0, B:0}
;
;           where: R, G, and B values of the sliders at the time of
;           the event
;
;
; COMMON BLOCKS: none
;
;
;
; SIDE EFFECTS: none
;
;
;
; RESTRICTIONS: none
;
;
;
; PROCEDURE: Three sliders will be created with a range from 0 to 255
;   The SET_VALUE keyword to WIDGET_CONTROL maybe used with a three element
;   vector to set the RGB value of the three sliders
;   The GET_VALUE keyword to WIDGET_CONTROL will return a three
;   element byte array containing the current values of the RGB sliders
;
;
; EXAMPLE: a = cw_rgbslide(tlb, /ROW, /FRAME)
;    widget_control, a, SET_VALUE = [100, 255, 128]
;    widget_control, a, GET_VALUE = colors
;
; MODIFICATION HISTORY: 11/97 - BL - written
;
;-


FUNCTION CW_RGBSLIDE_EH, event

  retstruct = {ID:event.HANDLER, $                ; ID of CW
  
    TOP:event.TOP, $	; TOP LEVEL BASE
    HANDLER:0L, $		; HANDLER
    R:0B, $		; red value after event
    G:0B, $		; green value after event
    B:0B}			; blue value after event
    
  ; Get the information strcuture from the first child of the base
  ; that contains the sliders
    
  info_id = WIDGET_INFO(event.HANDLER, /CHILD)
  WIDGET_CONTROL, info_id, get_uvalue = info
  
  ; get the values of all three sliders
  
  WIDGET_CONTROL, info.R_SLIDE, get_value = tempr
  WIDGET_CONTROL, info.G_SLIDE, get_value = tempg
  WIDGET_CONTROL, info.B_SLIDE, get_value = tempb
  
  ; set the R, G, B values in the event handler
  
  retstruct.R = BYTE(tempr)
  retstruct.G = BYTE(tempg)
  retstruct.B = BYTE(tempb)
  
  RETURN, retstruct
END

;------

FUNCTION CW_RGBSLIDE_GET_VALUE, id

  ; get the info structure from the first child of the
  ; cw id

  info_id = WIDGET_INFO(id, /CHILD)
  WIDGET_CONTROL, info_id, get_uvalue = info
  
  ; get the values of all three sliders
  
  WIDGET_CONTROL, info.R_SLIDE, get_value = tempr
  WIDGET_CONTROL, info.G_SLIDE, get_value = tempg
  WIDGET_CONTROL, info.B_SLIDE, get_value = tempb
  
  ; create a byte array that will contain the RGB values
  
  value = BYTARR(3)
  value[0] = BYTE(tempr)
  value[1] = BYTE(tempg)
  value[2] = BYTE(tempb)
  
  RETURN, value
END

;------

PRO CW_RGBSLIDE_SET_VALUE, id, value

  ; check to see that value is a 1D array of three elements

  inf = SIZE(value)
  IF (inf[0] NE 1) THEN BEGIN
    MESSAGE, 'ERROR: value must be a one dimension array of 3 rgb values'
  ENDIF
  
  IF (inf[1] NE 3) THEN BEGIN
    MESSAGE, 'ERROR: array must have 3 elements'
  ENDIF
  
  ; get the info structure from the first child of the
  ; cw id
  
  info_id = WIDGET_INFO(id, /CHILD)
  WIDGET_CONTROL, info_id, get_uvalue = info
  
  ; set the value of the sliders using the array that was passed in
  
  WIDGET_CONTROL, info.R_SLIDE, set_value = FIX(value[0])
  WIDGET_CONTROL, info.G_SLIDE, set_value = FIX(value[1])
  WIDGET_CONTROL, info.B_SLIDE, set_value = FIX(value[2])
  
  RETURN
END

;------

FUNCTION CW_RGBSLIDE, parent, _extra = extra

  ; make sure the the parent is valid

  IF (not WIDGET_INFO(parent, /VALID)) THEN BEGIN
    MESSAGE,'ERROR: parent ID not present or not valid'
  ENDIF
  
  ; create the main base for this compound widget
  
  rgb_base = WIDGET_BASE(parent, $
    _extra = extra, $
    EVENT_FUNC = 'cw_rgbslide_eh', $
    PRO_SET_VALUE = 'cw_rgbslide_set_value', $
    FUNC_GET_VALUE = 'cw_rgbslide_get_value')
    
  ; create the three sliders that will contain the red, green and blue
  ; values
    
  r_slide = WIDGET_SLIDER(rgb_base, $
    MIN = 0, $
    MAX = 255, $
    TITLE = 'RED', $
    VALUE = 0)
    
  g_slide = WIDGET_SLIDER(rgb_base, $
    MIN = 0, $
    MAX = 255, $
    TITLE = 'GREEN', $
    VALUE = 0)
    
  b_slide = WIDGET_SLIDER(rgb_base, $
    MIN = 0, $
    MAX = 255, $
    TITLE = 'BLUE', $
    VALUE = 0)
    
  ; store the widget IDs of the sliders in a structure that will
  ; be passed around
    
  info = {r_slide:r_slide, $
    g_slide:g_slide, $
    b_slide:b_slide}
    
  ; put the info data into the first child of rgbbase
    
  WIDGET_CONTROL, r_slide, set_uvalue = info
  
  RETURN, rgb_base
  
END

;+
; NAME:
;       CW_CTRLPAD
;
; PURPOSE:
;       This procedure creates a control pad widget with eight
;       bitmap buttons pointing in the north, south, east, west,
;       northeast, northwest, southeast, and southwest directions
;
;       When a button is on the control pad and event structure
;       is passed that indicates the direction of the button
;       that was pressed
;
; CATEGORY:
;       Compound Widgets
;
; CALLING SEQUENCE:
;       Id = CW_CTRLPAD(parent)
;
; INPUTS:
;       parent: The widget ID of the parent base for the compound
;               widget
;
; KEYWORD PARAMETERS:
;       VALUE: Set this keyword to a string that will contain a
;              label for the control pad
;       PAD_FRAME: Set this keyword to a non-zero value to cause
;              a frame to be drawn around the control pad
;       COLUMN: Set this keyword to a non-zero value to align
;               the label on top of the control pad
;       ROW: Set this keyword to a non-zero value to align
;               the label to the right of the control pad
; MODIFICATION HISTORY:
;       Written by:     BL, June 1997.
;-

FUNCTION CTRLPAD_EH, event

  ; The ID of the control pad is the base that the handler is attached
  ; to set up a variable to hold this value for use in the return
  ; structure

  base = event.HANDLER
  
  ; create the return structure that will pass through as the event
  ; structure for this compound widget. Start everything off as 0
  
  retstruct = {CW_CTRLPAD_EVENT, ID:base, TOP:event.TOP, HANDLER:0L, $
    NORTH:0, SOUTH:0, WEST:0, EAST:0, NEast:0, SEast:0, $
    NWest:0, SWest:0, Reset:0}
    
  ; get the user value of the button that caused the event
    
  WIDGET_CONTROL, event.ID, GET_UVALUE = uval
  
  ; set the field of the structure corresponding to the button pressed
  ; to 1. The event structure should have all zeros except the field that
  ; corresponds to the button that was pressed
  
  CASE uval OF
    'moveNW': retstruct.NWEST = 1
    'moveNorth': retstruct.NORTH = 1
    'moveNE': retstruct.NEAST = 1
    'moveWest': retstruct.WEST = 1
    'moveEast': retstruct.EAST = 1
    'moveSW': retstruct.SWEST = 1
    'moveSouth': retstruct.SOUTH = 1
    'moveSE':retstruct.SEAST = 1
    'moveReset':retstruct.RESET = 1
  ENDCASE
  
  RETURN, retstruct
END

FUNCTION CW_CTRLPAD, parent, VALUE = value, PAD_FRAME = pad_frame, $
    _EXTRA = extra
    
  ; define the bitmaps for the buttons
    
  southBM = 	[				$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [193B, 131B],			$
    [195B, 195B],			$
    [199B, 227B],			$
    [207B, 243B],			$
    [222B, 123B],			$
    [252B, 063B],			$
    [248B, 031B],			$
    [240B, 015B],			$
    [224B, 007B],			$
    [192B, 003B]			$
    ]
    
  westBM = 	[				$
    [192B, 003B],			$
    [224B, 001B],			$
    [240B, 000B],			$
    [120B, 000B],			$
    [060B, 000B],			$
    [030B, 000B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [030B, 000B],			$
    [060B, 000B],			$
    [120B, 000B],			$
    [240B, 000B],			$
    [224B, 001B],			$
    [192B, 003B]			$
    ]
    
  eastBM = 	[				$
    [192B, 003B],			$
    [128B, 007B],			$
    [000B, 015B],			$
    [000B, 030B],			$
    [000B, 060B],			$
    [000B, 120B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [255B, 255B],			$
    [000B, 120B],			$
    [000B, 060B],			$
    [000B, 030B],			$
    [000B, 015B],			$
    [128B, 007B],			$
    [192B, 003B]			$
    ]
    
  northBM = 	[				$
    [192B, 003B],			$
    [224B, 007B],			$
    [240B, 015B],			$
    [248B, 031B],			$
    [252B, 063B],			$
    [222B, 123B],			$
    [207B, 243B],			$
    [199B, 227B],			$
    [195B, 195B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B],			$
    [192B, 003B]			$
    ]
    
  ;nw bitmap
  ;definition
  nwBM = 	[				$
    [255B, 000B],			$
    [127B, 000B],			$
    [063B, 000B],			$
    [063B, 000B],			$
    [127B, 000B],			$
    [255B, 000B],			$
    [243B, 001B],			$
    [225B, 003B],			$
    [192B, 007B],			$
    [128B, 015B],			$
    [000B, 031B],			$
    [000B, 062B],			$
    [000B, 124B],			$
    [000B, 248B],			$
    [000B, 240B],			$
    [000B, 224B]			$
    ]
    
  ;ne bitmap
  ;definition
  neBM = 	[				$
    [000B, 255B],			$
    [000B, 254B],			$
    [000B, 248B],			$
    [000B, 252B],			$
    [000B, 254B],			$
    [000B, 223B],			$
    [128B, 207B],			$
    [192B, 135B],			$
    [224B, 003B],			$
    [240B, 001B],			$
    [248B, 000B],			$
    [124B, 000B],			$
    [062B, 000B],			$
    [031B, 000B],			$
    [015B, 000B],			$
    [007B, 000B]			$
    ]
    
  ;se bitmap
  ;definition
  seBM = 	[				$
    [007B, 000B],			$
    [015B, 000B],			$
    [031B, 000B],			$
    [062B, 000B],			$
    [124B, 000B],			$
    [248B, 000B],			$
    [240B, 001B],			$
    [224B, 003B],			$
    [192B, 135B],			$
    [128B, 207B],			$
    [000B, 255B],			$
    [000B, 254B],			$
    [000B, 252B],			$
    [000B, 252B],			$
    [000B, 254B],			$
    [000B, 255B]			$
    ]
    
  ;sw bitmap
  ;definition
  swBM = 	[				$
    [000B, 224B],			$
    [000B, 240B],			$
    [000B, 248B],			$
    [000B, 124B],			$
    [000B, 062B],			$
    [000B, 031B],			$
    [128B, 015B],			$
    [192B, 007B],			$
    [225B, 003B],			$
    [243B, 001B],			$
    [255B, 000B],			$
    [127B, 000B],			$
    [063B, 000B],			$
    [063B, 000B],			$
    [127B, 000B],			$
    [255B, 000B]			$
    ]
  ;blank bitmap
  ;definition
  blankBM = 	[				$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B],			$
    [000B, 000B]			$
    ]
    
  ; create the main base widget
    
  mainBase = WIDGET_BASE(parent, $
    EVENT_FUNC = 'ctrlpad_eh', SPACE = 10, _EXTRA = extra)
    
  ; if the user passes in the value keyword then use to set up a label
  ; for control pad. The positioning of the label will be determined
  ; by the type alignment of the control pad. If the /ROW is passed in,
  ; the label will be on the left. If /COLUMN, the label will be
  ; on the right of the control pad
    
  IF (KEYWORD_SET(VALUE)) THEN BEGIN
    padLabel = WIDGET_LABEL(mainBase, VALUE = value)
  ENDIF
  
  ; allow the user to draw a frame around the control pad with the /PAD_FRAME
  ; keyword. This frame will be around the control pad only, not the label. If
  ; a frame around the label and control pad is desired, the /FRAME keyword
  ; should be used.
  
  IF (KEYWORD_SET(PAD_FRAME)) THEN BEGIN
    ctrlPadBase = WIDGET_BASE(mainBase, /COLUMN, SPACE = 0, YPAD = 0, $
      /BASE_ALIGN_CENTER, /ALIGN_CENTER, /FRAME)
  ENDIF ELSE BEGIN
    ctrlPadBase = WIDGET_BASE(mainBase, /COLUMN, SPACE = 0, YPAD = 0, $
      /BASE_ALIGN_CENTER, /ALIGN_CENTER)
  ENDELSE
  
  ; set up the actual buttons that make up the control pad. Three row bases
  ; each with three tightly packed buttons
  
  ; North base - hold the three north buttons
  
  ctrlNorthBase = WIDGET_BASE(ctrlPadBase, /ROW, /BASE_ALIGN_CENTER, $
    SPACE = 0, YPAD = 0)
  nwBut = WIDGET_BUTTON(ctrlNorthBase, /ALIGN_RIGHT, $
    VALUE = nwBM, UVALUE = 'moveNW')
  northBut = WIDGET_BUTTON(ctrlNorthBase, /ALIGN_CENTER, $
    VALUE = northBM, UVALUE = 'moveNorth')
  neBut = WIDGET_BUTTON(ctrlNorthBase, /ALIGN_LEFT, $
    VALUE = neBM, UVALUE = 'moveNE')
    
  ; East-West Base - hold the East-West and reset buttons
    
  ctrlEWBase = WIDGET_BASE(ctrlPadBase, /ROW, SPACE = 0, YPAD = 0, $
    /BASE_ALIGN_CENTER)
  westBut = WIDGET_BUTTON(ctrlEWBase, /ALIGN_LEFT, $
    VALUE = westBM, UVALUE = 'moveWest')
  resetBut = WIDGET_BUTTON(ctrlEWBase, /ALIGN_CENTER, $
    VALUE = blankBM, UVALUE = 'moveReset')
  eastBut = WIDGET_BUTTON(ctrlEWBase, /ALIGN_RIGHT, $
    VALUE = eastBM, UVALUE = 'moveEast')
    
  ; South base - hold the three south buttons
    
  ctrlSouthBase = WIDGET_BASE(ctrlPadBase, /ROW, /BASE_ALIGN_CENTER, $
    SPACE = 0, YPAD = 0)
  swBut = WIDGET_BUTTON(ctrlSouthBase, /ALIGN_RIGHT, $
    VALUE = swBM, UVALUE = 'moveSW')
  southBut = WIDGET_BUTTON(ctrlSouthBase, /ALIGN_CENTER, $
    VALUE = southBM, UVALUE = 'moveSouth')
  seBut = WIDGET_BUTTON(ctrlSouthBase, /ALIGN_LEFT, $
    VALUE = seBM, UVALUE = 'moveSE')
    
  ; thats it! return the ID of the control pad base as the
  ; return value of the funtion and the ID of the
  ; compound widget
    
  RETURN, ctrlPadBase
END

;----------------------------------------------------------------------------
; MAP3D
;
; Purpose:
;  The Map3D demo
;.


PRO MAP3D_DEMO, $
    IMAGE = image, $
    _EXTRA = extra
    
  ; get the total screen size and set variables
  ; that will be used later to set the dimensions
  ; of the main draw widget
    
  DEVICE, get_screen_size = scr
  xdim = scr[0] * .5
  ydim = scr[0] * .6
  
  ; Variables needed for various widgets
  
  colors = ['RED', 'GREEN', 'BLUE', 'WHITE', 'BLACK']
  colorVals = [[255,0,0],[0,255,0],[0,0,255],[255,255,255],[0,0,0]]
  fontNames =  ['Helvetica', 'Courier', 'Times', 'Symbol']
  fontSizes = ['8', '10', '12', '14', '18', '24', '36', '48']
  lineStyles = ['________', '........', '--------', '-.-.-.-.', $
    '-...-...', '__ __ __', '(none)']
    
  ; Widgets
  ; Top-level base of the window containing the mapping object
    
  tlb = WIDGET_BASE(TITLE = 'A Map Object!!!', $
    /COLUMN, $
    /TLB_SIZE_EVENTS, $
    /TLB_KILL_REQUEST_EVENTS, $
    XOFFSET = 0, $
    YOFFSET = 0)
    
  draw = WIDGET_DRAW(tlb, $
    XSIZE = xdim, $
    YSIZE = xdim, $
    GRAPHICS_LEVEL = 2, $
    /EXPOSE_EVENTS, $
    /MOTION_EVENTS, $
    /BUTTON_EVENTS)
    
    
  statuslabel = WIDGET_LABEL(tlb, $
    VALUE = '                                 ', $
    /DYNAMIC_RESIZE, $
    /ALIGN_LEFT)
    
    
  ;** Property sheet window
  ; Top-level base 2 - group is tlb so when tlb dies, this window will
  ; also be destroyed
    
  tlb2 = WIDGET_BASE(TITLE = 'Map Properties', $
    /COLUMN, $
    GROUP = tlb, $
    YOFFSET = 0, $
    XOFFSET = xdim + 10)
    
  ; The names of the property sheets that will control
  ; the appearance of the globe
    
  sheets = ['Animation', $
    'Rotation', $
    'Color', $
    'Text', $
    'Output', $
    'Light Sources', $
    'Map'] ;, $
  ; 'Transforms']
    
  ; droplist that will change the currently visible property sheet
    
  propDrop = WIDGET_DROPLIST(tlb2, $
    VALUE = sheets, $
    UVALUE = 'props')
    
  ; base of the bulliten board base that will contain the property sheets
    
  propBB = WIDGET_BASE(tlb2, /FRAME)
  propBase = LONARR(N_ELEMENTS(sheets))
  
  ; Property sheets
  ;** Animation **
  
  propBase[0] = WIDGET_BASE(propBB, $
    /COLUMN, $
    MAP = 1, $
    EVENT_PRO = 'animate_eh')
    
  animBase = WIDGET_BASE(propBase[0], $
    /ROW, $
    UVALUE = 'animTimer')
  anim1Lab = WIDGET_LABEL(animBase, $
    VALUE = 'Animate ')
  animEBase = WIDGET_BASE(animBase, $
    /ROW, $
    /NONEXCLUSIVE)
  xanimBut = WIDGET_BUTTON(animEBase, $
    VALUE = ' X ', $
    UVALUE = 'xanim')
  yanimBut = WIDGET_BUTTON(animEBase, $
    VALUE = ' Y ', $
    UVALUE = 'yanim')
  zanimBut = WIDGET_BUTTON(animEBAse, $
    VALUE = ' Z ', $
    UVALUE = 'zanim')
  anim2Lab = WIDGET_LABEL(animBase, $
    VALUE = ' Axis In ')
  animincText = WIDGET_TEXT(animBase, $
    XSIZE = 5, $
    YSIZE = 1, $
    /EDITABLE, $
    UVALUE = 'startanim')
  anim3Lab = WIDGET_LABEL(animBase, $
    VALUE = ' Degree Increments')
  animctlBase = WIDGET_BASE(propBase[0], $
    /ROW, $
    SPACE = 10)
  delayField = CW_FIELD(animctlBase, $
    TITLE = 'Animation Delay (sec): ', $
    /ROW, $
    XSIZE=5, $
    /FLOAT, $
    VALUE = 0.1, $
    UVALUE = 'startanim')
  animgoBut = WIDGET_BUTTON(animctlBase, $
    VALUE = ' Start Animation ', $
    UVALUE = 'startanim')
  animstopBut = WIDGET_BUTTON(animctlBase, $
    VALUE =' Stop Animation ', $
    UVALUE = 'stopanim')
    
  WIDGET_CONTROL, xanimBut, SET_BUTTON = 1  ; set x axis for default
  
  ;** Rotations
  
  propBase[1] = WIDGET_BASE(propBB, $
    /ROW, $
    SPACE = 10, $
    MAP=0, $
    EVENT_PRO = 'rotate_eh')
    
  rotationsBase = WIDGET_BASE(propBase[1], /COLUMN)
  rotslideBase = WIDGET_BASE(rotationsBase, $
    /ROW, $
    SPACE = 10)
  xrotSlide = WIDGET_SLIDER(rotslideBase, $
    MINIMUM = -360, $
    MAXIMUM = 360, $
    VALUE = 0, $
    UVALUE = 'rotate', $
    TITLE = 'X Rotation (Degrees)')
  yrotSlide = WIDGET_SLIDER(rotslideBase, MINIMUM = -360, MAXIMUM = 360, $
    VALUE = 0, $
    UVALUE = 'rotate', $
    TITLE = 'Y Rotation (Degrees)')
  zrotSlide = WIDGET_SLIDER(rotslideBase, $
    MINIMUM = -360, $
    MAXIMUM = 360, $
    VALUE = 0, $
    UVALUE = 'rotate', $
    TITLE = 'Z Rotation (Degrees)')
    
  rotfieldBase = WIDGET_BASE(rotationsBase, $
    /ROW, $
    SPACE = 5)
  scaleLab = WIDGET_LABEL(rotfieldBase, $
    VALUE = 'ZOOM:')
  zoomSlider = WIDGET_SLIDER(rotfieldBase, $
    VALUE = 0, $
    /SUPPRESS_VALUE, $
    /ALIGN_CENTER, $
    MINIMUM = -20, $
    MAXIMUM = 20, $
    XSIZE = 300, $
    UVALUE = 'zoomit')
    
  translationsBase = WIDGET_BASE(propBase[1], /COLUMN)
  cpad = CW_CTRLPAD(translationsBase, $
    /COLUMN, $
    VALUE = 'Move Surface', $
    UVALUE = 'cpad', $
    /PAD_FRAME)
    
  ;** Colors
    
    
  propBase[2] = WIDGET_BASE(propBB, $
    /COLUMN, $
    MAP=0, $
    EVENT_PRO = 'color_eh')
    
  colorControl = WIDGET_BASE(propBase[2], $
    /ROW, $
    /EXCLUSIVE, $
    /ALIGN_CENTER)
  predefButton = WIDGET_BUTTON(colorControl, $
    VALUE = 'Use Predefined Colors', $
    UVALUE = 'predef')
  rgbButton = WIDGET_BUTTON(colorControl, $
    VALUE = 'Use RGB Values', $
    UVALUE = 'rgb')
  WIDGET_CONTROL, predefButton, SET_BUTTON = 1
  
  colorBase = WIDGET_BASE(propBase[2], $
    /FRAME, $
    /ALIGN_CENTER)
    
  predefBase = WIDGET_BASE(colorBase, $
    /COLUMN, $
    MAP = 1)
  colordropRow = WIDGET_BASE(predefBase, $
    /ROW, $
    SPACE=10)
  fcolorList = WIDGET_DROPLIST(colordropRow, $
    VALUE = colors, $
    UVALUE = 'fcolor', $
    TITLE = 'Foreground Color: ')
  WIDGET_CONTROL, fcolorList, SET_DROPLIST_SELECT = 4 ; foreground color default black
  bcolorList = WIDGET_DROPLIST(colordropRow, $
    VALUE = colors, $
    UVALUE = 'bcolor', $
    TITLE = 'Background Color: ')
  WIDGET_CONTROL, bcolorList, SET_DROPLIST_SELECT = 3 ; background color default white
  
  rgbBase = WIDGET_BASE(colorBase, $
    /COLUMN, $
    MAP = 0)
    
  rgbFGBase = WIDGET_BASE(rgbBase, $
    /ROW)
  colorLabel = WIDGET_LABEL(rgbFGBase, $
    VALUE = 'Foreground Color:')
  rgbFG = CW_RGBSLIDE(rgbFGBase, $
    /ROW, $
    UVALUE = 'fgcolor')
    
    
  rgbBGBase = WIDGET_BASE(rgbBase, $
    /ROW)
  colorLabel = WIDGET_LABEL(rgbBGBase, $
    VALUE = 'Background Color:')
  rgbBG = CW_RGBSLIDE(rgbBGBase, $
    /ROW, $
    UVALUE = 'bgcolor')
    
    
  ;** Text
    
  propBase[3] = WIDGET_BASE(propBB, $
    /COLUMN, $
    MAP=0, $
    EVENT_PRO = 'text_eh')
    
  text1Row = WIDGET_BASE(propBase[3], $
    /ROW)
  addtextField = CW_FIELD(text1Row, $
    TITLE = 'Text to Add: ', $
    /STRING, $
    XSIZE = 30)
  fontDrop = WIDGET_DROPLIST(text1Row, $
    TITLE = 'Font Name', $
    VALUE = fontNames, $
    UVALUE = 'choosefont')
  sizeDrop = WIDGET_DROPLIST(text1Row, $
    TITLE = 'Size:', $
    VALUE = fontSizes, $
    UVALUE = 'fontsize')
    
  text2Row = WIDGET_BASE(propBase[3], $
    /ROW)
  locLabel = WIDGET_LABEL(text2Row, $
    VALUE = 'Location - ')
  locXField = CW_FIELD(text2Row, $
    /ROW, $
    TITLE = 'LON: ', $
    VALUE = 0.0, $
    /FLOAT, $
    UVALUE = 'Xtext', $
    /RETURN_EVENTS, $
    XSIZE = 10)
  locYField = CW_FIELD(text2Row, $
    /ROW, $
    TITLE = 'LAT: ', $
    VALUE = 0.0, $
    /FLOAT, $
    UVALUE = 'Ytext', $
    /RETURN_EVENTS, $
    XSIZE = 10)
    
  textNERow = WIDGET_BASE(text2Row, $
    /NONEXCLUSIVE, $
    /ROW)
  threedBut = WIDGET_BUTTON(textNERow, $
    VALUE='3D Text', $
    UVALUE='threed')
  addBut = WIDGET_BUTTON(text2Row, $
    VALUE = 'Add Text', $
    UVALUE = 'addtext')
    
  text3Row = WIDGET_BASE(propBase[3], $
    /ROW)
    
  textLabel = WIDGET_LABEL(text3Row, VALUE = 'Text Color: ')
  textColor = CW_RGBSLIDE(text3Row, $
    /ROW, $
    UVALUE = 'textcolor')
  WIDGET_CONTROL, textColor, SET_VALUE = [0,0,255]
  
  ;** Output
  
  propBase[4] = WIDGET_BASE(propBB, $
    /COL, $
    MAP = 0, $
    EVENT_PRO = 'output_eh')
  printBase = WIDGET_BASE(propBase[4], /ROW, SPACE = 30)
  printLabel = WIDGET_LABEL(printBase, VALUE = 'Printing: ')
  printSetup = WIDGET_BUTTON(printBase, $
    VALUE = 'Print Setup', $
    UVALUE = 'printsetup')
  printGo = WIDGET_BUTTON(printBase, $
    VALUE = 'Print', $
    UVALUE = 'print')
    
  imageBase = WIDGET_BASE(propBase[4], /ROW)
  imageLabel = WIDGET_LABEL(imageBase, VALUE = 'Image Output As: ')
  imageEBase = WIDGET_BASE(imageBase, /EXCLUSIVE, /ROW)
  imageGIF = WIDGET_BUTTON(imageEBase, VALUE = 'GIF', UVALUE = 'imagetype')
  imageJPG = WIDGET_BUTTON(imageEBase, VALUE = 'JPG', UVALUE = 'imagetype')
  imageBMP = WIDGET_BUTTON(imageEBase, VALUE = 'BMP', UVALUE = 'imagetype')
  imageTIF = WIDGET_BUTTON(imageEBase, VALUE = 'TIF', UVALUE = 'imagetype')
  imagePICT = WIDGET_BUTTON(imageEBase, VALUE = 'PICT', UVALUE = 'imagetype')
  imageGo = WIDGET_BUTTON(imageBase, VALUE = 'Save Image to File', UVALUE = 'imagego')
  WIDGET_CONTROL, imageGIF, SET_BUTTON = 1
  vrmlRow = WIDGET_BASE(propBase[4], /ROW)
  vrmlBut = WIDGET_BUTTON(vrmlRow, VALUE = 'Output to VRML file', $
    UVALUE = 'vrml')
    
    
  fileBase = WIDGET_BASE(propBAse[4], /ROW)
  fileLabel = WIDGET_LABEL(fileBase, VALUE = 'File Name: ')
  fileText = WIDGET_TEXT(fileBase, $
    XSIZE = 50, $
    YSIZE = 1, $
    UVALUE = 'filetext', $
    /EDITABLE)
  fileBrowse = WIDGET_BUTTON(fileBase, $
    VALUE = 'Browse', $
    UVALUE = 'filebrowse')
    
  ;** Light Sources
  propBase[5] = WIDGET_BASE(propBB, $
    /COL, $
    MAP = 0, $
    EVENT_PRO = 'light_eh')
    
  lightBase1 = WIDGET_BASE(propBase[5], /ROW)
  light1NE = WIDGET_BASE(lightBase1, /ROW, /NONEXCLUSIVE)
  light1Toggle = WIDGET_BUTTON(light1NE, $
    VALUE = 'Light 1: ', $
    UVALUE = 'light1')
  light1color = CW_RGBSLIDE(lightBase1, UVALUE = 'light1color', /ROW)
  
  lightBase2 = WIDGET_BASE(propBase[5], /ROW)
  light2NE = WIDGET_BASE(lightBase2, /ROW, /NONEXCLUSIVE)
  light2Toggle = WIDGET_BUTTON(light2NE, $
    VALUE = 'Light 2: ', $
    UVALUE = 'light2')
  light2color = CW_RGBSLIDE(lightBase2, UVALUE = 'light2color', /ROW)
  
  
  lightBase3 = WIDGET_BASE(propBase[5], /ROW)
  light3NE = WIDGET_BASE(lightBase3, /ROW, /NONEXCLUSIVE)
  light3Toggle = WIDGET_BUTTON(light3NE, $
    VALUE = 'Light 3: ', $
    UVALUE = 'light3')
  light3color = CW_RGBSLIDE(lightBase3, UVALUE = 'light3color', /ROW)
  
  ;** The Map
  
  propBase[6] = WIDGET_BASE(propBB, $
    /COLUMN, $
    MAP = 0, $
    EVENT_PRO = 'map_eh')
    
  itemNEBase = WIDGET_BASE(propBase[6], /ROW, /NONEXCLUSIVE)
  b_usa = WIDGET_BUTTON(itemNEBase, VALUE = 'USA', UVALUE='changemap')
  b_rivers = WIDGET_BUTTON(itemNEBase, VALUE = 'RIVERS', UVALUE='changemap')
  b_cont = WIDGET_BUTTON(itemNEBase, VALUE = 'CONTINENTS', UVALUE='changemap')
  b_coast = WIDGET_BUTTON(itemNEBase, VALUE = 'COASTS', UVALUE='changemap')
  b_countries = WIDGET_BUTTON(itemNEBase, VALUE = 'COUNTRIES', UVALUE='changemap')
  b_cities = WIDGET_BUTTON(itemNEBase, VALUE = 'CITIES', UVALUE = 'changemap')
  
  colorBase = WIDGET_BASE(propBase[6], /ROW)
  mapcolor = CW_RGBSLIDE(colorBase, /ROW, UVALUE = 'changecolor', TITLE = 'Coast Color')
  b_remove = WIDGET_BUTTON(colorBase, VALUE = 'Remove All Map Lines', UVALUE = 'removeall')
  
  lineBase = WIDGET_BASE(propBase[6], /ROW, SPACE = 30)
  lsDrop = WIDGET_DROPLIST(lineBase, $
    VALUE = lineStyles, $
    UVALUE = 'linestyle', $
    TITLE = 'Line Style: ')
  ltField = CW_FIELD(lineBase, $
    XSIZE = 5, $
    YSIZE = 1, $
    /INTEGER, $
    /RETURN_EVENTS, $
    VALUE = 0, $
    UVALUE = 'linethick', $
    TITLE = 'Line Thickness')
    
  ; ** transformation information
  ;
  ; To enable this code, uncomment the widgets
  ; below and the transformations structure near the bottom
    
  ;propBase[7] = widget_base(propBB, $
  ;	/COLUMN, $
  ;	MAP = 0, $
  ;	EVENT_PRO = 'transform_eh')
  ;
  ;transLabel = widget_label(propBase[7], $
  ;	VALUE = 'EarthMap transformation matrix', $
  ;	UVALUE = 'transformtimer')
  ;
  ;transtable = widget_table(propBase[7], $
  ;	XSIZE = 4, $
  ;	YSIZE = 4, $
  ;	/RESIZEABLE_COLUMNS, $
  ;	/RESIZEABLE_ROWS, $
  ;	UVALUE = 'transformtable', $
  ;	VALUE = fltarr(4,4), $
  ;	FORMAT = '(f7.4)', $
  ;	/EDITABLE)
  ;
  ;buttonbase = widget_base(propBase[7], $
  ;	/ROW, $
  ;	SPACE = 30)
  ;transbutton = widget_button(buttonbase, $
  ;	VALUE = 'Get Transformation Matrix Now!', $
  ;	UVALUE = 'transformtimer')
  ;setasdefbutton = widget_button(buttonbase, $
  ;	VALUE = 'Set Current as Default Matrix', $
  ;	UVALUe = 'setdefault')
    
  ;** End of widget creation
    
  WIDGET_CONTROL, tlb, /REALIZE
  WIDGET_CONTROL, tlb, /HOURGLASS
  
  ; Objects
  ; printer object
  
  ;oPrinter = obj_new('IDLgrPrinter')
  oPrinter = 0
  ; he cambiado esto porque si no, no funciona cuando no tengo impresora instalada.
  
  ; The main view object
  oView = OBJ_NEW('IDLgrView', $
    VIEWPLANE_RECT = [-1.1, -1.1, 2.2, 2.2], $
    ZCLIP = [4.0, -4.0], $
    PROJECTION = 1, $
    EYE = 5, $
    COLOR = [255,255,255])
    
  ; The main model object
  oModel = OBJ_NEW('IDLgrModel')
  
  oView->ADD, oModel
  
  ; The creation of the earth map using the map3d object
  oEarthMap = OBJ_NEW('map3d', $
    _EXTRA = extra)
    
  ; Since we have created the EarthMap object using _EXTRA
  ; the user will have all the control over the setting of the
  ; properties. The GetPRoperty method will tell us all we need
  ; to know to set our widgets corectly
  ;
  oEarthMap->GETPROPERTY, $
    USA = usa, $
    CONT = cont, $
    COUNTRIES = countries, $
    RIVERS = rivers, $
    COASTS = coasts, $
    MLINESTYLE = ls, $
    MLINETHICK = linethick, $
    MAPCOLOR = mc, $
    COLOR = fg
    
  oView->GETPROPERTY, COLOR = bg
  
  ; setup the widgets to reflect the true properties of the
  ; earth object
  WIDGET_CONTROL , b_usa, set_button = usa
  WIDGET_CONTROL , b_cont, set_button = cont
  WIDGET_CONTROL , b_countries, set_button = countries
  WIDGET_CONTROL , b_rivers, set_button = rivers
  WIDGET_CONTROL , b_coast, set_button = coasts
  WIDGET_CONTROL, lsDrop, set_droplist_select = ls
  WIDGET_CONTROL, ltField, set_value = linethick
  WIDGET_CONTROL, mapcolor, set_value = mc
  WIDGET_CONTROL, rgbBG, set_value = bg
  WIDGET_CONTROL, rgbFG, set_value = fg
  
  
  ; Draw the equator and the prime meridan
  oEq = oEarthMap->DRAWEQUATOR()
  oPr = oEarthMap->DRAWPRIME()
  
  ; Draw some points on the earth
  
  ;oSym = obj_new('IDLgrSymbol', 2, $
  ;	SIZE = [0.02,0.02])
  ;lon = randomu(seed, 35) * 40.0 - 35.0
  ;lat = randomu(seed,35) * (-60)
  ;oPt = oEarthMap->Plot(lon, lat, $
  ;	SYMBOL = oSym, $
  ;	COLOR = [0,255,0], $
  ;	LINESTYLE = 0)
  
  ; Draw a piece of text on the globe
  oTxt = oEarthMap->DRAWTEXT('0,0,0 point', 0.0, 0.0, COLOR = [255,128,0])
  
  ; Add the EarthMap to the model
  oModel->ADD, oEarthMap
  
  ; Light Sources
  oLight1 = OBJ_NEW('IDLgrLight', $
    location = [-1,-1,1], $
    TYPE = 2, $
    COLOR = [0,255,0], $
    HIDE = 1)
  WIDGET_CONTROL, light1color, set_value = [0,255,0]
  oLight2 = OBJ_NEW('IDLgrLight', $
    LOCATION = [1,1,-1], $
    TYPE = 2, $
    COLOR = [0,0,255], $
    HIDE = 1)
  WIDGET_CONTROL, light2color, set_value = [0,0,255]
  oLight3 = OBJ_NEW('IDLgrLight', $
    LOCATION = [0,0,1], $
    TYPE = 2, $
    COLOR = [255,0,0], $
    HIDE = 1)
  WIDGET_CONTROL, light3color, set_value = [255,0,0]
  
  oLightModel = OBJ_NEW('IDLgrModel')
  oLightModel->ADD, oLight1
  oLightModel->ADD, oLight2
  oLightModel->ADD, oLight3
  oView->ADD, oLightModel
  
  ; the user wants to overlay a map on the surface
  IF (KEYWORD_SET(image)) THEN BEGIN
    OPENR, lun, FILEPATH('worldelv.dat', subdir = ['examples','data']), /get
    img = BYTARR(360,360)
    READU, lun, img
    FREE_LUN, lun
    img = CONGRID(img, 359, 179)
    img = SHIFT(img, 89, 0)
    
    ct = getct(5)
    oPalette = OBJ_NEW('IDLgrPalette', ct[*,0], ct[*,1], ct[*,2])
    oImage = OBJ_NEW('IDLgrImage', img, PALETTE = oPalette)
    oEarthMap->SETPROPERTY, TEXTURE_MAP = oImage
  ENDIF ELSE BEGIN
    oImage = OBJ_NEW('IDLgrImage')
  ENDELSE
  
  ; VRML object: IDL 5.1+
  ;oVRML = obj_new('IDLgrVRML')
  
  ; Create the trackball object used to drag the globe around with the earth
  oTrack = OBJ_NEW('TRACKBALL', [xdim/2.0, ydim/2.0], xdim/2.0)
  
  ; Get the window object reference from the VALUE of the GR2 draw widget
  WIDGET_CONTROL, draw, get_value = oWindow
  
  ; Rotate the earth a little
  
  oModel->ROTATE,[0,1,0],-90
  oModel->ROTATE,[0,0,1],-60
  
  ; Set the transformation table widget to the value of the current
  ; transformation matrix
  oModel->GETPROPERTY, TRANSFORM = deftrans
  ;widget_control, transtable, set_value = deftrans
  
  ; Draw the view to the window
  oWindow->DRAW, oView
  
  WIDGET_CONTROL, tlb, HOURGLASS = 0
  
  WIDGET_CONTROL, tlb2, /REALIZE
  
  ; set off the timer that automatically updates the transformation
  ; matrix table widget
  ; widget_control, translabel, TIMER = 4
  
  
  ; The structures that will carry information over to the event
  ; handlers
  
  ; animation property sheet info
  animate = { base:animBase, $
    loop:0, $
    inctext:animincText, $
    position:0, $
    increment:0, $
    delay:delayField, $
    xaxis:1, $
    yaxis:0, $
    zaxis:0, $
    reset:0}
    
  ; rotation property sheet info
  rotate = {xrot:xrotSlide, $
    yrot:yrotSlide, $
    zrot:zrotSlide, $
    zoomsliderval:0}
    
  ; color manipulation prop sheet info
  color = { rgbFG:rgbFG, $
    rgbBG:rgbBG, $
    predefBase:predefBase, $
    rgbBase:rgbBase, $
    colorVals:colorVals}
    
  ; text manipulation info
  text = {locX:locXField, $
    locY:locYField, $
    textColor:textColor, $
    threed:threedBut, $
    onglass:1, $
    addtext:addtextField, $
    fontNames:fontNames, $
    fontSizes:fontSizes, $
    fontsize:12, $
    font:0, $
    curtext:0}
    
  ; output property sheet info
  output = {imagetype:'GIF', $
    fileText:fileText}
    
  ; transformations property sheet info
  ;transforms = {translabel:translabel, $
  ;			  transtable:transtable}
    
  ; All of the object references, group together so they
  ; can all be destroyed when the application dies!
  obj = { oWindow:oWindow, $
    oView:oView,     $
    oModel:oModel,   $
    oTrack:oTrack, $
    oEarthMap:oEarthMap, $
    oText:OBJARR(100), $
    oFont:OBJ_NEW('IDLgrFont'), $
    oPrinter:oPrinter, $
    oLight1:oLight1, $
    oLight2:oLight2, $
    oLight3:oLight3, $
    oImage:oImage} ;, $
  ; oVRML:oVRML}
    
  ; misc data that doesn't fit anywhere else
  data = { xdim:xdim, $
    ydim:ydim, $
    statuslabel:statuslabel, $
    propBase:propBase, $
    currentPropSheet:0, $
    defTrans:defTrans, $
    MouseButton:0b}
    
  ; The information structure that will be passed through the UVALUE of the
  ; top-level bases.
  info = { obj:obj, $
    data:data, $
    animate:animate, $
    rotate:ROTATE, $
    color:color, $
    text:TEXT, $
    output:output } ; , $
  ; transforms:transforms}
    
  WIDGET_CONTROL, tlb, set_uvalue = info
  WIDGET_CONTROL, tlb2, set_uvalue = info
  
  ; call xmanager twice, once for the first top-level base and
  ; then again for the property sheet bases
  XMANAGER, 'map3d_demo', tlb, $
    EVENT_HANDLER = 'map3d_demo_event', $
    /NO_BLOCK
  XMANAGER, 'map3d_demo', tlb2, $
    EVENT_HANDLER = 'properties_eh',$
    /NO_BLOCK
    
END
