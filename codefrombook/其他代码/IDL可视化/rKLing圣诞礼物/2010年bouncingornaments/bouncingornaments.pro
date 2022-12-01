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
pro bouncingOrnaments_event, event
  ;single event handler

  compile_opt idl2
  
  widget_control, event.top, get_uvalue=object
  ;method names are stored in the uname
  method =  widget_info(event.id,/uname)
  if method ne '' then call_method, method, object, event
  
  return & end
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  pro bouncingClean, base
    ;called when the widget dies
    widget_control, base, get_uvalue=object
    if obj_valid(object) then obj_destroy, object
    
    return & end
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    pro bouncingOrnaments::timer, event
      ;at each timer event update the view
    
      deltaTime = 1.0 ;gives a good looking animation
      
      ;calculate the new centroids
      *self.pCentroidX = *self.pCentroidX + *self.pVel_x * deltaTime
      *self.pCentroidY = *self.pCentroidY + *self.pVel_y * deltaTime
      *self.pCentroidZ = *self.pCentroidZ + *self.pVel_z * deltaTime
      
      ;check for outer box violations
      ind = where( *self.pCentroidX lt -self.xBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidX)[ind] = -self.xBound + randomu(seed,count)/10 ;radnomu keeps the points from being in the same place
        (*self.pVel_x)[ind] = -(*self.pVel_x)[ind]
      endif
      
      ind = where( *self.pCentroidX gt self.xBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidX)[ind] = self.xBound - randomu(seed,count)/10 ;randomu keeps the points from being in the same place
        (*self.pVel_x)[ind] = -(*self.pVel_x)[ind]
      endif
      
      ind = where( *self.pCentroidY lt -self.yBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidY)[ind] = -self.yBound + randomu(seed,count)/10 ;radnomu keeps the points from being in the same place
        (*self.pVel_y)[ind] = -(*self.pVel_y)[ind]
      endif
      
      ind = where( *self.pCentroidY gt self.yBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidY)[ind] = self.yBound - randomu(seed,count)/10 ;radnomu keeps the points from being in the same place
        (*self.pVel_y)[ind] = -(*self.pVel_y)[ind]
      endif
      
      ind = where( *self.pCentroidZ lt -self.zBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidZ)[ind] = -self.zBound + randomu(seed,count)/10 ;radnomu keeps the points from being in the same place
        (*self.pVel_z)[ind] = -(*self.pVel_z)[ind]
      endif
      
      ind = where( *self.pCentroidZ gt self.zBound, count)
      if count gt 0 then begin ;bounces off a wall
        (*self.pCentroidZ)[ind] = self.zBound - randomu(seed,count)/10 ;radnomu keeps the points from being in the same place
        (*self.pVel_z)[ind] = -(*self.pVel_z)[ind]
      endif
      
      ;step over all the ornaments to check for collisions
      for i=0, self.numOrnaments-2 do begin
        ;PRE IDL 8.0
        ;  distX = (*self.pCentroidX)[i] - (*self.pCentroidX)[i+1:*]
        ;  distY = (*self.pCentroidY)[i] - (*self.pCentroidY)[i+1:*]
        ;  distZ = (*self.pCentroidZ)[i] - (*self.pCentroidZ)[i+1:*]
        ;IDL 8.0
        distX = (*self.pCentroidX)[i] - (*self.pCentroidX)[i+1:-1]
        distY = (*self.pCentroidY)[i] - (*self.pCentroidY)[i+1:-1]
        distZ = (*self.pCentroidZ)[i] - (*self.pCentroidZ)[i+1:-1]
        
        totDist = sqrt(distX^2 + distY^2 + distZ^2)
        ind = where(totDist lt 2*self.radius, ccc) ;find all places where a collision occurs
        if ccc gt 0 then begin
          ;have to pull out these into single variables since IDL passes subscripted
          ;arrays by value and we need to change the values in collision3Dfast
          x1 = (*self.pCentroidX)[i]
          y1 = (*self.pCentroidY)[i]
          z1 = (*self.pCentroidZ)[i]
          x2 = (*self.pCentroidX)[i+1+ind]
          y2 = (*self.pCentroidY)[i+1+ind]
          z2 = (*self.pCentroidZ)[i+1+ind]
          vx1 = (*self.pVel_x)[i]
          vy1 = (*self.pVel_y)[i]
          vz1 = (*self.pVel_z)[i]
          vx2 = (*self.pVel_x)[i+1+ind]
          vy2 = (*self.pVel_y)[i+1+ind]
          vz2 = (*self.pVel_z)[i+1+ind]
          collision3Dfast,  self.restitutionCoef,  self.mass,  self.mass,  $
            self.radius,  self.radius, x1,  y1, z1, x2,  y2,  z2, $
            vx1,  vy1,  vz1, vx2, vy2, vz2
          ;reload the changed values
          (*self.pCentroidX)[i] = x1[0]
          (*self.pCentroidY)[i] = y1[0]
          (*self.pCentroidZ)[i] = z1[0]
          (*self.pCentroidX)[i+1+ind] = x2
          (*self.pCentroidY)[i+1+ind] = y2
          (*self.pCentroidZ)[i+1+ind] = z2
          (*self.pVel_x)[i] = vx1[0]
          (*self.pVel_y)[i] = vy1[0]
          (*self.pVel_z)[i] = vz1[0]
          (*self.pVel_x)[i+1+ind] = vx2
          (*self.pVel_y)[i+1+ind] = vy2
          (*self.pVel_z)[i+1+ind] =vz2
        endif
      endfor
      
      ;initialize the groundPts to the right size
      groundPts = *self.pGeneric_pts
      ;update with the new centroid positions
      groundPts[0,*,*] = (*self.pGeneric_pts)[0,*,*] + *self.pCentroidX ## make_array(153,value=1.0)
      groundPts[1,*,*] = (*self.pGeneric_pts)[1,*,*] + *self.pCentroidY ## make_array(153,value=1.0)
      groundPts[2,*,*] = (*self.pGeneric_pts)[2,*,*] + *self.pCentroidZ ## make_array(153,value=1.0)
      ;update the polygon points and draw
      ;Pre IDL 8.0
      ;self.oOrnamentPolygon->setProperty, data=groundPts
      ;self.oWindow->draw, self.oView
      ;IDL 8.0 and later
      self.oOrnamentPolygon.data=groundPts
      self.oWindow.draw, self.oView
      
      ;drive this at 30 frames/second
      widget_control, self.wBase, timer=1.0/30.0
      
      return & end
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      pro bouncingOrnaments::changeNumPoints, event
        ;changes the number of points. Rather than adding or deleting points
        ;we just create new ones
      
        compile_opt idl2
        
        if n_params() eq 1 then begin ;called by a slider event
          self.numOrnaments = event.value
        endif
        
        ;create the centroids for each of the ornaments
        centroidX = (randomu(seed, self.numOrnaments) * 2.0*self.xBound) - self.xBound
        centroidY = (randomu(seed, self.numOrnaments) * 2.0*self.yBound) - self.yBound
        centroidZ = (randomu(seed, self.numOrnaments) * 2.0*self.zBound) - self.zBound
        
        ;need to make sure that no centroids start out inside each other. Unfortunately, this
        ;is kind of slow since we have to check each point against all others
        
        ;Pre IDL 8.0
        ;goodInd = [-1]
        ;IDL 8.0
        goodInd = list(-1)
        for i=0, self.numOrnaments-1 do begin
          for j=0,i do begin
            if i eq j then continue
            distX = centroidX[i] - centroidX[j]
            distY = centroidY[i] - centroidY[j]
            distZ = centroidZ[i] - centroidZ[j]
            totDist = sqrt(distX^2 + distY^2 + distZ^2)
            if totDist gt 2*self.radius then begin
              ;Pre IDL 8.0
              ;goodInd = [goodInd,i]
              ;IDL 8.0
              goodInd.add, i
            endif
          endfor
        endfor
        
        ;PRE IDL 8.0
        ;goodInd = goodInd[1:*] ;discard the first
        ;IDL 8.0
        goodInd = goodInd[1:-1] ;discard the first
        goodInd = goodInd.toArray() ;convert to an array
        
        goodInd = goodInd[uniq(goodInd, sort(goodInd))] ;get rid of duplicates
        ;get new centroids
        centroidX = centroidX[goodInd]
        centroidY = centroidY[goodInd]
        centroidZ = centroidZ[goodInd]
        
        ;recalculate the number
        self.numOrnaments = n_elements(centroidX)
        ;find random velocities centered on 0, dividing by the bounds is a wag to make
        ;them move slower. In a real analysis app this would be something else
        vel_x = randomn(seed, self.numOrnaments)/self.xBound
        vel_y = randomn(seed, self.numOrnaments)/self.yBound
        vel_z = randomn(seed, self.numOrnaments)/self.zBound
        
        ;these parameters control the resolution of the ornament spheres
        nLongitude = 16
        nLatitude = 9
        ;50 is just a wag to get the initial coords, we will divide it out later
        mesh_obj, 4, vert,conn, replicate(50, nLongitude+1, nLatitude), /close
        
        ;define the colors for the ornaments, IDL will cycle among the colors
        ;first color is a rainbow effect
        vertColors = Byte(256*RandomU(seed, 3, nLongitude+1, nLatitude))
        vertColors[*, nLongitude, *] = vertColors[*, 0, *]
        for i=1, nLongitude do begin
          vertColors[*, i, 0] = vertColors[*, 0, 0]
          vertColors[*, i, nLatitude-1] = vertColors[*, 0, nLatitude-1]
        endfor
        vertColors = Reform(/Overwrite, vertColors, 3, (nLongitude+1)*nLatitude)
        ;red ones
        v = vertColors * 0
        v[0,*] = 255B
        vertColors = [[vertColors],[v]]
        ;green ones
        v = vertColors * 0
        v[1,*] = 255B
        vertColors = [[vertColors],[v]]
        ;blue ones
        v = vertColors * 0
        v[2,*] = 255B
        vertColors = [[vertColors],[v]]
        
        ;what we are doing is creating self.numOrnaments number of spheres
        ;These are all centered at [0,0,0] so that all we have to do is keep track of the centroids
        numVertices = n_elements(vert[0,*])
        ;scale it from 1 to -1 by dividing by 50 and then make smaller by 0.05. You can
        ;change this number to make the balls bigger or smaller
        scaledVert = (vert/50.0)*self.radius
        ;turn it into a 1D array
        gg =  reform(scaledVert,n_elements(scaledVert))
        generic_pts =  gg ;first vector
        ;just append each vector
        for i=1,self.numOrnaments-1 do generic_pts = [generic_pts, gg]
        
        ;next we turn it into a 3,m,n array that will make it easy to modify the ornament surfaces ,
        ;see the handleEvent method
        generic_pts = reform(generic_pts, 3, numVertices, self.numOrnaments)
        
        ;modifyConnection is a neat little function that rebuilds the polygon connectivity
        ;list with new indices
        connections = conn
        for i=1,self.numOrnaments-1 do $
          connections = [connections, modifyConnection(conn, numVertices,i*(numVertices))]
          
        ;initialize the surfaces of the ornaments to the same points
        surfacePts = generic_pts
        ;modify the surface points so that they surround the centroid
        numVertices = n_elements(generic_pts[0,*,0])
        surfacePts[0,*,*] = generic_pts[0,*,*] + centroidX ## make_array(numVertices,value=1.0)
        surfacePts[1,*,*] = generic_pts[1,*,*] + centroidY ## make_array(numVertices,value=1.0)
        surfacePts[2,*,*] = generic_pts[2,*,*] + centroidZ ## make_array(numVertices,value=1.0)
        
        ;now update the polygon with new vertices and connections
        ;PRE IDL 8.0
        ;self.oOrnamentPolygon->setProperty, data=surfacePts, polygon=connections, $
        ;            Vert_Colors=vertColors, shading=1, style=2
        self.oOrnamentPolygon.data=surfacePts
        self.oOrnamentPolygon.polygon=connections
        self.oOrnamentPolygon.Vert_Colors=vertColors
        self.oOrnamentPolygon.shading=1
        self.oOrnamentPolygon.style=2
        
        ;save the values
        *self.pGeneric_pts = generic_pts
        *self.pCentroidX = centroidX
        *self.pCentroidY = centroidY
        *self.pCentroidZ = centroidZ
        *self.pVel_x = vel_x
        *self.pVel_y = vel_y
        *self.pVel_z = vel_z
        
        return & end
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        pro bouncingOrnaments::changeRestCoef, event
          ;less than one slows down, equal to one perfect rebound
          ;greater than one accelerate after each collisioin
        
          self.restitutionCoef = event.value
          
          return & end
          
          ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
          
          pro bouncingOrnaments::changeRadius, event
            ;update the radius is real time
          
            *self.pGeneric_pts = *self.pGeneric_pts/self.radius
            self.radius = event.value
            *self.pGeneric_pts = *self.pGeneric_pts * self.radius
            
            return & end
            
            ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
            
            pro bouncingOrnaments::cleanup
            
              compile_opt idl2
              
              if ptr_valid(self.pGeneric_pts)then ptr_free, self.pGeneric_pts
              if ptr_valid(self.pCentroidX)then ptr_free, self.pCentroidX
              if ptr_valid(self.pCentroidY)then ptr_free, self.pCentroidY
              if ptr_valid(self.pCentroidZ)then ptr_free, self.pCentroidZ
              if ptr_valid(self.pVel_x)then ptr_free, self.pVel_x
              if ptr_valid(self.pVel_y)then ptr_free, self.pVel_y
              if ptr_valid(self.pVel_z)then ptr_free, self.pVel_z
              
              return & end
              
              ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
              
              function bouncingOrnaments::init, wBase
                ;builds the GUI and initializes all of the points
              
                compile_opt idl2
                
                wBase = widget_base(column=1, title='Bouncing Ornaments', $
                  tlb_size_events=1, uname='timer')
                  
                wDraw = widget_draw(wBase, xsize=500,ysize=500, graphics_level=2, $
                  renderer=0)
                wVoid = widget_label(wBase, value='Merry Christmas!')
                wVoid = widget_label(wBase, value='From Kling Research and Software')
                wRowBase = widget_base(wBase, row=1)
                wLeftCol = widget_base(wRowBase, col=1)
                wVoid = widget_slider(wLeftCol, title='Number of Ornaments', min=10,max=500, $
                  value=20, uname='changeNumPoints',/drag)
                wVoid = cw_fslider(wLeftCol, title='Radius',min=0.1,max=2.0, uname='changeRadius', value=0.5,/drag)
                wRightCol = widget_base(wRowBase, col=1)
                wVoid = cw_fslider(wRightCol, title='Restitution Coeff', min=0.1, max=2.0, uname='changeRestCoef',value=1.0,/drag)
                
                widget_control, wBase, /realize
                self.wBase = wBase
                widget_control, self.wBase, set_uvalue=self
                widget_control, wDraw, get_value=oWindow
                self.oWindow = oWindow
                
                self.restitutionCoef = 1.0
                self.mass = 1.0
                self.xBound = 10.0
                self.yBound = 10.0
                self.zBound = 10.0
                self.numOrnaments = 20
                self.radius = 0.5
                self.pGeneric_pts = ptr_new(0)
                self.pCentroidX = ptr_new(0)
                self.pCentroidY = ptr_new(0)
                self.pCentroidZ = ptr_new(0)
                self.pVel_x = ptr_new(0)
                self.pVel_y = ptr_new(0)
                self.pVel_z = ptr_new(0)
                
                ;Pre IDL 8.0
                ;make the view a little bigger than the bounds
                ;self.oView = obj_new('IDLgrView', viewplane_rect=[-self.xBound*1.1,-self.yBound*1.1,$
                ;           2.2*self.xBound,2.2*self.yBound], projection=2, zclip=[self.zBound*2, -self.zBound*2], color=[0,0,0])
                ;oModel = obj_new('IDLgrModel')
                ;self.oView->add,oModel
                ;IDL 8.0
                self.oView = IDLgrView( viewplane_rect=[-self.xBound*1.1,-self.yBound*1.1,$
                  2.2*self.xBound,2.2*self.yBound], projection=2, zclip=[self.zBound*2, -self.zBound*2], color=[0,0,0])
                oModel = IDLgrModel()
                self.oView.add,oModel
                
                ;Pre IDL 8.0
                ;directional light
                ;oLight1 = obj_new('IDLgrLight', loc=[2,2,5], type=2, $ ; Directional (parallel rays).
                ;    color=[255,255,255], intensity=.5 )
                ;ambient light
                ;oLight2 = obj_new('IDLgrLight', type=0, intensity=0.5, color=[255,255,255] )
                ;oModel->add, [oLight1, oLight2]
                ;IDL 8.0
                ;directional light
                oLight1 = IDLgrLight(loc=[2,2,5], type=2, $ ; Directional (parallel rays).
                  color=[255,255,255], intensity=.5 )
                ;ambient light
                oLight2 = IDLgrLight(type=0, intensity=0.5, color=[255,255,255] )
                oModel.add, [oLight1, oLight2]
                
                ;trick to speed in this visualization is to have a single polygon object
                ;but with a special connectivity so that it looks like we have a bunch of
                ;polygons behaving independently
                ;PRE IDL 8.0
                ;self.oOrnamentPolygon = obj_new('IDLgrPolygon',   $ ;Vert_Colors=vertColors, $
                ;                    shading=1, style=2 )
                ;oModel->Add, self.oOrnamentPolygon
                self.oOrnamentPolygon = IDLgrPolygon(shading=1, style=2)
                oModel.Add, self.oOrnamentPolygon
                
                self->changeNumPoints
                
                ;Pre IDL 8.0
                ;self.oWindow->draw, self.oView
                ;IDL 8.0
                self.oWindow.draw, self.oView
                
                widget_control, self.wBase, timer=1.0/30.0
                
                return,1
              end
              
              
              ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
              
              pro bouncingOrnaments__define
              
                compile_opt idl2
                
                void = {bouncingOrnaments, $
                
                  numOrnaments : 0, $
                  radius : 0.0, $
                  restitutionCoef : 0.0, $
                  mass : 0.0, $
                  xBound : 0.0, $
                  yBound : 0.0, $
                  zBound : 0.0, $
                  
                  wBase : 0L, $
                  
                  pGeneric_pts : ptr_new(), $
                  pCentroidX : ptr_new(), $
                  pCentroidY : ptr_new(), $
                  pCentroidZ : ptr_new(), $
                  pVel_x : ptr_new(), $
                  pVel_y : ptr_new(), $
                  pVel_z : ptr_new(), $
                  
                  oView : obj_new(), $
                  oOrnamentPolygon : obj_new(), $
                  oWindow : obj_new() }
                  
                return & end
                
                ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
                
                pro bouncingOrnaments
                
                  oBounce = obj_new('bouncingOrnaments', wBase)
                  
                  xmanager,'bouncingOrnaments',wBase, /no_block, cleanup='bouncingClean'
                  
                  return & end