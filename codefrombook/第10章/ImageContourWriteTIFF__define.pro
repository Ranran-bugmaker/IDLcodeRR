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
;iImageContour工具的类文件输出功能类定义
;Modified By DYQ
;-
FUNCTION ImageContourWriteTIFF::Init, _REF_EXTRA = _extra

   IF (self->IDLitWriter::Init('tiff', $
      TYPES=['IDLIMAGE', 'IDLIMAGEPIXELS', 'IDLARRAY2D'], $
      NAME='Tag Image File Format', $
      DESCRIPTION='Tag Image File Format (TIFF)', $
      _EXTRA = _extra) EQ 0) THEN $
      RETURN, 0

   RETURN, 1

END

;将数据写出为tiff文件
FUNCTION ImageContourWriteTIFF::SetData, oImageData

   ;获取输出文件名
   strFilename = self->GetFilename()
   IF (strFilename EQ '') THEN RETURN, 0

   ;检测输出对象类有效
   IF (~ OBJ_VALID(oImageData)) THEN BEGIN
      MESSAGE, 'Invalid image data object.', /CONTINUE
      RETURN, 0 
   ENDIF

   ;获取一维矢量数据类
   oData = (oImageData->GetByType('IDLIMAGEPIXELS'))[0]

   ;获取二维数据类型
   IF (~ OBJ_VALID(oData)) THEN BEGIN
      oData = (oImageData->GetByType('IDLARRAY2D'))[0]
      IF (~ OBJ_VALID(oData)) THEN RETURN, 0
   ENDIF

   ; 未获得任何数据，则失败
   IF (~ oData->GetData(image)) THEN BEGIN
      MESSAGE, 'Error retrieving image data.', /CONTINUE
      RETURN, 0 
   ENDIF

   ; 获取颜色表
   oPalette = (oImageData->GetByType('IDLPALETTE'))[0]

   ; 获取颜色表则解析颜色表
   IF (OBJ_VALID(oPalette)) THEN BEGIN
      success = oPalette->GetData(palette)
      IF (N_ELEMENTS(palette) GT 0) THEN BEGIN
         red = REFORM(palette[0,*])
         green = REFORM(palette[1,*])
         blue = REFORM(palette[2,*])
      ENDIF
   ENDIF

   ;数据的维数
   ndim = SIZE(image, /N_DIMENSIONS)

   ;输出为tiff文件和颜色表，reverse保证格式的通用性
   WRITE_TIFF, strFilename, REVERSE(image, ndim), $
      RED = red, GREEN = green, BLUE = blue
   RETURN, 1  ; success
END
; 类定义
PRO ImageContourWriteTIFF__Define
   struct = {ImageContourWriteTIFF,       $
             inherits IDLitWriter  $
           }
END

