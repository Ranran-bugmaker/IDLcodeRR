;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsChromosome::setProperty, xPos=xPos, yPos=yPos, names=names
  ;replaces old traversal order with new one.

  ;keep the first and last points the same
  if n_elements(xPos) ne 0 then (*self.xPos)[1:self.numGenes-2] = xPos
  if n_elements(yPos) ne 0 then (*self.yPos)[1:self.numGenes-2] = yPos
  if n_elements(names) ne 0 then (*self.names)[1:self.numGenes-2] = names
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsChromosome::getProperty, numGenes=numGenes, xPos=xPos, yPos=yPos, $
    fitness=fitness, names=names, $
    fullPath=fullPath
  ;gets these values.
  ;keep the first and last points the same since we do not want to change the
  ;start and stop points
  numGenes = self.numGenes-2
  if arg_present(xPos) then begin
    if keyword_set(fullPath) then begin
      xPos = *self.xPos
    endif else begin
      xPos = (*self.xPos)[1:self.numGenes-2]
    endelse
  endif
  if arg_present(yPos) then begin
    if keyword_set(fullPath) then begin
      yPos = *self.yPos
    endif else begin
      yPos = (*self.yPos)[1:self.numGenes-2]
    endelse
  endif
  if arg_present(fitness) then fitness = self->getFitness()
  if arg_present(names) then begin
    if keyword_set(fullPath) then begin
      names = *self.names
    endif else begin
      names = (*self.names)[1:self.numGenes-2]
    endelse
  endif
  
  if keyword_set(fullPath) then begin
    lon = xPos
    lat = yPos
    pts = [0,0]
    for i=0,self.numGenes-2 do begin
      pts = [[pts],[map_2points(lon[i], lat[i],lon[i+1],lat[i+1],npath=10)]]
    endfor
    xPos = reform(pts[0,1:*])
    yPos = reform(pts[1,1:*])
  endif
  
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function tsChromosome::copy
  ;returns and exact duplicate of the chromosome
  chromosome = obj_new('tsChromosome',numGenes=self.numGenes, $
    xPos=(*self.xPos), yPos=(*self.yPos), $
    names=(*self.names))
  return,chromosome
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function tsChromosome::getFitness
  ;calculates the total distance squared traveled along the
  ;great circle

  lon = *self.xPos
  lat = *self.yPos
  
  distance = 0.0
  for i=0,self.numGenes-2 do begin
    distance = distance + map_2points(lon[i], lat[i],lon[i+1],lat[i+1],radius=6378.135)
  endfor
  return, distance
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function tsChromosome::init,numGenes=numGenes, xPos=xPos, yPos=yPos, $
    names=names
  ;initilizes a new chromosome based upon the input traversal order.
  self.numGenes = numGenes
  self.xPos = ptr_new(xPos)
  self.yPos = ptr_new(yPos)
  self.names = ptr_new(names)
  
  return,1
end
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsChromosome::cleanup
  ;frees pointers
  if ptr_valid(self.xPos) then ptr_free,self.xPos
  if ptr_valid(self.yPos) then ptr_free,self.yPos
  if ptr_valid(self.names) then ptr_free,self.names
  
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsChromosome__define

  void = {tsChromosome, $
    numGenes : 0L, $ ;number of genes
    xPos : ptr_new(), $ ;x pos
    yPos : ptr_new(), $  ;y pos
    names : ptr_new() } ;names of each gene, used for identification
    
  return
end