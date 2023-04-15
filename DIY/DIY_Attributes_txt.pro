;+
;
;	:Author:	冉炯涛
;	
;	:Description:
;		 //TODO 搜索MTL文件数据
;
;	:Date 2023年4月14日 上午12:04:46
;	
;	:Params:
;   txt:  文本，需先外部打开
;   
;	:keywords:
;	  name: 待搜索组名
;   idcode: 搜索组属性
;   key: 模式选择，默认0即不分割=
;  除非搜索属性在文本中含有多个位置，否则只需要搜索属性
;  
;	:return:
;   name_list : 返回数据
;-
PRO DIY_Attributes_txt,txt,name_list,name=name,idcode=idstr,key=key
  ;  txt  文本，需先外部打开
  ;  name  待搜索组名
  ;  idcode 搜索组属性
  ;  key  模式选择，默认0即不分割=
  ;  除非搜索属性在文本中含有多个位置，否则只需要搜索属性
  txtsize=SIZE(txt,/N_ELEMENTS)
  IF N_ELEMENTS(name) EQ 0 THEN BEGIN
    name=''
  ENDIF
  if (txtsize  eq 1) then begin
    txt=STRSPLIT(txt,string(10b),/EXTRACT)
  endif else begin
  endelse
  
  
  group=idstr[0]+'[^*]{0,}=[^*]{0,}'+name
  txtergex=STREGEX(txt,group, /SUBEXPR)
  pos=WHERE(txtergex ne  -1)
  if (pos[0] ne -1) then begin
    IF N_ELEMENTS(pos) eq 1 THEN BEGIN
      xxxx=INDGEN(1)
      xxxx=pos
    ENDIF ELSE IF N_ELEMENTS(pos) eq 2 THEN  BEGIN
      xxxx=INDGEN((pos[1]-pos[0]-1))
      xxxx+=pos[0]+1
    ENDIF ELSE  begin
      xxxx=INDGEN(N_ELEMENTS(pos))
      xxxx=pos
    ENDELSE
    name_list=txt[xxxx]
    name_list=strcompress(name_list,/REMOVE_ALL)
  endif else begin
  endelse
IF N_ELEMENTS(key) EQ 0 THEN BEGIN
  key=9
ENDIF
case (key) of
  1: begin
    name_list=strcompress(txt[xxxx],/REMOVE_ALL)
    name_list_spl=strsplit(name_list,'="()',/extract)
    if N_ELEMENTS(name_list_spl) gt 2 then begin
      name_list=name_list_spl.toarray()
    endif else begin
      name_list=name_list_spl
    endelse
  end
  else: begin
  end
endcase
END