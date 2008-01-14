VERSION 5.00
Object = "{67397AA1-7FB1-11D0-B148-00A0C922E820}#6.0#0"; "MSADODC.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMain
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   6555
   ClientLeft      =   150
   ClientTop       =   435
   ClientWidth     =   10620
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6555
   ScaleWidth      =   10620
   StartUpPosition =   3  'Windows Default
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'---------------------------------------------------------------------------
'
' SOURCE FILE NAME: Demo.frm
'
' SAMPLE: Visual Basic Demo with user interface for the sample modules
'
' For more information about samples, refer to the README file.
'
'---------------------------------------------------------------------------

Option Explicit

Private con As ADODB.Connection
Private rst As ADODB.Recordset
Private strMsgText As String
Private wShowInstructions As Integer

'This procedure calls ConnectOLEDB() in the module dbConn to get
'a connection object.
Private Sub cmdConnectOLEDB_Click()
  'define the error handler
'  On Error GoTo cmdConnectOLEDB_Error

  'connect to database
  Set con = ConnectOLEDB()

  'generate a message of success
  sbrStatus.Panels(1).Text = "Connect to sample database succeeded!"

  'config status of the buttons
  EnableButtons

  'show instructions
  If wShowInstructions = vbYes Then
    ShowConnectionInstruction
  End If
End Sub
