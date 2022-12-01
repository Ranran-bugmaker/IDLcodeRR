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

FUNCTION ENVI_USER_RPC_READER, FID=fileID, FNAME=filename, $
    _EXTRA=extra
  COMPILE_OPT STRICTARR
  
  ;如果没有RPC文件，则返回-1,读取RPC文件成功则返回RPCs的结构体
  IF (N_ELEMENTS(filename) EQ 0) THEN BEGIN
    IF (N_ELEMENTS(fileID) EQ 0) THEN RETURN, -1
    ENVI_FILE_QUERY, fileID, FNAME = filename
    filename = filename + '.rpc'
  ENDIF
  ;创建RPC结构体.
  rpcCoeffs = get_rpc_coefficient_structure()
  ; 找到RPC 文件并打开读取， .rpc 文件和图像数据文件在同一目录
  IF (~FILE_TEST(filename)) THEN RETURN, -1
  OPENR, unit, filename, /GET_LUN
  value = ''
  ;读取RPC结构体赋值
  FOR index = 0, 4 DO BEGIN
    READF, unit, value
    rpcCoeffs.OFFSETS[index] = DOUBLE(value)
  ENDFOR
  FOR index = 0, 4 DO BEGIN
    READF, unit, value
    rpcCoeffs.SCALES[index] = DOUBLE(value)
  ENDFOR
  FOR INDEX = 0, 19 DO BEGIN
    READF, unit, value
    rpcCoeffs.LINE_NUM_COEFF[index] = DOUBLE(value)
  ENDFOR
  FOR INDEX = 0, 19 DO BEGIN
    READF, unit, value
    rpcCoeffs.LINE_DEN_COEFF[index] = DOUBLE(value)
  ENDFOR
  FOR INDEX = 0, 19 DO BEGIN
    READF, unit, value
    rpcCoeffs.SAMP_NUM_COEFF[index] = DOUBLE(value)
  ENDFOR
  FOR INDEX = 0, 19 DO BEGIN
    READF, unit, value
    rpcCoeffs.SAMP_DEN_COEFF[index] = DOUBLE(value)
  ENDFOR
  READF,unit,value
  rpcCoeffs.P_OFF = DOUBLE(value)
  READF,unit,value
  rpcCoeffs.L_OFF = DOUBLE(value)
  ;文件关闭.
  FREE_LUN, unit
  ;返回RPC结构体
  RETURN, rpcCoeffs
END
