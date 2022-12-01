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
;生成模拟信号数据
N = 1024
delt = 0.02
u = -0.3 + 1.0 * SIN(2 * !PI * 2.8 * delt * FINDGEN(N)) $
  + 1.0 * SIN(2 * !PI * 6.25 * delt * FINDGEN(N)) $
  + 1.0 * SIN(2 * !PI * 11.0 * delt * FINDGEN(N))
  
;离散时间序列.
t = delt * FINDGEN(N)
;信号采集开始时间
t1 = 1.0
;信号采集结束时间
t2 = 2.0
;绘制曲线（图15.14）
IPLOT, T + delt/2, U, /HISTOGRAM, $
  XRANGE=[t1,t2], XTITLE='time in seconds', YTITLE='amplitude',$
  TITLE='Portion of Sampled Time Signal u(k)'
  
  
;快速傅立叶变换
V = FFT(U)
M = (INDGEN(N)-(N/2-1))
F = M / (N*delt)
;显示信号的实部（图15.15上）
IPLOT, F, FLOAT(SHIFT(V,N/2-1)), $
  DIMENSIONS=[500,800], VIEW_GRID=[1,2], $
  YTITLE='Real part of spectrum', $
  XTITLE='Frequency in cycles / second', $
  XRANGE=[-1,1]/(2*delt), $
  TITLE='Real and Imaginary Spectrum of u(k)'
;显示信号的虚部（图15.15下）
IPLOT, F, IMAGINARY(SHIFT(V,N/2-1)), $
  /VIEW_NEXT, $
  YTITLE='Imaginary part of spectrum', $
  XTITLE='Frequency in cycles / second', $
  XRANGE=[-1,1]/(2*delt)
  
  
;快速傅立叶变换
V = FFT(U)
F = FINDGEN(N/2+1) / (N*delt)
;幅度
mag = ABS(V(0:N/2))
;相位
phi = ATAN(V(0:N/2), /PHASE)
;幅度的对数（实蓝色）相位（度，黑色）
IPLOT, F, 20*ALOG10(mag),$
  YTITLE='Magnitude in dB / Phase in degrees', $
  XTITLE='Frequency in cycles / second', COLOR=[72,72,255], $
  TITLE='Magnitude (solid) and Phase (dashed)'
IPLOT, F, phi/!DTOR, $
  YRANGE=[-180,180],   YMAJOR=7, /X_LOG, $
  XRANGE=[1.0,1.0/(2.0*delt)], $
  LINESTYLE=2,  /OVERPLOT
  
  
;快速傅立叶变换
V = FFT(U)
F = FINDGEN(N/2+1) / (N*delt)
;绘制功率谱（图15.17）
IPLOT, F, ABS(V(0:N/2))^2, $
  YTITLE='Power Spectrum of u(k)', /Y_LOG, YMINOR=0, $
  XTITLE='Frequency in cycles / second', /X_LOG, $
  XRANGE=[1.0,1.0/(2.0*delt)], $
  TITLE='Power Spectrum'
  
;创建仿真信号数据
N = 1024
delt = 0.02
T = delt * FINDGEN(N)
f1 = 5.0 / ((n-1)*delt)
f2 = 0.5 / ((n-1)*delt)
R = SIN(2*!PI*f1*T) * SIN(2*!PI*f2*T)
;绘制希尔伯特变换（图15.18）
IPLOT, T, R, -FLOAT(HILBERT(R)), $
  XTITLE = 'time in seconds', $
  YTITLE = 'real', ZTITLE = 'imaginary', $
  TITLE='Analytic Signal for r(t) Using Hilbert Transform'
  
  
  
;采样周期
delt = 0.02
;高于f_low的过滤
f_low = 15.
;低于f_high的过滤
f_high = 7.
;脉动幅度
a_ripple = 50.
;滤波次数
nterms = 40
;计算脉冲响应
bs_ir_k = DIGITAL_FILTER(f_low*2*delt, f_high*2*delt, $
  a_ripple, nterms)
nfilt = N_ELEMENTS(bs_ir_k)
;放缩快速傅立叶的频率响应
bs_fr_k = FFT(bs_ir_k) * nfilt
;带阻滤波器的幅度
f_filt = FINDGEN(nfilt/2+1) / (nfilt*delt)
mag = ABS(bs_fr_k(0:nfilt/2))
;绘制滤波结果（图15.19）
IPLOT, f_filt, 20*ALOG10(mag), YTITLE='Magnitude in dB', $
  XRANGE=[1.0,1.0/(2.0*delt)], YRANGE=[-60,20], $
  XTITLE='Frequency in cycles / second', /X_LOG, $
  TITLE='Frequency Response for Bandstop FIR Filter (Kaiser)'
  
  
  
  
;模拟仿真信号
delt = 0.02
f0 = 6.5
C = (1.0-!PI*f0*delt) / (1.0+!PI*f0*delt)
B = [(1+C^2)/2, -2*C, (1+C^2)/2]
A = [   C^2,    -2*C,     1    ]
na = N_ELEMENTS(A)-1
nb = N_ELEMENTS(B)-1
N = 1024L
U = FLTARR(N)
U[0] = FLOAT(N)
Y = FLTARR(N)
Y[0] = B[2]*U[0] / A[na]
;递归计算滤波信号
FOR K = 1, N-1 DO $
  Y(K) = ( TOTAL( B[nb-K>0:nb  ]*U[K-nb>0:K  ] ) $
  - TOTAL( A[na-K>0:na-1]*Y[K-na>0:K-1] ) ) / A[na]
;频谱计算.
V = FFT(Y)
F = FINDGEN(N/2+1) / (N*delt)
mag = ABS(V(0:N/2))
phi = ATAN(V(0:N/2), /PHASE)
;绘制曲线显示（图15.20上）
IPLOT, F, 20*ALOG10(mag), DIMENSIONS=[550,800], $
  VIEW_GRID=[1,2], YTITLE='Magnitude in dB', $
  XTITLE='Frequency in cycles / second', $
  /X_LOG, XRANGE=[1.0,1.0/(2.0*delt)], $
  TITLE='Frequency Response Function of b(z)/a(z)'
;绘制曲线显示（图15.20下）
IPLOT, F, phi/!DTOR, $
  /VIEW_NEXT, YTITLE='Phase in degrees', $
  YRANGE=[-180,180], YTICKS=4, YMINOR=3, $
  XTITLE='Frequency in cycles / second', /X_LOG, $
  XRANGE=[1.0,1.0/(2.0*delt)]
  
END