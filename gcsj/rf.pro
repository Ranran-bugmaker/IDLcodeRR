;+
;	:Description:
;		 //TODO RF简单实现
;	:parameters:
;
;	:keywords:
;
;	:return:
;
;	:Author:	冉炯涛
;	:Date 2023年4月17日 下午9:35:36
;-
;
pro RF
  E=envi(/headless)
  compile_opt idl2
  on_error, 2
  envi,/restore_base_save_files
  envi_batch_init
  PRINT,"test"
  
  
  ; -------------------------
  ; Train Random Forest Model
  ; -------------------------
  task_2 = ENVITask('TrainRandomForestModelTask')
  task_2.input_raster = IDLHydrate(TYPE='ENVIRASTER', JSON_Parse('{' + $
    '    "url": "R:\\PROject_practice\\yb\\temp\\Com.dat",' + $
    '    "factory": "URLRaster",' + $
    '    "auxiliary_url": ["R:\\PROject_practice\\yb\\temp\\Com.hdr"]' + $
    '}' ))
  task_2.input_rois = IDLHydrate(TYPE='ENVIROI', JSON_Parse('[' + $
    '    {' + $
    '        "url": "R:\\PROject_practice\\yb\\SHP_XML\\ROI_xm.xml",' + $
    '        "factory": "URLRoi",' + $
    '        "dataset_index": 0' + $
    '    },' + $
    '    {' + $
    '        "url": "R:\\PROject_practice\\yb\\SHP_XML\\ROI_water.xml",' + $
    '        "factory": "URLRoi",' + $
    '        "dataset_index": 0' + $
    '    },' + $
    '    {' + $
    '        "url": "R:\\PROject_practice\\yb\\SHP_XML\\ROI_builds.xml",' + $
    '        "factory": "URLRoi",' + $
    '        "dataset_index": 0' + $
    '    }' + $
    ']' ))
  task_2.impurity_threshold = 0.19799999892711639
  task_2.output_model_uri = "R:\PROject_practice\yb\model\test"
  task_2.output_raster_uri = "R:\PROject_practice\yb\classifed\test.dat"
  task_2.Execute
  task_2.ParameterNames()


  ; -----------------------------
  ; Random Forest Classify Raster
  ; -----------------------------
  task_1 = ENVITask('RandomForestClassifyRasterTask')
  task_1.input_raster = IDLHydrate(TYPE='ENVIRASTER', JSON_Parse('{' + $
    '    "url": "R:\\PROject_practice\\yb\\temp\\Com.dat",' + $
    '    "factory": "URLRaster",' + $
    '    "auxiliary_url": ["R:\\PROject_practice\\yb\\temp\\Com.hdr"]' + $
    '}' ))
  task_1.model_file = "R:\PROject_practice\yb\model\test"
  task_1.output_raster_uri = "R:\PROject_practice\yb\classifed\test.dat"
  task_1.Execute

  
  PRINT,"test0"
END