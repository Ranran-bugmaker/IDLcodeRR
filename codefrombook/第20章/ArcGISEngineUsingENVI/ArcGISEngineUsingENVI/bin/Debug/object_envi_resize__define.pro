;+
;         《IDL程序设计》
; --数据快速可视化与ENVI二次开发（配盘）
;
; 示例源代码
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
;
;重采样执行功能
;输入放缩比例和采样方法
PRO Object_ENVI_Resize::EXECUTEResize,$
    xfactor, yfactor,method
  COMPILE_OPT idl2, hidden
  
  ;打开文件
  ENVI_OPEN_FILE, self.INFILENAME, R_FID=fid
  IF (fid EQ -1) THEN RETURN
  ;查询文件基本信息
  ENVI_FILE_QUERY, fid, dims=dims, nb=nb
  pos  = LINDGEN(nb)
  ;重采样处理
  ENVI_DOIT, 'resize_doit', $
    fid=fid, pos=pos, dims=dims, $
    interp=1, rfact=1./[XFACTOR,YFACTOR], $
    method = METHOD,$
    out_name=self.OUTFILENAME
    
END
;对象的析构函数
PRO Object_ENVI_Resize::CLEANUP
  COMPILE_OPT idl2, hidden  
  ;关闭ENVI二次开发模式
  ;需要注意，COM组件调用该功能的时候，必须设置如下参数：
  ; 在ENVI主菜单的File-Preference-Miscellaneous下
  ; 设置 Exit IDL on Exit from ENVI为'NO'
  ENVI_BATCH_EXIT
END

;ENVI初始化方法
FUNCTION Object_ENVI_Resize::initEnvi
  CATCH, error_status
  IF Error_status NE 0 THEN BEGIN
    RETURN,-1
    CATCH, /CANCEL
  ENDIF
  ;ENVI二次开发模式初始化
  ENVI,/Restore_Base_Save_Files
  ENVI_BATCH_INIT
  RETURN,1
  
END


;对象初始化函数
;包含两个参数：输入和输出文件名。
;
FUNCTION Object_ENVI_Resize::INIT,$
    inFileName ,outFileName
  COMPILE_OPT idl2
  ;文件名参数
  self.INFILENAME = inFileName
  self.OUTFILENAME = outFileName
  ;初始化ENVI
  INITFALG = self->INITENVI()
  RETURN, INITFALG
  
END
;类定义
PRO OBJECT_ENVI_RESIZE__DEFINE
  ;类定义结构体
  void = {Object_ENVI_Resize, $
    inFileName : '', $
    outFileName : '' $
    }
END