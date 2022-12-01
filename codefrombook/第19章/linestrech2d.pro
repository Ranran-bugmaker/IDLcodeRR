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
;对显示数据进行百分之二的线性拉伸
;
PRo lineStrech2d,data;,min_index,max_index

  dimens=Size(data,/dimensions)
  if size(data,/N_DIMENSIONS) eq 2 then begin
      MinCount=float(dimens[0])*dimens[1]*0.02
      MaxCount=float(dimens[0])*dimens[1]*0.98
      ;数据最大最小值
      min=min(data,max=max)
      ;统计数据分布
      hist=histogram(data)
      ;获取累加个数
      hist_sum=total(hist,/cumulative)
      ; 找下限
      index=where(hist_sum GT MinCount)
      min_index=(float(index[0]+1)*(max-min)/256)+min
      ;找上限
      index=where(hist_sum GT MaxCount)
      max_index=(float(index[0]+1)*(max-min)/256)+min
      ;
      ;拉伸
      data=Bytscl(temporary(data),min=min_index,max=max_index,top=255)

  endif
ENd