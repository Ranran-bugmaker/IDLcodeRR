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
pro test_drawOrb3
    ;
    oModel = Obj_New('IDLgrModel')
    ;创建绿色框线
    angle = findgen(37)*360/36*!Dtor
    inArr = make_array(3,37,/float)
    inArr[0,*] = cos(angle)
    inArr[2,*] = sin(angle)
    Mesh_Obj, 6, Vertex_List, Polygon_List  , $
        inArr, P1 =12 , P2=[0,0,0], $
        P3 = [0,0,1], $
        P4 =0, P5 = 360*!Dtor
    oPoly = Obj_New('IDLgrPolygon', vertex_list, $
        Polygons = polygon_list, $
        color = [96,196,0],style =1) &  oModel->Add,oPoly

    ;创建红色
    angle = angle/4+135*!Dtor
    inArr = make_array(3,37,/float)
    inArr[0,*] = cos(angle)
    inArr[2,*] = sin(angle)
    Mesh_Obj, 6, Vertex_List, Polygon_List  , $
        inArr, P1 =72 , P2=[0,0,0], $
        P3 = [0,0,1], $
        P4 =0, P5 = 270*!Dtor
    oPoly = Obj_New('IDLgrPolygon', vertex_list, $
        Polygons = polygon_list, $
        color = [196,0,0],style =1) &  oModel->Add,oPoly

    ;创建蓝色
    angle = angle-90*!Dtor
    inArr = make_array(3,37,/float)
    inArr[0,*] = cos(angle)
    inArr[2,*] = sin(angle)
    Mesh_Obj, 6, Vertex_List, Polygon_List  , $
        inArr, P1 =72 , P2=[0,0,0], $
        P3 = [1,0,0], $
        P4 =75*!Dtor, P5 = 285*!Dtor
    oPoly = Obj_New('IDLgrPolygon', vertex_list, $
        Polygons = polygon_list, $
        color = [0,0,196],style =1, $
        thick =2) &  oModel->Add,oPoly

    xobjview,oModel;,background = [0,0,0]
end

