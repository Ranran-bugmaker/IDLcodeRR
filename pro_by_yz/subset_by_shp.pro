;;;;image_dir为影像路径
;;;;vector_dir矢量路径
;;;;outfile_dir裁剪后结果路径
pro subset_by_shp,in_tifffile,shpfile,out_tifffile
  compile_opt idl2
  envi,/restore_base_save_files
  envi_batch_init,/no_status_window

  catch, err
  if (err ne 0) then begin
    catch, /cancel
    print, 'error: ' + !error_state.msg
    message, /reset
    return
  endif
  
  envi_open_file, in_tifffile, r_fid=fid
  envi_file_query, fid, ns=ns, nl=nl, nb=nb, $
    dims=dims, fname=fname, bnames=bnames
  pos  = lindgen(nb)
  
  ;读取shp文件的信息
  oshp=obj_new('idlffshape',shpfile)
  if ~obj_valid(oshp) then return
  oshp->getproperty,n_entities=n_ent,$ ;记录个数
    attribute_info=attr_info,$ ;属性信息，结构体， name为属性名
    attribute_names = attr_names, $
    n_attributes=n_attr,$ ;属性个数
    entity_type=ent_type  ;记录类型

  iproj = envi_proj_create(/geographic)
  ;自动读取prj文件获取投影坐标系
  potpos = strpos(shpfile,'.',/reverse_search)  ;
  prjfile = strmid(shpfile,0,potpos[0])+'.prj'
  if file_test(prjfile) then begin
    openr, lun, prjfile, /get_lun
    strprj = ''
    readf, lun, strprj
    free_lun, lun

    case strmid(strprj, 0,6) of
      'GEOGCS': begin
        iproj = envi_proj_create(pe_coord_sys_str=strprj, $
          type = 1)
      end
      'PROJCS': begin
        iproj = envi_proj_create(pe_coord_sys_str=strprj, $
          type = 42)
      end
    endcase
  endif
  
  oproj = envi_get_projection(fid = fid)
  ;然后使用roi进行掩膜统计
  roi_ids = !null
  for i = 0, n_ent-1 do begin
    ;
    ent = oshp->getentity(i, /attributes) ;第i条记录

    ;如果ent不是多边形，则继续
    if ent.shape_type ne 5 then continue

    n_vertices=ent.n_vertices ;顶点个数

    parts=*(ent.parts)

    verts=*(ent.vertices)
    ; 将顶点坐标转换为输入文件的地理坐标
    envi_convert_projection_coordinates,  $
      verts[0,*], verts[1,*], iproj,    $
      oxmap, oymap, oproj
    ; 转换为文件坐标
    envi_convert_file_coordinates,fid,    $
      xfile,yfile,oxmap,oymap

    if (min(xfile) ge ns or $
      min(yfile) ge nl or $
      max(xfile) le 0 or $
      max(yfile) le 0) and i ne 0 then continue

    ;记录xy的区间，裁剪用
    if i eq 0 then begin
      xmin = round(min(xfile,max = xmax))
      ymin = round(min(yfile,max = ymax))
    endif else begin
      xmin = xmin < round(min(xfile))
      xmax = xmax > round(max(xfile))
      ymin = ymin < round(min(yfile))
      ymax = ymax > round(max(yfile))
    endelse

    ;创建roi
    n_parts = n_elements(parts)

    for j=0, n_parts-1 do begin
      roi_id = envi_create_roi(color=i,     $
        ns = ns ,  nl = nl)
      if j eq n_parts-1 then begin
        tmpfilex = xfile[parts[j]:*]
        tmpfiley = yfile[parts[j]:*]
      endif else begin
        tmpfilex = xfile[parts[j]:parts[j+1]-1]
        tmpfiley = yfile[parts[j]:parts[j+1]-1]
      endelse

      envi_define_roi, roi_id, /polygon,    $
        xpts=reform(tmpfilex), ypts=reform(tmpfiley)

      ;如果有的roi像元数为0，则不保存
      envi_get_roi_information, roi_id, npts=npts
      if npts eq 0 then continue

      roi_ids = [roi_ids, roi_id]
    endfor
  endfor
  ;创建掩膜，裁剪后掩
  envi_mask_doit,         $
    and_or = 2,           $
    in_memory=0,          $
    roi_ids= roi_ids,     $
    ns = ns, nl = nl,     $
    inside=1,        $
    r_fid = m_fid,        $
    out_name = envi_get_tmp()

  xmin = xmin >0
  xmax = round(xmax) < (ns-1)
  ymin = ymin >0
  ymax = round(ymax) < (nl-1)
  out_dims = [-1,xmin,xmax,ymin,ymax]

  envi_mask_apply_doit, fid = fid,      $
    pos = pos,                          $
    dims = out_dims,                    $
    m_fid = m_fid, m_pos = [0],         $
    value = 0, /in_memory, r_fid = r_fid

  ; 掩膜文件id移除
  envi_file_mng, id = m_fid,/remove,/delete

  obj_destroy,oshp
  
  envi_file_query,r_fid,dims=data_dims,data_type=data_type
  out_data=envi_get_data(fid=r_fid,pos=pos,dims=data_dims)

  map_info=envi_get_map_info(fid=r_fid)
  geo_loc=map_info.(1)
  px_size=map_info.(2)

  geo_info={$
    MODELPIXELSCALETAG:[px_size[0],px_size[1],0.0],$
    MODELTIEPOINTTAG:[0.0,0.0,0.0,geo_loc[2],geo_loc[3],0.0],$
    GTMODELTYPEGEOKEY:2,$
    GTRASTERTYPEGEOKEY:1,$
    GEOGRAPHICTYPEGEOKEY:4326,$
    GEOGCITATIONGEOKEY:'GCS_WGS_1984',$
    GEOGANGULARUNITSGEOKEY:9102}

  case data_type of
      1: write_tiff,out_tifffile,out_data,geotiff=geo_info
      2: write_tiff,out_tifffile,out_data,/short,/signed,geotiff=geo_info
      3: write_tiff,out_tifffile,out_data,/long,/signed,geotiff=geo_info
      4: write_tiff,out_tifffile,out_data,/float,geotiff=geo_info
      5: write_tiff,out_tifffile,out_data,/double,geotiff=geo_info
      6: write_tiff,out_tifffile,out_data,/complex,geotiff=geo_info
      9: write_tiff,out_tifffile,out_data,/dcomplex,geotiff=geo_info
      12: write_tiff,out_tifffile,out_data,/short,geotiff=geo_info
      13: write_tiff,out_tifffile,out_data,/long,geotiff=geo_info
      14: write_tiff,out_tifffile,out_data,/l64,/signed,geotiff=geo_info
      15: write_tiff,out_tifffile,out_data,/l64,geotiff=geo_info
    endcase
    envi_batch_exit
end