FUNCTION DIY_h4_info,file_name,name,key=identify
;  获取栅格数据
;  file_name  文件，包含路径
;  name 搜索文件名，搜索info
;  identify 
;  0：搜索栅格数据
;  1：搜索全局属性
;  2：搜索文件属性
  IF ~keyword_set(identify) THEN BEGIN
    identify=0
  ENDIF
  sd_id=HDF_SD_START(file_name,/read)
  case (identify) of
    0: begin
;      获取栅格数据       
      sds_index=HDF_SD_NAMETOINDEX(sd_id,name[0])
      sds_id=HDF_SD_SELECT(sd_id,sds_index)
      HDF_SD_GETDATA,sds_id,data
      hdf_sd_endaccess,sds_id
      hdf_sd_end,sd_id
      return,data
    END
    1:  BEGIN
;      获取全局属性
      attr=HDF_SD_ATTRFIND(sd_id,name[0])
      hdf_sd_attrinfo,sd_id,attr,DATA=txt
      hdf_sd_end,sd_id
      RETURN,txt
    END
    2:  BEGIN
;      获取栅格属性
      sds_index=hdf_sd_nametoindex(sd_id,name[0])
      sds_id=hdf_sd_select(sd_id,sds_index)
      att_index=hdf_sd_attrfind(sds_id,name[1])
      hdf_sd_attrinfo,sds_id,att_index,data=attrdata
      HDF_SD_ENDACCESS,sds_id
      hdf_sd_end,sd_id
      RETURN,attrdata
    END
    else: begin
      print,"Incorrect identifier"
    end
  endcase
end