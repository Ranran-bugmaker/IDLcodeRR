pro gcsj_05
  ;随机森林训练及应用部分
  ;目前准备采用裁剪一部分图像
  ;训练
  roifile='R:\PROject_practice\DATA_SHPorETC\ROI\ouput00.xml'
  file='R:\PROject_practice\DATA_masked\202009L\Gamma0_VH_db.img'
  e = ENVI()
  raster = e.OpenRaster(file)
  rois = e.OpenROI(roifile)
  Task = ENVITask('TrainRandomForestModelTask')
  Task.INPUT_RASTER = raster
  Task.INPUT_ROIS = rois
  Task.NUMBER_OF_TREES = 100
  Task.IMPURITY_FUNCTION = 'Gini Index'
  Task.MIN_NUMBER_OF_SAMPLES = 1
  Task.IMPURITY_THRESHOLD = 0
  Task.OUTPUT_MODEL_URI = 'R:\PROject_practice\DATA_rondom\model.rfc'
  Task.OUTPUT_RASTER_URI = 'R:\PROject_practice\DATA_rondom\class.dat'
  Task.Execute
  output_raster = Task.OUTPUT_RASTER
  
;  ;模型应用
;  e = ENVI()
;  raster = e.OpenRaster(file)
;  Task = ENVITask('RandomForestClassifyRasterTask')
;  Task.INPUT_RASTER = raster
;  Task.MODEL_FILE = 'C:\temp\model.rfc'
;  Task.OUTPUT_RASTER_URI = 'C:\temp\class.dat'
;  Task.Execute
;  output_raster = Task.OUTPUT_RASTER
;  
;  
;  
;  ;模型批量应用
;  e = ENVI()
;  raster1 = e.OpenRaster(file1)
;  raster2 = e.OpenRaster(file2)
;  Task = ENVITask('RandomForestClassifyRasterBatch')
;  Task.INPUT_RASTERS = [raster1, raster2]
;  Task.MODEL_FILE = 'C:\temp\model.rfc'
;  Task.OUTPUT_POSTFIX = '_classrfc.dat'
;  Task.DISPLAY_RESULTS = 0
;  Task.OUTPUT_RASTER_URI = 'C:\temp\uselessname'
;  Task.Execute
;  output_files = Task.OUTPUT_FILES
  print,'---end----'
end