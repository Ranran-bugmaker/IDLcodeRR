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
pro projectile::tumble, inTheAir=inTheAir
  ;tumbles each projectile

  ;set the flag assuming that it is still in the air
  inTheAir = 1
  ;different time steps and gravitational force will change the path
  ;make this number smaller for faster CPUs
  tstep = 0.5
  gravity = 9.82/1000.
  
  ;to get rotation about the projectile center we always have to translate
  ;it back to the origin before rotation.
  self->translate,-self.xCenter, -self.yCenter, -self.zCenter
  ;scaling the rotation by the time step gives a smooth effect
  self->rotate,[1,1,1],self.rotationRate * tstep
  self->translate,self.xCenter, self.yCenter, self.zCenter
  
  ;The up direction is determined by the inital orientation of the projectile.
  ;This direction does not change even if the projectile is rotated!
  case self.upDir of
    '+X' : begin
      self.upVelocity = self.upVelocity - gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.xVelocity = self.upVelocity
      if self.upPos le 0.0 then inTheAir=0 ;hit the surface
    end
    '-X' : begin
      self.upVelocity = self.upVelocity + gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.xVelocity = self.upVelocity
      if self.upPos ge 0.0 then inTheAir=0
    end
    '+Y' : begin
      self.upVelocity = self.upVelocity - gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.yVelocity = self.upVelocity
      if self.upPos le 0.0 then inTheAir=0
    end
    '-Y' : begin
      self.upVelocity = self.upVelocity + gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.yVelocity = self.upVelocity
      if self.upPos ge 0.0 then inTheAir=0
    end
    '+Z' : begin
      self.upVelocity = self.upVelocity - gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.zVelocity = self.upVelocity
      if self.upPos le 0.0 then inTheAir=0
    end
    '-Z' : begin
      self.upVelocity = self.upVelocity + gravity * tstep
      self.upPos = self.upPos + self.upVelocity * tstep
      self.zVelocity = self.upVelocity
      if self.upPos ge 0.0 then inTheAir=0
    end
  endcase
  ;now translate them to the new position
  self->translate,self.xVelocity * tstep,self.yVelocity*tstep,self.zVelocity*tstep
  ;calculate the new center positions for the next rotation.
  self.xCenter = self.xCenter + self.xVelocity * tstep
  self.zCenter = self.zCenter + self.zVelocity * tstep
  self.yCenter = self.yCenter + self.yVelocity * tstep
  ;keep track of the total rotation angle for later reorientation
  self.totalRotation = self.totalRotation + self.rotationRate * tstep
  
  return & end
  
  ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
  
  pro projectile::getProperty, xCenter=xCenter, yCenter=yCenter, $
      zCenter=zCenter, totalRotation=totalRotation, $
      rotationRate=rotationRate
      
    xCenter = self.xCenter
    yCenter = self.yCenter
    zCenter = self.zCenter
    totalRotation = self.totalRotation
    rotationRate = self.rotationRate
    
    return & end
    
    ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
    
    pro projectile::setProperty,xVelocity=xVelocity, yVelocity=yVelocity, $
        zVelocity=zVelocity, rotationRate=rotationRate, $
        _extra=extra
        
      if n_elements(extra) ne 0 then self->IDLgrModel::setProperty, _extra=extra
      
      velocityChanged = 0
      if n_elements(xVelocity) then begin
        self.xVelocity = xVelocity
        velocityChanged = 1
      endif
      if n_elements(yVelocity) then begin
        self.yVelocity = yVelocity
        velocityChanged = 1
      endif
      if n_elements(zVelocity) then begin
        self.zVelocity = zVelocity
        velocityChanged = 1
      endif
      if n_elements(rotationRate) then self.rotationRate = rotationRate
      ;The up direction is determined by the inital orientation of the projectile.
      ;This direction does not change even if the projectile is rotated!
      ;up velocity always has to be in the direction of up, hence the abs and -1 factors
      if velocityChanged then begin
        case self.upDir of
          '+X' : self.upVelocity = abs(self.xVelocity)
          '-X' : self.upVelocity = -1 * abs(self.xVelocity)
          '+Y' : self.upVelocity = abs(self.yVelocity)
          '-Y' : self.upVelocity = -1 * abs(self.yVelocity)
          '+Z' : self.upVelocity = abs(self.zVelocity)
          '-Z' : self.upVelocity = -1 * abs(self.zVelocity)
        endcase
      endif
      
      return & end
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      function projectile::init, xCenter=xCenter, yCenter=yCenter, $
          zCenter=zCenter, upDir=upDir, $
          _extra=extra
          
        ;initialization routine for the projectile object
          
        ;initialize the super class
        if (self->IDLgrModel::init(_extra=extra) ne 1) then return, 0
        
        self.xCenter = keyword_set(xCenter) ? xCenter : 0
        self.yCenter = keyword_set(yCenter) ? yCenter : 0
        self.zCenter = keyword_set(zCenter) ? zCenter : 0
        
        self.upDir = strupcase(upDir)
        case self.upDir of
          '+X' : self.upPos = self.xCenter
          '-X' : self.upPos = self.xCenter
          '+Y' : self.upPos = self.yCenter
          '-Y' : self.upPos = self.yCenter
          '+Z' : self.upPos = self.zCenter
          '-Z' : self.upPos = self.zCenter
        endcase
        
        self.upPos = self.upPos
        
        return,1
      end
      
      ;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
      
      pro projectile__define
        ;projectile object that calculates its own trajectory
        void = {projectile, $
          inherits IDLgrModel, $
          upDir : '', $
          xCenter : 0.0, $
          yCenter : 0.0, $
          zCenter : 0.0, $
          xVelocity : 0.0, $
          yVelocity : 0.0, $
          zVelocity : 0.0, $
          upPos : 0.0, $
          upVelocity : 0.0, $
          rotationRate : 0.0D, $
          totalRotation : 0.0D }
          
        return & end
