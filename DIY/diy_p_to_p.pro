PRO DIY_p_to_p,data,lon,lat,out_data,DPI=DPI
  ;
  lon_data=lon/DPI
  
  out_col_num=ceil((max(lon_data)-min(lon_data))/DPI)
  out_line_num=ceil((max(lat_data)-min(lat_data))/DPI)
  col_out=floor((lon_data-min(lon_data))/DPI)
  line_out=floor((max(lat_data)-lat_data)/DPI)

END