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

;
;对调用IDLDrawWidget下的SetNamedArray和CopyNamedArray方法后的数组顺序做调整
;
FUNCTION CHANGEARRAYORDER, inArr
  ;
  oDims = SIZE(inArr,/dimension)
  oType = SIZE(inArr,/Type)
  nDims = SIZE(inArr,/N_dim)
  CASE nDims OF
    1:result = inArr
    2: BEGIN
      result = REFORM(inArr, oDims[1],oDims[0])
    END
    3: BEGIN
      result = REFORM(inArr,oDims[2],oDims[1],oDims[0])
    END
    ELSE: BEGIN
      cmdStr = 'result= Reform(inArr'
      FOR idx=nDims-1,0,-1 DO BEGIN
        cmdStr += ',oDims['+STRTRIM(iDx)+']'
      ENDFOR
      void = EXECUTE(cmdStr+')')
    END
  ENDCASE
  
  RETURN,result
END
