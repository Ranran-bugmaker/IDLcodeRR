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
;iImageContour工具入口文件
; Copy from ITTVIS
;-
PRO IIMAGECONTOUR, parm1, IDENTIFIER = identifier,$
    _EXTRA = _extra
  IF (N_PARAMS() GT 0) THEN BEGIN
    ;
    ;调用IDLitParameterSet保存数据对象
    ;
    oParmSet = OBJ_NEW('IDLitParameterSet', $
      NAME = '参数', $
      ICON = 'image', $
      DESCRIPTION = 'tool parameters')
    ;如调用时输入了数据则进行数据存储
    IF (N_ELEMENTS(parm1) GT 0) THEN BEGIN
      ;如果是文件名则用iopen读取数据
      IF (SIZE(parm1, /TNAME) EQ 'STRING') THEN BEGIN
        filenameTmp = parm1
        IOPEN, parm1, data, rgbTableIn, _EXTRA=_extra
      ENDIF
      oData = OBJ_NEW('IDLitDataIDLImagePixels')
      result = oData->SETDATA(data, _EXTRA = _extra)
      oParmSet->ADD, oData, PARAMETER_NAME = 'ImagePixels'
      ;默认显示灰度颜色表.
      ramp = BINDGEN(256)
      oPalette = OBJ_NEW('IDLitDataIDLPalette', $
        TRANSPOSE([[ramp], [ramp], [ramp]]), $
        NAME = 'Palette')
      oParmSet->ADD, oPalette, PARAMETER_NAME = 'PALETTE'
    ENDIF
  ENDIF
  ;注册可视化工具
  IREGISTER, 'Image Contour tool', 'iImageContour'
  identifier = IDLITSYS_CREATETOOL('Image Contour tool',$
    VISUALIZATION_TYPE = ['Image&Contour'], $
    INITIAL_DATA = oParmSet, _EXTRA = _extra, $
    TITLE = 'Image Contour tool')
    
END