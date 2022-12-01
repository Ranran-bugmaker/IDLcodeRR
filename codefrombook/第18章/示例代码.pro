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

  ;选择系统自带的一个sav文件，包含了体数据
  savefile = FILEPATH('cduskcD1400.sav', $
   SUBDIRECTORY=['examples', 'data'])
  ;创建Savefile对象
  sObj = OBJ_NEW('IDL_Savefile', savefile)
  ;调用对象方法查询sav文件内容
  sContents = sObj.CONTENTS()
  ;查看sav内容个数
  PRINT, sContents.N_VAR
 
  ;获取sav文件中的变量名称
  sNames = sObj.NAMES()
  ;查看变量名称
  PRINT, sNames

  ;查询变量'density'的信息，等同于size()函数
  sDensitySize = sObj.SIZE('density')
  ;查看变量信息
  PRINT, sDensitySize

  ;恢复变量到IDL内存中
  sObj.RESTORE, 'density'
  ;调用iTools工具显示（图18.7）
  IVOLUME, density

end