pro gcsj_01
  gvh=FILE_SEARCH('R:\PROject_practice\DATA_masked','Gamma0_VH_db.img',/TEST_REGULAR)
  gvv=FILE_SEARCH('R:\PROject_practice\DATA_masked','Gamma0_VV_db.img',/TEST_REGULAR)
  svh=FILE_SEARCH('R:\PROject_practice\DATA_masked','Sigma0_VH_db.img',/TEST_REGULAR)
  svv=FILE_SEARCH('R:\PROject_practice\DATA_masked','Sigma0_VV_db.img',/TEST_REGULAR)

  path_xm_pt='R:\PROject_practice\DATA_SHPorETC\ROI\xiaomai.shp'
  path_water_pt='R:\PROject_practice\DATA_SHPorETC\ROI\shuiti.shp'
  path_bulid_pt='R:\PROject_practice\DATA_SHPorETC\ROI\fuyang_building_point.shp'
  all=[gvh,gvv,svh,svv]
  e = ENVI(/headless)
  for i = 0L, N_ELEMENTS(all)-1 do begin
    a=STRSPLIT(FILE_DIRNAME(all[i]),'\',/EXTRACT)
    if file_test('R:\PROject_practice\DATA_2tif\'+FILE_BASENAME(all[i],'.img')+'-'+a[-1]+'.tif') eq 0 then begin
      start_time=systime(1)
      print,"start    "+FILE_BASENAME(all[i],'.img')+'-'+a[-1]+'.tif'
      raster = e.OpenRaster(all[i])
      raster.Export,'R:\PROject_practice\DATA_2tif\'+FILE_BASENAME(all[i],'.img')+'-'+a[-1]+'.tif', 'TIFF'
      raster.close
      end_time=systime(1)
      print,'R:\PROject_practice\DATA_2tif\'+FILE_BASENAME(all[i],'.img')+'-'+a[-1]$
        +'.tif   cost'+strcompress(string(end_time-start_time))+' s.'
    endif
  endfor
  print,'---end----'
end