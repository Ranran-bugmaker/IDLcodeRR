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
 
 file = dialog_pickfile(/Directory)
 ;对话框选择文件，见图11.16-(b).
 file = dialog_pickfile()
 ;添加初始化路径和文件类型过滤，见图11.16-(c).
 file = dialog_pickfile(title ='选择文件', path ='c:\', get_path = oriPath, filter ='*.pro')
 ;文件过滤，并可以多选，见图11.16-(d).
 file = dialog_pickfile(title ='选择文件', path =oriPath, /multiple_files, $ 
   filter =[['*.jpg','*.bmp','*.tif','*.*'], ['JPG文件','BMP文件','TIF文件','所有文件']])
   
    ;信息提示对话框，见图11.17-(a).
 rlt= DIALOG_MESSAGE('信息提示',title='信息',/Information)
 ;错误提示对话框，见图11.17-(b).
 rlt= DIALOG_MESSAGE('程序出错了！',title='错误',/Error)
 ;疑问对话框，见图11.17-(c).
 rlt= DIALOG_MESSAGE('正确么？',title='疑问',/Question)
 ;疑问对话框，见图11.17-(d).
rlt= DIALOG_MESSAGE('继续?',title='疑问',/Cancel)
   
   
 END