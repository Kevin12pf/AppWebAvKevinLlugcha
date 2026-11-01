<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV3.Song" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Canciones · PoliMusic</title>
    <link href="<%= ResolveUrl("~/Content/Song.css") %>" rel="stylesheet" />
</head>
<body class="app-body">
    <form id="formSong" runat="server">

        <!-- Cabecera estilo Apple Music Library -->
        <header class="library-header">
            <a class="brand" href="<%= ResolveUrl("~/Default.aspx") %>" aria-label="Inicio">PoliMusic</a>
            <div class="header-title">
                <h1>Canciones</h1>
                <p class="subtitle"><asp:Literal ID="litSummary" runat="server" /> canciones en tu biblioteca</p>
            </div>
            <div class="user-banner" aria-label="Usuario de la sesión">
                <span class="user-dot" aria-hidden="true"></span>
                <span class="user-label">Usuario:</span>
                <span class="user-name"><asp:Literal ID="litUserName" runat="server" /></span>
            </div>
        </header>

        <!-- Panel con la lista de canciones -->
        <section class="library-panel" aria-label="Biblioteca de canciones">
            <div class="panel-wrap">
                <asp:GridView ID="gvSongs" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="ID_SONG"
                    CssClass="song-table"
                    GridLines="None"
                    OnRowDataBound="GvSongs_RowDataBound"
                    EmptyDataText="No hay canciones en la biblioteca."
                    aria-rowcount="0">
                    <Columns>
                        <asp:TemplateField HeaderText="#"
                            ItemStyle-CssClass="col-index"
                            HeaderStyle-CssClass="col-index">
                            <ItemTemplate>
                                <%# Container.DataItemIndex + 1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cover"
                            ItemStyle-CssClass="col-cover"
                            HeaderStyle-CssClass="col-cover">
                            <ItemTemplate>
                                <img src='<%= ResolveUrl("~/Content/covers/album-default.svg") %>' class="cover"
                                    alt="Carátula del álbum" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="SONG_NAME" HeaderText="Título"
                            ItemStyle-CssClass="col-title"
                            HeaderStyle-CssClass="col-title" />
                        <asp:BoundField DataField="ARTIST_NAME" HeaderText="Artista"
                            ItemStyle-CssClass="col-artist"
                            HeaderStyle-CssClass="col-artist" />
                        <asp:BoundField DataField="ALBUM_NAME" HeaderText="Álbum"
                            ItemStyle-CssClass="col-album"
                            HeaderStyle-CssClass="col-album" />
                        <asp:BoundField DataField="DURATION" HeaderText="Duración"
                            ItemStyle-CssClass="col-duration"
                            HeaderStyle-CssClass="col-duration"
                            ItemStyle-HorizontalAlign="Right" />
                        <asp:TemplateField HeaderText="Reproductor"
                            ItemStyle-CssClass="col-player"
                            HeaderStyle-CssClass="col-player">
                            <ItemTemplate>
                                <audio class="apple-audio" controls preload="none"
                                    src='<%# ResolveUrl(Eval("SONG_PATH").ToString()) %>'
                                    title='<%# Eval("SONG_NAME") %>'
                                    aria-label='<%# "Reproducir " + Eval("SONG_NAME") %>'>
                                </audio>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </section>

        <!-- Mini reproductor fijo inferior -->
        <div class="mini-player" id="miniPlayer">
            <span class="label">Reproduciendo</span>
            <span class="title" id="miniTitle"></span>
        </div>

        <script>
            (function () {
                var players = [].slice.call(document.querySelectorAll('.apple-audio'));
                var mini = document.getElementById('miniPlayer');
                var miniTitle = document.getElementById('miniTitle');
                var activePlayer = null;
                var activeRow = null;

                function setPlaying(player, title) {
                    if (activePlayer && activePlayer !== player) {
                        activePlayer.pause();
                        activePlayer.currentTime = 0;
                    }
                    activePlayer = player;
                    activeRow = player.closest('tr');
                    if (activeRow) {
                        activeRow.classList.add('playing');
                    }
                    if (mini && miniTitle) {
                        miniTitle.textContent = title || '';
                        mini.classList.add('visible');
                    }
                }

                function stopPlaying() {
                    if (activePlayer) {
                        activePlayer.pause();
                        activePlayer.currentTime = 0;
                    }
                    if (activeRow) {
                        activeRow.classList.remove('playing');
                    }
                    activePlayer = null;
                    activeRow = null;
                    if (mini) {
                        mini.classList.remove('visible');
                    }
                }

                players.forEach(function (player) {
                    player.addEventListener('play', function () {
                        setPlaying(player, player.title);
                    });
                    player.addEventListener('pause', function () {
                        if (activePlayer === player) {
                            stopPlaying();
                        }
                    });
                    player.addEventListener('ended', stopPlaying);
                });
            })();
        </script>

    </form>
</body>
</html>
