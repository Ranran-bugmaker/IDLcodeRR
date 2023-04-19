;+
;	:Description:
;		 //TODO 将shp转换为ROI方便进行RF
;	:parameters:
;
;	:keywords:
;
;	:return:
;
;	:Author:	冉炯涛
;	:Date 2023年4月17日 下午7:44:11
;-
;
pro SHP2ROI
  PRINT,"test"
  shp_path='R:\PROject_practice\yb\SHP_XML\'
  
  E=envi(/headless)

  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init
  
  shps=FILE_SEARCH(shp_path,"*.shp")
  
  
  for index = 0L, N_ELEMENTS(shps)-1 do begin
    roi="R:\PROject_practice\yb\SHP_XML\ROI_"+FILE_BASENAME(shps[index],".shp")+".xml"
    if file_test(roi) then file_delete,roi,/QUIET
    ; ------------------------------------------------
    ; 矢量记录转为 ROI - Convert Vector Records to ROI
    ; ------------------------------------------------
    print,"矢量转ROI"
    VECTORcmutm=ENVI.OpenVector(shps[index])
    task_1 = ENVITask('VectorRecordsToROI')
    task_1.input_vector = VECTORcmutm
    task_1.output_roi_uri = roi
    task_1.Execute
    VECTORcmutm.close
  endfor


  
  E.Close
END