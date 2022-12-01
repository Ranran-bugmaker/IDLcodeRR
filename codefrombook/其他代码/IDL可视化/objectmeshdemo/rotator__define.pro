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
;+
; NAME:
;   rotator__define
;
; PURPOSE:
;   Provide a type of IDLgrModel that can rotate itself using
;       methods very similar to an IDL Trackball object.
;
; CATEGORY:
;   IDL object examples.
;
; CREATION:
;   oRotatorModel = OBJ_NEW('rotator', Center, Radius)
;
; METHODS:
;   The methods for rotator__define are nearly the same as those of IDL's
;   Trackball and IDLgrModel classes, with the following exceptions:
;       INIT:
;           Requires Center and Radius keywords.
;
;       SETPROPERTY:
;           Keyword CENTER added.  Sets Trackball center.
;           Keyword RADIUS added.  Sets Trackball radius.
;
;       GETPROPERTY:
;           Keyword CENTER added.  Gets Trackball center.
;           Keyword RADIUS added.  Gets Trackball radius.
;
; Written by Ronn Kling
;            Kling Research and Software
;            www.rlkling.com
; Loosely based upon the IDLexRotatorModel supplied with IDL
;-


function rotator::update, event

if (event.press gt 0) then begin
  self.currentButton = event.press ;capture which button was pressed
  validTransform = self->trackball::Update(event, TRANSFORM=qmat, $
                                       mouse=event.press ) ;this registers which mouse button to watch
endif

;The next two lines work to translate the earth left and right.
validTransform = self->trackBall::Update(event, TRANSFORM=qmat,$
                    translate= ((self.currentButton eq 2b) or (self.currentButton eq 4b)))

if (validTransform NE 0) then begin
  self->GetProperty, TRANSFORM=trans
  if self.currentButton eq 1b then begin
    self->SetProperty, TRANSFORM=trans # qmat
  endif else if self.currentButton eq 2b then begin
    self->SetProperty, TRANSFORM=trans # qmat
  endif else if self.currentButton eq 4b then begin
    delta = total(qmat) - 4 ;removing the 4 just gets the x and y changes
    ;translate for the zoom effect when the projection type is 2. Otherwise,
    ;just change the viewport size.  If you want to "fly" through the data
    ;then use projection type =2
    self.viewModel->getProperty,projection=projType
    if projType eq 2 then  self->translate,0,0,delta else begin
      self.viewModel->getProperty,view=myView
      myView = myView * (1.-delta)
      self.viewModel->setProperty,view=myView
    endelse
  endif
endif

return,validTransform
end
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
pro rotator::getProperty, center=center, radius=radius, transform=transform,$
             currentButton=currentButton, _extra=extra

center = self.center
radius = self.radius
currentButton = self.currentButton
self->IDLgrModel::getProperty,transform=transform
self->IDLgrModel::getProperty,_extra=extra

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|
pro rotator::setProperty, transform=transform, center=center, radius=radius, $
             currentButton=currentButton, _extra=extra
;set the current properties for the rotator.


if n_elements(transform) gt 0 then self->IDLgrModel::setProperty,transform=transform

if n_elements(center) gt 0 then self.center=center

if n_elements(radius) gt 0 then self.radius=radius

if n_elements(currentButton) gt 0 then self.currentButton=currentButton

self->IDLgrModel::setProperty, _extra=extra

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro rotator::reset, transform=transform, currentButton=currentButton, $
                    _extra=extra

if n_elements(transform) eq 0 then transform=self.initialTransform

self->setProperty,transform=transform

;self->trackBall::reset,self.center,self.radius,_extra=extra


return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro rotator::rotate, axis, angle, _extra=extra
;calling the rotate method directly does have the side effect of
;resetting the initial transform
self->IDLgrModel::rotate, axis, angle, _extra=extra
self->getProperty,transform=transform
self.initialTransform=transform

return
end
;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro IDLexRotator::cleanup

self->trackball::cleanup
self->IDLgrModel::cleanup

return
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

function rotator::init, center=center, radius=radius, transform=transform, $
                  viewModel=viewModel, _extra=extra

if( (not keyword_set(center)) or (not keyword_set(radius)) )then begin
  r = widget_message('Center and Radius must be set!')
  return,0
endif

if not obj_valid(viewModel) then begin
  r = widget_message('Rotator must be initialized with a valid IDLgrView reference')
  return,0
endif

self.viewModel = viewModel ;necessary to have for zooming

;if no initial transform set then create diagonal one
if n_elements(transform) eq 0 then transform=identity(4)
self->setProperty,transform=transform
self.initialTransform = transform

if not self->trackball::init(center,radius,_extra=extra) then begin
  r = widget_message('Trackball object failed to initialize')
  return,0
endif

if not self->IDLgrModel::init(_extra=extra) then begin
  r = widget_message('IDLgrModel object failed to initialize')
  return,0
endif

;everything worked
return,1
end

;{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|{{:|

pro rotator__define

void = {Rotator, $
        inherits trackBall, $
        inherits IDLgrModel, $
        initialTransform : fltarr(4,4), $
        currentButton : 0b, $
        viewModel : obj_new() }

return
end