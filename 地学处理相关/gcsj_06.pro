  ;+
  ; :Description:
  ;   计算shp面积
  ;
  ;
  ;
  ;
  ;
  ; :Author: ACM
  ;-
pro gcsj_06
  shppath='R:\PROject_practice\DATA_SHPorETC\SHP\小麦lon.shp'
  shpobj=obj_new('IDLffShape',shppath)
  shpobj.GetProperty, n_entities=ent_n,n_attributes=att_n,attribute_info=att_info
  OPENw,lun,'R:\PROject_practice\DATA_SHPorETC\SHP\xmmmmmmmmmm.csv',/GET_LUN
  for ni = 0L, ent_n-1 do begin
    att_result=shpobj.GetAttributes(ni)
    a=shpobj.GetEntity(ni)
    entvs=*(a.VERTICES)
    DIY_lonlat_area,entvs,out
    printf,lun,string(att_result.ATTRIBUTE_1,FORMAT='(i9)')+','+string(out,FORMAT='(F0.4)')
  endfor
  FREE_LUN,lun
  print,'---end----'
end