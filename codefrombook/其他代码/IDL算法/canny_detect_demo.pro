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
PRO kill_canny_app, event
  SHMUNMAP, 'rose_shmmap'
END

PRO CANNY_DETECT_DEMO_event, event
  centered = 0
  
  CASE WIDGET_INFO(event.ID, /uname) OF
    "BtnQuit":   BEGIN
      SHMUNMAP, 'rose_shmmap'
      WIDGET_CONTROL, event.TOP,/destroy
    END
    ELSE: BEGIN
      sliderH_ID = WIDGET_INFO(event.TOP, find_by_uname = "HIGHv")
      WIDGET_CONTROL, sliderH_ID, get_value = HighValue ; <-- in percentage
      sliderL_ID = WIDGET_INFO(event.TOP, find_by_uname = "LOWv")
      WIDGET_CONTROL, sliderL_ID, get_value = LowValue  ; <-- in percentage
      sliderS_ID = WIDGET_INFO(event.TOP, find_by_uname = "SIGMAv")
      WIDGET_CONTROL, sliderS_ID, get_value = SigmaValue    ; <-- in percentage
      HighValue = HighValue * 0.01
      LowValue = LowValue * 0.01
      SigmaValue = SigmaValue * 0.01
      wDraw2_ID = WIDGET_INFO(event.TOP, find_by_uname = "RoseEdges")
      WIDGET_CONTROL, wDraw2_ID, get_value = ID_grWindow2
      rose_image = SHMVAR('rose_shmmap')
      
      ;_____Plot the edges of the image:_____
      WSET, ID_grWindow2
      rose_xsize = (SIZE(rose_image, /dimensions))[1]
      rose_ysize = (SIZE(rose_image, /dimensions))[2]
      red_rose = REFORM(rose_image[0, *, *], rose_xsize, rose_ysize)
      green_rose = REFORM(rose_image[0, *, *], rose_xsize, rose_ysize)
      blue_rose = REFORM(rose_image[0, *, *], rose_xsize, rose_ysize)
      red_edge = CANNY(red_rose, HIGH = HighValue, LOW = LowValue, SIGMA = SigmaValue)
      green_edge = CANNY(green_rose, HIGH = HighValue, LOW = LowValue, SIGMA = SigmaValue)
      blue_edge = CANNY(blue_rose, HIGH = HighValue, LOW = LowValue, SIGMA = SigmaValue)
      
      
      RGB_edge = BINDGEN(3, rose_xsize, rose_ysize)
      RGB_edge[0, *, *] = red_edge * 255
      RGB_edge[1, *, *] = green_edge * 255
      RGB_edge[2, *, *] = blue_edge * 255
      TV, RGB_edge[0,*,*],CHANNEL=1
      TV, RGB_edge[1,*,*],CHANNEL=2
      TV, RGB_edge[2,*,*],CHANNEL=3
    END
  ENDCASE
  
  
;  FilterIt:
;
;  goto, AllDone
;
;  ExitFilterApp:
;  shmunmap, 'rose_shmmap'
;  widget_control, event.top, /destroy
;  return
;  Modified By DYQ
;
;  AllDone:
END

PRO CANNY_DETECT_DEMO
  COMPILE_OPT IDL2
  DEVICE, GET_SCREEN_SIZE = csz
  ;_____Create the unfiltered image:_____
  
  queryStatus = QUERY_IMAGE('', imageInfo)
  WHILE( queryStatus NE 1 )DO BEGIN
  
    rose_path  = DIALOG_PICKFILE(filte = ['*.jpg;*.jpeg', '*.tif;*.tiff', '*.bmp;*.bmp'],$
    title ='选择输入图像文件')
    IF rose_path EQ '' THEN RETURN
    queryStatus = QUERY_IMAGE(rose_path, imageInfo)
    
  ENDWHILE
  rose_image = READ_IMAGE(rose_path)
  
  ;图像太大则进行重采样
  imageSZ = imageinfo.DIMENSIONS
  IF imageSZ[0] GT (csz[0]-10)/2 THEN BEGIN
    x = (csz[0]-10)/2
    imageSZ = [x, imageSZ[1]*(csz[0]-10.)/2/imageSZ[0]]
  ENDIF
  IF imageSZ[1] GT (csz[1]-10)/2 THEN BEGIN
    y = (csz[1]-10)/2
    imageSZ = [ imageSZ[0]*(csz[1]-10.)/2/imageSZ[1],y]
  ENDIF
  ;修改图像大小
  IF imageinfo.CHANNELS EQ 1 THEN BEGIN
    rose_image = CONGRID(rose_image,imageSZ)
    tmp = BYTARR(3,imageSZ)
    tmp [0,*] = rose_image
    tmp [1,*] = rose_image
    tmp [2,*] = rose_image
    rose_image = TEMPORARY(tmp)
  ENDIF ELSE IF imageinfo.CHANNELS EQ 3 THEN BEGIN
    rose_image = CONGRID(rose_image,3,imageSZ[0],imagesz[1])
  ENDIF ELSE RETURN
  
  
  ;_____Set up shared memory (so event handler can have image):_____
  SHMMAP, 'rose_shmmap', /BYTE, SIZE(rose_image, /dimensions)
  shm_var = SHMVAR('rose_shmmap')
  shm_var[*] = rose_image
  ;_________________________________________________________________
  
  
  ;_____Create the edge-detected image:_____
  ;  rose_xsize = (size(rose_image, /dimensions))[1]
  ;  rose_ysize = (size(rose_image, /dimensions))[2]
  red_rose = REFORM(rose_image[0, *, *], imageSZ)
  green_rose = REFORM(rose_image[0, *, *], imageSZ)
  blue_rose = REFORM(rose_image[0, *, *], imageSZ)
  red_edge = CANNY(red_rose)
  green_edge = CANNY(green_rose)
  blue_edge = CANNY(blue_rose)
  RGB_edge = BINDGEN(3, imageSZ[0],imageSZ[1])
  RGB_edge[0, *, *] = red_edge * 255
  RGB_edge[1, *, *] = green_edge * 255
  RGB_edge[2, *, *] = blue_edge * 255
  ;____________________________________
  
  
  ;_____Build the widgets:_____
  wTLB=WIDGET_BASE(/ROW)
  wControls = WIDGET_BASE(wTLB, /column)
  wLeft = WIDGET_BASE(wTLB,/COLUMN)
  wRight = WIDGET_BASE(wTLB,/COLUMN)
  wBase1 = WIDGET_BASE(wLeft,/COLUMN)
  wBase2 = WIDGET_BASE(wRight,/COLUMN)
  wText1a = WIDGET_LABEL(wBase1,VALUE="Original Rose")
  wDraw1 = WIDGET_DRAW(wBase1,XSIZE = imageSZ[0], YSIZE = imageSZ[1])
  wText2 = WIDGET_LABEL(wBase2,VALUE="Rose's edges")
  wDraw2 = WIDGET_DRAW(wBase2,XSIZE = imageSZ[0], YSIZE = imageSZ[1], uname = "RoseEdges")
  
  ;_____Controllers:_____
  wSliderH = WIDGET_SLIDER(wBase1, title = "High Value (% of maximum pixel value):", maximum = 100, $
    minimum = 0, value = 80, uname = "HIGHv")
  wSliderL = WIDGET_SLIDER(wBase1, title = "Low Value (% of High Value):", maximum = 100, $
    minimum = 0, value = 40, uname = "LOWv")
  wSliderS = WIDGET_SLIDER(wBase1, title = "Sigma %", maximum = 100, $
    minimum = 0, value = 60, uname = "SIGMAv")
  wButtonQuit = WIDGET_BUTTON(wBase1, value = "Quit Edge App", uname = "BtnQuit")
  ;____________________________
  
  
  WIDGET_CONTROL,wTLB,/REALIZE
  
  ;____________________Draw the images:____________________
  WIDGET_CONTROL, wDraw1, GET_VALUE = window1ID
  WIDGET_CONTROL, wDraw2, GET_VALUE = window2ID
  
  ;_____Plot the original image:_____
  WSET, window1ID
  reconstructed_rose = BINDGEN(imageSZ[0],imageSZ[1], 3)
  reconstructed_rose[*,*,0] = red_rose
  reconstructed_rose[*,*,1] = green_rose
  reconstructed_rose[*,*,2] = blue_rose
  TV,rose_image[0,*,*],CHANNEL=1
  TV,rose_image[1,*,*],CHANNEL=2
  TV,rose_image[2,*,*],CHANNEL=3
  
  
  ;_____Plot the edges of the image:_____
  WSET, window2ID
  TV, RGB_edge[0,*,*],CHANNEL=1
  TV, RGB_edge[1,*,*],CHANNEL=2
  TV, RGB_edge[2,*,*],CHANNEL=3
  
  ;________________________________________________________
  
  XMANAGER,'CANNY_DETECT_DEMO',wTLB, cleanup = "kill_canny_app"
END
;---
