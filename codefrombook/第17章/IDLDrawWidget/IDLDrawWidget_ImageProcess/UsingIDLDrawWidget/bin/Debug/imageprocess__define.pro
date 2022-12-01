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

;根据两个点返回矩形的四个点坐标
FUNCTION imageProcess::CalRectPoints,ulPos,drPos

  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect
  lLoc = viewRect[0:1]+[ulPos[0],ulPos[1]]*viewRect[2:3]/winDims
  rLoc = viewRect[0:1]+[drPos[0],drPos[1]]*viewRect[2:3]/winDims
  if abs(rLoc[0]-lLoc[0]) eq 0 then rLoc[0]= lLoc[0]+1
  if abs(rLoc[1]-lLoc[1]) eq 0 then rLoc[1]= lLoc[1]+1
  RETURN,[[lLoc],[lLoc[0],rLoc[1]],$
    [rLoc],[rLoc[0],lLoc[1]]]
END
;销毁析构
PRO imageProcess::CLEANUP
  IF  PTR_VALID(self.ORIDATA) THEN PTR_FREE,self.ORIDATA
  IF OBJ_VALID(self.OWINDOW) THEN OBJ_DESTROY, self.OWINDOW
  IF OBJ_VALID(self.OIMAGE) THEN OBJ_DESTROY, self.OIMAGE
  IF OBJ_VALID(self.ORECT) THEN OBJ_DESTROY, self.ORECT
END

;修改组件大小是
PRO imageProcess::ChangeDrawSize,width,height
  IF N_ELEMENTS(width) THEN BEGIN
    self.OWINDOW.GETPROPERTY, graphics_tree = oView    
    oView.GetProperty,ViewPlane_Rect = viewP,dimensions = dims
    oriWL = viewP[2:3]
      viewP[2:3] =viewP[2:3]*[width,height]/dims
      viewP[0:1]+=(oriWL-viewP[2:3])/2
    
    oView.SETPROPERTY,dimension = [width,height],viewPlane_Rect= viewP
    self.oWindow.Draw
    
  ENDIF
END

;图像处理
PRO imageProcess::imageprocesso,type = type

  CASE type OF
    ;+++++图像增强
    ;灰度拉伸
    'Byte': BEGIN
      IF self.RGBTYPE EQ 0 THEN BEGIN
        self.OIMAGE.SETPROPERTY, data = BYTSCL(*(self.ORIDATA))
      ENDIF ELSE BEGIN
        data = *(self.ORIDATA)
        FOR i=0,2 DO data[i,*,*] = BYTSCL(REFORM(data[i,*,*]))
        self.OIMAGE.SETPROPERTY, data = data
      ENDELSE
    END
    ;直方图均衡化
    'Hist_Equal': BEGIN
      IF self.RGBTYPE EQ 0 THEN BEGIN
        self.OIMAGE.SETPROPERTY, data = HIST_EQUAL(*(self.ORIDATA))
      ENDIF ELSE BEGIN
        data = *(self.ORIDATA)
        FOR i=0,2 DO data[i,*,*] = HIST_EQUAL(REFORM(data[i,*,*]))
        self.OIMAGE.SETPROPERTY, data = data
      ENDELSE
    END
    ;均值平滑
    'Smooth':BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = SMOOTH(*(self.ORIDATA), 5, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = SMOOTH(REFORM(data[i,*,*]), 5, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;中值平滑
  'MEDIAN': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = MEDIAN(*(self.ORIDATA), 5)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MEDIAN(REFORM(data[i,*,*]), 5)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;锐化
  'Sharpen': BEGIN
    ; Create a sharpening (high pass) filter.
    kernelSize = [3, 3]
    kernel = REPLICATE(-1./9., kernelSize[0], kernelSize[1])
    kernel[1, 1] = 1.
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =CONVOL(FLOAT(*(self.ORIDATA)), kernel, /CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = CONVOL(FLOAT(REFORM(data[i,*,*])), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;+++++域变换
  ;快速傅立叶
  ;小波变换
  ;Hough变换
  'Hough': BEGIN
    ; Create a sharpening (high pass) filter.
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = HOUGH(*(self.ORIDATA), RHO = houghRadii, $
        THETA = houghAngles, /GRAY)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      nArr = HOUGH(REFORM(data[0,*,*]), RHO = houghRadii, $
        THETA = houghAngles, /GRAY)
      dims = SIZE(nArr,/Dimensions)
      result = MAKE_ARRAY(3,dims[0],dims[1],/float)
      FOR i=0,2 DO result[i,*,*] =  HOUGH(REFORM(data[i,*,*]), RHO = houghRadii, $
        THETA = houghAngles, /GRAY)
      self.OIMAGE.SETPROPERTY, data = result
    ENDELSE
  END
  ;Radon变换
  'Radon': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = RADON(*(self.ORIDATA), RHO = houghRadii, $
        THETA = houghAngles, /GRAY)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] =  RADON(REFORM(data[i,*,*]), RHO = houghRadii, $
        THETA = houghAngles, /GRAY)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;+++++滤波
  ;低通滤波
  'LowPass': BEGIN
    ; Create a low pass filter.
    kernelSize = [3, 3]
    kernel = REPLICATE((1./(kernelSize[0]*kernelSize[1])), $
      kernelSize[0], kernelSize[1])
      
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =CONVOL(FLOAT(*(self.ORIDATA)), kernel, /CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = CONVOL(FLOAT(REFORM(data[i,*,*])), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;高通滤波
  'HighPass': BEGIN
    ; Create a high pass filter.
    kernelSize = [3, 3]
    kernel = REPLICATE(-1./9., kernelSize[0], kernelSize[1])
    kernel[1, 1] = 8./9.
    
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = CONVOL(FLOAT(*(self.ORIDATA)), kernel,/CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = CONVOL(FLOAT(REFORM(data[i,*,*])), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;方向滤波
  'Direction': BEGIN
    ; Create a directional filter.
    kernelSize = [3, 3]
    kernel = FLTARR(kernelSize[0], kernelSize[1])
    kernel[0, *] = -1.
    kernel[2, *] = 1.
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = CONVOL(FLOAT(*(self.ORIDATA)), kernel,/CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = CONVOL(FLOAT(REFORM(data[i,*,*])), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;拉普拉斯滤波
  'Laplacian': BEGIN
    ; Create a Laplacian filter.
    kernelSize = [3, 3]
    kernel = FLTARR(kernelSize[0], kernelSize[1])
    kernel[1, *] = -1.
    kernel[*, 1] = -1.
    kernel[1, 1] = 4.
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = CONVOL(FLOAT(*(self.ORIDATA)), kernel,/CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = CONVOL(FLOAT(REFORM(data[i,*,*])), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;++++++++++++噪声去除
  'Hanning': BEGIN
    ;
    imageSize = self.IMAGEDIMS
    IF self.RGBTYPE EQ 0 THEN BEGIN
      transform = SHIFT(FFT(*(self.ORIDATA)), (imageSize[0]/2), $
        (imageSize[1]/2))
        
      ; Use a Hanning mask to filter out the noise.
      mask = HANNING(imageSize[0], imageSize[1])
      maskedTransform = transform*mask
      
      ; Apply the inverse transformation to masked frequency
      ; domain image.
      inverseTransform = FFT(SHIFT(maskedTransform, $
        (imageSize[0]/2), (imageSize[1]/2)), /INVERSE)
        
      self.OIMAGE.SETPROPERTY, data = CONGRID(REAL_PART(inverseTransform), $
        imageSize[0], imageSize[1])
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO BEGIN
        transform = SHIFT(FFT(REFORM(data[i,*,*])), (imageSize[0]/2), $
          (imageSize[1]/2))
          
        ; Use a Hanning mask to filter out the noise.
        mask = HANNING(imageSize[0], imageSize[1])
        maskedTransform = transform*mask
        ; Apply the inverse transformation to masked frequency domain image.
        
        inverseTransform = FFT(SHIFT(maskedTransform, $
          (imageSize[0]/2), (imageSize[1]/2)), /INVERSE)
        data[i,*,*] = CONGRID(REAL_PART(inverseTransform), $
          imageSize[0], imageSize[1])
      ENDFOR
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'LEEFILT': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =LEEFILT(*(self.ORIDATA), 1);  CONVOL(FLOAT(), kernel,/CENTER, /EDGE_TRUNCATE)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = LEEFILT(REFORM(data[i,*,*]), 1); CONVOL(FLOAT(), kernel, /CENTER, /EDGE_TRUNCATE)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;+++++++++边界提取
  'roberts': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =ROBERTS(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = ROBERTS(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'SOBEL': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =SOBEL(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = SOBEL(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'CANNY': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =255*CANNY(*(self.ORIDATA) ,HIGH = .5, LOW = .5, SIGMA = .6)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = 255*CANNY(REFORM(data[i,*,*]),HIGH = .5, LOW = .5, SIGMA = .6)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'PREWITT': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =PREWITT(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = PREWITT(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'SHIFT_DIFF': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =SHIFT_DIFF(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = SHIFT_DIFF(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'EDGE_DOG': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =EDGE_DOG(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = EDGE_DOG(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'EMBOSS': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =EMBOSS(*(self.ORIDATA))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = EMBOSS(REFORM(data[i,*,*]))
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;+++++++++形状提取
  ;
  ;膨胀运算
  'ERODE': BEGIN
    dims = self.IMAGEDIMS
    ; Create the structuring element, a disk with a radius of 2.
    radius = 2
    strucElem = SHIFT(DIST(2*radius+1), radius, radius) LE radius
    
    IF self.RGBTYPE EQ 0 THEN BEGIN
      img = *(self.ORIDATA)
      erodeImg = REPLICATE(MAX(img), dims[0]+2, dims[1]+2)
      erodeImg [1,1] = img
      erodeImg = ERODE(erodeImg, strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = erodeImg ;EMBOSS(*(self.oriData))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      nData = MAKE_ARRAY(3,dims[0]+2, dims[1]+2,type = SIZE(data,/type))
      FOR i=0,2 DO BEGIN
        img = REFORM(data[i,*,*])
        erodeImg = REPLICATE(MAX(img), dims[0]+2, dims[1]+2)
        erodeImg [1,1] = img
        erodeImg = ERODE(erodeImg, strucElem, /GRAY)
        nData[i,*,*] = erodeImg
      END
      self.OIMAGE.SETPROPERTY, data = nData
    ENDELSE
  END
  ;腐蚀运算
  'DILATE': BEGIN
    dims = self.IMAGEDIMS
    ; Create the structuring element, a disk with a radius of 2.
    radius = 2
    strucElem = SHIFT(DIST(2*radius+1), radius, radius) LE radius
    
    IF self.RGBTYPE EQ 0 THEN BEGIN
      img = *(self.ORIDATA)
      erodeImg = REPLICATE(MAX(img), dims[0]+2, dims[1]+2)
      erodeImg [1,1] = img
      
      erodeImg = DILATE(erodeImg, strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = erodeImg ;EMBOSS(*(self.oriData))
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      nData = MAKE_ARRAY(3,dims[0]+2, dims[1]+2,type = SIZE(data,/type))
      FOR i=0,2 DO BEGIN
        img = REFORM(data[i,*,*])
        erodeImg = REPLICATE(MAX(img), dims[0]+2, dims[1]+2)
        erodeImg [1,1] = img
        erodeImg = DILATE(erodeImg, strucElem, /GRAY)
        nData[i,*,*] = erodeImg
      END
      self.OIMAGE.SETPROPERTY, data = nData
    ENDELSE
  END
  ;开运算
  'MORPH_OPEN': BEGIN
    ; Define the radius of the structuring element and
    ; create the disk.
    radius = 7
    strucElem = SHIFT(DIST(2*radius+1), $
      radius, radius) LE radius
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =MORPH_OPEN(*(self.ORIDATA), strucElem, /GRAY)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MORPH_OPEN(REFORM(data[i,*,*]), strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;闭运算
  'MORPH_CLOSE': BEGIN
    ; Define the size of the structuring element
    ;  and create the square.
    side = 3
    strucElem = DIST(side) LE side
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =MORPH_CLOSE(*(self.ORIDATA), strucElem, /GRAY)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MORPH_CLOSE(REFORM(data[i,*,*]), strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;峰值亮度
  'MORPH_TOPHAT': BEGIN
    ; Define and create the structuring element.
    radius = 3
    strucElem = SHIFT(DIST(2*radius+1), $
      radius, radius) LE radius
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =MORPH_TOPHAT(*(self.ORIDATA), strucElem, /GRAY)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MORPH_TOPHAT(REFORM(data[i,*,*]), strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;分水岭
  'WATERSHED': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data =WATERSHED(*(self.ORIDATA), CONNECTIVITY = 100)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO BEGIN
        watershedImg = WATERSHED(REFORM(data[i,*,*]), CONNECTIVITY = 8)
        img = REFORM(data[i,*,*])
        img [WHERE (watershedImg EQ 0)] = 0
        data[i,*,*] = img;WATERSHED(Reform(data[i,*,*]), CONNECTIVITY = 100)
      ENDFOR
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  ;图像识别
  'MORPH_HITORMISS': BEGIN
    radhit = 7
    radmiss = 23
    hit = SHIFT(DIST(2*radhit+1), radhit, radhit) LE radhit
    miss = SHIFT(DIST(2*radmiss+1), radmiss, radmiss) GE radmiss
    IF self.RGBTYPE EQ 0 THEN BEGIN
      ; Using structuring elements, define matching regions.
      matches = MORPH_HITORMISS(*(self.ORIDATA), hit, miss)
      ; Display the regions matching hit and miss conditions.
      ; Dilate the matches to the radius of a 'hit'.
      ;dmatches = DILATE(matches, hit)
      self.OIMAGE.SETPROPERTY, data =DILATE(matches, hit)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO BEGIN
        matches = MORPH_HITORMISS(REFORM(data[i,*,*]), hit, miss)
        data[i,*,*] = DILATE(matches, hit)
      ENDFOR
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'MORPH_GRADIENT': BEGIN
    ; Define and create the structuring element.
    radius = 1
    strucElem = SHIFT(DIST(2*radius+1), $
      radius, radius) LE radius
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = MORPH_GRADIENT(*(self.ORIDATA), strucElem)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MORPH_GRADIENT(REFORM(data[i,*,*]), strucElem);MORPH_TOPHAT(Reform(data[i,*,*]), strucElem, /GRAY)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'MORPH_DISTANCE': BEGIN
    IF self.RGBTYPE EQ 0 THEN BEGIN
      self.OIMAGE.SETPROPERTY, data = MORPH_DISTANCE(binaryImg, NEIGHBOR_SAMPLING = 1)
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO data[i,*,*] = MORPH_DISTANCE(REFORM(data[i,*,*]), NEIGHBOR_SAMPLING = 1)
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  'MORPH_THIN': BEGIN
    ; Prepare hit and miss structures for thinning.
    h0 = [[0b, 0, 0], [0, 1, 0], [1, 1, 1]]
    m0 = [[1b, 1, 1], [0, 0, 0], [0, 0, 0]]
    h1 = [[0b, 0, 0], [1, 1, 0], [1, 1, 0]]
    m1 = [[0b, 1, 1], [0, 0, 1], [0, 0, 0]]
    h2 = [[1b, 0, 0], [1, 1, 0], [1, 0, 0]]
    m2 = [[0b, 0, 1], [0, 0, 1], [0, 0, 1]]
    h3 = [[1b, 1, 0], [1, 1, 0], [0, 0, 0]]
    m3 = [[0b, 0, 0], [0, 0, 1], [0, 1, 1]]
    h4 = [[1b, 1, 1], [0, 1, 0], [0, 0, 0]]
    m4 = [[0b, 0, 0], [0, 0, 0], [1, 1, 1]]
    h5 = [[0b, 1, 1], [0, 1, 1], [0, 0, 0]]
    m5 = [[0b, 0, 0], [1, 0, 0], [1, 1, 0]]
    h6 = [[0b, 0, 1], [0, 1, 1], [0, 0, 1]]
    m6 = [[1b, 0, 0], [1, 0, 0], [1, 0, 0]]
    h7 = [[0b, 0, 0], [0, 1, 1], [0, 1, 1]]
    m7 = [[1b, 1, 0], [1, 0, 0], [0, 0, 0]]
    IF self.RGBTYPE EQ 0 THEN BEGIN
      bCont = 1b
      iIter = 1
      thinImg = *(self.ORIDATA)
      WHILE bCont EQ 1b DO BEGIN
        inputImg = thinImg
        ; Perform the thinning using the first pair of structure elements.
        thinImg = MORPH_THIN(inputImg, h0, m0)
        ; Perform the thinning operation using the remaining structural element pairs.
        thinImg = MORPH_THIN(thinImg, h1, m1)
        thinImg = MORPH_THIN(thinImg, h2, m2)
        thinImg = MORPH_THIN(thinImg, h3, m3)
        thinImg = MORPH_THIN(thinImg, h4, m4)
        thinImg = MORPH_THIN(thinImg, h5, m5)
        thinImg = MORPH_THIN(thinImg, h6, m6)
        thinImg = MORPH_THIN(thinImg, h7, m7)
        
        ; Test the condition and increment the loop.
        bCont = MAX(inputImg - thinImg)
        iIter = iIter + 1
      ; End WHILE loop statements.
      ENDWHILE
      self.OIMAGE.SETPROPERTY, data = thinImg
    ENDIF ELSE BEGIN
      data = *(self.ORIDATA)
      FOR i=0,2 DO BEGIN
        bCont = 1b
        iIter = 1
        thinImg = REFORM(data[i,*,*])
        WHILE bCont EQ 1b DO BEGIN
          inputImg = thinImg
          ; Perform the thinning using the first pair of structure elements.
          thinImg = MORPH_THIN(inputImg, h0, m0)
          ; Perform the thinning operation using the remaining structural element pairs.
          thinImg = MORPH_THIN(thinImg, h1, m1)
          thinImg = MORPH_THIN(thinImg, h2, m2)
          thinImg = MORPH_THIN(thinImg, h3, m3)
          thinImg = MORPH_THIN(thinImg, h4, m4)
          thinImg = MORPH_THIN(thinImg, h5, m5)
          thinImg = MORPH_THIN(thinImg, h6, m6)
          thinImg = MORPH_THIN(thinImg, h7, m7)
          
          ; Test the condition and increment the loop.
          bCont = MAX(inputImg - thinImg)
          iIter = iIter + 1
          PRINT,'Iteration: ', iIter
        ; End WHILE loop statements.
        ENDWHILE
        
        data[i,*,*] = thinImg
        
      ENDFOR
      self.OIMAGE.SETPROPERTY, data = data
    ENDELSE
  END
  
  ELSE:
ENDCASE
self.OWINDOW.draw
END
;参数设置
PRO imageProcess::GetProperty, initFlag = initFlag
  initFlag= self.INITFLAG
END

;参数设置
PRO imageProcess::SetProperty, mouseType = mouseType
  self.MOUSETYPE= mouseType
END

;鼠标滚轮时的事件
PRO imageProcess::WheelEvents,wType,xPos,yPos
  COMPILE_OPT idl2
  
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect
  
  IF wType GT 0 THEN rate = 0.8 ELSE rate = 1.125
  
  
  oriDis =[xPos,yPos]*viewRect[2:3]/winDims
  viewRect[0:1]+=(1-rate)*oriDis
  viewRect[2:3]= viewRect[2:3]*rate
  ;
  oView.SETPROPERTY, viewPlane_Rect = viewRect
  self.oWindow.Draw
END


;鼠标点击时的事件
PRO imageProcess::MousePress,xpos,ypos
  COMPILE_OPT idl2
  self.MOUSELOC[0:1] = [xPos,yPos]
  CASE self.MOUSETYPE OF
    ;放大
    2: BEGIN
      data = self.CALRECTPOINTS(self.MOUSELOC[0:1],self.MOUSELOC[0:1])
      self.ORECT.SETPROPERTY, hide =0,data = data
    END
    ;缩小
    3: BEGIN
    
      data = self.CALRECTPOINTS(self.MOUSELOC[0:1],self.MOUSELOC[0:1])
      ;void = dialog_Message(string(data),/infor)
      self.ORECT.SETPROPERTY, hide =0,data = data
    END
    ELSE:
  ENDCASE
END
;鼠标弹起时的操作
PRO imageProcess::MouseRelease,xpos,ypos
  COMPILE_OPT idl2
  
  self.ORECT.SETPROPERTY, hide =1
  curLoc = [xPos,yPos]
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect
  
  CASE self.MOUSETYPE OF
    ;放大
    2: BEGIN
      data = self.CALRECTPOINTS(self.MOUSELOC,curLoc)
      maxV = MAX(data[0,*],min= minV)
      xRange = [minV,maxV]
      
      maxV = MAX(data[1,*],min= minV)
      yRange = [minV,maxV]
      ;
      viewRate= viewRect[3]/viewRect[2]
      rectRate = (yRange[1]-yRange[0])/(xRange[1]-xRange[0])
      ;
      IF viewRate GT rectRate THEN BEGIN
        width = xRange[1]-xRange[0]
        height = (xRange[1]-xRange[0])*winDims[1]/winDims[0]
        viewStartLoc= [TOTAL(xRange),TOTAL(yRange)]/2-[width,height]/2
      ENDIF ELSE BEGIN
        width = (yRange[1]-yRange[0])*winDims[0]/winDims[1]
        height = yRange[1]-yRange[0]
        viewStartLoc= [TOTAL(xRange),TOTAL(yRange)]/2-[width,height]/2
      ENDELSE
      newVP =[viewStartLoc,width,height ]
      oView.SETPROPERTY, viewPlane_Rect = newVP
      
    END
    ;缩小
    3: BEGIN
      data = self.CALRECTPOINTS(self.MOUSELOC,curLoc)
      maxV = MAX(data[0,*],min= minV)
      xRange = [minV,maxV]
      
      maxV = MAX(data[1,*],min= minV)
      yRange = [minV,maxV]
      ;
      viewRate= viewRect[3]/viewRect[2]
      rectRate = (yRange[1]-yRange[0])/(xRange[1]-xRange[0])
      ;
      IF viewRate GT rectRate THEN BEGIN
        viewRect[2:3] = viewRect[2:3]*(viewRect[2])/(2*(xRange[1]-xRange[0]))
        ViewRect[0:1]= [TOTAL(xRange),TOTAL(yRange)]/2 - viewRect[2:3]/2
        
      ENDIF ELSE BEGIN
        viewRect[2:3] = viewRect[2:3]*(viewRect[3])/(2*(yRange[1]-yRange[0]))
        ViewRect[0:1]= [TOTAL(xRange),TOTAL(yRange)]/2 - viewRect[2:3]/2
        
      ENDELSE
      
      oView.SETPROPERTY, viewPlane_Rect = ViewRect
      
    END
    ELSE:
  ENDCASE
  
  self.oWindow.Draw
END
;鼠标双击时的操作
PRO imageProcess::DbClick,drawId,button,xpos,ypos
  self.ORIGINALSHOW
END

PRO imageProcess::MouseMotion,xpos,ypos
  ;
  curLoc = [xPos,yPos]
  ;
  self.OWINDOW.GETPROPERTY, dimensions = winDims,graphics_tree = oView
  oView.GETPROPERTY, viewPlane_Rect = viewRect
  
  CASE self.MOUSETYPE OF
    ;平移
    1: BEGIN
      ;屏幕偏移量
      offset = curLoc- self.MOUSELOC
      ;对应偏移量
      viewRect[0:1]-=offset*viewRect[2:3]/WinDims
      oView.SETPROPERTY, viewPlane_Rect = viewRect
      self.oWindow.Draw
      ;
      self.MOUSELOC = curLoc
    END
    ;放大
    2: BEGIN
      data = self.CALRECTPOINTS(self.MOUSELOC,curLoc)
      self.ORECT.SETPROPERTY, data = data
      self.oWindow.Draw
    END
    ;缩小
    3: BEGIN
      data = self.CALRECTPOINTS(self.MOUSELOC,curLoc)
      self.ORECT.SETPROPERTY, data = data
      self.oWindow.Draw
    END
    ELSE:
  ENDCASE
  
  
END
;初始化图像显示，注意XY方向同比例变换
PRO imageProcess::originalShow
  ;
  self.OWINDOW.GETPROPERTY, dimensions = windowDims,graphics_tree = oView
  imageDims = self.IMAGEDIMS
  ;
  imgRate = FLOAT(imageDims[0])/imageDims[1]
  viewRate = FLOAT(windowDims[0])/windowDims[1]
  ;
  IF imgRate GT viewRate THEN BEGIN
    viewWidth = imageDims[0]
    viewHeight = imageDims[0]/viewRate
    viewPlant_rect = [0, -(viewHeight-imageDims[1])/2,viewWidth,viewHeight]
    
  ENDIF ELSE BEGIN
    viewHeight = imageDims[1]
    viewwidth = imageDims[1]*ViewRate
    viewPlant_rect = [-(viewwidth-imageDims[0])/2,0,viewWidth,viewHeight]
    
  ENDELSE
  oView.SETPROPERTY, viewPlane_Rect = viewPlant_rect,dimensions = WindowDims
  self.oWindow.draw
END
;构建显示图像体系
PRO imageProcess::CreateDrawImage
  oView = OBJ_NEW('IDLgrView',color = [255,255,255])
  self.OWINDOW.SETPROPERTY, graphics_tree = oView
  
  queryStatus = QUERY_IMAGE(self.INFILE, imageInfo)
  IF queryStatus EQ 0 THEN BEGIN
    self.INITFLAG= 0
    RETURN
  ENDIF
  
  self.IMAGEDIMS = imageInfo.DIMENSIONS
  data = READ_IMAGE(self.INFILE)
  self.ORIDATA = PTR_NEW(data,/no_Copy)
  ;
  IF imageInfo.CHANNELS EQ 1 THEN BEGIN
    ;
    self.RGBTYPE =0
    self.OIMAGE = OBJ_NEW('IDLgrImage',*(self.ORIDATA) )
    
  ENDIF ELSE BEGIN
    self.RGBTYPE =1
    self.OIMAGE = OBJ_NEW('IDLgrImage',*(self.ORIDATA) ,INTERLEAVE =0)
  ENDELSE
  ;辅助红色矩形，初始化为隐藏
  self.ORECT = OBJ_NEW('IDLgrPolygon', $
    style =1,$
    thick=1,$
    color = [230,0,0],/hide)
    
  oModel = OBJ_NEW('IDLgrModel')
  
  oModel.ADD, [self.OIMAGE,self.ORECT]
  oView.ADD,oModel
  self.ORIGINALSHOW
  self.INITFLAG= 1
END

;类初始化函数
FUNCTION imageProcess::INIT,infile,drawID
  ;
  self.INFILE = infile
  ;传入的drawID
  WIDGET_CONTROL, drawID, get_Value = oWindow
  self.OWINDOW = oWindow
  ;调用CreateImage方法创建显示图像
  self.CREATEDRAWIMAGE
  
  RETURN, self.INITFLAG
END

;对象类定义
PRO IMAGEPROCESS__DEFINE
  struct = {imageProcess, $
    initFlag  : 0b, $
    mouseType : 0B, $;鼠标状态，0-默认,1-平移,2-放大,3-缩小。
    mouseLoc : FLTARR(2), $ ;
    
    infile: '' , $
    rgbType : 0, $
    imageDims : LONARR(2), $
    oriData  : PTR_NEW(), $
    oWindow : OBJ_NEW(), $
    oImage  : OBJ_NEW(), $
    oRect   : OBJ_NEW(), $
    DrawID: 0L $
    }
END