pro kmeans_test
  input_file='O:\coarse_data\GMM\bhtmref.tif'
  output_file='O:\coarse_data\GMM\bhtmref_kmeans.tif'
  class_n=6
  iteration_n=5
  
  data=read_tiff(input_file,geotiff=geo_info)
  data_size=size(data)
  pixel_n=data_size[2]*data_size[3]
  random_pos=randomu(seed,class_n)
  true_pos=floor(random_pos*pixel_n)
  target_pos=array_indices(reform(data[0,*,*]),true_pos)
  initial_value_array=fltarr(data_size[1],class_n)
  for class_i=0,class_n-1 do begin
    for band_i=0,data_size[1]-1 do begin
      initial_value_array[band_i,class_i]=data[band_i,target_pos[0,class_i],target_pos[1,class_i]]
    endfor
  endfor
  print,initial_value_array
  distance_array=fltarr(class_n,data_size[2],data_size[3])
  class_array=intarr(iteration_n,data_size[2],data_size[3])
  for iteration_i=0,iteration_n-1 do begin
    for class_i=0,class_n-1 do begin
      temp_array=fltarr(data_size[2],data_size[3])
      for band_i=0,data_size[1]-1 do begin
        temp_array+=(data[band_i,*,*]-initial_value_array[band_i,class_i])^2.0
      endfor
      distance_array[class_i,*,*]=sqrt(temp_array)
    endfor
    
    for col_i=0,data_size[2]-1 do begin
      for line_i=0,data_size[3]-1 do begin
        class_num=where(distance_array[*,col_i,line_i] eq min(distance_array[*,col_i,line_i]))
        class_array[iteration_i,col_i,line_i]=class_num[0]
      endfor
    endfor
    
    for class_i=0,class_n-1 do begin
      for band_i=0,data_size[1]-1 do begin
        temp_value=total(data[band_i,*,*]*(class_array[iteration_i,*,*] eq class_i))/$
          total(class_array[iteration_i,*,*] eq class_i)
        initial_value_array[band_i,class_i]=temp_value
      endfor
    endfor
  endfor
  write_tiff,output_file,class_array,geotiff=geo_info
end