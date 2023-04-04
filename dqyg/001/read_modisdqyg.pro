pro read_modisdqyg
  hdfid=hdf_sd_start('R:\JX\dqyg\sy1\data\MOD021KM.A2008125.0320.005.2009283065904.hdf')
  index=hdf_sd_nametoindex(hdfid,'EV_1KM_RefSB')
  varid=hdf_sd_select(hdfid,index)
  hdf_sd_getdata,varid,ref
  hdf_sd_endaccess,varid
  hdf_sd_end,hdfid
  print,'ref[0,0,0]:',ref[0,0,0]
  print,'size(ref):',size(ref)
end
