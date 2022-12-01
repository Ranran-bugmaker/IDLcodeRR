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
;	mesh__define
;
; PURPOSE:
;	This object serves as a graphical representation of a user defined mesh.
;	Subclasses from the IDLgrModel class.
;
; CATEGORY:
;	Object graphics.
;
; CALLING SEQUENCE:
;	To initially create:
;	       	omesh = OBJ_NEW('mesh',meshtype, keywords....)
;
;   Valid mesh types can be specified as either a string name or integer:
;   	 triangulated or 0
;		 rectangular or 1
;		 polar or 2
;		 cylindrical or 3
;		 spherical or 4
;		 extrusion or 5
;		 revolution or 6
;		 ruled or 7
;
;	To retrieve a property value:
;		omesh->GetProperty, keywords
;
;	To set a property value:
;		omesh->SetProperty, keywords
;
;	To print to the standard output stream the current properties of
;	the mesh:
;		omesh->Print
;
;	To destroy:
;		OBJ_DESTROY, omesh
;
; Input PARAMETERS:
;   mesh::INIT:
;	<Note that keywords accepted by IDLgrModel::Init and/or
;	 IDLgrPolygon::Init are also accepted here.>
;  SEE RKMESH_OBJ FOR A DETAILED DESCRIPTION OF THE KEYWORDS ACCEPTED HERE
;   array1 and array2 are input positional parameters.
;   The keywords p1,p2,p3,p4,p5 control specific attributes.
;
;	POS:	A three-element vector, [x,y,z], specifying the position
;               of the center of the mesh, measured in data units .
;		Defaults to [0,0,0].
;	TEX_COORDS: Set this keyword to a nonzero value if texture map
;               coordinates are to be generated for the mesh.
;
;   endcap : Set this keyword for a cylindrical mesh object so that the ends will
;					be covered.
;
;   mesh::GETPROPERTY:
;	POS:	Set this keyword to a named variable that upon return will
;		contain a three-element vector, [x,y,z], specifying the
;		position of the center of the mesh, measured in data units .
;
;   pobj : use this keyword to retrieve the polygon objects id.
;
;   mesh::SETPROPERTY:
;	<Note that keywords accepted by IDLgrModel::SetProperty and/or
;	 IDLgrPolygon::SetProperty are also accepted here.>
;
;	All of the keywords in init may also be set here.
;
;   mesh::reset
;
;   Deletes all the current mesh data.  Useful for when the object style needs
;   to be changed, but the user wants to keep the object reference.
;
; MODIFICATION HISTORY:
; 	Written by:	RLK, June 1999
;				Ronn Kling Consulting
;				www.rlkling.com
;		based upon orb__define provided by RSI
;-

;----------------------------------------------------------------------------
function checkMeshType,meshtype
  ;check the passed in value and returns a lowercase string

  ;first check to see if a number or string was passed in.
  validMesh = ['triangulated',$
    'rectangular', $
    'polar', $
    'cylindrical', $
    'spherical', $
    'extrusion', $
    'revolution', $
    'ruled']
    
  type = datatype(meshType)
  if type eq 'integer' then begin
    if( (meshType lt 0) or (meshType gt 7))then return,'' ;bad type
    return,validMesh[meshType]
  endif else if type eq 'string' then begin
    meshType = strlowcase(meshType)
    index = where(meshType eq validMesh,count)
    if count eq 0 then return,'' else return,meshType
  endif else return,''
end

;----------------------------------------------------------------------------
function mesh::Init, meshType, array1, array2, POS=pos, TEX_COORDS=tex_coords, $
    p1=p1, p2=p2, p3=p3, p4=p4, p5=p5, endcaps=endcaps, _EXTRA=e
  ; Purpose:
  ;  Initializes the mesh object.
  ;
  ;  This function returns a 1 if initialization is successful, or 0 otherwise.
  ;
  IF (self->IDLgrModel::Init(_EXTRA=e) NE 1) THEN RETURN, 0
  
  self.pos = [0.0,0.0,0.0]
  IF (N_ELEMENTS(pos) EQ 3) THEN self.pos = pos
  
  IF (N_ELEMENTS(tex_coords) EQ 1) THEN self.texture = tex_coords
  
  ; Initialize the polygon object that will be used to represent
  ; the mesh.
  self.oPoly = OBJ_NEW('IDLgrPolygon', SHADING=1,  _EXTRA=e)
  self->Add,self.oPoly
  
  meshType = checkMeshType(meshType) ;check on mesh type and return consistent string
  if meshType eq '' then begin
    r = widget_message('Unknown mesh type',/error)
    return,0
  endif
  ; Build the polygon vertices and connectivity based on property settings.
  result = self->BuildPoly( meshType, array1,array2,p1=p1, p2=p2, p3=p3, p4=p4, p5=p5,$
    _extra=extra)
  if result eq 0 then begin
    r = widget_message('Mesh__define failed to build mesh',/error)
    return,0
  endif
  ;now load up the polygon values
  self.meshType = meshType
  self.array1 = ptr_new(array1)
  if n_elements(array2) ne 0 then self.array2=ptr_new(array2)
  if keyword_set(p1) then self.p1 = ptr_new(p1)
  if keyword_set(p2) then self.p2 = ptr_new(p2)
  if keyword_set(p3) then self.p3 = ptr_new(p3)
  if keyword_set(p4) then self.p4 = ptr_new(p4)
  if keyword_set(p5) then self.p5 = ptr_new(p5)
  return, 1
end

;----------------------------------------------------------------------------
; mesh::CLEANUP
;
; Purpose:
;  Cleans up all memory associated with the mesh.
;
pro mesh::Cleanup
  ; Cleanup the polygon object used to represent the mesh.
  OBJ_DESTROY, self.oPoly
  ; Cleanup the superclass.
  self->IDLgrModel::Cleanup
  if ptr_valid(self.array1) then ptr_free,self.array1
  if ptr_valid(self.array2) then ptr_free,self.array2
  if ptr_valid(self.p1) then ptr_free,self.p1
  if ptr_valid(self.p2) then ptr_free,self.p2
  if ptr_valid(self.p3) then ptr_free,self.p3
  if ptr_valid(self.p4) then ptr_free,self.p4
  if ptr_valid(self.p5) then ptr_free,self.p5
  
  return
end

;----------------------------------------------------------------------------

pro mesh::resetMesh
  ;Deletes all the current mesh data.  Useful for when the object style needs
  ;to be changed, but the user wants to keep the object reference.

  if ptr_valid(self.array1) then ptr_free,self.array1
  if ptr_valid(self.array2) then ptr_free,self.array2
  if ptr_valid(self.p1) then ptr_free,self.p1
  if ptr_valid(self.p2) then ptr_free,self.p2
  if ptr_valid(self.p3) then ptr_free,self.p3
  if ptr_valid(self.p4) then ptr_free,self.p4
  if ptr_valid(self.p5) then ptr_free,self.p5
  
  return
end
;----------------------------------------------------------------------------
; mesh::SETPROPERTY
;
; Purpose:
;  Sets the value of properties associated with the mesh object.
;
pro mesh::SetProperty,  meshType=meshType, array1=array1, array2=array2, p1=p1, $
    p2=p2, p3=p3, p4=p4, p5=p5, endcaps=endcaps, POS=pos,  _EXTRA=e
    
  ; Pass along extraneous keywords to the superclass and/or to the
  ; polygon used to represent the mesh.
  self->IDLgrModel::SetProperty, _EXTRA=e
  self.oPoly->SetProperty, _EXTRA=e
  
  IF (N_ELEMENTS(pos) EQ 3) THEN self.pos = pos
  ;flag on whether to call buildPoly
  flag = 0
  if keyword_set(meshType) then flag=1
  if keyword_set(array1) then flag=1
  if keyword_set(array2) then flag=1
  if keyword_set(p1) then flag=1
  if keyword_set(p2) then flag=1
  if keyword_set(p3) then flag=1
  if keyword_set(p4) then flag=1
  if keyword_set(p5) then flag=1
  
  if flag eq 1 then begin
    if not keyword_set(meshType) then meshType = self.meshType
    if not keyword_set(array1) then array1 = *self.array1
    if (not keyword_set(array2)) and (ptr_valid(self.array2)) then array2 = *self.array2
    if (not keyword_set(p1)) and (ptr_valid(self.p1)) then p1 = *self.p1
    if (not keyword_set(p2)) and (ptr_valid(self.p2)) then p2 = *self.p2
    if (not keyword_set(p3)) and (ptr_valid(self.p3)) then p3 = *self.p3
    if (not keyword_set(p4)) and (ptr_valid(self.p4)) then p4 = *self.p4
    if (not keyword_set(p5)) and (ptr_valid(self.p5)) then p5 = *self.p5
    
    ; Rebuild the polygon according to keyword settings.
    result = self->BuildPoly( meshType, array1,array2,p1=p1, p2=p2, p3=p3, p4=p4, p5=p5,endcaps=endcaps, $
      _extra=extra)
    if result eq 0 then  r = widget_message('Mesh__define failed to build mesh',/error)
    
    ;now reload the polygon values (pointers are already defined here)
    self.meshType = meshType ;always has to be present
    if ptr_valid(self.array1) then *self.array1 = array1  else self.array1=ptr_new(array1)
    ;pretty cool way to nest if statements below
    if keyword_set(array2) then if (ptr_valid(self.array2)) then *self.array2 = array2 else self.array2=ptr_new(array2)
    if keyword_set(p1) then if (ptr_valid(self.p1)) then *self.p1 = p1 else self.p1=ptr_new(p1)
    if keyword_set(p2) then if (ptr_valid(self.p2)) then *self.p2 = p2 else self.p2=ptr_new(p2)
    if keyword_set(p3) then if (ptr_valid(self.p3)) then *self.p3 = p3 else self.p3=ptr_new(p3)
    if keyword_set(p4) then if (ptr_valid(self.p4)) then *self.p4 = p4 else self.p4=ptr_new(p4)
    if keyword_set(p5) then if (ptr_valid(self.p5)) then *self.p5 = p5 else self.p5=ptr_new(p5)
    
  endif
  return
end


;----------------------------------------------------------------------------

pro mesh::GetProperty, POS=pos, POBJ=pobj, _REF_EXTRA=re
  ;
  ; Purpose:
  ;  Retrieves the value of properties associated with the mesh object.
  ;
  self->IDLgrModel::GetProperty, _EXTRA=re
  self.oPoly->GetProperty, _EXTRA=re
  pos = self.pos
  pobj = self.oPoly
  return
end

;----------------------------------------------------------------------------

pro mesh::print
  ;print out the objects position only.
  PRINT, self.pos
  return
end

;----------------------------------------------------------------------------

function mesh::BuildPoly, meshType, array1,array2,p1=p1, p2=p2, p3=p3, p4=p4, p5=p5, $
    endcaps=endcaps, _extra=extra
  ; Purpose:
  ;  Sets the vertex and connectivity arrays for the polygon used to
  ;  represent the mesh.
  ;
  ; Build the mesh.
    
  tex_coords = self.texture ;initialize the keyword
  
  case strlowcase(meshType) of
    'triangulated':begin
    sz = size(array1)
    if sz[0] ne 2 then return,0
    if sz[1] ne 3 then return,0
    rkMesh_obj, 0, verts, conn, array1, $
      tex_coords = tex_coords, _extra=extra
  end
  
  'rectangular' :begin
  sz = size(array1)
  if sz[0] ne 2 then return,0
  rkMesh_obj, 1, verts, conn, array1,p1=p1, p2=p2, $
    tex_coords = tex_coords, _extra=extra
end

'polar' : begin
  sz = size(array1)
  if sz[0] ne 2 then return,0
  rkMesh_obj, 2, verts, conn, array1,p1=p1, p2=p2, p3=p3, p4=p4, $
    tex_coords = tex_coords, _extra=extra
end

'cylindrical':begin
sz = size(array1)
if sz[0] ne 2 then return,0
rkMesh_obj, 3, verts, conn, array1,p1=p1, p2=p2, p3=p3, p4=p4, $
  tex_coords = tex_coords,endcaps=endcaps, _extra=extra
end

'spherical' : begin
  sz = size(array1)
  if sz[0] ne 2 then return,0
  rkMesh_obj, 4, verts, conn, array1,p1=p1, p2=p2, p3=p3, p4=p4, $
    tex_coords = tex_coords, _extra=extra
end

'extrusion':begin
sz = size(array1)
if sz[0] ne 2 then return,0
if sz[1] ne 3 then return,0
rkMesh_obj, 5, verts, conn, array1,p1=p1, p2=p2, $
  tex_coords = tex_coords, _extra=extra
end

'revolution':begin
sz = size(array1)
if sz[0] ne 2 then return,0
if sz[1] ne 3 then return,0
rkMesh_obj, 6, verts, conn, array1,p1=p1, p2=p2, p3=p3, p4=p4, $
  tex_coords = tex_coords, _extra=extra
end
'ruled':begin
sz = size(array1)
if sz[0] ne 2 then return,0
if sz[1] ne 3 then return,0
sz = size(array2)
if sz[0] ne 2 then return,0
if sz[1] ne 3 then return,0
rkMesh_obj, 7, verts, conn, array1, array2, p1=p1, $
  tex_coords = tex_coords, _extra=extra
end
else:
endcase

verts[0,*] = verts[0,*] + self.pos[0]
verts[1,*] = verts[1,*] + self.pos[1]
verts[2,*] = verts[2,*] + self.pos[2]

self.oPoly->SetProperty, DATA=verts, POLYGONS=conn

IF (self.texture NE 0) THEN self.oPoly->SetProperty, TEXTURE_COORD=tex_coords
return,1
end

;----------------------------------------------------------------------------
; mesh__DEFINE
;
; Purpose:
;  Defines the object structure for an mesh object.
;
pro mesh__define
  struct = { mesh, $
    INHERITS IDLgrModel, $
    pos: [0.0,0.0,0.0], $
    texture: 0, $
    oPoly: OBJ_NEW(), $
    meshType : '', $
    array1 : ptr_new(), $
    array2 : ptr_new(), $
    p1 : ptr_new(), $
    p2 : ptr_new(), $
    p3 : ptr_new(), $
    p4 : ptr_new(), $
    p5 : ptr_new() }
  return
end







