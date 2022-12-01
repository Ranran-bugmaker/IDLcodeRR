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


;初始化Java类，由java代码创建5*5的数组
joArr = OBJ_NEW('IDLJavaObject$arrayDemo', 'arrayDemo',5,5)
;获取数组下标为[2,3]的值
PRINT, '数组[2,3]=', joArr->GETVALUEBYINDEX(2,3)
;获取Java中所有数组的值
IDL_Arr = joArr->GETARRAYVALUES()
;查看从Java类中获取数组的信息
HELP, IDL_Arr
;查看数组
PRINT, '数组[2,3]=', IDL_Arr[2,3]
;数组运算，原乘以2。
IDL_Arr = IDL_Arr*2
;将运算后数组存储到Java中
joArr->SETARRAYVALUE, IDL_Arr
;获取数组下标为[2,3]的值
PRINT, '数组[2,3]=', joArr->GETVALUEBYINDEX(2,3)
;销毁对象
OBJ_DESTROY, joArr


;动态库文件完整路径
dll = 'd:\imageProcess.dll'
;测试图像
image = BYTSCL(DIST(200, 200))
;创建400*200的窗口
WINDOW,1,xsize = 400,ysize =200
;显示原始图像（图18-2左图）
TV,image,0
;拉伸参数
width = 200L
height = 200L
min = 20L
max = 220L
ret = CALL_EXTERNAL(dll, 'ImgExtend', image, width, height, min, max)
;显示DLL拉伸后图像（图18-2右图）
TV, image,1


END