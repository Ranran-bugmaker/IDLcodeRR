;
;创建箭头线段
;
PRO CreateLineArrow, oArrow, startLoc, endLoc,double_head = double_head, $
  labelDim = labelDim, direction = direction
  COMPILE_OPT idl2;

  cLength = CalDistance(startLoc[0:1], endLoc[0:1])

  cAlphaRate =0.12
  cLengthRate = 1;3.0/4

  alpha = Cal2PointsAngle(endLoc[0:1], startLoc[0:1])
  ;
  IF KeyWord_Set(double_head) THEN BEGIN
    ;细直箭标
        ;  8   2      4  9
        ;  |  /       \  |
        ; 0|/___________\|1
        ;  |\           /|
        ;  | \        /  |
        ;  | 3       5   |
        ; 6|_____________|7
        ;
    oPolyline = DblArr(3,10)
    oPolyline[2,*] = startLoc[2,0]
    oPolyline[*,6] = startLoc
    oPolyline[*,7] = endLoc
    ;顺时针则
    IF direction EQ -1 THEN newAlpha = alpha-!PI/2 $
    ELSE  newAlpha = alpha+!PI/2
    ;
    oPolyline[0,0] = startLoc[0]+labelDim*COS(newAlpha)
    oPolyline[1,0] = startLoc[1]+labelDim*SIN(newAlpha)
    ;
    oPolyline[0,8] = startLoc[0]+labelDim*COS(newAlpha)*2
    oPolyline[1,8] = startLoc[1]+labelDim*SIN(newAlpha)*2
    ;
    oPolyline[0,1] = endLoc[0]+labelDim*COS(newAlpha)
    oPolyline[1,1] = endLoc[1]+labelDim*SIN(newAlpha)
    ;
    oPolyline[0,9] = endLoc[0]+labelDim*COS(newAlpha)*2
    oPolyline[1,9] = endLoc[1]+labelDim*SIN(newAlpha)*2
;    ;
    beta = alpha + cAlphaRate*!PI+!PI
    oPolyline[0,2] = oPolyline[0,0]+cLengthRate*labelDim*COS(beta);cLengthRate*cLength
    oPolyline[1,2] = oPolyline[1,0]+cLengthRate*labelDim*SIN(beta)

    beta = alpha-cAlphaRate*!PI+!PI
    oPolyline[0,3] = oPolyline[0,0]+cLengthRate*labelDim*COS(beta)
    oPolyline[1,3] = oPolyline[1,0]+cLengthRate*labelDim*SIN(beta)
    ;
    beta = alpha + cAlphaRate*!PI
    oPolyline[0,4] = oPolyline[0,1]+cLengthRate*labelDim*COS(beta)
    oPolyline[1,4] = oPolyline[1,1]+cLengthRate*labelDim*SIN(beta)

    beta = alpha-cAlphaRate*!PI
    oPolyline[0,5] = oPolyline[0,1]+cLengthRate*labelDim*COS(beta)
    oPolyline[1,5] = oPolyline[1,1]+cLengthRate*labelDim*SIN(beta)
;
    oPolylines = [2,0,1,3,2,0,3,3,4,1,5,3,6,0,8,3,9,1,7,2,6,7]
  ENDIF ELSE BEGIN
    cLengthRate = 1.0/10
    ;细直箭标   2
        ;            \
        ; 0 ___________\1
        ;              /
        ;            /
        ;           3
    oPolyline = DblArr(3,4)
    oPolyline[2,*] = startLoc[2,0]

    oPolyline[*,0:1] = [startLoc, endLoc]

    beta = alpha + cAlphaRate*!PI
    oPolyline[0,2] = endLoc[0]+cLengthRate*cLength*COS(beta)
    oPolyline[1,2] = endLoc[1]+cLengthRate*cLength*SIN(beta)

    beta = alpha-cAlphaRate*!PI
    oPolyline[0,3] = endLoc[0]+cLengthRate*cLength*COS(beta)
    oPolyline[1,3] = endLoc[1]+cLengthRate*cLength*SIN(beta)

    oPolylines = [3,0,1,2,3,0,1,3]

  ENDELSE
  ;控制点
  oArrow->SetProperty,Data = oPolyline, Polylines = oPolylines
END
;
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;计算两个点的距离
;
function CalDistance, point1, point2
    Return, SQRT((point1[0]-point2[0])^2+(point1[1]-point2[1])^2)
end
;
;;
;根据两点坐标返回线段与坐标轴的夹角(弧度)
;Point1到point2线段
;
Function Cal2PointsAngle ,point1,point2

    dx = point2[0]- point1[0]
    dy = point2[1]- point1[1]

    IF dx EQ 0 THEN BEGIN ; x轴
        IF dy GT 0 THEN result = !PI/2 ELSE $
        result = 3*!PI/2

    ENDIF ELSE BEGIN
        IF dy EQ 0 THEN BEGIN ;x轴
            IF dx GT 0 THEN result = 0 ELSE $
            result = !PI
        ENDIF ElSE BEGIN
            result = ATAN(dy/dx)
            IF result GT 0 THEN IF dx LT 0 THEN result = result +!Pi
            IF result LT 0 THEN IF dx LT 0 THEN result = result +!Pi ELSE $
            result = result + 2*!PI
        ENDELSE
    END

    return,result MOD (2*!PI)
END