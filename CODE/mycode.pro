; Code generated by IDL 8.5.
  restore, "R:\IDL\CODE_IDL\Default\CODE\mycode.sav"
  x0 = data['x0']
  y0 = data['y0']
  x1 = data['x1']
  y1 = data['y1']
  x2 = data['x2']
  y2 = data['y2']

  scatterplot0 = Scatterplot(x0, y0, $  ; <- Data required
    XRANGE=[0.00000000,1.5000000], $
    YRANGE=[0.00000000,1.5000000], $
    XTICKFONT_NAME='Times', $
    XTICKFONT_SIZE=18.000000, $
    YTITLE='Satellite AOD(550nm)', $
    YTICKFONT_SIZE=18.000000, $
    YTICKFONT_NAME='Times', $
    XTITLE='AERONET AOD(550nm)', $
    DIMENSIONS=[800,800], $
    SYM_FILLED=1, $
    NAME='point200.784', $
    SYM_SIZE=2.0000000, $
    SYMBOL=23, $
    SYM_FILL_COLOR='coral', $
    SYM_COLOR='black', $
    POSITION=[0.13250000,0.13070312,0.92187500,0.88206250], $
    TITLE='biubiubibu')
  title = scatterplot0.TITLE
; Code generated by IDL 8.5.
  plot0 = Plot(x0, y0, $  ; <- Data required
    XTICKFONT_NAME='Times', $
    YTICKFONT_SIZE=18.000000, $
    YTICKFONT_NAME='Times', $
    THICK=3.00000, $
    XTICKFONT_SIZE=18.000000, $
    DIMENSIONS=[800,800])
 
  plot1 = Plot(x1, y1, $  ; <- Data required
    OVERPLOT=scatterplot0, $
    XTICKFONT_NAME='Times', $
    YTICKFONT_NAME='Times', $
    YTICKFONT_SIZE=18.000000, $
    THICK=3.00000, $
    XTICKFONT_SIZE=18.000000, $
    COLOR='red', $
    NAME='error line', $
    LINESTYLE=2)
 
  plot2 = Plot(x2, y2, $  ; <- Data required
    OVERPLOT=scatterplot0, $
    XTICKFONT_NAME='Times', $
    YTICKFONT_NAME='Times', $
    YTICKFONT_SIZE=18.000000, $
    THICK=3.00000, $
    XTICKFONT_SIZE=18.000000, $
    COLOR='red', $
    NAME='Plot 1', $
    LINESTYLE=2)
 
  legend0 = Legend(TARGET=[plot0,scatterplot0,plot2], $
    POSITION=[0.88940103,0.26660938])

end
