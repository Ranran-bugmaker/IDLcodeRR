;
; IDL Event Callback Procedures
; GIMMS_TOOLS_eventcb
;
; Generated on:	03/23/2008 19:38.03
;
;
; Empty stub procedure used for autoloading.;

;参数初始化
pro InitShow, wWidget

	Boundary_id=Widget_Info(wWidget, FIND_BY_UNAME='Boundary_DROPLIST')
	OutFormate_id=Widget_Info(wWidget,Find_By_UName='OutFormate_DROPLIST')
	Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')

	Boundary=['中国子区（西部数据中心专用）','黑河流域','自定义']
	Widget_Control,Boundary_id,set_value=Boundary
	Formate=['ENVI (.img)','Geo TIFF','ESRI GRID','ESRI ASCII','ERDAS IMAGE']
	Widget_Control,OutFormate_id,set_value=Formate
	MessageText=['版本:2.0'+string(13b),$
	            '日期:2008-3-25'+string(13b),$
	            '作者:Wulizong'+string(13b),$
	            'Email:wulizong@lzb.ac.cn'+string(13b),$
	            '单位:中国科学院寒区旱区环境与工程研究所'+string(13b),$
	            '地址:甘肃省兰州市东岗西路320号'+string(13b),$
	            '邮编:730000'+string(13b),$
	            '电话:0931-4967298'+string(13b),$
	            '致谢:本程序受到基金委西部生态环境数据中心和地球系统科学数据中心的联合资助'+string(13b),$
	            '程序使用说明:'+string(13b),$
	            '1.本程序需要调用ENVI的函数,请确认计算机中已经安装了ENVI.'+string(13b),$
	            '2.数据的输出存放目录格式为:'+string(13b),$
	            '    输出目录/'+string(13b),$
	            '            1981/'+string(13b),$
	            '            1982/'+string(13b),$
	            '            ..../'+string(13b),$
	            '*****程序修改历史***********'+string(13b),$
	            'v2,0 2008-3-25 程序修改为界面'+string(13b),$
              'v1.1 2008-3-16 程序基于从Gimms FTP站点上下载的原始数据上运行的，程序自动解压缩，然后再切割，可以设置输出多种数据格式'+string(13b),$
              'v1.0 2007-8-1  基于已经转换好的ENVI格式的全球数据进行切割的，不能对其它格式的数据进行读取']

	Widget_Control,Message_id,set_value=messageText
  ;定义全局变量
  out_message=['---输出设置---'+string(13b),'','','','','']
  bound={north:0.0,south:0.0,west:0.0,east:0.0}
  help,out_message
  info={bound_Type:'',bound:bound,inpath:'',outpath:'',OutFormate:'',$
        out_message:out_message}
  pinfo=ptr_new(info,/No_Copy)
  Widget_Control,wWidget,set_uvalue=pinfo
end
;-------选择数据输入目录----------------------
pro OpenGIMMS, Event
	wWidget =  Event.top
  Widget_Control,wWidget,get_Uvalue=pinfo

	Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')
	FilePath_id=Widget_Info(wWidget,Find_By_UName='FilePath_TEXT')
   Workspace=DIALOG_PICKFILE(/DIRECTORY)
   filelist=File_Search(Workspace,'*.gz',count=count)

   Out_Message='目录中共有*.gz格式的文件'+strtrim(string(count),2)+'个'

   (*pinfo).Out_Message[1]=Out_message+string(13b)
   Widget_Control,FilePath_id,set_value=workspace
   Widget_Control,Message_id,set_value=(*pinfo).Out_Message
   (*pinfo).inpath=workspace

end

;-----------------------------------------------------------------
;设置切割范围
pro Set_Boundary, Event
  wWidget =  Event.top
  Widget_Control,wWidget,get_Uvalue=pinfo

  Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')

  Boundary_id=Widget_Info(wWidget, FIND_BY_UNAME='Boundary_DROPLIST')
  North_id=Widget_Info(wWidget, FIND_BY_UNAME='North_TEXT')
  South_id=Widget_Info(wWidget, FIND_BY_UNAME='South_TEXT')
  West_id=Widget_Info(wWidget, FIND_BY_UNAME='West_TEXT')
  East_id=Widget_Info(wWidget, FIND_BY_UNAME='East_TEXT')
  index=widget_info(Boundary_id,/DROPLIST_SELECT)
  widget_control,Boundary_id,get_value=bound_type
  (*pinfo).bound_Type=bound_type[index]
  case index of
  0:begin
  widget_Control,North_id,set_value='45',Editable=0
  widget_Control,South_id,set_value='15',Editable=0
  widget_Control,West_id,set_value='70',Editable=0
  widget_Control,East_id,set_value='140',Editable=0

	(*pinfo).bound.north=45.0
	(*pinfo).bound.south=15.0
	(*pinfo).bound.west=70.0
	(*pinfo).bound.east=140.0
	(*pinfo).Out_Message[2]='你选择的切割范围是中国子区'+string(13b)
  end
  1:begin
  widget_Control,North_id,set_value='41',Editable=0
  widget_Control,South_id,set_value='38',Editable=0
  widget_Control,West_id,set_value='99',Editable=0
  widget_Control,East_id,set_value='102',Editable=0

	(*pinfo).bound.north=41.0
	(*pinfo).bound.south=38.0
	(*pinfo).bound.west=99.0
	(*pinfo).bound.east=102.0
	(*pinfo).Out_Message[2]='你选择的切割范围是黑河流域'+string(13b)
  end
  2:begin
  widget_Control,North_id,set_value='', EDITABLE=1
  widget_Control,South_id,set_value='', EDITABLE=1
  widget_Control,West_id,set_value='', EDITABLE=1
  widget_Control,East_id,set_value='', EDITABLE=1
  (*pinfo).Out_Message[2]='你选择的切割范围是自定义区域'+string(13b)
  end
  endcase
  Widget_Control,Message_id,set_value=(*pinfo).Out_Message
end


;-----------------------------------------------------------------
;设置输出格式
pro Set_OutFormate, Event
   wWidget =  Event.top
   Widget_Control,wWidget,get_Uvalue=pinfo

	 OutFormate_id=Widget_Info(wWidget,Find_By_UName='OutFormate_DROPLIST')
   Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')

   index=Widget_Info(OutFormate_id,/DROPLIST_SELECT)
   widget_control,OutFormate_id,get_value=OutFormate

   (*pinfo).OutFormate=OutFormate[index]
   (*pinfo).Out_Message[3]='你选择的输出格式为 '+OutFormate[index]+string(13b)
   Widget_Control,Message_id,set_value=(*pinfo).Out_Message
end
;设置输出路径
pro Set_Outpath, Event
   wWidget =  Event.top
   Widget_Control,wWidget,get_Uvalue=pinfo

	 OutPath_id=Widget_Info(wWidget,Find_By_UName='OutPath_TEXT')
	 Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')
   Outpath=DIALOG_PICKFILE(/DIRECTORY)


   Widget_Control,OutPath_id,set_value=OutPath
   (*pinfo).Out_Message[4]='输出路径为 '+Outpath+string(13b)
   (*pinfo).outpath=Outpath
   Widget_Control,Message_id,set_value=(*pinfo).Out_Message
end


;-----------------------------------------------------------------
pro Run, Event
  Compile_opt strictarr

  wWidget =  Event.top
  Widget_Control,wWidget,get_uValue=pinfo


	Message_id=Widget_Info(wWidget,Find_By_UName='Message_TEXT')

  info=*pinfo
  if info.bound_Type eq '自定义' then begin
  	North_id=Widget_Info(wWidget, FIND_BY_UNAME='North_TEXT')
  	South_id=Widget_Info(wWidget, FIND_BY_UNAME='South_TEXT')
  	West_id=Widget_Info(wWidget, FIND_BY_UNAME='West_TEXT')
  	East_id=Widget_Info(wWidget, FIND_BY_UNAME='East_TEXT')
  	Widget_Control,North_id,Get_value=north_str
  	Widget_Control,South_id,Get_value=south_str
  	Widget_Control,West_id,Get_value=west_str
  	Widget_Control,East_id,Get_value=east_str

  	(*pinfo).bound.north=float(north_str)
  	(*pinfo).bound.south=float(south_str)
  	(*pinfo).bound.west=float(west_str)
  	(*pinfo).bound.east=float(east_str)
  endif
  if info.inpath eq '' then begin
    Widget_Control,Message_id,set_value='没有设置输入路径!'
    return
  endif
  if info.bound_Type eq '' then begin
    Widget_Control,Message_id,set_value='没有设置切割范围!'
    return
  endif
  if info.outformate eq '' then begin
  	Widget_Control,Message_id,set_value='没有设置输出格式!'
    return
  endif
  if info.outpath eq '' then begin
  	Widget_Control,Message_id,set_value='没有设置输出路径!'
    return
  endif
  ;建立数据输出路径
  Filelist=File_Search(info.inpath,'*.gz',count=count)
  Year_str=strmid(file_basename(Filelist),0,2)
  Year_index = Year_str[UNIQ(Year_str, SORT(Year_str))]
  For i=0,n_elements(Year_index)-1 do begin
     if strmid(Year_index[i],0,1) eq '0' then begin
     File_MKDir,info.outPath+'20'+Year_index[i]
     endif else begin
     File_MKDir,info.outPath+'19'+Year_index[i]
     endelse
  Endfor




;	;开始ENVI批处理模式
;  envi, /restore_base_save_files
;  envi_batch_init, log_file='batch.txt'
;
;  ;推出批处理模式
;	envi_batch_exit     ;退出批处理模式
end



pro Cancle, Event
  wWidget =  Event.top
end
