<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV2.Song" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>PoliMusic · Canciones</title>
    <link href="Content/site.css?v=4" rel="stylesheet" />
    <script src="Scripts/site.js"></script>
</head>
<body class="app-body">
    <form id="formSong" runat="server">
        <aside class="sidebar">
            <div class="logo"><span class="logo-mark">&#9835;</span> PoliMusic</div>
            <nav class="nav">
                <a class="nav-item active" href="Song.aspx"><span>&#9835;</span> Canciones</a>
                <span class="nav-item disabled"><span>&#9776;</span> Playlists</span>
                <span class="nav-item disabled"><span>&#9737;</span> Álbumes</span>
                <span class="nav-item disabled"><span>&#9788;</span> Artistas</span>
            </nav>
            <div class="sidebar-footer">
                <p>Laboratorio 03</p>
                <p class="muted small">ASP.NET WebForms · .NET Framework 2.0</p>
            </div>
        </aside>

        <main class="main">
            <header class="topbar">
                <div>
                    <h1>Canciones</h1>
                    <p class="muted"><asp:Literal ID="litSummary" runat="server" /> canciones en tu biblioteca</p>
                </div>
                <div class="user-chip">
                    <asp:Image ID="imgUser" runat="server" CssClass="avatar" AlternateText="Foto de usuario" />
                    <span class="user-name"><asp:Literal ID="litUserName" runat="server" /></span>
                    <a class="link" href="Logout.aspx">Salir</a>
                </div>
            </header>

            <section class="panel">
                <asp:GridView ID="gvSongs" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="ID_SONG"
                    CssClass="song-table"
                    GridLines="None"
                    OnRowCommand="GvSongs_RowCommand"
                    EmptyDataText="No hay canciones registradas en la base de datos.">
                    <Columns>
                        <asp:TemplateField HeaderText="#" ItemStyle-CssClass="col-index">
                            <ItemTemplate>
                                <%# Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="SONG_NAME" HeaderText="Canción" />
                        <asp:BoundField DataField="ARTIST_NAME" HeaderText="Artista" />
                        <asp:BoundField DataField="PLAYS" HeaderText="Reproducciones" ItemStyle-CssClass="col-plays" />
                        <asp:TemplateField HeaderText="" ItemStyle-CssClass="col-play">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnPlay" runat="server"
                                    CommandName="Play"
                                    CommandArgument='<%# Eval("ID_SONG") %>'
                                    CssClass="play-btn"
                                    ToolTip="Reproducir canción">&#9654;</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </section>
        </main>

        <div class="player-bar">
            <div class="now-playing">
                <span class="equalizer"><i></i><i></i><i></i><i></i></span>
                <div>
                    <span class="player-label">Reproduciendo</span>
                    <strong id="nowPlaying">Selecciona una canción</strong>
                </div>
            </div>
            <audio id="audioPlayer" controls preload="none"></audio>
        </div>
    </form>
</body>
</html>
