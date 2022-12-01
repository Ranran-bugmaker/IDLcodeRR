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
  ;trunk
  opl = OBJ_NEW('IDLgrPolygon', TRANSPOSE([[ -9, -11, -20, -20, -18] , [-18,-20,-20,-11,-9], [INTARR(5)]]),color=[255,0,0],bottom=[255,255,255])
  op2 = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[-2,-9,-18,-11], [-11,-18,-9,-2], [INTARR(4)]]),color=[255,0,0],bottom=[255,255,255])
  op3 = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[6,6,-2,-11,-3], [6,-3,-11,-2,6], [INTARR(5)]]),color=[255,0,0],bottom=[255,255,255])
  op4 = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[15,6,6], [6,6,15], [INTARR(3)]] ),color= [255,0,0],bottom=[255,255,255])
  op5 = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[15,15,6,11], [11,6,15,15], [INTARR(4)]]),color=[255,0,0],bottom=[255,255,255])
  op6 = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[15,15,11], [15,11, 15], [INTARR (3) ] ] ) , color= [255,0, 0], bottom= [255,255,255]) ;left
  
  ;left arm
  op7 = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[13,6,6], [-1,-3,6], [INTARR(3)]]),color= [255,0,0],bottom=[255,255,255])
  op8 = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[13,13,6], [-1, -10, -3] , [INTARR (3) ] ] ) , color= [255,0, 0], bottom= [255,255,255])
  op9 = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[15,15,13,13], [-3,-8,-10,-1], [INTARR(4)]]),color=[255,0,0],bottom=[255,255,255])
  op10 = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[13,13,6,6], [-10,-12,-12,-3], [INTARR(4)]]),color=[255,0,0],bottom=[255,255,255])
  opll = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[13,13,6,6], [-12,-20,-20,-12], [INTARR(4)]] ),color=[255,0,0],bottom=[255,255,255])
  op12 = OBJ_NEW('IDLgrPolygon',TRANSPOSE([[15,15,13,13], [-12,-20,-20,-12], [INTARR(4)]] ),color=[255,0,0],bottom=[255,255,255])
  
  ;right arm
  op7r = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([ [-1, -3, 6] , [13,6, 6] , [INTARR (3) ] ] ) ) , color= [255,0, 0], bottom= [255,255,255] )
  op8r = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([ [-1,-10,-3], [13,13,6], [INTARR(3) ] ])) ,color=[255,0,0] ,bottom=[255,255,255])
  op9r = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([ [-3,-8,-10,-1], [15,15,13,13], [INTARR(4) ] ])) ,color=[255,0,0] ,bottom=[255,255,255])
  opl0r = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([[-10, -12, -12, -3 ] , [13,13,6, 6] , [INTARR(4)]] )) , color= [255,0, 0], bottom= [255,255,255] )
  opllr = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([[-12, -20, -20, -12] , [13,13,6, 6] , [INTARR(4)]] )), color= [255,0, 0], bottom= [255,255,255])
  op12r = OBJ_NEW('IDLgrPolygon',TRANSPOSE(Reverse([[-12, -20, -20, -12], [15,15,13, 13], [INTARR(4)]] )), color= [255,0, 0], bottom= [255,255,255])
  
  oFace = OBJ_NEW('IDLgrPolyLine',TRANSPOSE([[6,4+1,-5+1,-3,6], [-3, -5+1, 4+1, 6, -3], [INTARR (5) +0.1] ] ), color= [0,0, 0], thick=3)
  theta = FINDGEN(180)*2*!dtor
  oNose = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[1.0*COS(theta)],[1.0*SIN(theta)],[FLTARR(N_ELEMENTS(theta))+0.2]]),color=[252,64,186], hide=1)
  oLeftEye = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[0.5*COS(theta)-1.5],[0.5*SIN(theta)+3.5],[FLTARR(N_ELEMENTS(theta))+0.2]]),color=[0,0,0],hide=1)
  oRightEye = OBJ_NEW('IDLgrPolygon',TRANSPOSE( [[0.5*COS(theta)+3.5],[0.5*SIN(theta)-1.5],[FLTARR(N_ELEMENTS(theta))+0.2]]),color=[0,0,0],hide=1)
  
  oTopModel = OBJ_NEW('IDLgrModel')
  ;trunk models
  oMod1 = obj_new ('IDLgrModel' )
  oMod2 = OBJ_NEW('IDLgrModel')
  oMod3 = OBJ_NEW('IDLgrModel')
  oMod4 = OBJ_NEW('IDLgrModel')
  oMod5  = OBJ_NEW('IDLgrModel')
  
  ;left arm models
  oLeftModel = OBJ_NEW('IDLgrModel')
  oMod6l =  OBJ_NEW('IDLgrModel')
  oMod7l = OBJ_NEW('IDLgrModel')
  oMod8l = OBJ_NEW('IDLgrModel')
  oMod9l = OBJ_NEW('IDLgrModel')
  
  ;build the hierarchy
  oMod6l->Add, op12
  oMod7l->Add, [oMod6l, opll]
  oMod8l->Add, [oMod7l, op10]
  oMod9l->Add, op9
  
  oLeftModel->Add, [op7, op8, oMod9l, oMod8l]
  
  ;right arm
  oRightModel = OBJ_NEW('IDLgrModel')
  oMod6r =  OBJ_NEW('IDLgrModel')
  oMod7r = OBJ_NEW('IDLgrModel')
  oMod8r = OBJ_NEW('IDLgrModel')
  oMod9r = OBJ_NEW('IDLgrModel')
  
  ;build the hierarchy
  oMod6r->Add, op12r
  oMod7r->Add, [oMod6r, opllr]
  oMod8r->Add, [oMod7r, opl0r]
  oMod9r->Add, op9r
  
  oRightModel->Add, [op7r,op8r,oMod9r,oMod8r]
  
  oTopModel->Add, [oLeftModel, oRightModel]
  oTopModel->Add, [oFace, oNose, oLeftEye, oRightEye]
  
  oMod2->Add, opl
  oMod1->Add, [oMod2,op2]
  oTopModel->Add, [op3,oMod1]
  oMod5->Add,op6
  oMod4->Add, [oMod5,op5]
  oMod3->Add, [oMod4,op4]
  oTopModel->Add, oMod3
  oTopModel->Rotate, [0,0,1],45
  
  ;spin up ITTVIS's xobjview
  DEVICE, get_screen_size=scrsz
  Xobjview, oTopModel, tlb=tlb, scale=1, renderer=1, xoffset=scrsz[0]-450 , background=[0,0,0]
