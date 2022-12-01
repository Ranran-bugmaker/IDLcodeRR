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
;Copy from ITTVIS
;iImageContour工具下的tif文件读取类ImageContourReadTIFF__define.pro
;Modified By DYQ
;-
FUNCTION ImageContourReadTIFF::INIT, _REF_EXTRA = _extra

  ;初始化继承类
  IF (self->IDLITREADER::INIT(["tiff", "tif"],$
    NAME="Tiff 文件", $
    DESCRIPTION="TIFF File format", $
    _EXTRA = _extra) NE 1) THEN $
    RETURN, 0
  ; Initialize the instance data field
  self._INDEX = 0
  ;注册索引属性
  self->REGISTERPROPERTY, 'IMAGE_INDEX', /INTEGER, $
    Description='Index of the image to read from the TIFF file.'
  ; Return success.
  RETURN,1
END
;监测是是tiff文件
FUNCTION ImageContourReadTIFF::ISA, strFilename
  RETURN, QUERY_TIFF(strFilename);
END
;读取tiff文件内容
FUNCTION ImageContourReadTIFF::GetData, oImageData
  ; 文件名
  filename = self->GETFILENAME()
  
  ; 无数据内容则返回
  IF (QUERY_TIFF(filename, fInfo, IMAGE_INDEX = self._INDEX) EQ 0) $
    THEN RETURN, 0
  ;有颜色表则读取
  IF (fInfo.HAS_PALETTE) THEN BEGIN
    image = READ_TIFF(filename, palRed, palGreen, palBlue, $
      IMAGE_INDEX = self._INDEX)
  ENDIF ELSE BEGIN
    image = READ_TIFF(filename, IMAGE_INDEX = self._INDEX)
  ENDELSE
  
  ;保存数据到IDLitDataIDLImage对象中
  oImageData = OBJ_NEW('IDLitDataIDLImage', $
    NAME = FILE_BASENAME(fileName))
  result = oImageData->SETDATA(image, 'ImagePixels', /NO_COPY)
  IF (result EQ 0) THEN RETURN, 0
  ;保存颜色表数据
  IF (fInfo.HAS_PALETTE) THEN $
    result = oImageData->SETDATA( TRANSPOSE([[palRed], $
    [palGreen], [palBlue]]), 'Palette')
  ;多个波段的读取
  IF fInfo.NUM_IMAGES GT 1 THEN $
    self->IDLITIMESSAGING::STATUSMESSAGE, $
    'Read channel ' + STRTRIM(self._INDEX,2)
  RETURN, result
END

; 属性获取方法
PRO ImageContourReadTIFF::GetProperty, IMAGE_INDEX = image_index, $
    _REF_EXTRA = _extra
    
  IF (ARG_PRESENT(image_index)) THEN image_index = self._INDEX
  
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IDLITREADER::GETPROPERTY, _EXTRA = _extra
END
;属性设置方法
PRO ImageContourReadTIFF::SetProperty, IMAGE_INDEX = image_index, $
    _REF_EXTRA = _extra
    
  IF (N_ELEMENTS(image_index) GT 0) THEN $
    self._INDEX = image_index
    
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IDLITREADER::SETPROPERTY, _EXTRA = _extra
END
; 类定义，继承类IDLitReader
PRO IMAGECONTOURREADTIFF__DEFINE
  struct = {ImageContourReadTIFF, $
    inherits IDLitReader, $
    _index : 0            $
    }
END

