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
;事件程序
PRO WIDGET_TABLE_EXAMPLE_EVENT,ev
  ;获取组件的uname
  uName = WIDGET_INFO(ev.id,/uName)
  
  
  ;基于组件名称响应事件
  IF uName EQ 'table1' THEN BEGIN
    ;
    IF ev.type EQ 4 THEN BEGIN
      IF ev.sel_left NE -1 THEN BEGIN
        tmp  = DIALOG_MESSAGE('选中的左上角行列号:'+STRTRIM(ev.sel_top,2)+STRTRIM(ev.sel_Left,2) $
          +'右下角行列号:'+STRTRIM(ev.sel_bottom,2)+STRTRIM(ev.sel_right,2),/infor)
      ENDIF
    ENDIF
  ENDIF
  IF uName EQ 'showInfo1' THEN BEGIN
    ;利用Widget_info来获得table1的ID
    tableID = WIDGET_INFO(ev.top,  $
      Find_By_UName='table1')
    IF tableID NE 0 THEN BEGIN
      ;获取表格的值
      WIDGET_CONTROL,tableID, get_Value = sValue
      PRINT,sValue
      ;默认返回定点索引
      PRINT,'当前选择',WIDGET_INFO(tableID,/TABLE_SELECT )
    ENDIF
  ENDIF
  IF uName EQ 'showInfo2' THEN BEGIN
    ;利用Widget_info来获得table1的ID
    tableID = WIDGET_INFO(ev.top,  $
      Find_By_UName='table2')    ;
    IF tableID NE 0 THEN BEGIN
      WIDGET_CONTROL,tableID, get_Value = sValue
      PRINT,'当前选择',WIDGET_INFO(tableID,/TABLE_SELECT )
    ENDIF
  ENDIF
END
;表格组件演示
PRO WIDGET_TABLE_EXAMPLE
  ;创建tlb
  tlb = WIDGET_BASE(title='Widget_Table演示', $
    /Column, $
    uname='wtlb' )
  ;创建表格组件，响应所有事件
  table1 = WIDGET_TABLE(tlb, $
    uName  = 'table1', $
    xsize = 4, ysize = 6, $
    /All_Events)
  ;创建一个按钮
  showInfo = WIDGET_BUTTON(tlb, $
    value ='查看表1', $
    uName  = 'showInfo1')
  ;创建表格组件，可编辑可矩形选择
  table2 = WIDGET_TABLE(tlb, $
    /DISJOINT_SELECTION, $
    /Editable,$
    COLUMN_LABELS = '列'+STRTRIM(INDGEN(5),2), $
    xsize = 3, ysize = 3, $
    uName  = 'table2')
  ;创建一个按钮
  showInfo = WIDGET_BUTTON(tlb, $
    value ='查看表2', $
    uName  = 'showInfo2')
  ;例示
  WIDGET_CONTROL,tlb,/realize
  ;表格内容赋初值
  WIDGET_CONTROL, table2, set_value = INDGEN(3,3)
  ;
  XMANAGER,'WIDGET_TABLE_EXAMPLE',tlb,/no_block
END