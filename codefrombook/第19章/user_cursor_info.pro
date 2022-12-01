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
;经纬度转度分秒
FUNCTION LLTODMS,oxmap
  COMPILE_OPT idl2
  absoxmap = ABS(oxmap)
  degree = FIX(absoxmap)
  minute = FIX((absoxmap-degree)*60)
  second = FIX(((absoxmap-degree)*60-minute)*60)  
  degree = STRTRIM(degree,2)
  minute = STRTRIM(minute,2)
  second = STRTRIM(second,2)
  ;补0操作
  IF STRLEN(minute) LT 2 THEN minute = '0'+minute
  IF STRLEN(second) LT 2 THEN second = '0'+second  
  dms = degree+'度'+minute+'分'+second+'秒'  
  RETURN, dms  
END
;
;鼠标移动时的位置数据显示
;
PRO USER_CURSOR_INFO, dn, xloc, yloc, xstart=xstart, ystart=ystart
  COMPILE_OPT idl2
  COMMON ud_move_2_c, ud_wid, data
  ;
  ;判断组件界面是否创建
  IF (N_ELEMENTS(ud_wid) EQ 0) THEN ud_wid = -1L
  IF (WIDGET_INFO(ud_wid, /valid) EQ 0) THEN BEGIN  
    ; 创建鼠标位置信息显示界面  
    title = '鼠标位置经纬度显示'
    ;界面居中
    ENVI_CENTER,  xoff, yoff
    base = WIDGET_BASE(title=title, xoff=xoff, yoff=yoff, $
      /row, group=envi_main_base(),TLB_FRAME_ATTR = 1)
    sb   = WIDGET_BASE(base, /column, /frame)
    sb1  = WIDGET_BASE(sb, /col)
    lab  = WIDGET_LABEL(sb1, value='鼠标信息')
    tw   = WIDGET_TEXT(sb1, value='Data display area.', xs=40, ys=5)
    WIDGET_CONTROL,base,/realize 
    data = {tw:tw}
    ud_wid = base    
  ENDIF  
  ;获得当前文件信息，其中fid、pos、Color等都作为返回信息
  ENVI_DISP_QUERY, dn, fid=fid, pos=pos, color=color
  ;读取map信息
  map_info = ENVI_GET_MAP_INFO(fid=fid,UNDEFINED=UNDEFINED)
  iproj = map_info.PROJ
  ;若未定义则提示
  IF UNDEFINED THEN BEGIN
    msg = ['Disp #' + STRTRIM(STRING(dn+1),2)+ ' (' + STRTRIM(STRING(LONG(xloc)+1),2) $
      + ',' + STRTRIM(STRING(LONG(yloc)+1),2)+')' , $
      'Projection: 未定义']
  ENDIF ELSE BEGIN
    ENVI_CONVERT_FILE_COORDINATES, fid, xloc, yloc, xmap, ymap, /to_map
    ;时时获取鼠标位置信息，转换为经纬度坐标显示
    oproj = ENVI_PROJ_CREATE(/geographic)
    ENVI_CONVERT_PROJECTION_COORDINATES, $
      xmap, ymap, iproj, $
      oxmap, oymap, oproj	;
    IF oxmap LT 0 THEN xPre ='西经' ELSE xPre ='东经'
    IF oymap LT 0 THEN yPre ='南纬' ELSE yPre ='北纬'
    xxmap = LLTODMS(oxmap)
    yymap = LLTODMS(oymap)
    msg = ['Disp #' + STRTRIM(STRING(dn+1),2)+ '(' + STRTRIM(LONG(xloc+1),2) $
      + ',' + STRTRIM(LONG(yloc)+1,2)+')' , $
      'Projection: '+iproj.NAME, $
      'LL-1: '+yPre+yymap+','+xPre+xxmap,$
      'LL-2: '+STRTRIM(STRING(oymap,format='(f0.4)'),2)+$
      '度,'+STRTRIM(STRING(oxmap,format='(f0.4)'),2)+'度']
  ENDELSE
  ;更新鼠标位置信息
  WIDGET_CONTROL, data.TW, set_value=msg, /no_copy
END
