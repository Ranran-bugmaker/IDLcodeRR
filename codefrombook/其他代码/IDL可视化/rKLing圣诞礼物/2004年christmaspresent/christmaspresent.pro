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
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent_event,event
;event handler for the top base
widget_control,event.top, get_uvalue=object
eventType = tag_names(event, /struct) ;find out what it is
case eventType of
 'WIDGET_TIMER': object->explode
else:
end

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresentCleanup, base
;called no matter how the widget dies

widget_control, base, get_uvalue=object
obj_destroy, object

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresentExit, event
;destroy the top level base
widget_control, event.top,/destroy

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent::moveLetter,object,position
;moves the letter to the final position

;different step sizes make it go faster or slower
stepsize = 0.5
xPos = position * 0.3  -2.0
yPos = 4.0
zPos = 2.0
;get the current projectile position
object->getProperty,xCenter=xCenter, yCenter=yCenter, zCenter=zCenter, $
                    totalRotation=totalRotation, rotationRate=rotationRate
;calculate the distance to move each letter to the final position
xDiff = xCenter - xPos
yDiff = yCenter - yPos
zDiff = zCenter - zPos
maxDiff = max(abs([xDiff,yDiff,zDiff]))
numSteps = float(ceil(maxDiff/stepsize))
xStep = xDiff/numSteps
yStep = yDiff/numSteps
zStep = zDiff/numSteps
for i=0,numSteps-1 do begin
  object->translate,-xStep,-yStep,-zStep
  self.oWindow->Draw, self.oView
  xCenter = xCenter - xstep
  yCenter = yCenter - ystep
  zCenter = zCenter - zstep
endfor
;this next rotation gets the letters pretty close to being oriented correctly
;However, it is not perfect. My guess is that it is because rotations are not
;commutative but if someone can fix it please let me know
object->translate,-xCenter,-yCenter,-zCenter
object->rotate,[1,1,1],-(totalRotation mod 360)
object->translate,xCenter,yCenter,zCenter

self.oWindow->Draw, self.oView

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent::explode
;"flies" the pieces as they explode

;give them some initial velocity
projectiles = self.oContainer->get(/all,isa='projectile',count=count)
;lowering the scale spreads them out further
scale = 20.0
for i=0,count-1 do begin
  projectiles[i]->setProperty,xVelocity=randomn(seed,1)/scale, yVelocity=randomn(seed,1)/scale, $
                              zVelocity=randomn(seed,1)/scale, rotationRate=randomn(seed,1)*10., $
                              hide=0
endfor

;make them explode
stillFlying = 1
widget_control, /hourglass
;loop until every piece is on the ground
while stillFlying do begin
  stillFlying = 0
  ;count = 3
  for i=0,count-1 do begin
    projectiles[i]->tumble, inTheAir=inTheAir
    if inTheAir then stillFlying=1
  endfor
  self.oWindow->Draw, self.oView
endwhile

;now bring the letters back
for position=0,n_elements(*self.message)-1 do begin
  for j=0,count-1 do begin
    object = projectiles[j]->get(/all)
    if obj_class(object[0]) eq 'IDLGRTEXT' then begin
      object[0]->getProperty,string=textVal
      if textVal eq (*self.message)[position] then begin
        self->moveLetter,projectiles[j],position
        ;save the rest of the letters but not this one
        indices = where( projectiles ne projectiles[j],count)
        if count gt 0 then projectiles = projectiles[indices]
        break ;jump out of loop
      endif
    endif
  endfor
endfor

;now undo the initial rotations in the reverse order to see the letters
for i=0,14 do begin
  self.oBottomPanelModel->rotate,[1,0,0],-1
  self.oWindow->Draw, self.oView
endfor

for i=0,44 do begin
  self.oBottomPanelModel->rotate,[0,1,0],-1
  self.oWindow->Draw, self.oView
endfor

for i=0,89 do begin
  self.oBottomPanelModel->rotate,[1,0,0],1
  self.oWindow->Draw, self.oView
endfor

;this next is a kludge to get the letters to look right. comment it out and you
;will see how the letters are not rotated back correctly
projectiles = self.oContainer->get(/all,isa='projectile',count=count)
for j=0,count-1 do begin
  object = projectiles[j]->get(/all)
  if obj_class(object[0]) eq 'IDLGRTEXT' then object[0]->setProperty,/onGlass
endfor

displayText = ['From Kling Research and Software, inc']
oFont = obj_new('IDLgrFont','Times*Bold*italic',size=20)
oText = obj_new('IDLgrText',string=displayText,location=[0.5,0,-2.5], $
                color=[255,0,0],font = oFont, align=0.5,/onglass)
self.oBottomPanelModel->add, oText
self.oContainer->add, oFont ;if you don't do this you will get a memory leak

self.oWindow->Draw, self.oView

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent::wrapPresent
;moves each polygon to make it look like the present is being wrapped

step = 10
for i=0,90-step,step do begin

  self.oSide1->translate,-1,0,0
  self.oSide1->rotate,[0,0,1],step
  self.oSide1->translate,1,0,0

  self.oSide2->translate,0,0,-1
  self.oSide2->rotate,[1,0,0],-step
  self.oSide2->translate,0,0,1

  self.oSide3->rotate,[0,0,1],-step

  self.oSide4->rotate,[1,0,0],step

  self.oWindow->Draw, self.oView
  wait,0.1
endfor

for i=0,90-step,step do begin

  self.oTop1->translate,-2,0,0
  self.oTop1->rotate,[0,0,1],step
  self.oTop1->translate,2,0,0

  self.oTop2->translate,0,0,-2
  self.oTop2->rotate,[1,0,0],-step
  self.oTop2->translate,0,0,2

  self.oTop3->translate,1,0,0
  self.oTop3->rotate,[0,0,1],-step
  self.oTop3->translate,-1,0,0

  self.oTop4->translate,0,0,1
  self.oTop4->rotate,[1,0,0],step
  self.oTop4->translate,0,0,-1

  self.oWindow->Draw, self.oView
  wait,0.1
endfor

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function christmasPresent::init, _extra=extra

;initialization routine for the christmasPresent

;initialize the super class
if (self->IDLgrModel::init(_extra=extra) ne 1) then return, 0

;Get the screen size.
device, get_screen_size = screenSize
xdim = screenSize[0]*.50 ;about 50 percent of the screen size
ydim=xdim  ;keep isotropic

self.base =widget_base(title='Christmas Present',column=1,mbar=barBase)
;pull down menu next
fileId = widget_button(barBase, value='File', /menu)
void = widget_button(fileId, /separator, value='Exit', $
           event_pro='christmasPresentExit')
self.drawId = widget_draw(self.base, xsize=xdim, ysize=ydim, $
                     graphics_level=2, retain=2)

widget_control, self.base, /realize
widget_control, hourglass=1
widget_control, self.drawId, get_value=oWindow
self.oWindow=oWindow

;create view object.
self.oView = obj_new('IDLgrView', projection=1, eye=6.1, $
        color=[0,0,0], view=[-2.5,-2.5,6,6], zclip=[6,-6])
;create the model heirarchy

;bottom flap of paper
self.oBottomPanelModel = obj_new('IDLgrModel')
;each side has a model, these can rotate independently of the bottom
self.oSide1 = obj_new('IDLgrModel')
self.oSide2 = obj_new('IDLgrModel')
self.oSide3 = obj_new('IDLgrModel')
self.oSide4 = obj_new('IDLgrModel')

;add them to the bottom flap
self.oBottomPanelModel->add,self.oSide1
self.oBottomPanelModel->add,self.oSide2
self.oBottomPanelModel->add,self.oSide3
self.oBottomPanelModel->add,self.oSide4

self.message = ptr_new(['M','E','R','R','Y',' ','C','H','R','I','S','T','M','A','S','!'])
oLetters = objarr(n_elements(*self.message))
color = [[255,0,0],[0,255,0]]
oFont = obj_new('IDLgrFont','helvetica',size=20)
for i=0,n_elements(*self.message)-1 do begin
  oLetters[i] = obj_new('projectile',xCenter=0.5, yCenter=0, zCenter=2.0,upDir='+z', $
                         hide=1)
  oText = obj_new('IDLgrText',(*self.message)[i],color=color[*,i mod 2],location=[0.5,0,2.0], $
                              font=oFont)
  oLetters[i]->add, oText
endfor

;each top flap inherits from a model so that they can rotate independently, also
;the projectile object needs an initial center position and which way is up. These match up with the tops
;below. See comments in the projectile code as to why.
self.oTop1 = obj_new('projectile',xCenter=2.25, yCenter=0, zCenter=0.5,upDir='+x')
self.oTop2 = obj_new('projectile',xCenter=0.5, yCenter=0, zCenter=2.25,upDir='+z')
self.oTop3 = obj_new('projectile',xCenter=-1.25, yCenter=0, zCenter=0.5,upDir='-x')
self.oTop4 = obj_new('projectile',xCenter=0.5, yCenter=0, zCenter=-1.25,upDir='-z')
;these get added to the side panels
self.oSide1->add, self.oTop1
self.oSide2->add, self.oTop2
self.oSide3->add, self.oTop3
self.oSide4->add, self.oTop4

self.oSide2->add, oLetters

;neat little trick to save some space and make changes easier
if float(!version.release) ge 6.1 then begin
  ;make it look like gold
  properties = { shading:1, style:2, ambient:[84,57,7], $
                 diffuse:[199,145,29], specular:[253,240,206], $
                 emmision:[0,0,0], shininess:27.8974}
endif else begin
  ;just a reddish package
  properties = {color : [255,25,25], style:2, shading:1 }
endelse

;now build the sides
oBottomPoly = obj_new('IDLgrPolygon',[0,1,1,0],[0,0,0,0],[0,0,1,1],_extra=properties)

;side 1
oSide1 = obj_new('IDLgrPolygon',[1,2,2,1],[0,0,0,0],[0,0,1,1],_extra=properties)
oTop1 = obj_new('IDLgrPolygon',[2,2.5,2],[0,0,0],[0,0.5,1],_extra=properties)
self.oSide1->add, oSide1
self.oTop1->add, oTop1


;side 2
oSide2 = obj_new('IDLgrPolygon',[0,1,1,0],[0,0,0,0],[1,1,2,2],_extra=properties)
oTop2 = obj_new('IDLgrPolygon',[0, 0.5, 1],[0,0,0],[2,2.5,2],_extra=properties)
self.oSide2->add, oSide2
self.oTop2->add, oTop2

;side 3
oSide3 = obj_new('IDLgrPolygon',[-1,0,0,-1],[0,0,0,0],[0,0,1,1],_extra=properties)
oTop3 = obj_new('IDLgrPolygon',[-1,-1.5,-1],[0,0,0],[1,0.5,0],_extra=properties)
self.oSide3->add, oSide3
self.oTop3->add, oTop3

;side 4
oSide4 = obj_new('IDLgrPolygon',[0,1,1,0],[0,0,0,0],[0,0,-1,-1],_extra=properties)
oTop4 = obj_new('IDLgrPolygon',[0, 0.5, 1],[0,0,0],[-1,-1.5,-1],_extra=properties)
self.oSide4->add, oSide4
self.oTop4->add, oTop4

self.oBottomPanelModel->add, oBottomPoly

;rotate the top model a bit
self.oBottomPanelModel->rotate,[0,1,0],45
self.oBottomPanelModel->rotate,[1,0,0],15

;add the models to the view
self.oView -> add, self.oBottomPanelModel

;light objects
oAmbLight = OBJ_NEW('IDLgrLight', type=0, color=[50,50,50])
oPosLight1 = OBJ_NEW('IDLgrLight', type=1, $
                      color=[255,255,255], location=[200,99,200])
oPosLight2 = OBJ_NEW('IDLgrLight', type=1, $
                      color=[255,255,255], location=[2,99,200])
oLightModel=obj_new('IDLgrModel')
oLightModel->Add, [oAmbLight, oPosLight1, oPosLight2]
self.oView->add, oLightModel

self.oWindow->Draw, self.oView

;close the box
self->wrapPresent

;store objects for cleanup
self.oContainer = obj_new('IDL_Container')
self.oContainer-> add, oLightModel
;only have to store the top model and the rest will be destroyed automatically by
;IDL, BUT I want to add the projectiles also so that I can retrieve them in the
;explode method
self.oContainer-> add, self.oBottomPanelModel
self.oContainer-> add, [self.oTop1, self.oTop2, self.oTop3, self.oTop4]
self.oContainer-> add, [oLetters, oFont]
;store the object reference in the base
widget_control, self.base,set_uvalue=self

widget_control,self.base,timer=1.0 ;timer for the explosion

xmanager,'christmasPresent',self.base,/no_block,cleanup='christmasPresentCleanup'
return,1
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent::cleanup
;cleanup routine for the christmasPresent object

self->idlGrModel::cleanup
if obj_valid(self.oContainer) then obj_destroy,self.oContainer
if obj_valid(self.oWindow) then obj_destroy,self.oWindow
if obj_valid(self.oView) then obj_destroy,self.oView

if ptr_valid(self.message) then ptr_free, self.message

return & end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro christmasPresent__define

;defintion routine for the christmasPresent object
void = {christmasPresent, $
        inherits IDLgrmodel, $
        base : 0L, $
        drawId : 0L, $
        oWindow : obj_new(), $
        oView : obj_new(), $
        oBottomPanelModel : obj_new(), $
        oSide1 : obj_new(), $
        oSide2 : obj_new(), $
        oSide3 : obj_new(), $
        oSide4 : obj_new(), $
        oTop1 : obj_new(), $
        oTop2 : obj_new(), $
        oTop3 : obj_new(), $
        oTop4 : obj_new(), $
        oContainer : obj_new(), $
        message : ptr_new() }

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|


pro christmasPresent, _extra=extra
;driver routine for the christmas present

oPresent = obj_new('christmasPresent',_extra=extra)

return & end
