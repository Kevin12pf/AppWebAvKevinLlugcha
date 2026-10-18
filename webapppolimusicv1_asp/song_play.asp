<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  song_play.asp - Endpoint AJAX del reproductor
'  Incrementa el campo PLAYS de una cancion y responde en formato JSON:
'      { "ok": true, "plays": 12 }
' ============================================================================

Dim sid, playsNow, dbError
sid      = Trim(Request.QueryString("id"))
playsNow = 0
dbError  = False

Response.ContentType = "application/json"
Response.CacheControl = "no-store"

If Session("username") = "" Or sid = "" Or Not IsNumeric(sid) Then
    Response.Write "{""ok"":false}"
Else
%><!--#include file="inc/conexion.asp"--><%
    Dim cmdInc, rsPlay

    Set cmdInc = Server.CreateObject("ADODB.Command")
    cmdInc.ActiveConnection = conn
    cmdInc.CommandType = 1  ' adCmdText
    cmdInc.CommandText = "UPDATE TBL_SONG SET PLAYS = ISNULL(PLAYS, 0) + 1 WHERE ID_SONG = ?"
    cmdInc.Parameters.Append cmdInc.CreateParameter("pId", 3, 1, , CLng(sid))  ' adInteger

    On Error Resume Next
    cmdInc.Execute
    If Err.Number <> 0 Then dbError = True
    On Error GoTo 0

    Set cmdInc = Nothing

    If Not dbError Then
        Set rsPlay = conn.Execute("SELECT PLAYS FROM TBL_SONG WHERE ID_SONG = " & CLng(sid))
        If Not rsPlay.EOF Then playsNow = CLng(rsPlay("PLAYS"))
        rsPlay.Close
        Set rsPlay = Nothing
    End If

    conn.Close
    Set conn = Nothing

    If dbError Then
        Response.Write "{""ok"":false}"
    Else
        Response.Write "{""ok"":true,""plays"":" & playsNow & "}"
    End If
End If
%>
