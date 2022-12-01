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

PRO USING_ENVI_TILE_WRITEFILE
  COMPILE_OPT IDL2
  
  ;恢复ENVI的sav文件
  ENVI, /RESTORE_BASE_SAVE_FILES
  ;初始化ENVI，并保存日志文件
  ENVI_BATCH_INIT
  ;ENVI函数打开文件
  ENVI_OPEN_FILE, fname, r_fid=fid
  ;选择输出文件名
  out_name = DIALOG_PICKFILE(title='选择输出文件名', $
    /Write)
  IF out_name EQ '' THEN   RETURN
  
  ;打开输入文件，获取文件ID
  ENVI_OPEN_FILE,fname,R_fid = fid
  
  IF (fid EQ -1) THEN RETURN
  ;根据文件ID，查询文件基本信息
  ENVI_FILE_QUERY, fid, $
    data_type=data_type, $
    ns=ns, $
    nl=nl, $
    nb=nb, $
    dims=dims
  pos = lindgen(nb)
  ;打开文件，并获取文件设备号unit
  OPENW, unit, out_name, /get_lun
  ;ENVI分块初始化操作
  tile_id = ENVI_INIT_TILE(fid, pos, interleave=0, $
    num_tiles=num_tiles, xs=dims[1], xe=dims[2], $
    ys=dims[3], ye=dims[4])
  ;依次读取块对应数据
  FOR i=0L, num_tiles-1 DO BEGIN
    ;获取块数据
    data = ENVI_GET_TILE(tile_id, i, band_index=band_index)
    ;查看当前块索引与波段索引
    PRINT, i, band_index
    ;将读出的块数据存储到文件中
    WRITEU, unit, data
  ENDFOR
  ;关闭文件设备号
  FREE_LUN, unit
  
  ;设置输出文件的hdr头信息内容
  ENVI_SETUP_HEAD, $
    fname=out_name, $     ;输出文件名
    ns=ns, $              ;数据行数
    nl=nl, $              ;数据列数
    nb=nb, $              ;波段数
    data_type=data_type, $;数据类型
    offset=0, $           ;偏移量
    interleave=0, $      ;存储格式
    descrip='save envi standard file',$;文件描述信息
    /write                ;写出到文件
    
  ;关闭块ID
  ENVI_TILE_DONE, tile_id
  ;ENVI二次开发模式关闭
  ENVI_BATCH_EXIT
  
  
END

