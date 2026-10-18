<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  song_delete.asp - Elimina una cancion de TBL_SONG (SOLO Admin)
' ============================================================================

' --- Control de acceso y rol -------------------------------------------------
If Session("username") = "" Then
    Response.Redirect "login.asp"
End If
If Session("role") <> 1 Then
    Response.Redirect "songs.asp"
End If

' --- Identificador -----------------------------------------------------------
Dim sid
sid = Trim(Request.QueryString("id"))
If sid = "" Or Not IsNumeric(sid) Then
    Response.Redirect "songs.asp"
End If
%><!--#include file="inc/conexion.asp"--><%
' --- DELETE parametrizado ----------------------------------------------------
Dim cmdDelete

Set cmdDelete = Server.CreateObject("ADODB.Command")
cmdDelete.ActiveConnection = conn
cmdDelete.CommandType = 1  ' adCmdText
cmdDelete.CommandText = "DELETE FROM TBL_SONG WHERE ID_SONG = ?"
cmdDelete.Parameters.Append cmdDelete.CreateParameter("pId", 3, 1, , CLng(sid))  ' adInteger

On Error Resume Next
cmdDelete.Execute
If Err.Number <> 0 Then
    ' Puede fallar si la cancion esta referenciada en TBL_PLAYER / TBL_TRACKLIST.
    Set cmdDelete = Nothing
    conn.Close
    Set conn = Nothing
    Response.Redirect "songs.asp?msg=dberror"
End If
On Error GoTo 0

Set cmdDelete = Nothing
conn.Close
Set conn = Nothing

Response.Redirect "songs.asp?msg=deleted"
%>
