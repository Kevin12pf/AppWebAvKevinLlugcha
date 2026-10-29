<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="WebAppPoliMusicV2.SignUp" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>PoliMusic · Crear cuenta</title>
    <link href="Content/site.css?v=4" rel="stylesheet" />
</head>
<body class="auth-body">
    <form id="formSignUp" runat="server" class="auth-shell auth-shell-wide" enctype="multipart/form-data">
        <section class="auth-brand">
            <div class="brand-logo">&#9835;</div>
            <h1>PoliMusic</h1>
            <p class="brand-tagline">Crea tu cuenta y empieza a escuchar.</p>
            <ul class="brand-points">
                <li>Registro gratuito</li>
                <li>Foto de perfil opcional</li>
                <li>Acceso inmediato al catálogo</li>
            </ul>
        </section>

        <section class="auth-card">
            <h2>Crear cuenta</h2>
            <p class="muted">Los campos marcados con * son obligatorios.</p>

            <div class="form-grid">
                <div class="form-row">
                    <label class="field-label" for="<%= txtUserName.ClientID %>">Usuario *</label>
                    <asp:TextBox ID="txtUserName" runat="server" CssClass="form-input" placeholder="tu.usuario" />
                </div>
                <div class="form-row">
                    <label class="field-label" for="<%= txtEmail.ClientID %>">Correo electrónico *</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="usuario@correo.com" />
                </div>
                <div class="form-row">
                    <label class="field-label" for="<%= txtPassword.ClientID %>">Contraseña *</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="mínimo 6 caracteres" />
                </div>
                <div class="form-row">
                    <label class="field-label" for="<%= txtConfirmPassword.ClientID %>">Confirmar contraseña *</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="repite tu contraseña" />
                </div>
                <div class="form-row">
                    <label class="field-label" for="<%= txtBirthDate.ClientID %>">Fecha de nacimiento</label>
                    <asp:TextBox ID="txtBirthDate" runat="server" CssClass="form-input" placeholder="dd/MM/yyyy" />
                </div>
                <div class="form-row">
                    <label class="field-label" for="<%= fupPhoto.ClientID %>">Foto de perfil</label>
                    <asp:FileUpload ID="fupPhoto" runat="server" CssClass="form-file" />
                    <span class="hint">JPG o PNG, máximo 10 MB. Si no eliges una, se usa la imagen por defecto.</span>
                </div>
            </div>

            <asp:Button ID="btnSumbit" runat="server" Text="Registrarme" CssClass="btn-primary" OnClick="btnSumbit_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="message" />

            <div class="auth-footer">
                ¿Ya tienes cuenta?
                <asp:HyperLink ID="HyperLink1" NavigateUrl="~/Login.aspx" runat="server" CssClass="link">Volver al login</asp:HyperLink>
            </div>
        </section>
    </form>
</body>
</html>
