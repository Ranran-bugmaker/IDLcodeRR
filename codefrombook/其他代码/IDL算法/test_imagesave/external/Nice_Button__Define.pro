;+----------------------------------------------------------------------------------------------------------------
; This routine sets properties of the Nice_Button class.
;
; @Keyword
;   Value {in}{optional}
;     Not presently implemented.
; @Keyword
;   Name {in}{optional}{type=string}
;     Set this keyword to a scalar string value to be
;     applied as the name property of the object.
; @Keyword
;   Timer {out}{optional}{type=float}
;     Set this keyword to a floating point value in seconds
;     representing the slow button pulse rhythm delay between
;     color changes.
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::SetProperty, $
                       Value = Value, $
                       Name = Name, $
                       Timer = Timer

    Compile_Opt StrictArr

    If (N_elements(Value) ne 0) then Begin
    EndIf

    If (N_elements(Name) ne 0) then Begin
        self.Name = Name
    EndIf

    If (N_elements(Timer) ne 0) then Begin
        self.BaseTimer = Timer
        self.Timer = self.BaseTimer
    EndIf
End
;+----------------------------------------------------------------------------------------------------------------
; This routine returns properties of the Nice_Button class.
;
; @Keyword
;   Value {out}{optional}
;     Not presently implemented.
; @Keyword
;   Name {out}{optional}{type=string}
;     Set this keyword to a named variable to retrieve the
;     name property of the object as a scalar string.
; @Keyword
;   Timer {out}{optional}{type=float}
;     Set this keyword to a named variable to retrieve the
;     current time delay in seconds of the button pulse
;     rhythm between color changes.
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::GetProperty, $
                       Value = Value, $
                       Name = Name, $
                       Timer = Timer

    Compile_Opt StrictArr

    If (Arg_Present(Value)) then Begin

    EndIf

    If (Arg_Present(Name)) then Begin
        Name = self.Name
    EndIf

    If (Arg_Present(Timer)) then Begin
        Timer = self.Timer
    EndIf
End
;+----------------------------------------------------------------------------------------------------------------
; This method is responsible for updating the graphic state of the
; "button" image.  If the cursor is off the button, it pulses slowly
; in blue. If the cursor is over the button, then it pulses more
; rapidly in red.  If the cursor is pressed on top of the button,
; it will additionally draw its usually-white outline in yellowish green.
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::Update_Button, init=init, NotInitImg=NotInitImg

    Compile_Opt StrictArr
    ;
    ; Get the copy of the original image array.
    ;
    DrawWidget = Widget_Info(self.ID, Find_by_UName = 'NiceButtonDrawWidget')
    Widget_Control, DrawWidget, Get_Value = oDrawWindow
    oDrawWindow->GetProperty, Graphics_Tree = oView, Dimensions = Dimensions
    oImage = oView->GetByName('NiceButtonModel/NiceButtonImage')
    oBarImage = oView->GetByName('BarModel/BarImage')
    oBarText = oView->GetByName('BarModel/BarText')
    ;
    ; Get the image array.  Remember that this is the original image from
    ; file, represented as a [3, X*Y] array, rather than the [3, X, Y]
    ; array currently used as the IDLgrImage data.
    ;
    oImage->GetProperty, UValue = Image
    ;
    ; 初始化到正常状态
    if Keyword_Set(init) then begin
       if ~Keyword_Set(NotInitImg) then begin
         ;
         ; 纯图标情况，移出时显示系统背景色
         if self.Status_Normal eq 1 then begin
          oImage->SetProperty, Data = *self.pBackImage
         endif else begin
          oImage->SetProperty, Data = Image ;
         endelse
       endif
       ;
       ;
       if Obj_Valid(oBarImage) then begin
         oBarImage->GetProperty, uvalue=oriLoc
         oBarImage->SetProperty, loc=oriLoc
       endif
       if Obj_Valid(oBarText) then begin
         oBarText->GetProperty, uvalue=oriLoc
         oBarText->SetProperty, loc=oriLoc
       endif
       oDrawWindow->Draw
       ;
       ;
    ;  ToolTip = Widget_Info(DrawWidget, /tooltip)
    ;  Widget_Control, DrawWidget, ToolTip = ToolTip
       Return
    endif
    ;
    ; 按下的时候，更换到被按下时的状态
    if self.IsPressed eq 1 then begin
       ;
       ; 显示
;     oImage->SetProperty, Data = Image
       ;
       ;
       if Obj_Valid(oBarImage) then begin
         oBarImage->GetProperty, loc=loc, uvalue=oriLoc
         if loc[0] eq oriLoc[0] then $
          oBarImage->SetProperty, loc=oriLoc+[1, -1]
       endif
       if Obj_Valid(oBarText) then begin
         oBarText->GetProperty, loc=loc, uvalue=oriLoc
         if loc[0] eq oriLoc[0] then $
          oBarText->SetProperty, loc=oriLoc+[1, -1]
       endif
       oDrawWindow->Draw
       ;
       ;
    ;  ToolTip = Widget_Info(DrawWidget, /tooltip)
    ;  Widget_Control, DrawWidget, ToolTip = ToolTip
       Return
;     Image = Reform(Image, 3, Dimensions[0], Dimensions[1], /Overwrite)
;     Image = Shift(Temporary(Image), 0, 1, -1)
    endif else begin
    ;
    ; 悬停的时候
       ;
       ; 渐变色调
       if self.Timer eq -1 then begin
         Image = (Image - 60) > 0B
       endif else begin
         self.Phase = (self.Phase + self.increase) mod 30
         if self.Phase eq 29 then self.increase = Abs(self.increase)*(-1)
         if self.Phase eq 0 then self.increase = Abs(self.increase)
         Image[0:2, *, *] = Temporary(255B < (Image[0:2, *, *] - 2.5*self.Phase) > 0B) ; 颜色往深的走
       endelse
       ;
       ; 显示
       oImage->SetProperty, Data = Image
       oDrawWindow->Draw
       ;
       ;
    ;  ToolTip = Widget_Info(DrawWidget, /tooltip)
    ;  Widget_Control, DrawWidget, ToolTip = ToolTip, update=1
       Return
    endelse
End
;+----------------------------------------------------------------------------------------------------------------
; This routine is responsible for dispatching IDL widget GUI
; events from the compound widget's contained widgets to the
; appropriate methods.
; <p>
; This routine is called by Generic_Class_Event, which
; is the XMANAGER-registered event handler for all
; GUI events associated with the control.</p>
;
; @Param
;   Event {in}{required}{type=structure}
;     An IDL widget event from the Nice_Button widget.
;
; @Uses
;   Nice_Button::Update_Button <br>
;   Nice_Button::Cursor_In_Ball
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::Event, Event ; 皇太后处理这些事件

    Compile_Opt StrictArr
    ;
    ; Clean up gracefully in the event of an error.
    ;
    Catch, ErrorNumber
    If (ErrorNumber ne 0) then Begin
        Catch, /Cancel
        Help, /Last_Message, Output = LastError
        v = Dialog_Message(Dialog_Parent = Event.Top, $
           /Error, LastError)
        Return
    EndIf
    ;
    ; If the widget doesn't have a UVALUE then we have nothing
    ; to do.
    ;
    Widget_Control, Event.ID, Get_UValue = UValue
    If (N_elements(UValue) eq 0) then Begin
        Return
    EndIf
    EventType = Tag_Names(Event, /Structure_Name)
    ;
;    ; 悬停事件处理
    If (EventType eq 'WIDGET_TRACKING') then Begin
        If (Event.Enter eq 1) then Begin

         DrawWidget = Widget_Info(self.ID, Find_by_UName = 'NiceButtonDrawWidget')
            Widget_Control, DrawWidget, Input_Focus = 1 ; 把焦点弄到Draw上去了。。。。
            self.IsEnter = 1
            ;
            ; 如果需要动画，打开计时器
            if self.Timer ne -1 then begin
               NiceButtonTimerBase = Widget_Info(self.ID, $
              Find_by_UName = 'NiceButtonTimerBase')
          Widget_Control, NiceButtonTimerBase, Timer = self.Timer
         endif else begin
          self->Update_Button
         endelse
            ; 转移焦点，下一次就不是WIDGET_TRACKING, 而是WIDGET_DRAW了
            ;
        EndIf Else Begin
            self.Timer = self.BaseTimer
            self.IsPressed = 0
            self.IsEnter = 0
            self.Phase = 28
            ;
            ; 如果不动画，将背景设置到初始状态
            if self.Timer eq -1 then begin
               self->Update_Button, /init
            endif

        EndElse

        Return
    EndIf
    ;
    ; Branch according to the UValue of the widget that caused this event.
    ;
    Case UValue of
       ;
       ; 动画暗门事件
        'NiceButtonTimer' : Begin
    ;
    ; On a timer event, pulse the color of the button and
    ; throw another timer event.
            ;
            ; 如果仍然是悬停，且需要动画，则继续打开计时器
            if self.IsEnter eq 1 then begin
               if self.Timer ne -1 then begin
                 self->Update_Button
                 Widget_Control, Event.ID, Timer = self.Timer
               endif else self->Update_Button
            endif else begin
               ;
               ; 将背景设置到初始状态
               self->Update_Button, /init
            endelse
            End
        'DrawWindow' : Begin
            Case Event.Type of
                0 : Begin
    ;
    ; Button press.  The press does not signal a selection
    ; of the button.  Only if we also release inside the button
    ; area do we signal the parent that we should Nice.
                        self.IsPressed = 1
                        self->Update_button
                        NewEvent = {WIDGET_BUTTON, $
                            ID : self.ID, $
                            Top : Event.Top, $
                            Handler : 0L, $
                            Select : 2L $
                            }
                        Widget_Control, self.ID, Send_Event = NewEvent
                    End
                1 : Begin
    ;
    ; Button release.  This is a true "select" event and indicates
    ; that we want to Nice.
    ;
                    If (self.IsPressed) then Begin
                        NewEvent = {WIDGET_BUTTON, $
                            ID : self.ID, $
                            Top : Event.Top, $
                            Handler : 0L, $
                            Select : 1L $
                            }
                        Widget_Control, self.ID, Send_Event = NewEvent
                    EndIf
                    NiceButtonTimerBase = Widget_Info(self.ID, $
                        Find_by_UName = 'NiceButtonTimerBase')
                    Widget_Control, NiceButtonTimerBase, Timer = self.Timer
                    self.IsPressed = 0B
                    self->Update_Button, /Init, /NotInitImg
                    End
                2 : Begin
    ;
    ; Motion
    ;
                    DrawWidget = Widget_Info(self.ID, $
                        Find_by_UName = 'NiceButtonDrawWidget')
                    Widget_Control, DrawWidget, Get_Value = oDrawWindow
                    oDrawWindow->GetProperty, Graphics_Tree = oView
    ;
    ; If we're inside the circle, turn up the pulse speed by 5 times.
    ; 3倍加速
    ;        InBall = self->Cursor_In_Ball([Event.X, Event.Y])
              InBall = 1
                    self.Timer = InBall ? self.BaseTimer/4. : self.BaseTimer
                    If (self.IsPressed && (~InBall)) then Begin
    ;
    ; If we're in a drag operation, we want to signal the parent if we've
    ; moved off the circle.  This has the effect of cancelling the press
    ; before signalling a release.
    ;
                        NewEvent = {WIDGET_BUTTON, $
                            ID : self.ID, $
                            Top : Event.Top, $
                            Handler : 0L, $
                            Select : 0 $
                            }
                        Widget_Control, self.ID, Send_Event = NewEvent
                        self.IsPressed = 0
                    EndIf
                    End
                4 : Begin
    ;
    ; Expose event
    ;
                    oDrawWindow->Draw
                    End
                5 : Begin
    ;
    ; Keyboard event
    ;
                    Case Event.Press of
                        1 : Begin
    ;
    ; Key press
    ;
                            Switch Event.Ch of
    ;
    ; On a carriage return, send an event on the button,
    ; as if the user had clicked and released it.
    ;
                                10 :
                                13 : Begin
                                    NewEvent = {WIDGET_BUTTON, $
                                        ID : self.ID, $
                                        Top : Event.Top, $
                                        Handler : 0L, $
                                        Select : 1L $
                                    }
                                    Widget_Control, self.ID, $
                                        Send_Event = NewEvent
                                    Break
                                    End
                                Else :
                            EndSwitch
                            End
                        Else :
                    EndCase
                    End
                Else :
            EndCase
            End
        Else:
    EndCase
End
;+----------------------------------------------------------------------------------------------------------------
; This method has the primary responsibility for cleaning
; up the Nice_Button object at the end of its lifecycle.
; It is called by the ::Cleanup method to perform the work
; of cleaning up the object.
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::Destruct

    Compile_Opt StrictArr
    ;
    ; Kill the top base, which will destroy the draw widget and
    ; its contained view elements.
    ;
    If (Widget_Info(self.ID, /Valid_ID)) then Begin
        Widget_Control, self.ID, Kill_Notify = ''
        Widget_Control, self.ID, /Destroy
    EndIf
    ;
    ; Clean up the pointers to the image indices indicating the
    ; "red" and "white" pixels.
    ;
    Ptr_Free, self.pBarImage
    Ptr_Free, self.pBackImage

    Obj_Destroy, self.oTextFont
    ;
    ; Only attempt to destroy the object reference if we are no
    ; longer in the INIT method of this class.
    ;
    Initializing = Where((Scope_Traceback(/Structure)).Routine eq $
        'Nice_Button::INIT', NInitializing)
    If (NInitializing eq 0) then Begin
        Obj_Destroy, self
    EndIf
End
;+----------------------------------------------------------------------------------------------------------------
; This lifecycle method is called during the
; destruction of the Nice_Button object
; via OBJ_DESTROY.  It simply calls the
; true destuctor, Nice_Button::Destruct.
;
; <p>This method cannot be called directly
; from the object reference.</p>
;
; Cleanup方法不能由此类的对象直接调用，所以将事件处理转移到可以直接调用的Nice_Button::Destruct上
;
; @Uses
;   Nice_Button::Destruct
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::Cleanup

    Compile_Opt StrictArr

    self->Destruct
End
;+----------------------------------------------------------------------------------------------------------------
; This method is called at the time the compound widget is initially realized.
; It constructs the graphics view associated with the graphics window and
; makes the widget visible.  This routine is called by GENERIC_CLASS_NOTIFY_REALIZE.
;
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;   2007-11-3 DYQ  ,IMAGEINFO - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button::Notify_Realize, ID ; 这个ID是UValueBase的ＩＤ，垂帘听政者

    Compile_Opt StrictArr           ; self.ID是龙椅上没有实权的皇帝

    On_Error, 2
    ;
    ; We get the system colors here so we can render the view in a way
    ; that makes it look natural as a widget in the user's current
    ; desktop theme.
    ;
    SystemColors = Widget_Info(self.ID, /System_Colors) ; 获取系统颜色
    self.Face_3D = SystemColors.Face_3D
    DrawWidget = Widget_Info(self.ID, Find_by_UName = 'NiceButtonDrawWidget')
    Widget_Control, DrawWidget, Get_Value = oDrawWindow
    ;
    ; We want this draw widget to look like a regular widget rather than
    ; a draw window.  We begin by setting the cursor to the standard arrow
    ; rather than the crosshairs.
    CD, Current = rootDir
    ;
    oDrawWindow->SetCurrentCursor, 'ARROW'
    oDrawWindow->GetProperty, Dimensions = Dimensions ; 这个Dim就是输入的Size
    ;
    ; Create the view into which our Nice button will be placed.
    ;
    oView = Obj_New('IDLgrView', Name = 'NiceButtonView', color=self.Face_3D, $
        Viewplane_Rect = [-Dimensions/2, Dimensions]) ; 中心点为0, 像素坐标
    oDrawWindow->SetProperty, Graphics_Tree = oView
    ;
    ; 将建Model
    oModel = Obj_New('IDLgrModel', Name = 'NiceButtonModel', /Select_Target) ; 将Model本身设为可选中对象
    oView->Add, oModel
    oModel->Translate, -Dimensions[0]/2., -Dimensions[1]/2., 0 ; Model移动到左下角
    ;
    ; 仅有图标时，普通状态(鼠标移出)不显示背景图片，显示背景色
    if self.Status_Normal eq 1 then begin
       Image = Bytarr(4, Dimensions[0], Dimensions[1])
       For I = 0, 2 Do Begin
           Image[I, *, *] = self.Face_3D[I]
       EndFor
       Image[3, *, *] = 255B ; 完全不透明
       self.pBackImage = Ptr_New(Temporary(Image))
    endif
    ;
    ; 背景可选：N种,系统提供, 可扩展
    case self.GroudStyle of
       ;
       ; 纯背景
       1: begin
         Image = Bytarr(4, Dimensions[0], Dimensions[1])
         For I = 0, 2 Do Begin
             Image[I, *, *] = self.Face_3D[I]
         EndFor
         Image[3, *, *] = 255B; 完全不透明
       end
       ;
       ; 蓝400*100
       2: begin
         Image = Read_Png(rootDir +'\resource\backGround\y2.png')
       end
       ;
       ; 淡黄400*100
       3: begin
         Image = Read_Png(rootDir +'\resource\backGround\y3.png' )
       end
       ;
       ; 淡蓝400*100
       4: begin
         Image = Read_Png(rootDir +'\resource\backGround\y4.png' )
       end
       ;
       ; 粉红400*100
       5: begin
         Image = Read_Png(rootDir +'\resource\backGround\y5.png' )
       end
       ;
       ; 浅灰400*100
       6: begin
         Image = Read_Png(rootDir +'\resource\backGround\y6.png' )
       end
       ;
       ; Vista蓝400*100
       7: begin
         Image = Read_Png(rootDir +'\resource\backGround\y7.png' )
       end
       ;
       ; 淡黄256*256
       8: begin
         Image = Read_Png(rootDir +'\resource\backGround\y8.png' )
       end
       ;
       ; 淡蓝256*256
       9: begin
         Image = Read_Png(rootDir +'\resource\backGround\y9.png' )
       end
       ;
       ; 淡紫256*256
       10: begin
         Image = Read_Png(rootDir +'\resource\backGround\y10.png' )
       end
       ;
       ; 浅灰256*256
       11: begin
         Image = Read_Png(rootDir +'\resource\backGround\y11.png' )
       end
       ;
       ; 水晶蓝256*256
       12: begin
         Image = Read_Png(rootDir +'\resource\backGround\y12.png' )
       end
       ;
       ; 水晶绿256*256
       13: begin
         Image = Read_Png(rootDir +'\resource\backGround\y13.png' )
       end
       else:
    endcase

    Image = Congrid(Image, 4, Dimensions[0], Dimensions[1])

    ;
    oImage = Obj_New('IDLgrImage', Image, $
        UValue = Image, Blend_Function = [3, 4], $ ; UValue保存原始图像，执行Alpha通道透明
        Name = 'NiceButtonImage')
    oModel->Add, oImage
    ;
    ; 风格可选：5种;
    ; 1：仅有文字
    ; 2：仅有图片
    ; 3：图片在上，文字在下
    ; 4：图片在左，文字在右
    ; 5：图片在右，文字在左
    case self.TypeStyle of
       1: begin
         oTextModel = Obj_New('IDLgrModel', Name='BarModel')
         oView->Add, oTextModel
         oText = Obj_New('IDLgrText', self.Name, Name='BarText', uvalue=[0,0], $
                    ALIGNMENT=0.5, VERTICAL_ALIGNMENT =0.5, color=self.TextColor)
         oTextModel->Add, oText
       end
       2: begin
         siz = Size(*self.pBarImage, /dim)
         oBarImageModel = Obj_New('IDLgrModel', Name='BarModel')
         oView->Add, oBarImageModel
         oriLoc = (-1*Dimensions[1])/2. + (Dimensions - Siz[1:2])/2.
         oBarImage = Obj_New('IDLgrImage', *self.pBarImage, dim=siz[1:2], loc=oriLoc, $
                    Name = 'BarImage', uvalue=oriLoc, Blend_Function = [3, 4])
         oBarImageModel->Add, oBarImage
       end
       3: begin
         siz = Size(*self.pBarImage, /dim)
         strSize = GetStringSize(self.Name, fontname='幼圆')
             oGroupModel = Obj_New('IDLgrModel', Name='BarModel')
         oView->Add, oGroupModel
         self.oTextFont = Obj_New('IDLgrFont', name='幼圆')
         textOriLoc = (-1*Dimensions)/2.+ [(Dimensions[0] - strSize[0])/2., Dimensions[1]*0.25]
         oText = Obj_New('IDLgrText', self.Name, Name='BarText', RENDER_METHOD=0, $
                    UValue=textOriLoc, Loc=textOriLoc, Font=self.oTextFont, $
                    ALIGNMENT=0.0, VERTICAL_ALIGNMENT =0.4, color=self.TextColor)
         oGroupModel->Add, oText
         oriLoc = (-1*Dimensions)/2.+ [(Dimensions[0] - siz[1])/2., (Dimensions[1] - siz[2])/2.+Dimensions[1]*0.2]
         oBarImage = Obj_New('IDLgrImage', *self.pBarImage, dim=siz[1:2], loc=oriLoc, $
                    Name = 'BarImage', uvalue=oriLoc, Blend_Function = [3, 4])
         oGroupModel->Add, oBarImage
       end
       4: begin
         siz = Size(*self.pBarImage, /dim)
         oGroupModel = Obj_New('IDLgrModel', Name='BarModel')
         oView->Add, oGroupModel
         self.oTextFont = Obj_New('IDLgrFont', name='幼圆')
         textOriLoc = [0, 0]
         oText = Obj_New('IDLgrText', self.Name, Name='BarText', Font=self.oTextFont, $
                    UValue=textOriLoc, Loc=textOriLoc, RENDER_METHOD=0, $
                    ALIGNMENT=0.4, VERTICAL_ALIGNMENT =0.4, color=self.TextColor)
         oGroupModel->Add, oText
         oriLoc = (-1*Dimensions)/2.+ [10, (Dimensions[1] - siz[2])/2.]
         oBarImage = Obj_New('IDLgrImage', *self.pBarImage, dim=siz[1:2], loc=oriLoc, $
                    Name = 'BarImage', uvalue=oriLoc, Blend_Function = [3, 4])
         oGroupModel->Add, oBarImage
       end
       5: begin
         siz = Size(*self.pBarImage, /dim)
         oGroupModel = Obj_New('IDLgrModel', Name='BarModel')
         oView->Add, oGroupModel
         self.oTextFont = Obj_New('IDLgrFont', name='幼圆')
         textOriLoc = [0, 0]
         oText = Obj_New('IDLgrText', self.Name, Name='BarText', Font=self.oTextFont, $
                    UValue=textOriLoc, Loc=textOriLoc, RENDER_METHOD=0, $
                    ALIGNMENT=0.6, VERTICAL_ALIGNMENT =0.4, color=self.TextColor)
         oGroupModel->Add, oText
         xloc = (Dimensions[0] - siz[1])/2. - 18
         yloc = (-1*Dimensions[1])/2.+ (Dimensions[1] - siz[2])/2.
         oriLoc = [xloc, yloc]
         oBarImage = Obj_New('IDLgrImage', *self.pBarImage, dim=siz[1:2], loc=oriLoc, $
                    Name = 'BarImage', uvalue=oriLoc, Blend_Function = [3, 4])
         oGroupModel->Add, oBarImage
       end
       else:
    endcase
    ;
    ;
    ; 将背景设置到初始状态
    self->Update_Button, /init
    ; Show the compound widget.
    ;
    Widget_Control, self.ID, Map = 1
End
;+----------------------------------------------------------------------------------------------------------------
; This method is responsible for creating a new Nice_Button
; object when invoked via OBJ_NEW().  This routine is invoked
; from cw_Nicebutton.pro.
;
; @Examples <pre>
;   TLB = Widget_Base(Title = 'Nice Button', /Column)
;   NiceButton = CW_NiceButton(TLB, $
;     UName = UName, $
;     UValue = UValue, $
;     Scr_Size = Size, $
;     Timer = Timer)</pre>
;
;   The event structure returned by this compound widget is
;   the standard {WIDGET_BUTTON} structure, with the Select
;   field given one of three values.<pre>
;     Select = 0 : The mouse moved off the button after a press but before a release
;     Select = 1 : The mouse was pressed and released on the button
;     Select = 2 : The mouse has been pressed but not released </pre>
;     Select = 3 : The mouse tracked out of the button w/o a press </pre>
;
; @Param
;   Parent {in}{required}{type=long}
;     The ID of the parent WIDGET_BASE to contain the Nice_Button
;     compound widget.
; @Param
;   ID {out}{required}{type=long}
;     The ID of the base acting as the top-level of the Nice_Button
;     compound widget.
;
; @Keyword
;   Scr_Size {in}{optional}{type=long}{default=100}
;     A single value, indicating the height and width of the Nice
;     button image, in pixels.
; @Keyword
;   UValue {in}{optional}{type=any}{default=none}
;     Set this keyword to any user-supplied user value to be associated
;     with the compound widget's top base.
; @Keyword
;   UName {in}{optional}{type=string}{default=none}
;     Set this keyword to any user-supplied name string to be applied to the
;     compound widget's top base.
; @Keyword
;   Name {in}{optional}{type=string}{default=none}
;     Set this keyword to any user-supplied name string to be applied to
;     the Nice_Button object.
; @Keyword
;   Timer {in}{optional}{type=float}{default=0.10}
;     Set this keyword to a scalar floating point value to indicate the
;     time between color changes when pulsing the button image.
;
; @History
;   2/27/2003  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Function Nice_Button::Init, $
                   Parent, $
                   ID, $ ; 输出组合组建顶Base
                     Name = Name, $ ;  给Nice_Button的名字
                     BarImage = BarImage, $ ;
                     UValue = UValue, $
                     UName = UName, $
                     Scr_Size = Size_Local, $  ; 组合组件大小[x, y], 大小不要超过背景图的大小
                     Timer = Timer, $
                     GroudStyle = GroudStyle, $ ; 背景可选：3种,系统提供
                   TypeStyle = TypeStyle, $ ; 风格可选：5种
                   Status_Normal = Status_Normal, $ ; 普通状态, 选择要不要背景
                   TextColor = TextColor, $ ;  文字颜色
                   ToolTip = ToolTip
    Compile_Opt StrictArr
    ;
    ; 初始化类结构
    ;
    ; 至少指定上级Base和给一个组合组件顶Base的接收变量
    If (N_Params() ne 2) then Begin
        Message, 'Two parameters are required.', /Traceback
    EndIf
    ;
    ; 上级Base合法否？
    If (not Widget_Info(Parent, /Valid_ID)) then Begin
        Message, 'PARENT widget ID is invalid.', /Traceback
    EndIf
    ;
    ; 是否提供了接收组合组件顶Base的变量？
    If (not Arg_Present(ID)) then Begin
        Message, 'RETURNID is not writable.', /Traceback
    EndIf
    ;
    ;
    if N_Elements(TextColor) eq 0 then self.TextColor = [0, 0, 0] $
    else self.TextColor = TextColor
    ;
    ; 闪烁时的增幅，通常是正负一
    self.increase = 1
    self.Phase = 28 ; 动画区间
    ;
    ; 普通状态
    ; 0：普通时显示背景图，1：普通是不显示背景图，完全透明，即显示背景色，纯图标工具栏有用这个
    if N_Elements(Status_Normal) eq 0 then self.Status_Normal = 0 $
    else self.Status_Normal = Status_Normal
    ;
    ; 背景可选：N种,系统提供, 可扩展
    ;
    if N_Elements(GroudStyle) eq 0 then self.GroudStyle = 2 $
    else self.GroudStyle = GroudStyle
    ;
    ; 风格可选：5种;
    ; 1：仅有文字
    ; 2：仅有图片
    ; 3：图片在上，文字在下
    ; 4：图片在左，文字在右
    ; 5：图片在右，文字在左
    if N_Elements(TypeStyle) eq 0 then self.TypeStyle = 1 $
    else self.TypeStyle = TypeStyle
    ;
    ;
    if N_Elements(BarImage) ne 0 then self.pBarImage = Ptr_New(BarImage)
    ;
    ; 默认组合组件大小是100
    if N_Elements(Size_Local) eq 0 then begin
       if self.TypeStyle eq 2 then begin
         siz = Size(*self.pBarImage, /Dim)
         Size = siz[1:2] + 6
       endif else Size = [100, 100]
    endif else begin
       Size = Size_Local
    endelse
    ;
    ; Fail gracefully in the event of an error; never leak memory in
    ; an INIT!
    ; 注意清空内存
    ;
    Catch, ErrorNumber
    If (ErrorNumber ne 0) then Begin
        Catch, /Cancel
        Help, /Last_Message, Output = LastError
        Print, LastError
        self->Destruct ; 可调用的内存清理方法
        Return, 0
    EndIf
    ;
    ; The Name property is set so a user could find this object by name.
    ;
    self.Name = N_elements(Name) eq 1 ? Name : ''  ; 默认空名字
    ;
    ; 动画速度
    if N_elements(Timer) ne 0 then begin
       self.BaseTimer = Timer; : 1.e-1 ; 基本动画速度, 默认0.1
       self.Timer = self.BaseTimer  ; 当前动画速度，默认和基本动画速度一致, 这个主要用在悬停和离开时，动画速度的变化
    endif else begin
       self.BaseTimer = -1
       self.Timer = -1
    endelse
    ;
    ; Create the top base for the compound widget with the
    ; user-specified UNAME and UVALUE.
    ; 组合组件顶Base
    self.ID = Widget_Base(Parent, $
       UName = UName, $ ; 这个是用户给定的UName
        /Align_Center, $
        UValue = UValue, $ ; 这个是用户给定的UValue
        XPad = 0, YPad = 0, Space = 0, $
        Func_Get_Value = 'NiceButton_Get_Value', $ ; 这个是给Widget_Info用的
        Pro_Set_Value = 'NiceButton_Set_Value') ; 这个是给Widget_Control用的
    ;
    ; The ID of this compound widget is passed back through
    ; an optional output parameter.
    ;
    ID = self.ID ; 输出
    ;
    ; Hide the base until post-realization.
    ; 先藏一下
    Widget_Control, self.ID, Map = 0
    ;
    ; The first child base contains the UVALUE and all the
    ; mechanics of the compound widget.   It's a bulletin
    ; board base so we can hide elements that won't be
    ; visible to the user.
    ; 实际上的顶层Base，所有的子组建都基于此, 垂帘听政的皇太后, 所有事件都是在这里说了算
    UValueBase = Widget_Base(self.ID, $
       UValue = self, $ ; 这是本类
        UName = 'UValueBase', $ ; 这是本类皇太后的UName
        XPad = 0, YPad = 0, Space = 0, $
        Notify_Realize = 'Generic_Class_Notify_Realize', $ ; 初始化界面
        Event_Pro = 'Generic_Class_Event', $ ; 组合组件事件处理
        Kill_Notify = 'Generic_Class_Kill_Notify') ; 组合组件销毁
    ;
    ; Create the base that will be used as our timer trigger
    ; for pulsing the button colors.
    ; 计时器暗门
    TimerBase = Widget_Base(UValueBase, $
                   UValue = 'NiceButtonTimer', $ ; 暗门标识
                     XPad = 0, YPad = 0, Space = 0, $
                     UName = 'NiceButtonTimerBase') ; 暗门标识
    ;
    ; Create the draw widget which will contain the Nice button image.
    ; 在暗门后搭建舞台
    if N_Elements(ToolTip) eq 0 then ToolTip = ''
    DrawWidget = Widget_Draw(TimerBase, XSize = Size[0], $ ; 大小就是输入的组合组件的大小，[x, y]
        YSize = Size[1], UValue = 'DrawWindow', $ ; 舞台标识
        ToolTip = ToolTip, $
        /Button_Events, /Motion_Events, $
        /Align_Center, Graphics_Level = 2, Renderer = 1, $
        /Expose_Events, /Keyboard_Events, $
        /Tracking_Events, $ ; 交互功能全开
        UName = 'NiceButtonDrawWidget') ; 舞台标识

    Return, 1
End
;+----------------------------------------------------------------------------------------------------------------
; Define the member variables of the Nice_Button
; compound widget's class.
;
; @Field
;   ID
;     ID is the top base widget ID of the compound widget.
; @Field
;   Name
;     A string scalar specified by the user of any value.
; @Field
;   IsPressed
;     A flag indicating if the mouse button is in a pressed
;     state within the circular area of the Nice button image.
; @Field
;   Timer
;     A floating point number indicating the current time, in
;     seconds, between updates of the button image's colors.
; @Field
;   BaseTimer
;     A floating point number indicating the slow pulse time,
;     in seconds, between updates of the button image's colors.
; @Field
;   Phase
;     An internal counter which records the phase of the button
;     pulse.
; @Field
;   pRed
;     A pointer to a vector of indices in the input image that
;     contain the color red.
; @Field
;   pWhite
;     A pointer to a vector of indices in the input image that
;     contain the color white or something close to it.
;
; @History
;   02/25/2002  JLP, RSI - Original version
;   10/24/2007 Huxz, ISEIS - Modified version
;-----------------------------------------------------------------------------------------------------------------
Pro Nice_Button__Define

    Nice_Button = {Nice_Button, $
                ID               : 0L, $ ; 组合组件顶层Base
                Name             : '', $ ; Text显示的字符
                pBarImage         : Ptr_New(), $ ; 显示图像，漂浮的
                pBackImage        : Ptr_New(), $ ; 纯图标显示时，需记录背景颜色数组，达到透明效果, 图标本身的边角透明要做Alpha通道
                oTextFont         : Obj_New(), $ ; 文本字体
                IsPressed        : 0B, $ ; 是否按下
                IsEnter        : 0B, $ ; 是否悬停
                Timer            : 0., $ ; 当前动画速度
                BaseTimer          : 0., $ ; 基本动画速度, 非选中时的动画，目前已停用，但保留接口
                Phase            : 0B, $ ; 动画闪烁时，当前循环控制
                increase         : 0, $ ; 动画闪烁循环的增量
                Face_3D       : Bytarr(3), $ ; 系统背景色
                TextColor      : Bytarr(3), $ ; 文字颜色
                GroudStyle       : 0, $ ; 背景可选：3种,系统提供
             TypeStyle        : 0, $ ; 风格可选：5种
             Status_Normal    : 0  $; 普通状态, 选择要不要背景
                 }
End