;+
;  《IDL程序设计》
;   -数据可视化与ENVI二次开发
;        
; 示例代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;-
function modifyConnection, connectivity, numVertices, startIndex

  true = 1
  counter = 1L
  numPoints = n_elements(connectivity)
  newConnectivity = connectivity
  while true eq 1 do begin
    numIndices = newConnectivity[counter-1]
    newConnectivity[counter:counter+numIndices-1] = newConnectivity[counter:counter+numIndices-1] + startIndex
    counter = counter + numIndices + 1
    if counter ge numPoints then true=0
  endwhile
  
  return, newConnectivity
end