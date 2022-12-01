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

;ENVI下创建evf的示例代码
;
PRO USING_ENVI_Create_EVF
  COMPILE_OPT IDL2
  ;创建经纬度投影
  proj = ENVI_PROJ_CREATE(/geographic)
  ;定义经纬度离散点
  points = [-106.572, 39.6643, $
    -106.643, 39.5218, $
    -106.453, 39.4386, $
    -106.417, 39.6168, $
    -106.595, 39.4386  ]
  ;点集重组为5*2的点
  points = REFORM(points, 2, 5)
  ;定义折线经纬度点坐标集合
  polyline = [-106.904, 41.5887, $
    -106.821, 42.2302, $
    -106.013, 42.2183, $
    -105.206, 41.3749, $
    -105.657, 40.5078, $
    -105.835, 39.5574, $
    -105.170, 38.8447, $
    -104.125, 39.4862, $
    -103.269, 40.0563, $
    -103.269, 40.0682, $
    -102.913, 39.0585, $
    -102.901, 39.0585, $
    -102.901, 39.0348, $
    -103.210, 38.4289, $
    -103.804, 38.3695]
  ;点集重组为15*2的点
  polyline = REFORM(polyline, 2, 15)
  ;定义多边形顶点坐标集合
  polygon = [-104.113, 41.6956, $
    -103.994, 42.1589, $
    -103.934, 41.6838, $
    -103.471, 41.8738, $
    -103.887, 41.5531, $
    -103.863, 41.0185, $
    -103.851, 41.0185, $
    -104.041, 41.4818, $
    -104.041, 41.4937, $
    -104.552, 41.2680, $
    -104.220, 41.6006, $
    -104.422, 42.0995, $
    -104.113, 41.6956]
  ;点集重组为13*2的点
  polygon = REFORM(polygon, 2, 13)
  
  ;初始化创建evf
  evf_ptr = ENVI_EVF_DEFINE_INIT('c:\temp\sample.evf', $
    projection=proj, data_type=4, $
    layer_name='Sample EVF File')
  ;创建失败则返回
  IF (PTR_VALID(evf_ptr) EQ 0) THEN RETURN
  ;添加离散点记录
  FOR i=0,4 DO ENVI_EVF_DEFINE_ADD_RECORD, evf_ptr, points[*,i]
  ;添加折线记录
  ENVI_EVF_DEFINE_ADD_RECORD, evf_ptr, polyline
  ;添加多边形记录
  ENVI_EVF_DEFINE_ADD_RECORD, evf_ptr, polygon
  
  ;EVF文件定义完毕，关闭文件
  evf_id = ENVI_EVF_DEFINE_CLOSE(evf_ptr, /return_id)
  ENVI_EVF_CLOSE, evf_id
  ;定义属性文件,1-5为点文件,6为折线,7为多边形
  attributes = REPLICATE( {name:'', id:0L}, 7)
  FOR i=0,4 DO BEGIN
    attributes[i].NAME = 'Sample Point ' + STRTRIM(i+1,2)
    attributes[i].ID = i+1
  ENDFOR
  attributes[5].NAME = 'Sample Polyline'
  attributes[5].ID = 6
  attributes[6].NAME = 'Sample Polygon'
  attributes[6].ID = 7
  ;写出矢量属性文件
  ENVI_WRITE_DBF_FILE, 'c:\temp\sample.dbf', attributes
  
END
