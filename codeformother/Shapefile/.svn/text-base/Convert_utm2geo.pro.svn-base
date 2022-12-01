PRO Convert_UTM2GEO
	Compile_Opt strictarr
	workspace='e:\GeoGlobe\glacier\images\'
	outpath='e:\GeoGlobe\glacier\ETM_Geo\'
  path_raw=["p134r033","p134r034","p134r035","p134r039","p134r040","p150r032","p150r033","p150r034",$
            "p141r027","p141r030","p141r034","p141r035","p141r036","p141r037","p141r038","p141r039",$
            "p141r040","p141r041","p132r034","p132r037","p132r038","p132r039","p132r040","p132r041",$
            "p148r029","p148r031","p148r032","p148r034","p148r035","p148r036","p139r030","p139r034",$
            "p139r035","p139r036","p139r037","p139r038","p139r039","p139r040","p139r041","p130r037",$
            "p130r038","p146r029","p146r030","p146r031","p146r035","p146r036","p146r037","p146r038",$
            "p146r039","p137r033","p137r035","p137r036","p137r037","p137r038","p137r039","p137r040",$
            "p137r041","p144r026","p144r027","p144r029","p144r030","p144r031","p144r035","p144r036",$
            "p144r037","p144r038","p144r039","p144r040","p135r033","p135r034","p135r035","p135r037",$
            "p135r038","p135r039","p135r040","p135r041","p151r032","p151r033","p142r027","p142r030",$
            "p142r034","p142r035","p142r036","p142r037","p142r038","p142r039","p142r040","p133r033",$
            "p133r034","p133r035","p133r036","p133r038","p133r039","p133r040","p133r041","p149r031",$
            "p149r032","p149r033","p149r034","p149r035","p140r033","p140r034","p140r035","p140r036",$
            "p140r037","p140r038","p140r039","p140r040","p140r041","p131r038","p131r039","p131r040",$
            "p131r041","p131r042","p147r028","p147r029","p147r030","p147r031","p147r034","p147r035",$
            "p147r036","p138r030","p138r033","p138r035","p138r036","p138r037","p138r038","p138r039",$
            "p138r040","p138r041","p145r026","p145r027","p145r029","p145r030","p145r031","p145r035",$
            "p145r036","p145r037","p145r038","p145r039","p136r033","p136r034","p136r035","p136r036",$
            "p136r037","p136r038","p136r039","p136r040","p136r041","p143r026","p143r027","p143r030",$
            "p143r031","p143r034","p143r035","p143r036","p143r037","p143r038","p143r039","p143r040"]
  
  

	ENVI, /RESTORE_BASE_SAVE_FILES
	ENVI_BATCH_INIT, LOG_FILE = 'batch.log'

	filelist=file_search(workspace+'*.img',count=count)
	FOR i=0,count-1 do begin
		Filename=filelist[i]
		basename=file_basename(filename)
		pathraw_string=strmid(basename,0,8)
		index=where(path_raw eq pathraw_string)
		if index gt -1 then begin
		pm,index
		print,'========================================================'
		endif
;		
		out_name=outpath+'geo_'+basename

		ENVI_open_file,filename,r_fid=fid
		Envi_file_query,fid,ns=ns,nl=nl,dims=dims

		zone=strmid(basename,21,2)
		oproj=ENVI_Proj_Create(/Geographic)
		o_pixel_size=[0.0002000D,0.0002000D]


		ENVI_Convert_file_map_projection,fid=fid,pos=[4,3,2],$
			dims=dims,o_proj=oproj,o_pixel_size=o_pixel_size,grid=[25,25],out_name=out_name,$
			warp_method=2,resampling=1,background=0,/ZERO_EDGE

	ENDFOR
	ENVI_batch_exit
	print,'====end===='
END