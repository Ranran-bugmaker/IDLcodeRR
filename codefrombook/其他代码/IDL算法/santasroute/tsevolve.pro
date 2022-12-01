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
pro tsEvolve, numCities=numCities, initPopulationSize=initPopulationSize, $
    populationSize=populationSize, numGenerations=numGenerations, $
    offspringPerGen=offspringPerGen, tournamentSize=tournamentSize, $
    crossOverRate=crossOverRate, elitism=elitism,mutationRate=mutationRate, $
    winPix=winPix, winPath=winPath, winXsize=winXsize, winYsize=winYsize,$
    winAllFit=winAllFit, winFit=winFit, $
    xPos=xPos, yPos=yPos, names=names, $
    lons=lons, lats=lats
  ;Genetic evolution example.
  ;Loosely based upon "An introduction to genetic algorithms in Java" by
  ;Michael Lacy. In Java Developers Journal, volume 6,issue 3.
  ;
  ; keywords
  ; numCities = number of cities the salesman visits
  ; initPopulationSize = initial size of the population to cull from
  ; populationSize = size of each generation
  ; numGenerations = how long you want the process to evolve.
  ; offspringPerGen = how many kids are born each generation
  ; tournamentSize = how many parents compete for mating.
  ; crossOverRate = how likey it is that parents will mate (0 to 1)
  ; elitsm = how many parents survive to the next generation
  ; mutationRate = how likely it is that a child will have a mutation
    
  if not keyword_set(numCities) then numCities = 25
  if not keyword_set(initPopulationSize) then initPopulationSize = 500
  if not keyword_set(populationSize) then populationSize = 100
  if not keyword_set(numGenerations) then numGenerations = 250
  if not keyword_set(offspringPerGen) then offspringPerGen = 90
  if not keyword_set(tournamentSize) then tournamentSize = 6
  if not keyword_set(crossOverRate) then crossOverRate = 0.9
  if not keyword_set(elitism) then elitism = 10
  if not keyword_set(mutationRate) then mutationRate = 0.1
  
  if (elitism + offspringPerGen) lt populationSize then begin
    void = dialog_message(['elitsm + offspringPerGen must be at least',$
      'equal to or greater than the populationSize'])
    return
  endif
  
  ;create the gene object. (Chromosomes are made up of genes)
  oGenePool = obj_new('tsGenePool',numCities,lats,lons,names)
  
  ;create a population
  oPopulation = obj_new('tsPopulation',initPopulationSize=initPopulationSize, $
    populationSize=populationSize, oGenePool=oGenePool, $
    offspringPerGen=offspringPerGen, elitism=elitism, $
    tournamentSize=tournamentSize, crossOverRate=crossOverRate, $
    mutationRate=mutationRate)
    
  ;evolve over the number of generations
  if not keyword_set(winPix) then begin
    winXsize=400
    winYsize=400
    window,0,xs=800,ys=400
    window,xs=800,ys=400,/free,/pix
    pix1 = !d.window
  endif
  oldFitness = 0.0
  fitnessArray = fltarr(numGenerations)
  for i=0,numGenerations-1 do begin
    oPopulation->reproduce
    oPopulation->getBestChromosome,xPos=xPos, yPos=yPos, names=names, fitness=fitness, /fullPath
    wset,winPix
    title = 'Generation = ' + string(i) + ' Current Path Length' + string(fitness)
    map_set,/cylin,/cont, title=title
    oplot,xPos,yPos
    wset,winPath
    wshow
    device,copy=[0,0,winXsize,winYsize,0,0,winPix]
  endfor
  ;get the new order of the lat/lons
  oPopulation->getBestChromosome,xPos=lons, yPos=lats, names=names
  ;free the resources
  obj_destroy, oGenePool
  obj_destroy, oPopulation
  
  return
end