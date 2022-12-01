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

;编写方法MessageFrom，响应数组传递
FUNCTION helloComEx::ArrayTest, array
  ;获取数组的信息
  type = SIZE(array,/type)
  dims = SIZE(array,/dimension)
  tmp = DIALOG_MESSAGE('数组信息Dims[0]：'+STRTRIM(dims[0]),/infor)
  tmp = DIALOG_MESSAGE('数组信息Dims[1]：'+STRTRIM(dims[1]),/infor)
  RETURN,array+2
END
;编写方法MessageFrom，字符串传递
FUNCTION helloComEx::MessageFrom, input
  ;如果调用时有变量输入，则弹出信息
  IF (N_ELEMENTS(input) NE 0) THEN self.MESSAGE = "Hello World from " + input $
  ELSE self.MESSAGE = 'Hello World'
  tmp = DIALOG_MESSAGE(self.MESSAGE,title = 'IDL',/infor)
  ;返回tmp
  RETURN, tmp
END
; 对象类初始化方法.
FUNCTION helloComEx::INIT
  RETURN, 1
END
; 对象类定义代码
PRO HELLOCOMEX__DEFINE
  struct = {helloComEx, $
    message: ' ' }
END