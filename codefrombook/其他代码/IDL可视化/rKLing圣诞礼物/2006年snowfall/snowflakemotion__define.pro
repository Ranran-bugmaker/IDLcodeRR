pro snowflakeMotion_event,event
;event handler for the snowflake object

widget_control,event.top,get_uvalue=object
;only one method to call
if obj_valid(object) then object->updatePosition

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function snowflakeMotion::getTransform

return, self.transform

end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflakeMotion::updatePosition, noTimer=noTimer

;define the z axis is the one we fall down
truckAxis = [0.0, 0.0, 1.0]
distance = 1.0 ;1 step each time. In a real application this distance would be calculated
               ;from type of dynamic model or even data
v = total(truckAxis^2)
truckAxis = temporary(truckAxis) / sqrt(v)
;get the fall axis orientation
yaw = -atan(truckAxis[0],truckAxis[2]) * !RADEG
pitch = atan(truckAxis[1], sqrt(truckAxis[2]^2 + truckAxis[0]^2)) * !RADEG
;the next steps are to determine the actual direction that we need to move the flake
self.rotQuat -> Set, pitch, yaw, 0.0
self.truckQuat -> SetQuat, self.Orientation -> GetQuat()
self.truckQuat -> PostMult, self.rotQuat -> GetQuat()
ovect = self.truckQuat -> GetDirectionVector()
;now move each distance component
self.xpos = self.xpos + (ovect[0] * distance)
self.ypos = self.ypos + (ovect[1] * distance)
self.zpos = self.zpos + (ovect[2] * distance)

;move it back up it when it gets below the surface
if self.zpos lt 10.0 then self.zpos = 50.0

;the next line rotates each snowflake according to its rotation vals
;in a real analysis application these angles would be computed from some types of
;dynamics  or data
;If you comment out the next line the flake will fall straight down.
self.rotQuat->set,self.xangle, self.yangle, self.zangle
self.Orientation -> PostMult, self.rotQuat -> GetQuat()
rotation = self.Orientation -> GetCTM()

;transform that will move the model back to the origin
translation = [[1., 0., 0., 0.], $
               [0., 1., 0., 0.], $
               [0., 0., 1., 0.], $
               [0., 0., 0., 1.]]
;apply the rotation
transform = translation # rotation

;transform to move it back to the new position
translation = [[1., 0., 0., self.xpos], $
               [0., 1., 0., self.ypos], $
               [0., 0., 1., self.zpos], $
               [0., 0., 0., 1.]]

self.transform = temporary(transform) # translation

;since we slowed the snowflake timer down by 10 we need to do the same thing here.
;otherwise we get way too much rotation and falling for each update event.
if not keyword_set(noTimer) then $
  widget_control,self.base,timer=randomu(seed,1)*10 ;set random timer

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflakeMotion::cleanup
;cleanup for the snowflake

if obj_valid(self.oContainer) then obj_destroy,self.oContainer
;want to clear any left over events and destroy the widget
widget_control, self.base, /clear_event,/destroy

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function snowflakeMotion::init, xpos=xpos, ypos=ypos, zpos=zpos

;all the keywords need to be set
if not keyword_set(xpos) then return,0
if not keyword_set(ypos) then return,0
if not keyword_set(zpos) then return,0

self.xpos = xpos
self.ypos = ypos
self.zpos = zpos

;initial rotation angles,scale by 10 to make them a little bigger
self.xangle = randomn(seed,1) * 10.0
self.yangle = randomn(seed,1) * 10.0
self.zangle = randomn(seed,1) * 10.0

;create Rick Towler's quaternions
self.rotQuat = obj_new('quaternion')
self.truckQuat = obj_new('quaternion')
self.orientation = obj_new('quaternion', pitch=0, yaw=0, roll=0)

self.oContainer = obj_new('IDL_Container')
self.oContainer->add, [self.rotQuat,self.truckQuat,self.orientation]

;update the position to get things started
self->updatePosition,/noTimer

;create an invisible base that generates timer events
self.base = widget_base(map=0)
widget_control,self.base,/realize
widget_control,self.base,set_uvalue=self

xmanager,'snowflakeMotion',self.base,/no_block
;start the timer
widget_control,self.base,timer= randomu(seed,1)*10

return,1
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflakeMotion__define
void = { snowflakeMotion, $
        rotQuat : obj_new(), $
        truckQuat : obj_new(), $
        orientation : obj_new(), $
        oContainer : obj_new(), $
        base : 0L, $
        transform : dblarr(4,4), $
        xangle : 0.0D, yangle:0.0D, zangle:0.0D, $
        xpos : 0.0D, ypos : 0.0D, zpos : 0.0D}

return & end
