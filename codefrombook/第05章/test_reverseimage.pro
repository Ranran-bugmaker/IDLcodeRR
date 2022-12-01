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
;循环进行像素交换
FUNCTION DO_METHOD_01, img
  ;列循环
  FOR i=0,2047 DO BEGIN
    ;图像上一半行循环
    FOR j=0,1023  DO BEGIN
      ;保存当前点坐标
      tmp = img[i,j]
      ;用中间对称点替换
      img[i,j]= img[i,2047-j]
      ;交换数据
      img[i,2047-j] = tmp
    ENDFOR
  ENDFOR
  ;返回翻转结果
  RETURN, img
END
;利用IDL特点行交换
FUNCTION DO_METHOD_02, img
  ;图像上一半行循环
  FOR j=0,1023  DO BEGIN
    ;保存当前行坐标
    tmp = img[*,j]
    ;用中间对称点替换
    img[*,j]= img[*,2047-j]
    ;交换数据
    img[*,2047-j] = tmp
  ENDFOR
  ;返回翻转结果
  RETURN, img
END
;多占用一倍内存，代码更加简洁
;
FUNCTION DO_METHOD_03, img
  ;数据复制一份
  img2 = img
  ;图像倒序赋值
  FOR j=0,2047 DO img2=img[*,2047-j]
  ;返回翻转结果
  RETURN, img2
END
;多占用一倍内存,进一步优化
;
FUNCTION DO_METHOD_04, img

  ;利用IDL特性将图像倒序赋值
  img2 = img[*,2047-INDGEN(2048)]
  ;返回翻转结果
  RETURN, img2
END
;最佳方法-IDL自带函数实现
;
FUNCTION DO_METHOD_05, img
  img = ROTATE(img,7)
  RETURN, img
END
PRO TEST_REVERSEIMAGE
  PROFILER, /SYSTEM
  ;定义数组2048*2048
  img = FLTARR(2048,2048)
  ;记录开始时间
  starttime = SYSTIME(1)
  ;翻转图像
  img = DO_METHOD_01(img)
  ;输出花费时间
  PRINT,'Method01:',SYSTIME(1) - starttime
  ;
  ;记录开始时间
  starttime = SYSTIME(1)
  ;翻转图像
  img = DO_METHOD_02(img)
  ;输出花费时间
  PRINT,'Method02:',SYSTIME(1) - starttime
  
  ;记录开始时间
  starttime = SYSTIME(1)
  ;翻转图像
  img = DO_METHOD_03(img)
  ;输出花费时间
  PRINT,'Method03:',SYSTIME(1) - starttime
  
  ;记录开始时间
  starttime = SYSTIME(1)
  ;翻转图像
  img = DO_METHOD_04(img)
  ;输出花费时间
  PRINT,'Method04:',SYSTIME(1) - starttime
  
  ;记录开始时间
  starttime = SYSTIME(1)
  ;翻转图像
  img = DO_METHOD_05(img)
  ;输出花费时间
  PRINT,'Method05:',SYSTIME(1) - starttime
  
END
;Method01:       1.1450000
;Method02:     0.023999929
;Method03:     0.020999908
;Method04:     0.031000137
;Method05:     0.016000032