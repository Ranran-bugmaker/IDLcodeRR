  Pro EHANDLER, EV
  WIDGET_CONTROL, /DESTROY, EV.TOP
  print,'test'
End

Pro Create_Animate
  workspace='D:\photo\temp\'
  filelist=FILE_SEARCH(workspace+'*.jpg',count=count)
  READ_JPEG,filelist[0],image
  dim=SIZE(image,/dimensions)
  data_size=dim[WHERE(dim Gt 3)]
  PRINT,data_size
  x_size=400
  factor=FLOAT(data_size[1])/FLOAT(data_size[0])
  PRINT,x_size*factor
  base = WIDGET_BASE(TITLE = 'Animation Widget')
  animate = CW_ANIMATE(base, x_size,x_size*factor, count,tab_mode=1,MPEG_QUALITY=100)
  WIDGET_CONTROL, /REALIZE, base
  
  For I=0,15 Do Begin
    READ_JPEG,filelist[i],data
    image=CONGRID(data,3,x_size,x_size*factor)
    CW_ANIMATE_LOAD, animate, FRAME=I, IMAGE=image,/CYCLE
  Endfor
  CW_ANIMATE_GETP, animate, pixmap_vect
  CW_ANIMATE_RUN, animate,5
  XMANAGER, 'Create_Animate', base, EVENT_HANDLER = 'EHANDLER'
End