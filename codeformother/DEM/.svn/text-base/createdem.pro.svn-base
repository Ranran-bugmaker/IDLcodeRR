forward_function ENVI_MAP_INFO_CREATE, ENVI_PROJ_CREATE, ENVI_TRANSLATE_PROJECTION_UNITS

Pro CreateDEM
  workspace='L:\Glacier_DEM_Related\DEM_Prepare\Test_DEM\'
  outpath='L:\Glacier_DEM_Related\DEM_Prepare\Test_DEM\'
  filelist=FILE_SEARCH(workspace+'*.shp',count=count)
  For j=0,count-1 Do Begin
    shapefile=filelist[j]
    print,shapefile
    basename=file_basename(shapefile)
    demfile=outpath+strmid(basename,0,strlen(basename)-3)+'tif'
    oshp=OBJ_NEW('IDLffShape',shapefile)
    oshp->GetProperty,n_entities=n_ent,ATTRIBUTE_INFO=attr_info,N_ATTRIBUTES=n_attr
    index=WHERE(STRLOWCASE(attr_info.name) Eq 'elev')

    ent=oshp->getentity(/all)
    n_vert=ent.n_vertices
    num=TOTAL(n_vert)

    x=FLTARR(num)
    y=FLTARR(num)
    z=FLTARR(num)

    pos=0
    For i=0LL,n_ent-1LL Do Begin
      ent=oshp->getentity(i)
      attr=oshp->getattributes(i)
      n_vert=ent.n_vertices
      vert=*(ent.vertices)

      x[pos:pos+n_vert-1]=vert[0,*]
      y[pos:pos+n_vert-1]=vert[1,*]
      z[pos:pos+n_vert-1]=attr.(index)
      pos=TEMPORARY(pos)+n_vert
    Endfor
    obj_destroy,oshp

    ; Preprocess and sort the data. GRID_INPUT will
    ; remove any duplicate locations.
    GRID_INPUT, x, y, z, xSorted, ySorted, zSorted, EPSILON=1.0

    ; Initialize the grid parameters.
    cellSize = [15.0,15.0]

    samples=FIX((MAX(xSorted) - MIN(xSorted))/cellSize[0])
    lines=FIX((MAX(ySorted) - MIN(ySorted))/cellSize[1])
    PRINT,FIX(samples),lines
    TRIANGULATE, xSorted, ySorted, Tin,b
    HELP,b
    dem=TRIGRID(xSorted,ySorted,zSorted,tin,[15.0,15.0],[MIN(Xsorted), MIN(Ysorted), MAX(Xsorted), MAX(Ysorted)],$
      max_value=MAX(zSorted),min_value=MIN(zSorted),/quintic,EXTRAPOLATE=b)
    dem1=rotate(dem, 7)

	ENVI, /RESTORE_BASE_SAVE_FILES
	ENVI_BATCH_INIT, LOG_FILE = 'batch_log.txt', BATCH_LUN = lunit

	params = [6378140.0, 6356755.3, $
	  		  0.000000,  87.000000, $
	  		  500000., 0., 1.0]
	datum = 'Xian-1980'
	name = 'GK Xian-1980 zone-15'
	units = ENVI_TRANSLATE_PROJECTION_UNITS('Meters')
	proj = 	ENVI_PROJ_CREATE(type=3, name=name, datum=datum, params=params)
	mapInfo = ENVI_MAP_INFO_CREATE(proj=proj, ps=cellsize, units=units, mc=[0, 0, min(Xsorted), max(Ysorted)])
	envi_enter_data, dem1, MAP_INFO=mapInfo, pixel_size=cellsize, xstart=MIN(Xsorted), $
		ystart=MIN(Ysorted), r_fid=r_fid
	envi_file_query, r_fid, dims=dims
 	ENVI_OUTPUT_TO_EXTERNAL_FORMAT, fid=r_fid, dims=dims, pos=[0], /TIFF, out_name=demfile
 	ENVI_BATCH_EXIT
 Endfor

End