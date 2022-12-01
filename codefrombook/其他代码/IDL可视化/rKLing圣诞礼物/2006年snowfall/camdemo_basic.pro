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
;       CAMDEMO_BASIC
;
; PURPOSE:
;       The purpose of this routine is to provide a VERY basic example of
;       using the camera object.  This example doesn't actually do anything
;       you can't do with the IDLgrView object but like I said, this
;       is a very basic example.
;
;
;       DISCLAIMER: The camdemo_* programs are quick examples of some
;                   of the features of my camera object.  They are
;                   NOT provided as examples of proper programming
;                   technique. Use at your own risk!
;
; AUTHOR:
;       Rick Towler
;       School of Aquatic and Fishery Sciences
;       University of Washington
;       Box 355020
;       Seattle, WA 98195-5020
;       rtowler@u.washington.edu
;
;
; CATEGORY:
;       Object Graphics
;
;
; KEYWORDS:
;
;   software:       Set this keyword to force rendering the scene using IDL's
;                   software renderer.
;
;
; DEPENDENCIES:     camera__define.pro
;                   quaternion__define.pro
;
;
; MODIFICATION HISTORY:
;       Written by: Rick Towler, 16 June 2001.
;
;
; LICENSE
;
;   CAMDEMO_BASIC.PRO Copyright (C) 2001  Rick Towler
;
;   This program is free software; you can redistribute it and/or
;   modify it under the terms of the GNU General Public License
;   as published by the Free Software Foundation; either version 2
;   of the License, or (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program; if not, write to the Free Software
;   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;
;   A full copy of the GNU General Public License can be found on line at
;   http://www.gnu.org/copyleft/gpl.html#SEC1
;
;-


pro camdemo_event, event

  Widget_Control, event.top, Get_UValue=info
  
  ;draw the window when it is exposed
  info.window -> draw, info.camera
  
end


pro camdemo_exit, event

  Widget_Control, event.top, /Destroy
  
end


pro camdemo_cleanup, tlb

  Widget_Control, tlb, Get_UValue=info
  Obj_Destroy, info.container
  
end


pro camdemo_basic, software=software

  ;check our keyword
  software = (n_elements(software) eq 0) ? 0 : keyword_set(software)
  
  ;create a container for easy cleanup
  container = obj_new('IDL_Container')
  
  
  ;define the top level base widget
  tlb=widget_base(column=1, mbar=menuid, title='Basic Camera Demo')
  
  ;file menu
  fileID=widget_button(menuID, value='File')
  exitID=widget_button(fileID, value='Exit', event_pro='camdemo_exit')
  
  ;create our graphics window
  ;force software renderer if software keyword is set.
  if (software) then begin
    drawID=widget_draw(tlb, xsize=600, ysize=600, expose_events=1, $
      graphics_level=2, renderer=1)
  endif else begin
    drawID=widget_draw(tlb, xsize=600, ysize=600, expose_events=1, $
      graphics_level=2)
  endelse
  
  ;realize the widget heirarchy
  widget_control, tlb, /realize
  
  ;get the window object reference
  widget_control, drawID, GET_VALUE = window
  container -> add, window
  
  
  ;create the camera, add a little perspective
  camera = obj_new('Camera', projection=2, camera_location=[0,0,100], $
    viewplane_rect=[0,0,10,10],color=[0,0,0],zclip=[300,-300],lookat=[50,50,0])
  container -> add, camera
  
  
  ;something to look at
  ;orb = obj_new('orb', radius=1, pos=[0,0,0], color=[255,0,0], density=2.0, $
  ;        style=1)
  
  ;;create the snow surface
  seed=100
  snowSurface = randomu(seed, 100, 100)*255.0
  oSnowSurface = obj_new('IDLgrSurface',snowSurface,color=[255,255,255],style=2,shading=1)
  
  
  container -> add, oSnowSurface
  
  ;rotate the orb so we view it side on
  ;oSnowSurface -> rotate, [1,0,0], 90.
  
  
  ;create a top level model whose transform will be manipulated directly
  ;by the camera.  Since the ORB is a subclass of IDLgrModel you could
  ;throw the orb directly into the camera but you would lose the rotation
  ;performed above becase the ORB's transform matrix would be replaced
  ;by the camera.
  topmodel = obj_new('IDLgrModel')
  container -> add, topmodel
  
  
  ;add the orb to the top model
  topmodel -> add, oSnowSurface
  ;topmodel-> rotate, [1,0,0], 90.
  
  ;and this model to our camera
  camera -> add, topmodel
  
  
  
  ;our global data structure
  info={  container:container, $
    window:window, $
    camera:camera}
    
    
  ;insert our global data structure into the tlb widget
  Widget_Control, tlb, Set_UValue=info
  
  ;fire up xmanager
  XManager, 'camdemo_basic', tlb, Cleanup='camdemo_cleanup', /No_Block, $
    Event_Handler='camdemo_event'
    
end





