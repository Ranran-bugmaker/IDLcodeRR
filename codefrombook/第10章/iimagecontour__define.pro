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
;iImageContour工具的类定义文件
;Modified By DYQ
;-
FUNCTION IIMAGECONTOUR::INIT, _REF_EXTRA = _extra

  ;初始化继承类
  IF ( self->IDLITTOOLBASE::INIT(_EXTRA = _extra) EQ 0) THEN $
    RETURN, 0
  ;*** 可视化
  ; 注册可视化工具
  self->REGISTERVISUALIZATION, 'Image&Contour', 'VisImageContour', $
    ICON = 'image', /DEFAULT
    
  ;*** 操作菜单
  ; 可视化时调用菜单中增加Canny按钮，功能由ImageContourCanny类定义
  self->REGISTEROPERATION, 'Canny边界检测', 'ImageContourCanny', $
    IDENTIFIER = 'Operations/Canny'
    
  ;***工具栏按钮
  ; 可参考运行“idldir/examples/doc/itools/example3tool.pro”
    
  ;***文件读取
  ; 添加特定格式文件读取
  self->REGISTERFILEREADER, '读取TIFF格式', 'ImageContourReadTIFF', $
    ICON='demo', /DEFAULT
  ;***文件写出
  ; 先将iTools自带的文件写出工具屏蔽
  self->UNREGISTERFILEWRITER, 'Tag Image File Format'
  ;注册编写的tif文件输出工具
  self->REGISTERFILEWRITER, '写出TIFF格式', 'ImageContourWriteTIFF', $
    ICON='demo', /DEFAULT
    
  ;类初始化成功
  RETURN, 1
  
END

; 类定义
PRO IIMAGECONTOUR__DEFINE

  struct = { iImageContour,              $
    INHERITS IDLitToolbase     $ ; Provides iTool interface
    }
    
END

