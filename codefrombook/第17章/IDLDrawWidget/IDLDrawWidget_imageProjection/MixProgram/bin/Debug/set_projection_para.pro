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
function set_projection_para
  oMapProjection = OBJ_NEW('ProjectionParameter', $
    Name='设定投影参数' , $
    projection=3        , $
    datum='WGS84'       )
  ;
  wTlb = Widget_Base(/column)
  wSetBase = Widget_Base(wTlb)
  Widget_Control,wTlb,/Realize  

  pSheet = WIDGET_PROPERTYSHEET( $
    wSetBase, $
    Value = oMapProjection, $
    /Sunken_Frame, $
    Scr_XSize = 310, $
    YSize = 15, $
    UName = 'pSheet', $
    /Multiple_Properties)
    
     prevImage = oMapProjection->Getpreview()
  WSET, wPrevID
  TV, prevImage
end