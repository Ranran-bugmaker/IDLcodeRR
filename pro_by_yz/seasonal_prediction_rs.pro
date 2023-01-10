function seasonal_predict,data,predict_n,alpha_given,alpha_cal=alpha_cal
  data_n=n_elements(data)
  season_mark=indgen(data_n)

  predict_t=indgen(predict_n)+1
  predict_result=fltarr(predict_n)

  smooth_result=fltarr(data_n)
  for smooth_i=1,data_n-2 do begin
    smooth_result[smooth_i]=mean(data[(smooth_i-1):(smooth_i+1)])
  endfor
  seasonal_index=data/smooth_result

  seasonal_factor=fltarr(4)
  for season_i=0,3 do begin
    target_season=where((season_mark mod 4) eq season_i)
    seasonal_factor[season_i]=mean(seasonal_index[target_season],/nan)
  endfor
  seasonal_factor=seasonal_factor*(4.0/total(seasonal_factor))

  if keyword_set(alpha_cal) then begin
    alpha_n=101
    alpha_test=findgen(alpha_n)*0.01
    mse=fltarr(alpha_n)
    for alpha_i=0,alpha_n-1 do begin
      smoothing_result=fltarr(data_n-1)
      smoothing_result[0]=data[0]
      for smoothing_i=1,data_n-2 do begin
        smoothing_result[smoothing_i]=alpha_test[alpha_i]*data[smoothing_i-1]+$
          (1.0-alpha_test[alpha_i])*smoothing_result[smoothing_i-1]
      endfor
      mse[alpha_i]=mean(total((smoothing_result-data[1:data_n-1])^2.0))
    endfor
    derivate=deriv(alpha_test,mse)
    gt0_pos=where(derivate gt 0)
    lt0_pos=where(derivate lt 0)
    if (gt0_pos[0] ne -1) and (lt0_pos[0] ne -1) then begin
      neg_derivate_max=max(derivate[lt0_pos])
      posi_derivate_min=min(derivate[gt0_pos])
      max_neg_pos=where(derivate eq neg_derivate_max)
      min_posi_pos=where(derivate eq posi_derivate_min)
      max_neg_alpha=alpha_test[max_neg_pos]
      min_posi_alpha=alpha_test[min_posi_pos]
      k=(max_neg_alpha-min_posi_alpha)/(neg_derivate_max-posi_derivate_min)
      alpha=k[0]*(0.0-posi_derivate_min)+min_posi_alpha[0]
    endif else begin
      alpha=alpha_given
    endelse
  endif else begin
    alpha=alpha_given
  endelse

  s1=fltarr(data_n)
  s2=fltarr(data_n)
  s1[0]=data[0]
  s2[0]=data[0]
  for s_i=1,data_n-1 do begin
    s1[s_i]=alpha*data[s_i]+(1.0-alpha)*s1[s_i-1]
    s2[s_i]=alpha*s1[s_i]+(1.0-alpha)*s2[s_i-1]
  endfor
  at=2.0*s1[data_n-1]-s2[data_n-1]
  bt=alpha*(s1[data_n-1]-s2[data_n-1])/(1.0-alpha)
  yt=at+bt*predict_t

  for predict_i=0,predict_n-1 do begin
    predict_result[predict_i]=yt[predict_i]*seasonal_factor[predict_i mod 4]
  endfor
  return,predict_result
end

function geotiff_extremum_range,geotiff_filelist
  lon_min=99999999999999999999d
  lon_max=-99999999999999999999d
  lat_min=99999999999999999999d
  lat_max=-99999999999999999999d
  extremum_range=dblarr(4)
  data_temp=read_tiff(geotiff_filelist[0],geotiff=geo_info)
  resolution_tag_temp=geo_info.(0)

  for file_i=0,n_elements(geotiff_filelist)-1 do begin
    data_temp=read_tiff(geotiff_filelist[file_i],geotiff=geo_info)
    resolution_tag=geo_info.(0)
    if total(resolution_tag eq resolution_tag_temp) ne 3 then retall
    geo_tag=geo_info.(1)
    data_size=size(data_temp)
    temp_lon_min=geo_tag[3]
    temp_lon_max=temp_lon_min+data_size[1]*resolution_tag[0]
    temp_lat_max=geo_tag[4]
    temp_lat_min=temp_lat_max-data_size[2]*resolution_tag[1]
    if temp_lon_min lt lon_min then lon_min=temp_lon_min
    if temp_lon_max gt lon_max then lon_max=temp_lon_max
    if temp_lat_min lt lat_min then lat_min=temp_lat_min
    if temp_lat_max gt lat_max then lat_max=temp_lat_max
  endfor
  extremum_range[0]=lon_min
  extremum_range[1]=lon_max
  extremum_range[2]=lat_min
  extremum_range[3]=lat_max
  return,extremum_range
end

pro seasonal_prediction_rs
  input_directory='R:\IDL\resource\seasonal_prediction\seasonal_prediction\'
  output_directory='R:\IDL\resource\seasonal_prediction\seasonal_prediction\prediction_result\'
  if ~file_test(output_directory,/directory) then file_mkdir,output_directory
  predict_n=16
  alpha_g=0.4
  predict_year_start=2021
  season_char=['autumn','spring','summer','winter']
  
  file_list=file_search(input_directory+'*.tiff',count=file_n)
  geo_range=geotiff_extremum_range(file_list)
  data_temp=read_tiff(file_list[0],geotiff=geo_info)
  resolution_tag=geo_info.(0)
  data_col=ceil((geo_range[1]-geo_range[0])/resolution_tag[0])
  data_line=ceil((geo_range[3]-geo_range[2])/resolution_tag[1])
  data_box=fltarr(file_n,data_col,data_line)
  data_box_prediction=fltarr(predict_n,data_col,data_line)
  
  for file_i=0,file_n-1 do begin
    data_temp=read_tiff(file_list[file_i],geotiff=geo_info_temp)
    data_size=size(data_temp)
    corner=geo_info_temp.(1)
    start_col=floor((corner[3]-geo_range[0])/resolution_tag[0])
    start_line=floor((geo_range[3]-corner[4])/resolution_tag[1])
    end_col=start_col+data_size[1]-1
    end_line=start_line+data_size[2]-1
    data_box[file_i,start_col:end_col,start_line:end_line]=data_temp
  endfor
  
  for col_i=0,data_col-1 do begin
    for line_i=0,data_line-1 do begin
      valid_num=total(data_box[*,col_i,line_i] gt 0)
      if valid_num ne file_n then continue
      predict_result=seasonal_predict(data_box[*,col_i,line_i],$
        predict_n,alpha_g,alpha_cal=0)
      data_box_prediction[*,col_i,line_i]=predict_result
    endfor
  endfor
  
  geo_info={$
    MODELPIXELSCALETAG:[resolution_tag[0],resolution_tag[1],0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,geo_range[0],geo_range[3],0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}

  for predict_i=0,predict_n-1 do begin
    current_year=predict_year_start+predict_i/4
    current_season=predict_i mod 4
    out_name=output_directory+string(current_year,format='(I04)')+$
      season_char[current_season]+'_predction.tiff'
    print,out_name
    write_tiff,out_name,data_box_prediction[predict_i,*,*],/float,geotiff=geo_info
  endfor
  SPAWN,"explorer "+FILE_DIRNAME(output_directory),res,/HIDE
  print,'-------end-------'
end