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
FUNCTION WV_FN_SPLINE, Order, Scaling, Wavelet, Ioff, Joff
  ;
  info = {family:'Spline', $
    order_name:'Order', $
    order_range:[1,5,1], $
    order:order, $
    discrete:1, $
    orthogonal:1, $
    symmetric:0, $
    support:support, $
    moments:moments, $
    regularity:regularity}
  RETURN, info
END