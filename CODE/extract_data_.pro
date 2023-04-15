pro extract_data_

  hdfid=hdf_sd_start('D:\text\MOD05_L2.A2008125.0320.005.2008126075028.hdf')
  index=hdf_sd_nametoindex(hdfid,'Water_Vapor_Near_Infrared')
  varid=hdf_sd_select(hdfid,index)
  hdf_sd_getdata,varid,jin
  hdf_sd_endaccess,varid
  hdf_sd_end,hdfid

  hdfid=hdf_sd_start('D:\text\MOD03.A2008125.0320.005.2008125132121.hdf')
  index=hdf_sd_nametoindex(hdfid,'Longitude')
  varid=hdf_sd_select(hdfid,index)
  hdf_sd_getdata,varid,lon
  hdf_sd_endaccess,varid
  hdf_sd_end,hdfid

  hdfid=hdf_sd_start('D:\text\MOD03.A2008125.0320.005.2008125132121.hdf')
  index=hdf_sd_nametoindex(hdfid,'Latitude')
  varid=hdf_sd_select(hdfid,index)
  hdf_sd_getdata,varid,lat
  hdf_sd_endaccess,varid
  hdf_sd_end,hdfid

  a=size(jin)

  openw,1,'data1.txt'

  for ii=0,a[1]-1 do begin
    for jj=0,a[2]-1 do begin

      printf,1,lon[ii,jj],lat[ii,jj],jin[ii,jj]*0.0013

    endfor
  endfor

  close,1

end
