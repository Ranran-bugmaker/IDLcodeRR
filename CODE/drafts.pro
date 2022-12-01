pro Drafts
  gvh=FILE_SEARCH('R:\PROject_practice\DATA_masked','Gamma0_VH_db.img',/TEST_REGULAR)
  gvv=FILE_SEARCH('R:\PROject_practice\DATA_masked','Gamma0_VV_db.img',/TEST_REGULAR)
  svh=FILE_SEARCH('R:\PROject_practice\DATA_masked','Sigma0_VH_db.img',/TEST_REGULAR)
  svv=FILE_SEARCH('R:\PROject_practice\DATA_masked','Sigma0_VV_db.img',/TEST_REGULAR)
  
  path_xm_pt='R:\PROject_practice\DATA_SHPorETC\ROI\xiaomai.shp'
  path_water_pt='R:\PROject_practice\DATA_SHPorETC\ROI\shuiti.shp'
  path_bulid_pt='R:\PROject_practice\DATA_SHPorETC\ROI\fuyang_building_point.shp'
  
  DIY_Read_envi_image,gvh[0],img
end