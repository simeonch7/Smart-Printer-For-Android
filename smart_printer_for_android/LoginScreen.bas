﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private raf As RandomAccessFile
	Private loginPanel As Panel
	Private appTitle, lblConnection As Label
	Private PrinterIP, PrinterPort As EditText
	Public btnloginPanel As Button
	Public CAD As CustomAlertDialog
	Private checkloginPanel As CheckBox
	Private usrString, PrinterPortString As String
	Private settingsBG As BitmapDrawable
	Private BMP_Options As Bitmap
End Sub

'Проверка за съществуване на директории и фаилове / Folder and file check on start up
Private Sub start_up
	If File.Exists(File.DirDefaultExternal , "PrinterIPs.config")  = True And File.Size (File.DirDefaultExternal , "PrinterIPs.config") > 0 Then
		checkloginPanel.Checked = True
	End If
	
	If checkloginPanel.Checked Then
		Read_SavedUsrs
		PrinterIP.Text = usrString
		PrinterPort.Text = PrinterPortString
	Else
		PrinterIP.Text = ""
		PrinterPort.Text = ""
	End If
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	appTitle.Initialize("")
	lblConnection.Initialize("isConnect")
	loginPanel.Initialize("loginPanelPanelsFake")
	PrinterIP.Initialize("PrinterIPName")
	PrinterPort.Initialize("PrinterPort")
	checkloginPanel.Initialize("Remember")
	btnloginPanel.Initialize("ButtonloginPanel")
	BMP_Options.Initialize(File.DirAssets, "options_icon.png")

	settingsBG.Initialize(BMP_Options)
	btnloginPanel.Background = settingsBG

End Sub

' Построяване на екрана / Builds the UI of the screen
Public Sub build_Screen
	loginPanel_Configurations
	start_up
	
	Private edtWidth,edtHeight As Int
	Private btnWidth,btnHeight As Int
	Private Padding,left As Int
	

		Padding = ProgramData.DefaultPadding
		edtWidth = loginPanel.Width*0.7
		edtHeight = loginPanel.Height*0.08
		btnHeight = loginPanel.Height*0.08
		btnWidth = edtWidth/2 - Padding
		left = (loginPanel.Width - edtWidth)/2	
		
	loginPanel.AddView(appTitle, left, loginPanel.Height*(0.1), edtWidth, edtHeight + 2)
	
	loginPanel.AddView(PrinterIP,left, loginPanel.Height*(0.3),edtWidth, edtHeight)
	loginPanel.AddView(PrinterPort, left, PrinterIP.Top+PrinterIP.Height*1.5+Padding, edtWidth, edtHeight)
		
	loginPanel.AddView(checkloginPanel, left + Padding, PrinterPort.Top + edtHeight * 1.5, btnWidth, btnHeight)
	Padding = 7%x
	loginPanel.AddView(btnloginPanel, checkloginPanel.Left + checkloginPanel.Width + Padding, checkloginPanel.Top, btnWidth / 2, btnHeight)

	loginPanel.AddView(lblConnection, left + Padding, checkloginPanel.Top + edtHeight * 1.5, btnWidth, btnHeight)


	
	btnloginPanel.Enabled=True
'	refreshloginPanel_Labels
End Sub

'Прилагане на стилове за външния вид на екрана за влизане / Applying visual styles for loginPanel screen
Private Sub loginPanel_Configurations
	loginPanel.SetBackgroundImage(LoadBitmap(File.DirAssets,"login_background.jpg"))
	
	appTitle.Text = Main.translate.GetString("title")
	appTitle.TextSize = 20
	appTitle.Typeface = Typeface.DEFAULT_BOLD
	appTitle.Gravity = Gravity.CENTER
	appTitle.TextColor = Colors.White
		
	HelperFunctions.Apply_ViewStyle(PrinterIP,Colors.Black,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,60)
	PrinterIP.Padding = Array As Int(15,0,0,0)
	PrinterIP.SingleLine = True

	PrinterIP.Hint = Main.translate.GetString("hintIP")
	PrinterIP.HintColor = Colors.Gray
	PrinterIP.TextSize = 14
	
	HelperFunctions.Apply_ViewStyle(PrinterPort,Colors.Black,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,60)
	PrinterPort.Padding = Array As Int(15,0,0,0)
	PrinterPort.SingleLine = True
	PrinterPort.Hint = Main.translate.GetString("hintPort")
	PrinterPort.HintColor = Colors.Gray
	PrinterPort.TextSize = 14

	checkloginPanel.TextColor=Colors.White
	checkloginPanel.TextSize = 14
	checkloginPanel.Gravity = Gravity.CENTER_VERTICAL
	checkloginPanel.Text = Main.translate.GetString("rememberSettings")

	btnloginPanel.Gravity = Gravity.CENTER
	btnloginPanel.Background = settingsBG
	
	lblConnection.TextSize = 14

	If checkNet Then
		lblConnection.Text = "Connected"
		lblConnection.TextColor = Colors.Green

	Else
		lblConnection.Text = "Disconnected"
		lblConnection.TextColor = Colors.Red
	End If

End Sub

'Метод прехвърлящ фокус между полетата / Changes focus between input fields
Private Sub PrinterPort_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		PrinterPort.Text=""
	End If
End Sub

'Записва в RAF файл текущия потребител / Writes the current PrinterIP 
Private Sub write_Usrs
	raf.Initialize(File.DirDefaultExternal, "PrinterIPs.config", False)
	raf.WriteEncryptedObject(usrString, ProgramData.rafEncPass, raf.CurrentPosition)
	raf.WriteEncryptedObject(PrinterPortString, ProgramData.rafEncPass, raf.CurrentPosition)
	raf.Close
End Sub

'Чете от RAF файл текущия потребител
Private Sub Read_SavedUsrs
	raf.Initialize(File.DirDefaultExternal, "PrinterIPs.config", False)
	usrString = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
	PrinterPortString = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
	
	ProgramData.strPrinterIP = usrString
	ProgramData.strPrinterPort = PrinterPortString
	raf.Close
End Sub

'Метода, който вкарва потребителя в системата / Method for log in 
Private Sub ButtonloginPanel_Click
	'Бутона Вход се деактивира. Против спам
	btnloginPanel.Enabled=False
	
End Sub

Private Sub isConnect_Click
	If checkNet Then
		lblConnection.Text = "Connected"
		lblConnection.TextColor = Colors.Green
	Else
		lblConnection.Text = "Disconnected"
		lblConnection.TextColor = Colors.Red
		ToastMessageShow("No Internet Connection", False)
	End If
End Sub

Public Sub checkNet As Boolean
	Dim p As Phone
	Dim Response, Error As StringBuilder
	Response.Initialize
	Error.Initialize
	'Ping Google DNS - if you can't reach this you are in serious trouble!
	p.Shell("ping -c 1 8.8.8.8",Null,Response,Error)
	Log("======= Response ========")
	Log(Response)
	Log("======= Error ===========")
	Log(Error)
	Log("======================")

	If Error.ToString="" Then
		Return True
       
	Else
		Return False
	End If
End Sub

Public Sub asView As Panel
	Return loginPanel
End Sub