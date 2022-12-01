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
;
;iImageContour工具的类定义文件
;Modified By DYQ
;-
FUNCTION ImageContourCanny::INIT, _REF_EXTRA = _extra

  ; 基类初始化
  IF (~ self->IDLITDATAOPERATION::INIT(NAME='Canny', $
    TYPES=['IDLVECTOR','IDLARRAY2D','IDLARRAY3D'], $
    DESCRIPTION="Canny", _EXTRA = _extra)) THEN $
    RETURN, 0
    
  ;设置默认值
  self._HIGHVALUE = 60
  self._LOWVALUE = 10
  self._SIGMAVALUE = 60
  
  ;注册属性
  self->REGISTERPROPERTY, 'HighValue', /FLOAT, $
    DESCRIPTION='Canny High'
    
  self->REGISTERPROPERTY, 'LowValue', /FLOAT, $
    DESCRIPTION='Canny Low.'
    
  self->REGISTERPROPERTY, 'SigmaValue', /FLOAT, $
    DESCRIPTION='Canny Sigma'
  ;显示参数设置界面
  self->SETPROPERTYATTRIBUTE, 'SHOW_EXECUTION_UI', HIDE=0
  
  ; keyword parameters to the superclass SetProperty method.
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IMAGECONTOURCANNY::SETPROPERTY, _EXTRA = _extra
    
  RETURN, 1
END

;执行功能.
FUNCTION ImageContourCanny::EXECUTE, data

  ;执行Canny算法编译检测
  data = CANNY(data,HIGH = HighValue, LOW = LowValue, SIGMA = SigmaValue)
  RETURN, 1
  
END

;参数设置界面显示
FUNCTION ImageContourCanny::DoExecuteUI

  ;获取当前工具的tool
  oTool = self->GETTOOL()
  IF (~oTool) THEN RETURN, 0
  ;参数设置生效
  self->SETPROPERTYATTRIBUTE, $
    ['HighValue', 'LowValue','SigmaValue'], SENSITIVE=1
  result = oTool->DOUISERVICE('PropertySheet', self)
  RETURN, result  
END

;获取属性参数
PRO ImageContourCanny::GetProperty, $
    HighValue =HighValue, $
    LowValue = LowValue, $
    SigmaValue = SigmaValue, $
    METHOD = method, $
    _REF_EXTRA = _extra
    
  ;如获取HighValue值，则返回self._HighValue
  IF ARG_PRESENT(HighValue) THEN  HighValue = self._HIGHVALUE
  ;如获取LowValue值，则返回self._LowValue
  IF ARG_PRESENT(LowValue) THEN LowValue = self._LOWVALUE
  ;如获取SigmaValue值，则返回self._SigmaValue
  IF ARG_PRESENT(SigmaValue) THEN SigmaValue = self._SIGMAVALUE  
  ;基类参数
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IDLITDATAOPERATION::GETPROPERTY, _EXTRA = _extra    
END

;设置属性参数
PRO ImageContourCanny::SetProperty, $
    LowValue = LowValue, $
    HighValue = HighValue, $
    SigmaValue = SigmaValue, $
    METHOD = method, $
    _REF_EXTRA = _extra
    
  ;如赋HighValue值，则赋给self._HighValue
  IF N_ELEMENTS(HighValue) THEN $
    IF (HighValue NE 0) THEN self._HIGHVALUE = HighValue
  ;如赋LowValue值，则赋给self._LowValue
  IF N_ELEMENTS(LowValue) THEN $
    IF (LowValue NE 0) THEN self._LOWVALUE = LowValue
  ;如赋SigmaValue值，则赋给self._SigmaValue  
  IF N_ELEMENTS(SigmaValue) THEN $
    IF (SigmaValue NE 0) THEN self._SIGMAVALUE = SigmaValue
    
  ;基类参数
  IF (N_ELEMENTS(_extra) GT 0) THEN $
    self->IDLITDATAOPERATION::SETPROPERTY, _EXTRA = _extra    
END

;类定义结构体
PRO IMAGECONTOURCANNY__DEFINE

  struc = {ImageContourCanny, $
    inherits IDLitDataOperation,   $
    _HighValue: 0d, $
    _LowValue: 0d, $
    _SigmaValue: 0d, $
    _method: 0b $
    }
    
END

