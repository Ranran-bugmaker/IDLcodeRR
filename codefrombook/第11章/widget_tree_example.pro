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
;  $Id: //depot/idl/releases/IDL_80/idldir/examples/doc/widgets/tree_widget_example.pro#1 $

;  Copyright (c) 2005-2010, ITT Visual Information Solutions. All
;       rights reserved.
;
; This program is used as an example in the "Widget Application Techniques"
; chapter of the _Building IDL Applications_ manual.
;
; This example creates a simple tree widget. Clicking on a leaf node
; toggles the text of the display to read either 'On' or 'Off'. This
; is not particularly useful, but serves as an example of how you
; might accomplish something more complicated.
;
; Modified By DYQ
;
;-

;事件响应程序
PRO TREE_WIDGET_EXAMPLE_EVENT, ev

  COMPILE_OPT hidden
  
  ;获取组件的UValue
  WIDGET_CONTROL, ev.ID, GET_UVALUE=uName
  
  ;如存在则进行处理
  IF (N_ELEMENTS(uName) NE 0) THEN BEGIN
    ;点击的是树叶
    IF (uName EQ 'LEAF') THEN BEGIN
      ;双击
      IF (ev.CLICKS EQ 2) THEN TWE_TOGGLEVALUE, ev.ID
    ENDIF
    ;点击的是按钮
    IF (uName EQ 'DONE') THEN WIDGET_CONTROL, ev.TOP, /DESTROY
  ENDIF
  
END

;修改树叶节点值
PRO TWE_TOGGLEVALUE, widID
  COMPILE_OPT hidden
  
  ;获取当前ID的值
  WIDGET_CONTROL, widID, GET_VALUE=curVal
  ;字符串拆解
  full_string = STRSPLIT(curVal, ':', /EXTRACT)
  ;判断字符串内容，在On和Off之间互换.
  full_string[1] = (full_string[1] EQ ' Off') ? ': On' : ': Off'
  ;设置组件value
  WIDGET_CONTROL, widID, SET_VALUE=STRJOIN(full_string)
END

;组件
PRO WIDGET_TREE_EXAMPLE
  ;创建界面.
  wTLB = WIDGET_BASE(/COLUMN, TITLE='Widget_Tree Example')
  ; 创建tree组件.
  wTree = WIDGET_TREE(wTLB)
  ;创建树根.
  wtRoot = WIDGET_TREE(wTree, VALUE='根', /FOLDER, /EXPANDED)
  ;创建树叶
  wtLeaf11 = WIDGET_TREE(wtRoot, VALUE='设置 1-1: Off', $
    UVALUE='LEAF')
  wtBranch12 = WIDGET_TREE(wtRoot, VALUE='树枝 1-2', $
    /FOLDER, /EXPANDED)
  wtLeaf121 = WIDGET_TREE(wtBranch12, VALUE='设置 1-2-1: Off', $
    UVALUE='LEAF')
  wtLeaf122 = WIDGET_TREE(wtBranch12, VALUE='设置 1-2-2: Off', $
    UVALUE='LEAF')
  wtLeaf13 = WIDGET_TREE(wtRoot, VALUE='设置 1-3: Off', $
    UVALUE='LEAF')
  wtLeaf14 = WIDGET_TREE(wtRoot, VALUE='设置 1-4: Off', $
    UVALUE='LEAF')    
  ;创建按钮.
  wDone = WIDGET_BUTTON(wTLB, VALUE="确定", UVALUE='DONE')  
  ;例示.
  WIDGET_CONTROL, wTLB, /REALIZE
  XMANAGER, 'tree_widget_example', wTLB, /NO_BLOCK
  
END

