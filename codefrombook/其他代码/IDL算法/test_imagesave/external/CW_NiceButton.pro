;+------------------------------------------------------------------------------------------
; This is a procedural interface for setting the
; current range of a range_slider object, called during
; WIDGET_CONTROL, SET_VALUE on the top base.  This
; is not presently implemented.
;
; @Param
;	ID {in}{required}{type=long}
;		The widget ID of the top base of the compound widget.
; @Param
;	Value
;
; @History
;	February 2003 : Jim Pendleton Research Systems, Inc.
;   October  2007 : Huxz, Insititute of Space and Earth Infomation Science, The Chinese University of Hong Kong
;-------------------------------------------------------------------------------------------
Pro NiceButton_Set_Value, ID, Value

	Compile_Opt StrictArr

	On_Error, 2

	UValueBase = Widget_Info(ID, Find_by_UName = 'UValueBase')

	Widget_Control, UValueBase, Get_UValue = oNiceButton

	oNiceButton->SetProperty, Value = Value
End
;+------------------------------------------------------------------------------------------
; This is a procedural interface for retrieving the
; current range of a range_slider object, via
; WIDGET_CONTROL, GET_VALUE on the top base.  This
; is not presently implemented.
;
; @Param
;	ID {in}{required}{type=long}
;		The widget ID of the top base of the compound widget.
;
; @Returns
;	The return value is a
;
; @History
;	February 2003 : Jim Pendleton, Research Systems, Inc.
;   October  2007 : Huxz, Insititute of Space and Earth Infomation Science, The Chinese University of Hong Kong
;-------------------------------------------------------------------------------------------
Function NiceButton_Get_Value, ID

	Compile_Opt StrictArr

	On_Error, 2

	UValueBase = Widget_Info(ID, Find_by_UName = 'UValueBase')

	Widget_Control, UValueBase, Get_UValue = oNiceButton

	oNiceButton->GetProperty, Value = Value

	Return, Value
End
;+------------------------------------------------------------------------------------------
; This is a procedural interface for creating
; a nice_button object widget.
;
;	TLB = Widget_Base(Title = 'Panic Button', /Column)
;	NiceButton = CW_NiceButton(TLB, $
;		UName = UName, $
;		UValue = UValue, $
;		Scr_Size = Size, $
;		Timer = Timer)</pre>
;
;	The event structure returned by this compound widget is
;	the standard {WIDGET_BUTTON} structure, with the Select
;	field given one of three values.<pre>
;	  Select = 0 : The mouse moved off the button after a press but before a release
;	  Select = 1 : The mouse was pressed and released on the button
;	  Select = 2 : The mouse has been pressed but not released </pre>
;
; @Param
;	Parent {in}{required}{type=long}
;		The ID of the parent WIDGET_BASE to contain the nice_button
;		compound widget.
;
; @Keyword
;	oNiceButton {out}{optional}{type=TwoDDraw object reference}
;		Set this keyword to a named variable to receive the
;		object reference to the nice_button object.
; @Keyword
;	Scr_Size {in}{optional}{type=long}{default=100}
;		A single value, indicating the height and width of the panic
;		button image, in pixels.
; @Keyword
;	UValue {in}{optional}{type=any}{default=none}
;		Set this keyword to any user-supplied user value to be associated
;		with the compound widget's top base.
; @Keyword
;	UName {in}{optional}{type=string}{default=none}
;		Set this keyword to any user-supplied name string to be applied to the
;		compound widget's top base.
; @Keyword
;	Timer {in}{optional}{type=float}{default=0.10}
;		Set this keyword to a scalar floating point value to indicate the
;		time between color changes when pulsing the button image.
;
; @Returns
;	The return value is the ID of the widget base containing
;	the GUI elements of the nice_button.  The function will
;	return -1 if the object creation fails.
;
; @History
;	February 2003 : Jim Pendleton, Research Systems, Inc.
;   October  2007 : Huxz, Insititute of Space and Earth Infomation Science, The Chinese University of Hong Kong
;-------------------------------------------------------------------------------------------
Function CW_NiceButton, Parent, $ ; 输入上级Base
						Name = Name, $ ; 显示文字
						BarImage = BarImage, $ ; 显示图像，漂浮的
						oNiceButton = oNiceButton, $ ; 输出组合对象
						Scr_Size = Scr_Size, $ ; 输入组件大小，[X Y]
						UName = UName, $ ; 输入识别符
						UValue = UValue, $ ; 输入抽屉
						Timer = Timer, $ ; 输入动画速度, 同时也是做不做动画的标记。如果没有输入Timer，则不做动画
						GroudStyle = GroudStyle, $ ; 背景可选：3种,系统提供
						TypeStyle = TypeStyle, $ ; 风格可选：5种
						Status_Normal = Status_Normal, $ ; 普通状态, 选择要不要背景
						TextColor = TextColor, $  ; 文字颜色
						ToolTip = ToolTip ;
	Compile_Opt StrictArr ;

	On_Error, 2

	oNiceButton = Obj_New('Nice_Button', $ ;
							Parent, $ ; 输入上级Base
							ID, $ ; 输出组合组件顶Base
							Scr_Size = Scr_Size, $ ;输入组合组件大小[X Y]
							Name=Name, $
							BarImage = BarImage, $ ; 显示图像，漂浮的
							UName = UName, $ ;输入识别符号
							UValue = UValue, $ ;输入抽屉
							Timer = Timer, $ ;输入动画速度
							GroudStyle = GroudStyle, $ ; 背景可选：3种,系统提供
							TypeStyle = TypeStyle, $ ; 风格可选：5种
							Status_Normal = Status_Normal, $; 普通状态, 选择要不要背景
							TextColor = TextColor, $ ; 文字颜色
							ToolTip = ToolTip $;
							)

	Return, Obj_Valid(oNiceButton) ? ID : -1 ; 如果初始化成功，返回组合组件顶Base，否则返回-1
End