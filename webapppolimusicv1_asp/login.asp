<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  login.asp - Autenticacion de usuarios contra TBL_USER
'  Al validar las credenciales se almacena:
'      Session("username") -> nombre del usuario
'      Session("role")     -> tipo de usuario (1 = Admin, 0 = Normal)
' ============================================================================

' Si ya existe una sesion activa, no tiene caso mostrar el formulario.
If Session("username") <> "" Then
    Response.Redirect "songs.asp"
End If

Dim loginError, frmUser, frmPass, doAuth
loginError = ""
frmUser    = ""
frmPass    = ""
doAuth     = False

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    frmUser = Trim(Request.Form("username"))
    frmPass = Trim(Request.Form("password"))

    If frmUser = "" Or frmPass = "" Then
        loginError = "Please enter your username and password."
    Else
        doAuth = True
    End If
End If
%>
<% If doAuth Then %>
<!--#include file="inc/conexion.asp"-->
<%
    Dim cmdLogin, rsLogin, roleValue

    Set cmdLogin = Server.CreateObject("ADODB.Command")
    cmdLogin.ActiveConnection = conn
    cmdLogin.CommandType = 1  ' adCmdText
    cmdLogin.CommandText = "SELECT USERNAME, USER_TYPE FROM TBL_USER WHERE USERNAME = ? AND PASSWORD = ?"
    cmdLogin.Parameters.Append cmdLogin.CreateParameter("pUser", 200, 1, 50, frmUser)  ' adVarChar(50) / adParamInput
    cmdLogin.Parameters.Append cmdLogin.CreateParameter("pPass", 200, 1, 50, frmPass)  ' adVarChar(50) / adParamInput
    Set rsLogin = cmdLogin.Execute

    If Not rsLogin.EOF Then
        ' --- Credenciales correctas: guardar sesion ---
        Session("username") = CStr(rsLogin("USERNAME"))

        ' Normalizar el rol por si USER_TYPE es INT o BIT en SQL Server.
        roleValue = rsLogin("USER_TYPE")
        If IsNull(roleValue) Then
            Session("role") = 0
        ElseIf VarType(roleValue) = 11 Then          ' 11 = vbBoolean (columna BIT)
            If CBool(roleValue) Then
                Session("role") = 1
            Else
                Session("role") = 0
            End If
        Else
            Session("role") = CLng(roleValue)
        End If

        rsLogin.Close
        Set rsLogin = Nothing
        Set cmdLogin = Nothing
        conn.Close
        Set conn = Nothing

        Response.Redirect "songs.asp"
    Else
        loginError = "Invalid username or password."
        rsLogin.Close
        Set rsLogin = Nothing
        Set cmdLogin = Nothing
        conn.Close
        Set conn = Nothing
    End If
End If
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoliMusic | Sign In</title>
    <link rel="stylesheet" href="css/style.css?v=2">
</head>
<body>
    <div class="login-wrap">
        <div class="login-card">

            <div class="brand">
                <span class="logo" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">
                        <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/>
                    </svg>
                </span>
                <span class="brand-name">Poli<span class="accent">Music</span></span>
            </div>

            <p class="login-sub">Sign in to start listening</p>

            <% If loginError <> "" Then %>
            <div class="alert alert-error"><%=Server.HTMLEncode(loginError)%></div>
            <% End If %>

            <form method="post" action="login.asp" autocomplete="off">
                <div class="field">
                    <label for="username">Username</label>
                    <input class="input" type="text" id="username" name="username"
                           maxlength="50" value="<%=Server.HTMLEncode(frmUser)%>" required autofocus>
                </div>

                <div class="field">
                    <label for="password">Password</label>
                    <input class="input" type="password" id="password" name="password"
                           maxlength="50" required>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Sign In</button>
                </div>
            </form>

            <p class="login-foot">PoliMusic - ASP Classic + SQL Server</p>
        </div>
    </div>
</body>
</html>
