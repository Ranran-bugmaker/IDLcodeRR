pro k_means_botom
  input='R:\IDL\resource\11.15\bhtmref.tif'
  output='R:\IDL\resource\11.15\bhtmref_kmeans.tif'
  class_n=9
  iteration_n=5
  
  data=READ_TIFF(input,GEOTIFF=geo_info)
  data_size=SIZE(data)
  pixie_n=data_size[2]*data_size[3]
  random_pos=RANDOMU(seed,class_n)
  true_pos=FLOOR(random_pos*pixie_n)
  target_pos=ARRAY_INDICES(REFORM( data[0,*,*]),true_pos)
  initial_value_array=FLTARR(data_size[1],class_n)
  for ci = 0L, class_n-1 do begin
    for bi = 0L, data_size[1]-1 do begin
      initial_value_array[bi,ci]=data[bi,target_pos[0,ci],target_pos[1,ci]]
    endfor
  endfor
  distance=FLTARR(class_n,data_size[2],data_size[3])
  classarry=INTARR(iteration_n,data_size[2],data_size[3])
  for ii = 0L, iteration_n-1 do begin
    for ci = 0L, class_n-1 do begin
      tmp_arry=FLTARR(data_size[2],data_size[3])
      for bi = 0L, data_size[1]-1 do begin
        tmp_arry+=(data[bi,*,*]-initial_value_array[bi,ci])^2.0
      endfor
      distance[ci,*,*]=SQRT(tmp_arry)
    endfor
    for cci = 0L, data_size[2]-1 do begin
      for lli = 0L, data_size[3]-1 do begin
        class_num=WHERE(distance[*,cci,lli] eq  min(distance[*,cci,lli]))
        classarry[ii,cci,lli]=class_num[0]
      endfor
    endfor
    for cci = 0L, class_n-1 do begin
      for lli = 0L, data_size[1]-1 do begin
        temp_value=total(data[lli,*,*]*(classarry[ii,*,*] eq cci))/$
          total(classarry[ii,*,*] eq cci)
        initial_value_array[lli,cci]=temp_value
      endfor
    endfor
  endfor
  write_tiff,output,classarry,geotiff=geo_info,/L64
end