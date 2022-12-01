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
pro SRGADone,event
  ;destroy the GUI
  widget_control,event.top,/destroy
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
pro SRGAGo,event
  ;event procedure that gets the annealing going

  widget_control,event.top,get_uvalue=state
  
  ;set up a catch statement in case the user types
  ;in a function that does not exist or something else goes on.
  catch, errno
  if(errno ne 0)then begin
    catch, /cancel
    void = dialog_message(/error, ["Unknown Error detected", !err_string])
    widget_control,event.top,set_uvalue=state,/no_copy
    return
  endif
  
  widget_control,state.numGenField,get_value = numGenerations
  widget_control,state.initPopField,get_value = initPopulationSize
  widget_control,state.popField,get_value = populationSize
  widget_control,state.eliteField ,get_value = elitism
  widget_control,state.crossoverField, get_value = crossOverRate
  widget_control,state.tournamentField, get_value = tournamentSize
  widget_control,state.mutateField, get_value = mutationRate
  
  widget_control, state.sleighID, sensitive=0
  
  widget_control,/hourglass
  
  ;have to turn all of the following from strings into scalar integers.
  numGenerations= fix(numGenerations[0])
  initPopulationSize = fix(initPopulationSize[0])
  populationSize = fix(populationSize[0])
  crossOverRate = float(crossOverRate[0])
  mutationRate = float(mutationRate[0])
  tournamentSize = fix(tournamentSize[0])
  elitism = fix(elitism[0])
  offspringPerGen = populationSize - elitism
  
  widget_control,event.id,get_value=value
  ;read in the cities
  file = filepath('cities.dat',subdir=['examples','demo','demodata'])
  ;find out how many lines there are
  numCities = 0L
  line = ''
  openr,lun,/get_lun,file
  while not eof(lun) do begin
    readf,lun,line
    numCities = numCities + 1L
  endwhile
  point_lun,lun,0 ;rewind file
  tLat = 0.0 & tLon = 0.0 & tName = ''
  lats = fltarr(numCities) & lons = fltarr(numCities) & names = strarr(numCities)
  for i=0L,numCities-1L do begin
    readf,lun,tLat,tLon,tName
    lats[i] = tLat
    lons[i] = tLon
    names[i] = tName
  endfor
  
  ;now call the GA program
  tsEvolve, numCities=numCities, initPopulationSize=initPopulationSize, $
    populationSize=populationSize, numGenerations=numGenerations, $
    offspringPerGen=offspringPerGen, tournamentSize=tournamentSize, $
    crossOverRate=crossOverRate, elitism=elitism,mutationRate=mutationRate, $
    winPix=state.winPix, winPath=state.winPath, $
    winXsize=state.winXsize, winYsize=state.winYsize,xPos=xPos, yPos=yPos, $
    names=names, lons=lons, lats=lats
    
  *state.xPos = xPos
  *state.yPos = yPos
  *state.names = names
  *state.lons = lons
  *state.lats = lats
  widget_control, state.sleighID, sensitive=1
  
  return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro sleighLaunch, event

  widget_control,event.top,get_uvalue=state
  xPos = (*state.xPos + 180) mod 360.0
  ind = where(xpos lt 0,count)
  if count gt 0 then xpos[ind] = xpos[ind]+360
  
  sleighRide, xPos, *state.yPos, group_leader=event.top
  
  return & end
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  pro SRGACleanup,base
    ;delete the pixmap
    widget_control,base,get_uvalue=state
    wdelete,state.winPix
    ;free the pointers
    if ptr_valid(state.xPos) then ptr_free, state.xPos
    if ptr_valid(state.yPos) then ptr_free, state.yPos
    if ptr_valid(state.lons) then ptr_free, state.lons
    if ptr_valid(state.lats) then ptr_free, state.lats
    return
  end
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  pro santasRoute
    ;+
    ;2005 Christmas card using a genetic algortithm to map Santa's route
    ;
    ; Written by;
    ; Ronn Kling
    ; Kling Research and Software, inc.
    ; 8074 E Main St
    ; Marshall, VA 20115
    ; ronn@rlkling.com
    ; www.rlkling.com
    ;-
  
  
    base = widget_base(/column,title='North Pole Computer Center')
    numGenField = cw_field(base,/string,title='Number of Generations ',value='100', $
      /return_events)
    initPopField = cw_field(base,/string,title='Initial Population Size',value='500', $
      /return_events )
    popField = cw_field(base,/string,title='Static Population Size',value='100', $
      /return_events )
    eliteField = cw_field(base,/string,title='Elite Population Size',value='10', $
      /return_events )
    crossoverField = cw_field(base,/string,title='Crossover Rate',value='.9', $
      /return_events )
    mutateField = cw_field(base,/string,title='Mutation Rate',value='.1', $
      /return_events )
    tournamentField = cw_field(base,/string,title='Tournament size',value='6', $
      /return_events )
      
    void = widget_button(base,value='Evolve',event_pro='SRGAGo')
    sleighID = widget_button(base,value='Launch The Sleigh!',sensitive=0, $
      event_pro='sleighLaunch')
    void = widget_button(base,value='Done',event_pro='SRGADone')
    
    pathBase = widget_base(group_leader=base,xoffset=300,$
      tlb_frame_attr=2, title='Proposed Route')
    pathDraw = widget_draw(pathBase,xsize=700,ysize=350)
    
    widget_control,base,/realize
    widget_control,pathBase,/realize
    
    widget_control,pathDraw,get_value=winPath
    
    window,/free,/pixmap,xsize=700,ysize=350
    
    state = { numGenField : numGenField, $ ;
      initPopField : initPopField, $
      popField : popField, $
      eliteField : eliteField, $
      crossoverField : crossoverField, $ ;
      mutateField : mutateField, $
      tournamentField : tournamentField, $ ;
      sleighID : sleighID, $
      winXsize : 700, winYsize : 350, $
      winPix : !d.window, $ ;pixmap window id
      winPath : winPath, $ ; window id
      lons : ptr_new(0), lats : ptr_new(0), $
      xPos : ptr_new(0) , yPos:ptr_new(0), names:ptr_new(0)}
      
    widget_control,base,set_uvalue=state,/no_copy
    
    xmanager,'santasRoute',base,/no_block,cleanup='SRGACleanup'
    return
  end