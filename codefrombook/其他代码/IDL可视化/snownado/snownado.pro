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
pro snownado_cleanup, base
  ;clean up the objects

  widget_control, base, get_uvalue=object
  if obj_valid(object) then obj_destroy, object
  
  return & end
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  pro snownado_event,event
    ;single event handler for all widget events
  
    widget_control, event.top, get_uvalue=object
    object->handleEvent, event
    
    return & end
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    pro snownado::handleEvent, event
    
      if tag_names(event, /structure_name) EQ 'WIDGET_TIMER' then begin
      
        compile_opt idl2
        
        self.count++ ;rotation counter
        pState = self.pState ;pull out pointer here to make the code a little easier to read
        seed = (*pState).seed ;we need to save the seed between events so that the snownado moves
        ;more randomly
        
        ;z position of each layer
        z_pos_ramp = 1.0 - (*pState).pos_tornado_z
        float_vel = 0.1 ;make this number bigger to make the snownado move around quicker
        
        ;calculate the velocities
        (*pState).vel_tornado_x = (*pState).vel_tornado_x + $
          ((*pState).ramp * z_pos_ramp^2 * (randomu(seed, self.numTornadoPts) - 0.5) / 4.0)
          
        (*pState).vel_tornado_y = (*pState).vel_tornado_y + $
          ((*pState).ramp * z_pos_ramp^2 * (randomu(seed, self.numTornadoPts) - 0.5) / 4.0)
          
        (*pState).vel_tornado_z = (*pState).vel_tornado_z - $
          ((*pState).ramp * float_vel * (randomu(seed, self.numTornadoPts) - 0.5))
        ;next line keeps the first point of the tornado z position less than 0.25
        if ((*pState).pos_tornado_z[0] ge 0.25) then $
          (*pState).vel_tornado_z[0] = (*pState).vel_tornado_z[0] < (*pState).vel_tornado_z[1] < (0.0)
        ;keep the top point velocity zero
        (*pState).vel_tornado_x[(*pState).max_torn_pt] = 0.0
        (*pState).vel_tornado_y[(*pState).max_torn_pt] = 0.0
        (*pState).vel_tornado_z[(*pState).max_torn_pt] = 0.0
        
        ;smooth things out so that we get a nice visual effect
        (*pState).vel_tornado_x = Smooth((*pState).vel_tornado_x,  3, /Edge_Truncate)
        (*pState).vel_tornado_y = Smooth((*pState).vel_tornado_y,  3, /Edge_Truncate)
        (*pState).vel_tornado_z = Smooth((*pState).vel_tornado_z,  3, /Edge_Truncate)
        
        ;update the position
        (*pState).pos_tornado_x = (*pState).pos_tornado_x + ((*pState).vel_tornado_x * (*pState).time_inc)
        (*pState).pos_tornado_y = (*pState).pos_tornado_y + ((*pState).vel_tornado_y * (*pState).time_inc)
        (*pState).pos_tornado_z = (*pState).pos_tornado_z + ((*pState).vel_tornado_z * (*pState).time_inc)
        
        (*pState).pos_tornado_x[0] = (*pState).pos_tornado_x[1]
        (*pState).pos_tornado_x[(*pState).max_torn_pt] = ((*pState).pos_tornado_x)[(*pState).max_torn_pt_m1]
        (*pState).pos_tornado_x = Smooth((*pState).pos_tornado_x,  3, /Edge_Truncate)
        
        (*pState).pos_tornado_y[0] = ((*pState).pos_tornado_y)[1]
        (*pState).pos_tornado_y[(*pState).max_torn_pt] = (*pState).pos_tornado_y[(*pState).max_torn_pt_m1]
        (*pState).pos_tornado_y = Smooth((*pState).pos_tornado_y,  3, /Edge_Truncate)
        
        (*pState).pos_tornado_z[0] = (*pState).pos_tornado_z[0] < ((*pState).pos_tornado_z[1] - 0.01)
        (*pState).pos_tornado_z[(*pState).max_torn_pt] = 1.0
        (*pState).pos_tornado_z = Smooth((*pState).pos_tornado_z,  3)
        ;check the boundary of the ground and if we are off then set that velocity component equal to zero
        index = Where(((*pState).pos_tornado_x le 0.0) or ((*pState).pos_tornado_x ge 1.0))
        if (index[0] ge 0l) then (*pState).vel_tornado_x[index] = 0.0
        index = Where(((*pState).pos_tornado_y le 0.0) or ((*pState).pos_tornado_y ge 1.0))
        if (index[0] ge 0l) then (*pState).vel_tornado_y[index] = 0.0
        index = Where(((*pState).pos_tornado_z LE 0.0) OR ((*pState).pos_tornado_z GE 1.0))
        if (index[0] ge 0l) then (*pState).vel_tornado_z[index] = 0.0
        (*pState).pos_tornado_x = ((*pState).pos_tornado_x > 0.0) < 1.0
        (*pState).pos_tornado_y = ((*pState).pos_tornado_y > 0.0) < 1.0
        (*pState).pos_tornado_z = ((*pState).pos_tornado_z > 0.0) < 1.0
        
        ;speed and spin rate calculation
        speed_tornado =  ((.25 + (*pState).ramp) * (*pState).time_inc * 20.0 * (Sqrt((*pState).spin_tornado) + 0.001))
        
        (*pState).spin_change = (*pState).spin_change + $
          Smooth(((randomu(seed, self.numTornadoPts) - 0.5) / 10.0), 3, /Edge_Truncate)
        (*pState).spin_change = Smooth((*pState).spin_change, 3, /Edge_Truncate)
        
        bracket = 0.125 ;bounds on how fast the spin can change
        (*pState).spin_change = ((*pState).spin_change > (-bracket)) < bracket
        (*pState).spin_tornado = (((*pState).spin_tornado + ((*pState).spin_change * (*pState).time_inc)) > 0.05) < 0.15
        (*pState).spin_tornado[(*pState).max_torn_pt] = $
          (*pState).spin_tornado[(*pState).max_torn_pt_m1] + ((0.001 * self.count) < 0.15)
        (*pState).spin_tornado = Smooth((*pState).spin_tornado,  3, /Edge_Truncate)
        (*pState).spin_tornado = Smooth((*pState).spin_tornado, (self.numTornadoPts/4), /Edge_Truncate)
        
        (*pState).twist_ang = (*pState).twist_ang + (10.0 * (*pState).time_inc * speed_tornado)
        index = Where((*pState).twist_ang GE 360.0)
        IF (index[0] GE 0L) THEN (*pState).twist_ang[index] = (*pState).twist_ang[index] - 360.0
        
        ;distance from the ground points to the snownado
        ground_dx = (*pState).pos_ground_x - (*pState).pos_tornado_x[0]
        ground_dy = (*pState).pos_ground_y - (*pState).pos_tornado_y[0]
        ground_dz = (*pState).pos_ground_z - (*pState).pos_tornado_z[0]
        ground_dist = Sqrt(ground_dx^2 + ground_dy^2)
        index = Where(ground_dist GT 0.0)
        ;angle of the points from the snownado
        (*pState).ground_ang = 0.0
        (*pState).ground_ang[index] = Atan(ground_dy[index], ground_dx[index])
        ;total distance from the snownado
        ground_xyz_dist = Sqrt(ground_dx^2 + ground_dy^2 + ground_dz^2)
        
        ;next block calculates how much the ground points move
        vect_x = (*pState).pos_tornado_x[2] - (*pState).pos_tornado_x[0]
        vect_y = (*pState).pos_tornado_y[2] - (*pState).pos_tornado_y[0]
        pt_dz = Sqrt(vect_x^2 + vect_y^2)
        IF (pt_dz GT 0.0) THEN pt_ang = Atan(vect_y, vect_x) ELSE pt_ang = 0.0
        ang_diff = pt_ang - (*pState).ground_ang
        tilt_fac = (pt_dz * (-Cos(ang_diff))) + (randomu(seed, self.numGroundPts) / 2.0)
        
        (*pState).vel_ground_z = (*pState).vel_ground_z - ((*pState).grav_time)
        
        (*pState).pos_ground_x = (((*pState).pos_ground_x + ((*pState).vel_ground_x * (*pState).time_inc)) > (-1.0)) < 2.0
        (*pState).pos_ground_y = (((*pState).pos_ground_y + ((*pState).vel_ground_y * (*pState).time_inc)) > (-1.0)) < 2.0
        (*pState).pos_ground_z = ((*pState).pos_ground_z + ((*pState).vel_ground_z * (*pState).time_inc)) > 0.0
        index = Where((*pState).pos_ground_z LE 0.0)
        IF (index[0] GE 0L) THEN BEGIN
          (*pState).vel_ground_x[index] = 0.0
          (*pState).vel_ground_y[index] = 0.0
          (*pState).vel_ground_z[index] = (*pState).time_inc * (*pState).spin_tornado[1] * 20.0 * tilt_fac[index] / $
            (ground_xyz_dist[index] + 0.25)^6
        ENDIF
        
        index = Where((*pState).pos_ground_z GT 0.0)
        IF (index[0] GE 0L) THEN BEGIN
          (*pState).vel_ground_x[index] = (*pState).vel_ground_x[index] - $
            (Sin((*pState).ground_ang[index]) * 4.0 * (*pState).spin_tornado[1] / $
            (1.5*(ground_xyz_dist[index] + 0.5))^6)
          (*pState).vel_ground_y[index] = (*pState).vel_ground_y[index] + $
            (Cos((*pState).ground_ang[index]) * 4.0 * (*pState).spin_tornado[1] / $
            (1.5*(ground_xyz_dist[index] + 0.5))^6)
        ENDIF
        
        (*pState).vel_ground_x = (*pState).vel_ground_x * 0.85
        (*pState).vel_ground_y = (*pState).vel_ground_y * 0.85
        (*pState).vel_ground_z = (*pState).vel_ground_z * 0.95
        
        ;this is where the speed happens, take all the original data and change each ball
        ;by the distance we just calculated.  Since we only have one polygon this gives
        ;very fast rendering
        data = (*pState).generic_ground_facet_pts
        for i=0,n_elements(data[0,*])-1 do begin
          data[0, i, *] = (*pState).pos_ground_x[0:self.numGroundPts-1] + data[0, i, *]
          data[1, i, *] = (*pState).pos_ground_y[0:self.numGroundPts-1] + data[1, i, *]
          data[2, i, *] = (*pState).pos_ground_z[0:self.numGroundPts-1] + data[2, i, *]
        endfor
        self.oGroundPolygon->SetProperty, data=data
        
        ;now calculate the new twist and spin of the snownado
        vect_x = (*pState).pos_tornado_x[(*pState).max_torn_pt] - (*pState).pos_tornado_x[(*pState).max_torn_pt_m2]
        vect_y = (*pState).pos_tornado_y[(*pState).max_torn_pt] - (*pState).pos_tornado_y[(*pState).max_torn_pt_m2]
        pt_dz = Sqrt(vect_x^2 + vect_y^2)
        IF (pt_dz GT 0.0) THEN pt_ang = Atan(vect_y, vect_x) ELSE pt_ang = 0.0
        
        ;for each snowflake (facet) calculate the new position and velocity
        FOR i=0, (*pState).max_torn_pt DO BEGIN
          prev_pt = (i - 1) > 0
          next_pt = (i + 1) < (*pState).max_torn_pt
          
          vect_x = (*pState).pos_tornado_x[next_pt] - (*pState).pos_tornado_x[prev_pt]
          vect_y = (*pState).pos_tornado_y[next_pt] - (*pState).pos_tornado_y[prev_pt]
          vect_z = ((*pState).pos_tornado_z[next_pt] - (*pState).pos_tornado_z[prev_pt]) > 0.001 > $
            (0.01 * Float(i) / Float((*pState).max_torn_pt))
          xy_len = Sqrt(vect_x^2 + vect_y^2)
          
          IF (xy_len GT 0.0) THEN BEGIN
            ang_z = Atan(vect_y, vect_x)
            ang_y = (!PI / 2.0) - (Atan(vect_z, xy_len))
          ENDIF $
          ELSE BEGIN
          ang_z = 0.0
          ang_y = 0.0
        ENDELSE
        
        trans = (*pState).ident4
        m4x4 = (*pState).ident4
        s_ang = Sin((*pState).twist_ang[i]-ang_z)
        c_ang = Cos((*pState).twist_ang[i]-ang_z)
        m4x4[0,0] = c_ang
        m4x4[0,1] = s_ang
        m4x4[1,0] = (-s_ang)
        m4x4[1,1] = c_ang
        trans = Temporary(trans) # m4x4
        
        m4x4 = (*pState).ident4
        s_ang = Sin(ang_y)
        c_ang = Cos(ang_y)
        m4x4[0,0] = c_ang
        m4x4[0,2] = (-s_ang)
        m4x4[2,0] = s_ang
        m4x4[2,2] = c_ang
        trans = Temporary(trans) # m4x4
        
        m4x4 = (*pState).ident4
        s_ang = Sin(ang_z)
        c_ang = Cos(ang_z)
        m4x4[0,0] = c_ang
        m4x4[0,1] = s_ang
        m4x4[1,0] = (-s_ang)
        m4x4[1,1] = c_ang
        trans = Temporary(trans) # m4x4
        
        m4x4 = (*pState).ident4
        m4x4[[3,7,11]] = [(*pState).pos_tornado_x[i], (*pState).pos_tornado_y[i], (*pState).pos_tornado_z[i]]
        ring_trans = Temporary(trans) # m4x4
        
        radius = (((*pState).spin_tornado[i]) * 1.25) > .05
        
        degree_turn = 0.0
        
        for j=0,self.numArcPts-1 do begin
          m4x4 = (*pState).ident4
          m4x4[[3,7]] = [cos(degree_turn * !dtor), sin(degree_turn * !dtor)] * radius
          trans = m4x4 # ring_trans
          
          r = !dtor * degree_turn
          m4x4_turn = (*pState).ident4
          m4x4_turn[[0,5]] =cos(r)
          m4x4_turn[1] = -sin(r)
          m4x4_turn[4] = sin(r)
          
          trans = m4x4_turn # temporary(trans)
          
          data = Vert_T3d((*pState).generic_facet_pts, Matrix=trans)
          data[2, *] = 0 > data[2, *] < 1.5
          (*self.pFacet)[i, j]->SetProperty, data=data
          
          degree_turn = degree_turn + (*pState).ang_inc
        endfor
      endfor
      
      (*pState).seed = seed
      
      self.oWindow->Draw, self.oScene
      
      widget_control, event.id, timer=0.001
      
    endif
    
    return & end
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    function snownado::init, numTornadoPts=numTornadoPts, numArcPts=numArcPts, $
        numGroundPts=numGroundPts, _extra=extra
      ;initialization routine for the snownado
      compile_opt idl2
      
      ;cd, sourcePath()
      
      if n_elements(numTornadoPts) eq 0 then numTornadoPts=25
      if n_elements(numArcPts) eq 0 then numArcPts=10
      if n_elements(numGroundPts) eq 0 then numGroundPts = 200
      
      self.numTornadoPts = numTornadoPts
      self.numGroundPts = numGroundPts
      self.numArcPts = numArcPts
      
      ;initial speed ramp in Z
      ramp = 1.0 - (findgen(numTornadoPts) / float(numTornadoPts - 1))
      self.pRamp = ptr_new(ramp)
      self.pGroundAng = ptr_new(fltarr(numGroundPts))
      
      pos_ground_x = (randomu(seed, numGroundPts) * 2.0) - 0.5
      pos_ground_y = (randomu(seed, numGroundPts) * 2.0) - 0.5
      pos_ground_z = fltarr(numGroundPts)
      
      vel_ground_x = fltarr(numGroundPts)
      vel_ground_y = fltarr(numGroundPts)
      vel_ground_z = fltarr(numGroundPts)
      
      clouds_center_x = 0.5
      clouds_center_y = 0.5
      
      pos_tornado_x = Replicate(clouds_center_x, numTornadoPts)
      pos_tornado_y = Replicate(clouds_center_y, numTornadoPts)
      pos_tornado_z = Replicate(1.0, numTornadoPts)
      
      vel_tornado_x = Fltarr(numTornadoPts)
      vel_tornado_y = Fltarr(numTornadoPts)
      vel_tornado_z = Replicate((-0.01), numTornadoPts) * (*self.pRamp)
      
      max_torn_pt = numTornadoPts - 1
      max_torn_pt_m1 = max_torn_pt - 1
      max_torn_pt_m2 = max_torn_pt - 2
      time_inc = .065
      ang_inc = 360.0 / Float(numArcPts)
      spin_tornado = Fltarr(numTornadoPts)
      spin_change = replicate(0.1, numTornadoPts)
      twist_ang =  randomu(seed, numTornadoPts) * 180.0
      ground_ang = Fltarr(numGroundPts)
      grav = .75
      grav_time = grav * time_inc
      
      generic_facet_pts = ([ $
        [0, 0, 0], $
        [0, 1, 0], $
        [0, 1, 1], $
        [0, 0, 1] $
        ] - .5) * .075
        
      ;ground points are a sphere
        
      nLongitude = 16
      nLatitude = 9
      Mesh_Obj, 4, vert, conn, Replicate(50, nLongitude+1, nLatitude), /Close
      
      ;define the colors for the ornaments, IDL will cycle among the colors
      ;first color is a rainbow effect
      vertColors = Byte(256*RandomU(seed, 3, nLongitude+1, nLatitude)) ; will reuse?
      vertColors[*, nLongitude, *] = vertColors[*, 0, *]
      FOR i=1, nLongitude DO BEGIN
        vertColors[*, i, 0] = vertColors[*, 0, 0]
        vertColors[*, i, nLatitude-1] = vertColors[*, 0, nLatitude-1]
      ENDFOR
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
      
      ;what we are doing is creating numGroundPts number of spheres
      numVertices = n_elements(vert[0,*])
      ;scale it from 1 to -1 by dividing by 50 and then make smaller by 0.05. You can
      ;change this number to make the balls bigger or smaller
      generic = (vert/50.0)*0.05
      ;turn it into a 1D array
      gg =  reform(generic,n_elements(generic))
      generic_ground_facet_pts =  gg
      ;just append each vector
      for i=1,numGroundPts-1 do generic_ground_facet_pts = [generic_ground_facet_pts, gg]
      
      ;next we turn it into a 3,m,n array that will make it easy to modify the ground points ,
      ;see the handleEvent method
      generic_ground_facet_pts = reform(generic_ground_facet_pts, 3, numVertices, numGroundPts)
      
      ;modifyConnection is a neat little function that rebuilds the polygon connectivity
      ;list with new indices
      connections = conn
      for i=1,numGroundPts-1 do begin
        connections = [connections, modifyConnection(conn, numVertices,i*(numVertices))]
      endfor
      
      ;save all the data in a pointer
      self.pState = ptr_new( {pos_ground_x: pos_ground_x, $
        pos_ground_y: pos_ground_y, $
        pos_ground_z: pos_ground_z, $
        vel_ground_x: vel_ground_x, $
        vel_ground_y: vel_ground_y, $
        vel_ground_z: vel_ground_z, $
        
        seed : seed, $
        generic_ground_facet_pts : generic_ground_facet_pts, $
        generic_facet_pts : generic_facet_pts, $
        ident4: identity(4), $
        ramp : ramp, $
        max_torn_pt: max_torn_pt, $
        max_torn_pt_m1: max_torn_pt_m1, $
        max_torn_pt_m2: max_torn_pt_m2, $
        ang_inc: ang_inc, $
        time_inc: time_inc, $
        numArcPts : numArcPts , $
        spin_tornado : spin_tornado, $
        spin_change : spin_change, $
        twist_ang : twist_ang, $
        ground_ang : ground_ang, $
        grav_time : grav_time, $
        
        pos_tornado_x: pos_tornado_x, $
        pos_tornado_y: pos_tornado_y, $
        pos_tornado_z: pos_tornado_z, $
        vel_tornado_x: vel_tornado_x, $
        vel_tornado_y: vel_tornado_y, $
        vel_tornado_z: vel_tornado_z});
        
      ;size of the window
      xdim =  500*1
      ydim =  500*1
      
      self.wBase =widget_base(title='snownado!',column=1)
      self.wDrawId = widget_draw(self.wBase, xsize=xdim, ysize=ydim, $
        graphics_level=2,  renderer=0, retain=0)
      widget_control, self.wBase, /realize
      widget_control, hourglass=1
      widget_control, self.wDrawId, get_value=oWindow
      self.oWindow=oWindow
      
      ;create the object heirarchy
      ;we are going to have two separate views in the same space so that we can
      ;light the ornaments and snownado differently
      oGroundView = obj_new('IDLgrView', viewplane_rec=[-1, -1, 2, 2],  projection=2, $
        zclip=[3, -3], color=[0, 0, 0] )
      oGroundModel = obj_new('IDLgrModel')
      oGroundView->add, oGroundModel
      
      displayText = ['Merry Christmas!','From Kling Research and Software, inc']
      oFont = obj_new('IDLgrFont','Times*Bold*italic',size=50)
      oText = obj_new('IDLgrText',string=displayText,render=0, $
        location=[[0.5,0.5],[0.5,0.2]], updir=[0,1,0], $
        color=[255,255,255],font = oFont, align=0.5,/hide)
      oGroundModel->add, oText
      
      ;directional light
      oLight1 = obj_new('IDLgrLight', loc=[2,2,5], type=2, $ ; Directional (parallel rays).
        color=[255,255,255], intensity=.5 )
      oGroundModel->add, oLight1
      ;ambient light
      oLight2 = obj_new('IDLgrLight', type=0, intensity=0.5, color=[255,255,255] )
      oGroundModel->add, oLight2
      ;rotate the model so that we can look down a little on the ground
      oGroundModel->Translate, -.5, -.5, -.5
      oGroundModel->Rotate, [0, 0, 1], 30
      oGroundModel->Rotate, [1, 0, 0], -60
      
      ;next build the facets of the snownado that we will fill with snowflake images
      oFacet = objarr(numTornadoPts, numArcPts)
      ;trick to speed in this visualization is to have a single polygon object
      ;but with a special connectivity so that it looks like we have a bunch of
      ;polygons behaving independently
      self.oGroundPolygon = obj_new('IDLgrPolygon',   Vert_Colors=vertColors, $
        shading=1, style=2 )
        
      self.oGroundPolygon->SetProperty, bottom=[0, 127, 0], color=[0, 255, 0], $
        data=generic_ground_facet_pts, polygon=connections
      oGroundModel->Add, self.oGroundPolygon
      
      ;create 12 different textureMaps each with a different image
      oTextureArray = objarr(12)
      for i=0,11 do begin
        filename = filepath(root=sourceRoot(), 'snow' + strcompress(string(i+1,format='(i2)') +'.png',/remove))
        image = read_image(filename)
        sz = size(image,/dimen)
        ;set the black background to transparent with the alpha channel
        ind = where(image[*,*] le 50)
        alpha = (image[*,*]*0B) + 255B
        alpha[ind] = 0B
        newImage = bytarr(4,sz[0],sz[1])
        newImage[0,*,*] = image[*,*]
        newImage[1,*,*] = image[*,*]
        newImage[2,*,*] = image[*,*]
        newImage[3,*,*] = alpha
        oTextureArray[i] = obj_new('IDLgrImage', newImage)
      endfor
      ;storage container for easy cleanup
      self.oContainer = obj_new('IDL_container')
      
      ;create a separate model for the snownado so that we have have different lighting
      oTornadoModel = obj_new('IDLgrModel',lighting=1)
      ;match the rotation with the ground
      oTornadoModel->Translate, -.5, -.5, -.5
      oTornadoModel->Rotate, [0, 0, 1], 30
      oTornadoModel->Rotate, [1, 0, 0], -60
      
      oTornadoView = obj_new('IDLgrView', viewplane_rec=[-1, -1, 2, 2],  projection=2, $
        zclip=[3, -3], color=[0, 0, 0],/transparent )
      oTornadoView->add, oTornadoModel
      
      ;add some lights for effect
      oTornadoLight1 = obj_new('IDLgrLight',  loc=[5,0,0], type=2, intensity=1.0, color=[255,255,255] )
      oTornadoModel->add, oTornadoLight1
      oTornadoLight2 = obj_new('IDLgrLight',  loc=[-5,0,0], type=2, intensity=1.0, color=[255,255,255] )
      oTornadoModel->add, oTornadoLight2
      
      ;create a scene object for the two views
      self.oScene = obj_new('IDLgrScene')
      self.oScene -> add, [oGroundView,oTornadoView]
      
      for i=0,n_elements(oFacet)-1 do begin
        ; get a random snowflake file
        index = strcompress(string(round(randomu(seed,1)*11),format='(i2)'),/remove)
        oFacet[i] = obj_new( 'IDLgrPolygon', texture_map=oTextureArray[index], $
          texture_coord=[[0,0], [1,0], [1,1], [0,1]], $
          bottom=[127, 127, 127], color=[255, 255, 255] )
        oTornadoModel->Add, oFacet[i]
        self.oContainer->Add, oFacet[i] ;for easy cleanu
      endfor
      
      ;we may have to tweak the font size for the text for it to fit
      ;first have to draw the scene so that we can get the right dimensions
      self.oWindow->Draw, self.oScene
      ;only problem is in x dimension
      oText->getProperty, xrange=xrange
      ;the next numbers for checking the range I just found by trial and error.
      ;as far as I know IDL does not give us a way to get the projected text coordinates
      ;after all of the rotations
      while xrange[0] lt -0.9 or xrange[1] gt 1.6 do begin
        oFont->getProperty,size=fontSize
        oFont->setProperty,size=fontSize-1
        self.oWindow->Draw, self.oScene
        oText->getProperty, xrange=xrange
      ;print, xrange
      endwhile
      ;create a pointer to hold the facets
      self.pFacet = ptr_new(oFacet)
      
      widget_control, self.wBase, set_uvalue=self
      
      self.oContainer->add,[self.oWindow, oGroundView, oGroundModel, oTextureArray, self.oGroundPolygon]
      self.oContainer->add,[oLight1, oLight2, oTornadoModel, oTornadoLight1, oTornadoLight2]
      self.oContainer->add,[self.oScene, oText, oFont]
      
      xmanager, 'snownado', self.wBase, cleanup='snownado_cleanup',/no_block
      snownado_event, {WIDGET_TIMER, id: self.wBase, top: self.wBase, handler:0L}
      
      return,1
    end
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    pro snownado::cleanup
      ;cleanup routine for the snownado object
    
      if obj_valid(self.oContainer) then obj_destroy,self.oContainer
      
      ptr_free, self.pRamp, self.pGroundAng, self.pState, self.pFacet
      
      return & end
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      pro snownado__define
      
        ;defintion routine for the shaderSnowflake object
        void = {snownado, $
          wBase : 0L, $
          wDrawId : 0L, $
          oWindow : obj_new(), $
          oScene : obj_new(), $
          oGroundPolygon : obj_new(), $
          oContainer : obj_new(), $
          
          pGroundAng : ptr_new(), $
          pRamp : ptr_new(), $
          pState : ptr_new(), $
          pFacet : ptr_new(), $
          
          numTornadoPts : 0L, $
          numGroundPts : 0L, $
          numArcPts : 0L, $
          count : 0L }
          
        return & end
        
        
        ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
        
        pro snownado, _extra=extra
          ;driver routine for the snownado visualization
        
          osnownado = obj_new('snownado', _extra=extra)
          
          return & end