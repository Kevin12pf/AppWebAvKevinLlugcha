<%@ Language="VBScript" CodePage = 65001 %>
<%
' ============================================================================
'  logout.asp - Cierra la sesion activa y regresa a la pantalla de login
' ============================================================================

Session.Contents.RemoveAll()
Session.Abandon()
Response.Redirect "login.asp"
%>
