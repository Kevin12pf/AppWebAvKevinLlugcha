<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  song_create.asp - Inserta una nueva cancion en TBL_SONG (SOLO Admin)
' ============================================================================

' --- Control de acceso y rol -------------------------------------------------
If Session("username") = "" Then
    Response.Redirect "login.asp"
End If
If Session("role") <> 1 Then
    Response.Redirect "songs.asp"
End If

' --- Datos del formulario ----------------------------------------------------
Dim songName, songPath, plays
songName = Trim(Request.Form("songName"))
songPath = Trim(Request.Form("songPath"))
plays    = Trim(Request.Form("plays"))

If songName = "" Or songPath = "" Then
    Response.Redirect "song_new.asp?err=missing"
End If

If plays = "" Or Not IsNumeric(plays) Then
    plays = 0
Else
    plays = CLng(plays)
    If plays < 0 Then plays = 0
End If
%><!--#include file="inc/conexion.asp"--><%
' --- INSERT parametrizado (evita inyeccion SQL) ------------------------------
Dim cmdInsert

Set cmdInsert = Server.CreateObject("ADODB.Command")
cmdInsert.ActiveConnection = conn
cmdInsert.CommandType = 1  ' adCmdText
cmdInsert.CommandText = "INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH, PLAYS) VALUES (?, ?, ?)"
cmdInsert.Parameters.Append cmdInsert.CreateParameter("pName", 200, 1, 50, songName)    ' adVarChar(50) / adParamInput
cmdInsert.Parameters.Append cmdInsert.CreateParameter("pPath", 200, 1, 255, songPath)   ' adVarChar(255) / adParamInput
cmdInsert.Parameters.Append cmdInsert.CreateParameter("pPlays", 3, 1, , plays)          ' adInteger / adParamInput

On Error Resume Next
cmdInsert.Execute
If Err.Number <> 0 Then
    Set cmdInsert = Nothing
    conn.Close
    Set conn = Nothing
    Response.Redirect "song_new.asp?err=db"
End If
On Error GoTo 0

Set cmdInsert = Nothing
conn.Close
Set conn = Nothing

Response.Redirect "songs.asp?msg=created"
%>
