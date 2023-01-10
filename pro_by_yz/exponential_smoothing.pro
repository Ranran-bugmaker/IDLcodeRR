pro exponential_smoothing
  data=[3149.44,3303.66,3010.30,3109.61,3639.21,3253.80,3466.50,3839.90,3894.66,4009.61,4253.25,4101.50,4119.88,4258.65,4401.79]
  data_n=n_elements(data)
  alpha=0.2
  alpha_n=1001
  alpha_test=findgen(alpha_n)*0.001
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
  if (gt0_pos[0] eq -1) or (lt0_pos[0] eq -1) then return
  neg_derivate_max=max(derivate[lt0_pos])
  posi_derivate_min=min(derivate[gt0_pos])
  max_neg_pos=where(derivate eq neg_derivate_max)
  min_posi_pos=where(derivate eq posi_derivate_min)
  max_neg_alpha=alpha_test[max_neg_pos]
  min_posi_alpha=alpha_test[min_posi_pos]
  k=(max_neg_alpha-min_posi_alpha)/(neg_derivate_max-posi_derivate_min)
  alpha=k*(0.0-posi_derivate_min)+min_posi_alpha
  print,alpha
  smoothing_result=fltarr(data_n-1)
  smoothing_result[0]=data[0]
  for smoothing_i=1,data_n-2 do begin
    smoothing_result[smoothing_i]=alpha*data[smoothing_i-1]+$
      (1.0-alpha)*smoothing_result[smoothing_i-1]
  endfor
  print,smoothing_result
end