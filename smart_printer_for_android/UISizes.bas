﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'This module holds the sizes/masures for all UI elements
Private Sub Process_Globals	
	Public HeaderHeight, FooterHeight, LeftPart,GroupScroller, ButtonLeft, settingsWidth, extrafunctionsWidth, initSettingsWidth, _
	keyboardWidth, GroupButtonHeight, HeaderLabelHeight, FooterLabelHeight, DefaultPadding, _
	PressedTextColor, itemHolderFooterHeight As Int	
	Public GroupColor_Normal, GroupColor_Pressed As String		
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	
		initSettingsWidth = 70%x
		keyboardWidth = 100%x
		HeaderHeight = 8%y
		FooterHeight = 7%y
		itemHolderFooterHeight = 5%y
		GroupScroller = 15%x
		
		DefaultPadding = 0.35%x
		LeftPart = 100%x
		settingsWidth = 80%x
		extrafunctionsWidth = 60%x
	
	GroupButtonHeight = 64dip
	GroupColor_Normal = 0xFF19ABFF
	GroupColor_Pressed = Colors.White	'Alternate value "0xFF0D5E89"
	PressedTextColor = Colors.Black
	ButtonLeft = 5%x
End Sub