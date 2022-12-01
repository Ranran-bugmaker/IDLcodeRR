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
function tsGenePool::createRandomChromosome
  ;function randomly sorts the gene and returns the new order
  index = sort(randomu(seed,self.numCities-2))
  ;keep the first and last points the same
  index = [0,index+1,self.numCities-1]
  xPos = (*self.lon)[index]
  yPos = (*self.lat)[index]
  names = (*self.names)[index]
  ;create the new chromosome from the re-orderd positions
  randomChromosome = obj_new('tsChromosome',numGenes=self.numCities, $
    xPos=xPos, yPos=yPos, names=names)
    
  return,randomChromosome
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function tsGenePool::init, numCities,lat,lon,names
  ;create the gene pool
  ;After they are created the positions never change, just the traversal order.
  ;have to add in the start and stop points of the north pole
  self.numCities = numCities + 2
  self.lon = ptr_new([-180,lon,180])
  self.lat = ptr_new([90,lat,90])
  ;when mating two chromosomes we need to be able to identify each gene.
  ;so the city name must be unique
  self.names = ptr_new(['north pole begin',names,'north pole end'])
  
  return,1
end
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsGenePool::cleanup
  ;free the pointers
  if ptr_valid(self.lon) then ptr_free,self.lon
  if ptr_valid(self.lat) then ptr_free,self.lat
  if ptr_valid(self.names) then ptr_free,self.names
  
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro tsGenePool__define

  void = { tsGenePool, $
    numCities : 0L, $ ;number of genes
    lon : ptr_new(), $ ;x position
    lat : ptr_new(), $ ;y position
    names : ptr_new() } ;unique name for identification
  return
end