;+
;	:Description:
;		 //TODO TODO_List
;	:parameters:
;
;	:keywords:
;
;	:return:
;
;	:Author:	冉炯涛
;	:Date 2023年4月14日 上午12:27:40
;-
PRO landsat9
  txtname='R:\IDL\resource\data\LC09_L2SP_130039_20220311_20220314_02_T1\LC09_L2SP_130039_20220311_20220314_02_T1_MTL.txt'
  file='R:\IDL\resource\data\LC09_L2SP_130039_20220311_20220314_02_T1\'
  output='R:\IDL\resource\data\LC09_L2SP_130039_20220311_20220314_02_T1\res\'
  if ~file_test(output,/directory) then file_mkdir,output
  txtline=FILE_LINES(txtname)
  txt=STRARR(txtline)
  OPENR,1,txtname
  READF,1,txt
  FREE_LUN,1
  group="PRODUCT_CONTENTS"
  DIY_Attributes_txt,txt,namelist,NAME=group,IDCODE="GROUP"
  DIY_Attributes_txt,namelist,filename,IDCODE="FILE_NAME_BAND_[0-9]",/KEY
  DIY_Attributes_txt,txt,tmpcal,NAME="LEVEL2_SURFACE_REFLECTANCE_PARAMETERS",IDCODE="GROUP"
  DIY_Attributes_txt,tmpcal,MULT,IDCODE="REFLECTANCE_MULT_BAND_[0-9]",/KEY
  DIY_Attributes_txt,tmpcal,add,IDCODE="REFLECTANCE_ADD_BAND_[0-9]",/KEY
  
  
  for file_i=0,n_elements(filename[*,1])-1 do begin
    print,filename[file_i,1]
    out_name=output+file_basename(filename[file_i,1],'.TIF')+'_calibration.tiff'
    data_temp=read_tiff(file+filename[file_i,1],geotiff=geo_info)
    data_cal=(data_temp*float(MULT[file_i,1])+float(add[file_i,1]))*(data_temp ne 0)
    write_tiff,out_name,data_cal,/float,geotiff=geo_info
  endfor
END