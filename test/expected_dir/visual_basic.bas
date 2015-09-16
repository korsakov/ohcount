visualbasic	code	VERSION 5.00
visualbasic	code	Object = "{67397AA1-7FB1-11D0-B148-00A0C922E820}#6.0#0"; "MSADODC.OCX"
visualbasic	code	Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
visualbasic	code	Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
visualbasic	code	Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
visualbasic	code	Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
visualbasic	code	Begin VB.Form frmMain
visualbasic	code	   BorderStyle     =   1  'Fixed Single
visualbasic	code	   ClientHeight    =   6555
visualbasic	code	   ClientLeft      =   150
visualbasic	code	   ClientTop       =   435
visualbasic	code	   ClientWidth     =   10620
visualbasic	code	   LinkTopic       =   "Form1"
visualbasic	code	   MaxButton       =   0   'False
visualbasic	code	   MinButton       =   0   'False
visualbasic	code	   ScaleHeight     =   6555
visualbasic	code	   ScaleWidth      =   10620
visualbasic	code	   StartUpPosition =   3  'Windows Default
visualbasic	code	Attribute VB_Name = "frmMain"
visualbasic	code	Attribute VB_GlobalNameSpace = False
visualbasic	code	Attribute VB_Creatable = False
visualbasic	code	Attribute VB_PredeclaredId = True
visualbasic	code	Attribute VB_Exposed = False
visualbasic	comment	'---------------------------------------------------------------------------
visualbasic	comment	'
visualbasic	comment	' SOURCE FILE NAME: Demo.frm
visualbasic	comment	'
visualbasic	comment	' SAMPLE: Visual Basic Demo with user interface for the sample modules
visualbasic	comment	'
visualbasic	comment	' For more information about samples, refer to the README file.
visualbasic	comment	'
visualbasic	comment	'---------------------------------------------------------------------------
visualbasic	blank	
visualbasic	code	Option Explicit
visualbasic	blank	
visualbasic	code	Private con As ADODB.Connection
visualbasic	code	Private rst As ADODB.Recordset
visualbasic	code	Private strMsgText As String
visualbasic	code	Private wShowInstructions As Integer
visualbasic	blank	
visualbasic	comment	'This procedure calls ConnectOLEDB() in the module dbConn to get
visualbasic	comment	'a connection object.
visualbasic	code	Private Sub cmdConnectOLEDB_Click()
visualbasic	comment	  'define the error handler
visualbasic	comment	'  On Error GoTo cmdConnectOLEDB_Error
visualbasic	blank	
visualbasic	comment	  'connect to database
visualbasic	code	  Set con = ConnectOLEDB()
visualbasic	blank	
visualbasic	comment	  'generate a message of success
visualbasic	code	  sbrStatus.Panels(1).Text = "Connect to sample database succeeded!"
visualbasic	blank	
visualbasic	comment	  'config status of the buttons
visualbasic	code	  EnableButtons
visualbasic	blank	
visualbasic	comment	  'show instructions
visualbasic	code	  If wShowInstructions = vbYes Then
visualbasic	code	    ShowConnectionInstruction
visualbasic	code	  End If
visualbasic	code	End Sub
