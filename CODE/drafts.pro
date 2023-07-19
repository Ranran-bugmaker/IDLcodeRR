FUNCTION drafts,arr
  ; 确定数组长度
  n = n_elements(arr)

  ; 确定二维数组的行列
  rows = 1L
  cols = n
  x=[n-rows*cols]
  while (rows lt cols) do begin
    rows+=1
    cols-=1
    x=[x,n-rows*cols]
  endwhile
  y=where(x eq max(x))
  ; 初始化新数组
  new_arr = fltarr(rows, cols) + !values.F_NAN
  
  ; 将一维数组中的数据逐个复制到新数组中
  for i=0, n-1 do begin
    new_arr[i mod rows, i / rows] = arr[i]
  endfor
  
  ; 返回结果
  return, new_arr
end
;  n = n_elements(arr)
;  dim = ceil(sqrt(n))
;  if dim*dim-n lt dim then dim = dim+1
;  m = fltarr(dim, dim)
;  for index = 0L, length-1 do begin
;
;  endfor
;
;  return, m
;end