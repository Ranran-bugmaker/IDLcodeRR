pro gcsj_02
  GVH=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma0_VH*.tif')
  GVV=FILE_SEARCH('R:\PROject_practice\DATA_2tif','Gamma0_VV*.tif')
  name1="Gamma_diff-"
  name2="Gamma_ratio-"
  for i = 0L, N_ELEMENTS(GVH)-1 do begin
    sa=STRSPLIT(FILE_BASENAME(gvv[i],'.tif'),'-',/EXTRACT)
    sb=STRSPLIT(FILE_BASENAME(gvh[i],'.tif'),'-',/EXTRACT)
    if file_test('R:\PROject_practice\DATA_2tif\'+name1+sa[1]+'.tif') eq 0 then begin
    a=READ_TIFF(gvv[i],GEOTIFF=geo1)
    b=READ_TIFF(gvh[i],GEOTIFF=geo2)
    mean_a=MEAN(a,/NAN)
    mean_b=MEAN(b,/NAN)
      if (sa[1] eq  sb[1]) then begin
        diff=a/mean_a-b/mean_b
        WRITE_TIFF,'R:\PROject_practice\DATA_2tif\'+name1+sa[1]+'.tif',diff,GEOTIFF=geo1,/FLOAT
        ratio=a/b
        WRITE_TIFF,'R:\PROject_practice\DATA_2tif\'+name2+sa[1]+'.tif',ratio,GEOTIFF=geo1,/FLOAT
        PRINT,name2+sa[1]+'.tif     '+name1+sa[1]+'.tif'
      endif else begin
      endelse
    endif
  endfor
  print,'---end----'
end