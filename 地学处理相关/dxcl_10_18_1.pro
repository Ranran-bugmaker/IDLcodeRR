pro dxcl_10_18_1
  
  Shp_File="R:\IDL\resource\data\chapter_2\chapter_0\sichuan_county_wgs84.shp"
  Out_Dir="R:\IDL\resource\data\chapter_2\chapter_out\"
  Input_Dir="R:\IDL\resource\data\chapter_2\chapter_0\"
  
  if ~file_test(Out_Dir,/directory) then file_mkdir,Out_Dir
  File_List=FILE_SEARCH(Input_Dir+'*.tiff')
end