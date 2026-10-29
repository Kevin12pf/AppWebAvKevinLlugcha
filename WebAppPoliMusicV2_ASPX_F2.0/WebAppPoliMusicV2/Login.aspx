<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebAppPoliMusicV2.Login" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>PoliMusic · Iniciar sesión</title>
    <link href="Content/site.css?v=4" rel="stylesheet" />
</head>
<body class="auth-body">
    <form id="formLogin" runat="server" class="auth-shell">
        <section class="auth-brand">
            <div class="brand-logo">&#9835;</div>
            <h1>PoliMusic</h1>
            <p class="brand-tagline">Tu música, tu biblioteca, un solo lugar.</p>
            <ul class="brand-points">
                <li>Catálogo de canciones</li>
                <li>Reproductor integrado</li>
                <li>Biblioteca personal</li>
            </ul>
        </section>

        <section class="auth-card">
            <h2>Bienvenido de nuevo</h2>
            <p class="muted">Ingresa con tu cuenta para escuchar música.</p>

            <label class="field-label" for="<%= txtLogin.ClientID %>">Usuario</label>
            <asp:TextBox ID="txtLogin" runat="server" CssClass="form-input" placeholder="usuario" />

            <label class="field-label" for="<%= txtPassword.ClientID %>">Contraseña</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="contraseña" />

            <asp:Button ID="btnLogin" runat="server" Text="Iniciar sesión" CssClass="btn-primary" OnClick="BtnLogin_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="message" ForeColor="#FF8080" />

            <div class="auth-footer">
                ¿No tienes cuenta?
                <asp:LinkButton ID="LinkButtonNewUser" runat="server" OnClick="LinkButtonNewUser_Click" CssClass="link">Regístrate</asp:LinkButton>
            </div>
        </section>
    </form>
</body>
</html>
