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
PRO RUNFROMIDL

  ;*******************************************************
  ;
  ;            	  Revolution IDL
  ;
  ;  The Source Code Generator for IDL Object Graphics.
  ;
  ;*******************************************************

  ;**********************************
  ; Instructions to run this program
  ;
  ; 1. Open this 'RunFromIDL.pro' file into the IDL Development Environment
  ; 2. Select: Run > Compile RunFromIDL.pro (or press Ctrl-F5)
  ; 3. Select: Run > Run RunFromIDL (or press F5)
  ;
  ; You can also run the program by doing double-click on the RevolutionIDL.sav
  ; but in that case you will lose some important features in the program.
  ;
  ; Refer to the documentation for additional details.
  ;
  ;**********************************

  ; Load and run main program.
  FORWARD_FUNCTION SOURCEPATH
  CD, FILEPATH('', root_dir=SOURCEPATH())
  RESTORE, 'RevolutionIDL.sav'
  RevolutionIDL
  
END


FUNCTION SOURCEPATH, Base_Name = BaseName, _Extra = Extra
  COMPILE_OPT StrictArr
  ON_ERROR, 2
  Stack = SCOPE_TRACEBACK(/Structure)
  Filename = Stack[N_ELEMENTS(Stack) - 2].FILENAME
  IF (ARG_PRESENT(BaseName)) THEN BEGIN
    BaseName = FILE_BASENAME(Filename)
  ENDIF
  RETURN, FILE_DIRNAME(Filename, _Extra = Extra)
END