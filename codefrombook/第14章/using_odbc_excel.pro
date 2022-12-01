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
PRO USING_ODBC_EXCEL
  filename = FILE_DIRNAME(ROUTINE_FILEPATH('Using_ODBC_EXCEL'))+'\SatelliteInformation.xlsx'
  ; 判断是否支持数据库功能
  IF DB_EXISTS() EQ 0 THEN BEGIN
    msg = DIALOG_MESSAGE('不支持ODBC!',/Error)
    RETURN
  ENDIF
  ; 新建数据库对象
  oDatabase = OBJ_NEW('IDLdbDatabase')
  ; 检查当前可用数据类型
  sources = oDatabase->GETDATASOURCES()
  index = WHERE(sources.DATASOURCE EQ 'Excel Files',count)
  IF count EQ 0 THEN BEGIN
    msg = DIALOG_MESSAGE('ODBC无法读取Excel Files',/Error)
    OBJ_DESTROY,oDatabase
    RETURN
  ENDIF
  ;连接数据库
  IF ~FILE_TEST(filename) THEN BEGIN
    msg = DIALOG_MESSAGE('找不到数据库文件!',/Error)
    OBJ_DESTROY,oDatabase
    RETURN
  ENDIF
  ; 连接到我们指定的数据库文件
  oDatabase->CONNECT,DATASOURCE='Excel Files;DBQ='+filename
  ;连接数据库
  oDatabase->GETPROPERTY,IS_CONNECTED = connectStat
  IF connectStat EQ 0 THEN BEGIN
    msg = DIALOG_MESSAGE('数据库连接不成功...',/Error)
    OBJ_DESTROY,oDatabase
    RETURN
  ENDIF
  
  ;读取数据库内数据,获取数据表
  tables = oDatabase->GETTABLES()
  nTables = N_ELEMENTS(tables)
  FOR i=0, nTables-1 DO BEGIN
    ; 操作指定表,注意表名，要加“[]”。
    tname = '[' + tables[i].NAME + ']'
    PRINT, 'table name', tname
    
    oRecordset = OBJ_NEW('IDLdbRecordset',oDatabase,table=tname);, SQL=sqlstr)
    ; 获取字段信息
    oRecordset->GETPROPERTY,field_info = fieldinfo
    NFileds = N_ELEMENTS(fieldinfo)
    ;获取数据表中的记录数目
    IF oRecordset->MOVECURSOR(/first) THEN BEGIN
      FOR j=0, NFileds-1 DO BEGIN
        Value = oRecordset->GETFIELD(j)
        PRINT, 'Talbe: ' + (fieldinfo.TABLE_NAME)[j] + ', ' + $
          'Filed Name: ' + (fieldinfo.FIELD_NAME)[j] + ', ' + $
          'Value: ', Value
      ENDFOR
      WHILE oRecordset->MOVECURSOR(/next) DO BEGIN
        FOR j=0, NFileds-1 DO BEGIN
          Value = oRecordset->GETFIELD(j)
          PRINT, 'Talbe: ' + (fieldinfo.TABLE_NAME)[j] + ', ' + $
            'Filed Name: ' + (fieldinfo.FIELD_NAME)[j] + ', ' + $
            'Value: ', Value
        ENDFOR
      ENDWHILE
    ENDIF ELSE BEGIN ; 一条记录都没有
      msg = DIALOG_MESSAGE('数据表无记录',/Infor)
      OBJ_DESTROY, oRecordset
    ENDELSE
    ; 销毁数据库对象
    OBJ_DESTROY, oRecordset
  ENDFOR
  OBJ_DESTROY,oDatabase
END