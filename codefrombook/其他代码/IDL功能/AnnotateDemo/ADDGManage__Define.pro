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
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;设置选择的对象
;
PRO ADDGManage::SetObj, obj

    COMPILE_OPT IDL2

    oSystem = self.oSystem

    self.beSelect = obj

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;刷新图形窗口
;
PRO ADDGManage::RefreshDraw

    COMPILE_OPT IDL2

    ;更新标注显示
    layerAnnotate = self->Get(/All, Isa = 'AdAnnoLayer', Count = count)
    IF count NE 0 THEN layerAnnotate->Refresh

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌


;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;标注
;
PRO ADDGManage::Annotate, event

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    oManager = oSystem.oManager
    oDraw = oManager.oDraw

    IF self.annotateStatus[0] EQ '' THEN Return

    CASE event.type OF
       ;点击
       0 : BEGIN
            self.oView->GetProperty, Dimensions = viewDim, Location = viewLoc, $
                    Viewplane_Rect = myView
            IF Obj_Valid(self.beSelect) THEN BEGIN
                self.beSelect->Setproperty, /OutLineHide
                self.beSelect = Obj_New()
            ENDIF
            ;左键
            IF event.press EQ 1 THEN BEGIN
                ;设置标注层
                layerAnnotate = self->Get(/All, Isa = 'AdAnnoLayer', Count = count)
                IF count EQ 0 THEN Return

                ;像素与图像坐标之间的关系
                ratio = myView[2]/viewDim[0]

                ;添加符号
                IF (self.annotateStatus)[0] EQ 'point' THEN BEGIN
                    locX = (event.x-viewLoc[0])/viewDim[0] * myview[2] + myview[0]
                    locY = (event.y-viewLoc[1])/viewDim[1] * myview[3] + myview[1]
                    location = [locX, locY,0]
                    ;
                    items = layerAnnotate->Get(/All, count = count)
                    ;
                    CASE count OF
                        4: BEGIN
                            FOR i=0, count-1 DO BEGIN
                                Obj_Destroy, items[i]
                            ENDFOR
                            ;
                            obj = Obj_New('AdLabel'     , $
                                OSystem = oSystem       , $
                                parent = layerAnnotate  , $
                                oManager = oManager     , $
                                Type = 0                , $
                                ratio = ratio           , $
                                /Select_Target          , $
                                Location = location       )
                        END
                        3: BEGIN
                            obj = Obj_New('AdLaybelAnalysis'     , $
                                OSystem = oSystem       , $
                                parent = layerAnnotate  , $
                                oManager = oManager     , $

                                /Select_Target            )
                        END
                        ELSE:BEGIN
                            obj = Obj_New('AdLabel'     , $
                                OSystem = oSystem       , $
                                parent = layerAnnotate  , $
                                oManager = oManager     , $
                                Type = count            , $
                                ratio = ratio           , $
                                /Select_Target          , $
                                Location = location       )
                        END
                    ENDCASE
                    oDraw.oWindow->Draw
                ENDIF
            ENDIF
        END
        ;释放
        1 : BEGIN
            ;IF Ptr_Valid(self.annLoc) THEN Return
            self.mouseStatus = 'hand'
        END

        ELSE:
    ENDCASE
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;滚轮缩放
;
PRO ADDGManage::Wheel, event

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    oDraw = (oSystem.oManager).oDraw

    scrXSize = oDraw.drawSize[0]
    scrYSize = oDraw.drawSize[1]

    self.oView->Getproperty, Dimensions = viewDim, Location = viewLoc

    ;
    evX = scrXSize / 2.
    evY = scrYSize / 2.

    centerX = evX - viewLoc[0]
    centerY = evY - viewLoc[1]

    ; 放大倍数为1.1,缩小倍数为0.9
    scaleRate = 1 + event.clicks / 10.

    viewDimX = (viewDim[0] * scaleRate) > self.viewRate[0]
    viewDimY = (viewDim[1] * scaleRate) > self.viewRate[1]

    IF viewDim[0]*scaleRate LT self.viewRate[0] THEN BEGIN
        tx = (centerX * 1 - scrXSize/2.)
    ENDIF ELSE BEGIN
        tx = (centerX * scaleRate - scrXSize/2.)
    ENDELSE

    IF viewDim[1]*scaleRate LT self.viewRate[1] THEN BEGIN
        ty = (centerY * 1 - scrYSize/2.)
    ENDIF ELSE BEGIN
        ty = (centerY * scaleRate - scrYSize/2.)
    ENDELSE

    currPos = [tx, ty]

    self.oView->SetProperty, Dimensions = [viewDimX, viewDimY], Location = -currPos

    self->RefreshDraw

    oDraw.oWindow->Draw
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;平移
;
PRO ADDGManage::Hand, event

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    oManager = oSystem.oManager
    oDraw = oManager.oDraw

    self.oView->GetProperty, Dimensions = viewDim, Location = viewLoc, $
                    Viewplane_Rect = myView

    scrXSize = oDraw.drawSize[0]
    scrYSize = oDraw.drawSize[1]

    IF event.type EQ 0 THEN BEGIN
       IF event.press EQ 1 THEN BEGIN
           self.panStatus[0:3] = [1,0,event.x,event.y]
       ENDIF
    ENDIF

    IF event.type EQ 2 THEN BEGIN
       IF self.panStatus[0] EQ 1 THEN BEGIN
         xPos = 1 > event.x < scrXSize-1
         yPos = 1 > event.y < scrYSize-1

            distanceX = self.panStatus[2] - xPos
            distanceY = self.panStatus[3] - yPos

            newViewLoc = viewLoc - [distanceX, distanceY]

           self.oView->SetProperty, Location = newViewLoc
         self.panStatus[2:3] = [xPos, ypos]
            oDraw.oWindow->Draw
       ENDIF
    ENDIF

    IF event.type EQ 1 THEN BEGIN
       self.panStatus[0:3] = 0
        oDraw.oWindow->Draw
    ENDIF

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;事件处理
;
PRO ADDGManage::HandleEvent, event

    COMPILE_OPT IDL2

    oSystem = self.oSystem

    IF event.type EQ 7 THEN BEGIN
       IF (Total(self.selectStatus) NE 0) OR (Obj_Valid(self.beLabelOn)) THEN Return
       self->Wheel, event
    ENDIF

    IF (Tag_Names(event, /Structure_Name) EQ 'WIDGET_DRAW') THEN BEGIN
       CASE self.mouseStatus OF
         'hand' : self->Hand, event
         'annotate' : self->Annotate, event
         ELSE :
       ENDCASE
    ENDIF
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;视图配置
;
PRO ADDGManage::ConfigureLayer

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    ;图像层
    oLayer = Obj_New('AdImageLayer' , $
              Project = self        , $
              Parent = self         , $
              UName = 'imagefile'    )
;    ;标注层
    oLayer = Obj_New('AdAnnoLayer'  , $
              Project = self        , $
              Parent = self         , $
              UName = 'annotate'      )

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;配置范围
;
PRO ADDGManage::configViewRange, image = image

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    oDraw = self.oDraw
    ;View显示范围
    viewPlane = [0, 0, self.viewXSize,self.viewYSize]

    viewRate = Float(viewPlane[2])/viewPlane[3]
    drawRate = Float(oDraw.drawSize[0])/oDraw.drawSize[1]
    ;
    IF KeyWord_Set(image) THEN BEGIN
        ;
        viewDimX = self.viewXSize;oDraw.drawSize[1]
        viewDimY = self.viewYSize;viewRate * viewDimY
        locationX = (oDraw.drawSize[0] - viewDimX)/2.
        locationY = (oDraw.drawSize[1] - viewDimY)/2.

    ENDIF ELSE BEGIN
        IF viewRate LE drawRate THEN BEGIN
            viewDimY = oDraw.drawSize[1]
            viewDimX = viewRate * viewDimY
            locationX = (oDraw.drawSize[0] - viewDimX)/2.
            locationY = 0
        ENDIF ELSE BEGIN
            viewDimX = oDraw.drawSize[0]
            viewDimY = 1 / viewRate * viewDimX
            locationX = 0
            locationY = (oDraw.drawSize[1] - viewDimY)/2.
        ENDELSE
    ENDELSE

    self.viewRate = [viewDimX, viewDimY, locationX, locationY]/4

    self.oView->Setproperty, Viewplane_Rect = viewPlane , $
                 Dimensions = [viewDimX, viewDimY]      , $
                 Location = [locationX, locationY]

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
;
;创建图像工程内部对象
;
PRO ADDGManage::Create

    COMPILE_OPT IDL2

    oSystem = self.oSystem
    oDraw = self.oDraw

    oColor = [255,255,255];[166,210,223]
    ;创建视图
    self.oView = Obj_New('IDLgrView'          , $
                   Color = oColor      , $
                   Eye = 101          , $
                   ZClip = [100,-1]     )
    oDraw.oScene->Add, self.oView
    self.oView->Add, self

    self->ConfigViewRange;

END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;析构
;
PRO ADDGManage::Cleanup

    COMPILE_OPT IDL2

    self->IDLgrModel::Cleanup

;    Ptr_Free, self.sMap
    Obj_Destroy, self.oView
;    Obj_Destroy, self.oZoomModel
;    Obj_Destroy, self.oZoomPlot

END
;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;初始化
;
FUNCTION ADDGManage::Init   , $
    OSystem = oSystem       , $
    oDGManager = oDGManager , $
    UName = uName           , $
    oDraw = oDraw           , $
    _Extra = _extra

    COMPILE_OPT IDL2

    IF (self->IDLgrModel::Init(_Extra=extra) NE 1) THEN Return, 0

    self.oSystem = oSystem
    self.oDraw = oDraw
    self.uName = uName
    self.rootDir = (self.oSystem).rootDir
    self.viewXSize = oDraw.drawSize[0];
    self.viewYSize= oDraw.drawSize[1]

    ; 图形窗口鼠标状态共分四种, 缩放(zoom), 平移(pan), 标注(annotation),
    ; 选择(select),
    self.mouseStatus= 'hand'
    self.annotateStatus[0] = 'text'

    self->Create

    self->ConfigureLayer

    oDraw.oWindow->SetCurrentCursor, 'ARROW'

    Return, 1
END

;≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌-
;
;定义
;
PRO ADDGManage__Define

    COMPILE_OPT IDL2

    void = {ADDGManage                      , $
           ;继承的父类
        INHERITS IDLgrModel                 , $

        ;系统参数
        rootDir         :    ''         , $
        uName           :    ''         , $
        value           :    ''         , $

        mouseStatus     :   ''          , $
        selectStatus    :  [0B,0B]      , $
        ;
        viewXSize       :   0L          , $
        viewYSize       :   0L          , $
        ;
        zoomPos         :   Fltarr(4)   , $
        panStatus       :   Fltarr(4)   , $
        viewRate        :   Fltarr(4)   , $

        ;标注相关
        beSelect        :   Obj_New()   , $
        beLabelOn       :   Obj_New()   , $
        ;当前标注的状态,
        annotateStatus  :   ['','']     , $

        ;系统对象
        oSystem         :   Obj_New()   , $
        oDraw           :   Obj_New()   , $
        oView           :   Obj_New()   , $
        oZoomPlot       :   Obj_New()     $
            }

END