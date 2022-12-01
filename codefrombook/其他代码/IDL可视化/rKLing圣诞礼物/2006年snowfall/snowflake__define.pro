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
pro snowflake_event,event
;event handler for the snowflake object

widget_control,event.top,get_uvalue=object
;only one method to call
if obj_valid(object) then object->updatePosition

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflake::updatePosition, noTimer=noTimer

if !version.release eq '6.3' then begin
  self.oIDLBridge->execute,"transform = motionObject->getTransform()"
  transform = self.oIDLbridge->getVar('transform')
  self->setProperty, transform=transform
endif else begin
  self->setProperty, transform=self.motionObject->getTransform()
endelse

;tell the parent to draw the new scene
self.parentObject->update

;setting too fast a timer here is a bad thing.  What seems to happen is that
;the timer events "stack up" and not all of them are processed.  Slowing them
;down by a factor of 10 seems to do the trick
if not keyword_set(noTimer) then $
  widget_control,self.base,timer=randomu(seed,1)*10 ;set random timer

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflake::cleanup
;cleanup for the snowflake

if obj_valid(self.oContainer) then obj_destroy,self.oContainer
self->idlGrModel::cleanup
;want to clear any left over events and destroy the widget
widget_control, self.base, /clear_event,/destroy


return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function snowflake::init, viewPlane_rect=viewPlane_rect, zclip=zclip, $
                          parentObject=parentObject, _extra=extra
;all the keywords need to be set
if not keyword_set(viewPlane_rect) then return,0
if not keyword_set(zclip) then return,0
if not keyword_set(parentObject) then return,0

self.parentObject=parentObject
;initialize the super class. THIS HAS TO BE DONE!
IF (self->IDLgrModel::init(_extra=extra) ne 1) then return, 0

;read in the snowflake images, get a random snowflake file
suffix = strcompress(string(round(randomu(seed,1)*11)+1,format='(i2)'),/remove)
filename = sourceroot() + 'snow' + suffix +'.png'
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
oImage = obj_new('IDLgrImage',newImage,blend_function=[3,4])

;put it in a random position in the viewing volume
xpos = 30 > (randomu(seed,1)*40 + 30) < 70
ypos = 30 > (randomu(seed,1)*40 + 30) < 70
zpos = 20 > randomu(seed,1)* 45

;the 5 is a scale factor to make each flake bigger
x = 5*([0,1,1,0]-.5)
z = 5*([0,0,1,1] -.5)
y = [0,0,0,0]
;create a texture mapped polygon centered at the origin and then we will
;transform the model to move it.
oSurface = obj_new('IDLgrPolygon',x,y,z,color=[255,255,255],texture_map=oImage, $
                texture_coord = [[0,0], [1,0], [1,1], [0,1]], /texture_interp)
self->add, oSurface

;the IDL bridge only exists after 6.3
if !version.release eq '6.3' then begin
  self.oIDLBridge = obj_new('IDL_IDLBridge')
  ;you have to set each variable to be passed to the object, BEFORE you create the object
  self.oIDLBridge->setVar,'xpos',xpos
  self.oIDLBridge->setVar,'ypos',ypos
  self.oIDLBridge->setVar,'zpos',zpos
  ;create an object that calculates how the snowflake falls.
  self.oIDLBridge->execute,"motionObject = obj_new('snowflakeMotion', xpos=xpos, ypos=ypos, zpos=zpos)"
endif else begin
  self.motionObject = obj_new('snowflakeMotion', xpos=xpos, ypos=ypos, zpos=zpos)
endelse

;now update the position
self->updatePosition, /noTimer

;have to add the image to a container object to destroy.  Just having it
;as a texture map to the surface object it is not destroyed.
self.oContainer = obj_new('IDL_Container')
if !version.release eq '6.3' then begin
  self.oContainer->add, [oImage, self.oIDLBridge]
endif else begin
  self.oContainer->add, [oImage,self.motionObject, self.oIDLBridge]
endelse

;create an invisible base that generates timer events
self.base = widget_base(map=0)
widget_control,self.base,/realize
widget_control,self.base,set_uvalue=self

xmanager,'snowflake',self.base,/no_block

widget_control,self.base,timer= 0.1

return,1
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro snowflake__define

void = {snowflake,$
        inherits IDLgrmodel, $
        parentObject : obj_new(), $
        motionObject : obj_new(), $
        oIDLBridge : obj_new(), $
        oContainer : obj_new(), $
        base : 0L}

return & end
