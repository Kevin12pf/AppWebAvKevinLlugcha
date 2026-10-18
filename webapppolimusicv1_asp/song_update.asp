<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  song_update.asp - Actualiza una cancion existente (SOLO Admin)
' ============================================================================

' --- Control de acceso y rol -------------------------------------------------
If Session("username") = "" Then
    Response.Redirect "login.asp"
End If
If Session("role") <> 1 Then
    Response.Redirect "songs.asp"
End If

' --- Datos del formulario ----------------------------------------------------
Dim sid, songName, songPath, plays
sid      = Trim(Request.Form("sid"))
songName = Trim(Request.Form("songName"))
songPath = Trim(Request.Form("songPath"))
plays    = Trim(Request.Form("plays"))

If sid = "" Or Not IsNumeric(sid) Then
    Response.Redirect "songs.asp"
End If

If songName = "" Or songPath = "" Then
    Response.Redirect "song_edit.asp?id=" & CLng(sid) & "&err=missing"
End If

If plays = "" Or Not IsNumeric(plays) Then
    plays = 0
Else
    plays = CLng(plays)
    If plays < 0 Then plays = 0
End If
%><!--#include file="inc/conexion.asp"--><%
' --- UPDATE parametrizado ----------------------------------------------------
Dim cmdUpdate

Set cmdUpdate = Server.CreateObject("ADODB.Command")
cmdUpdate.ActiveConnection = conn
cmdUpdate.CommandType = 1  ' adCmdText
cmdUpdate.CommandText = "UPDATE TBL_SONG SET SONG_NAME = ?, SONG_PATH = ?, PLAYS = ? WHERE ID_SONG = ?"
cmdUpdate.Parameters.Append cmdUpdate.CreateParameter("pName", 200, 1, 50, songName)    ' adVarChar(50)
cmdUpdate.Parameters.Append cmdUpdate.CreateParameter("pPath", 200, 1, 255, songPath)   ' adVarChar(255)
cmdUpdate.Parameters.Append cmdUpdate.CreateParameter("pPlays", 3, 1, , plays)          ' adInteger
cmdUpdate.Parameters.Append cmdUpdate.CreateParameter("pId", 3, 1, , CLng(sid))         ' adInteger

On Error Resume Next
cmdUpdate.Execute
If Err.Number <> 0 Then
    Set cmdUpdate = Nothing
    conn.Close
    Set conn = Nothing
    Response.Redirect "song_edit.asp?id=" & CLng(sid) & "&err=db"
End If
On Error GoTo 0

Set cmdUpdate = Nothing
conn.Close
Set conn = Nothing

Response.Redirect "songs.asp?msg=updated"
%>
