<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  songs.asp - Pagina principal: listado de canciones (Song List)
'
'  - Exige una sesion activa (Session("username")).
'  - Muestra el mensaje de bienvenida con el nombre del usuario logueado.
'  - Solo el rol Admin (USER_TYPE = 1) ve los botones de CRUD.
'  - La columna Play usa <audio controls> apuntando al campo SONG_PATH.
' ============================================================================

' --- Control de acceso ------------------------------------------------------
If Session("username") = "" Then
    Response.Redirect "login.asp"
End If

Dim displayName, isAdmin, roleLabel, roleClass, avatarLetter
displayName  = CStr(Session("username"))
isAdmin      = (Session("role") = 1)
avatarLetter = UCase(Left(displayName, 1))

If isAdmin Then
    roleLabel = "Admin"
    roleClass = "admin"
Else
    roleLabel = "User"
    roleClass = "user"
End If

' --- Mensajes de confirmacion (CRUD) ----------------------------------------
Dim msg, msgText, msgKind, msgIcon
msg     = Request.QueryString("msg")
msgText = ""
msgKind = "ok"

Select Case msg
    Case "created"
        msgText = "The song was added successfully."
    Case "updated"
        msgText = "The song was updated successfully."
    Case "deleted"
        msgText = "The song was deleted successfully."
    Case "dberror"
        msgKind = "error"
        msgText = "The operation could not be completed. The song may be referenced by another table."
End Select
%>
<!--#include file="inc/conexion.asp"-->
<%
' --- Carga del listado ------------------------------------------------------
Dim rsSongs, rsCount, songTotal, colSpan

Set rsCount = conn.Execute("SELECT COUNT(*) AS TOTAL FROM TBL_SONG")
songTotal = 0
If Not rsCount.EOF Then songTotal = CLng(rsCount("TOTAL"))
rsCount.Close
Set rsCount = Nothing

Set rsSongs = conn.Execute("SELECT ID_SONG, SONG_NAME, SONG_PATH, PLAYS FROM TBL_SONG ORDER BY ID_SONG")

colSpan = 4
If isAdmin Then colSpan = 5
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoliMusic | Song List</title>
    <link rel="stylesheet" href="css/style.css?v=2">
</head>
<body>
<div class="app">

    <!-- ======================= SIDEBAR ======================= -->
    <aside class="sidebar">
        <a class="brand" href="songs.asp">
            <span class="logo" aria-hidden="true">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
                    <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/>
                </svg>
            </span>
            <span class="brand-name">Poli<span class="accent">Music</span></span>
        </a>

        <nav class="nav">
            <a class="nav-item active" href="songs.asp">
                <svg viewBox="0 0 24 24" width="17" height="17" fill="currentColor" aria-hidden="true">
                    <path d="M3 13h2v-2H3v2zm0 4h2v-2H3v2zm0-8h2V7H3v2zm4 4h14v-2H7v2zm0 4h14v-2H7v2zM7 7v2h14V7H7z"/>
                </svg>
                Song List
            </a>
            <% If isAdmin Then %>
            <a class="nav-item" href="song_new.asp">
                <svg viewBox="0 0 24 24" width="17" height="17" fill="currentColor" aria-hidden="true">
                    <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                </svg>
                Add Song
            </a>
            <% End If %>
        </nav>

        <div class="sidebar-spacer"></div>

        <div class="sidebar-footer">
            <div class="user-card">
                <span class="avatar"><%=Server.HTMLEncode(avatarLetter)%></span>
                <span class="user-meta">
                    <span class="user-name"><%=Server.HTMLEncode(displayName)%></span>
                    <span class="badge badge-<%=roleClass%>"><%=roleLabel%></span>
                </span>
            </div>
            <a class="btn btn-ghost btn-block" href="logout.asp">Logout</a>
        </div>
    </aside>

    <!-- ======================= CONTENIDO ======================= -->
    <main class="content">

        <!-- Bienvenida personalizada con Session("username") -->
        <header class="hero">
            <p class="hero-kicker">Your Library</p>
            <h1>Welcome, <span class="accent-name"><%=Server.HTMLEncode(displayName)%></span></h1>
            <p class="hero-sub">
                Below you will find the <strong>Song List</strong>: every track stored in
                BDD_PoliMusic. Use the player on each row to listen to it directly from the
                assets folder.
            </p>
            <div class="hero-stats">
                <span class="chip">Role: <strong><%=roleLabel%></strong></span>
                <span class="chip">Songs: <strong><%=songTotal%></strong></span>
            </div>
        </header>

        <% If msgText <> "" Then %>
        <div class="alert alert-<%=msgKind%>"><%=msgText%></div>
        <% End If %>

        <!-- Listado de canciones -->
        <section class="panel">
            <div class="panel-head">
                <div>
                    <h2>Song List</h2>
                    <p class="panel-sub">Tracks available in TBL_SONG</p>
                </div>

                <div class="panel-actions">
                    <div class="search-box">
                        <svg viewBox="0 0 24 24" width="17" height="17" fill="currentColor" aria-hidden="true">
                            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                        </svg>
                        <input class="input" type="search" id="songSearch" placeholder="Search song...">
                    </div>

                    <% If isAdmin Then %>
                    <a class="btn btn-primary btn-sm" href="song_new.asp">
                        <svg viewBox="0 0 24 24" width="15" height="15" fill="currentColor" aria-hidden="true">
                            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                        </svg>
                        Add Song
                    </a>
                    <% End If %>
                </div>
            </div>

            <div class="table-scroll">
                <table class="songs-table" id="songsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Song Name</th>
                            <th>Play</th>
                            <th>Reproductions</th>
                            <% If isAdmin Then %><th>Actions</th><% End If %>
                        </tr>
                    </thead>
                    <tbody>
                        <% If songTotal = 0 Then %>
                        <tr>
                            <td colspan="<%=colSpan%>">
                                <div class="empty-state">
                                    <strong>No songs yet</strong>
                                    The song list is empty. <% If isAdmin Then %>Use "Add Song" to create the first one.<% End If %>
                                </div>
                            </td>
                        </tr>
                        <% Else %>
                        <% Do While Not rsSongs.EOF %>
                        <tr>
                            <td class="cell-id"><%=rsSongs("ID_SONG")%></td>
                            <td>
                                <div class="song-title">
                                    <span class="song-dot" aria-hidden="true">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/>
                                        </svg>
                                    </span>
                                    <span class="song-name"><%=Server.HTMLEncode(rsSongs("SONG_NAME"))%></span>
                                </div>
                            </td>
                            <td>
                                <audio class="player" controls preload="none"
                                       data-song-id="<%=rsSongs("ID_SONG")%>"
                                       src="<%=Server.HTMLEncode(rsSongs("SONG_PATH"))%>">
                                    Your browser does not support the audio element.
                                </audio>
                            </td>
                            <td class="plays" id="plays-<%=rsSongs("ID_SONG")%>"><%=rsSongs("PLAYS")%></td>
                            <% If isAdmin Then %>
                            <td>
                                <div class="actions">
                                    <a class="btn btn-ghost btn-sm" href="song_edit.asp?id=<%=rsSongs("ID_SONG")%>">Edit</a>
                                    <a class="btn btn-danger btn-sm" href="song_delete.asp?id=<%=rsSongs("ID_SONG")%>"
                                       data-confirm="Delete this song? This action cannot be undone.">Delete</a>
                                </div>
                            </td>
                            <% End If %>
                        </tr>
                        <% rsSongs.MoveNext : Loop %>
                        <% End If %>
                    </tbody>
                </table>
            </div>
        </section>

        <p class="page-foot">PoliMusic - ASP Classic + SQL Server - Academic project</p>
    </main>
</div>

<%
' --- Liberar recursos --------------------------------------------------------
rsSongs.Close
Set rsSongs = Nothing
conn.Close
Set conn = Nothing
%>
<script src="js/app.js?v=2"></script>
</body>
</html>
