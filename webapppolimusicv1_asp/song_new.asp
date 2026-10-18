<%@ Language="VBScript" CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Session.CodePage = 65001 %>
<%
' ============================================================================
'  song_new.asp - Formulario para agregar una cancion (SOLO Admin)
' ============================================================================

' --- Control de acceso y rol -------------------------------------------------
If Session("username") = "" Then
    Response.Redirect "login.asp"
End If
If Session("role") <> 1 Then
    Response.Redirect "songs.asp"
End If

Dim displayName, avatarLetter, roleLabel, roleClass
displayName  = CStr(Session("username"))
avatarLetter = UCase(Left(displayName, 1))
roleLabel    = "Admin"
roleClass    = "admin"

' --- Mensajes de error -------------------------------------------------------
Dim errCode, errText
errCode = Request.QueryString("err")
errText = ""

Select Case errCode
    Case "missing"
        errText = "Song name and audio file are required."
    Case "db"
        errText = "The song could not be saved. Please try again."
End Select
%>
<!--#include file="inc/scan_audio.asp"-->
<%
' --- Archivos de audio disponibles en /assets (recursivo) --------------------
Dim audioFiles(), audioCount, fso, objFolder, physicalAssets, i
audioCount     = 0
ReDim audioFiles(127)
physicalAssets = Server.MapPath("assets")

Set fso = Nothing
On Error Resume Next
Set fso = Server.CreateObject("Scripting.FileSystemObject")
On Error GoTo 0

If Not (fso Is Nothing) Then
    If fso.FolderExists(physicalAssets) Then
        Set objFolder = fso.GetFolder(physicalAssets)
        ScanAudioFiles fso, objFolder, "assets/", audioFiles, audioCount
        Set objFolder = Nothing
    End If
    Set fso = Nothing
End If
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoliMusic | Add Song</title>
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
            <a class="nav-item" href="songs.asp">
                <svg viewBox="0 0 24 24" width="17" height="17" fill="currentColor" aria-hidden="true">
                    <path d="M3 13h2v-2H3v2zm0 4h2v-2H3v2zm0-8h2V7H3v2zm4 4h14v-2H7v2zm0 4h14v-2H7v2zM7 7v2h14V7H7z"/>
                </svg>
                Song List
            </a>
            <a class="nav-item active" href="song_new.asp">
                <svg viewBox="0 0 24 24" width="17" height="17" fill="currentColor" aria-hidden="true">
                    <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                </svg>
                Add Song
            </a>
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

        <a class="back-link" href="songs.asp">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" aria-hidden="true">
                <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
            </svg>
            Back to Song List
        </a>

        <div class="form-card">
            <h1 class="form-title">Add New Song</h1>
            <p class="form-desc">Register a new track in TBL_SONG. The audio file must exist inside the assets folder.</p>

            <% If errText <> "" Then %>
            <div class="alert alert-error"><%=Server.HTMLEncode(errText)%></div>
            <% End If %>

            <form method="post" action="song_create.asp">
                <div class="field">
                    <label for="songName">Song Name</label>
                    <input class="input" type="text" id="songName" name="songName"
                           maxlength="50" placeholder="e.g. Midnight Drive" required autofocus>
                </div>

                <div class="field">
                    <label for="songPath">Audio File (/assets)</label>
                    <% If audioCount > 0 Then %>
                    <select class="input" id="songPath" name="songPath" required>
                        <% For i = 0 To audioCount - 1 %>
                        <option value="<%=Server.HTMLEncode(audioFiles(i))%>"><%=Server.HTMLEncode(audioFiles(i))%></option>
                        <% Next %>
                    </select>
                    <p class="hint">Files detected automatically from the assets folder.</p>
                    <% Else %>
                    <input class="input" type="text" id="songPath" name="songPath"
                           maxlength="255" placeholder="assets/song.mp3" required>
                    <p class="hint">No audio files were found in /assets. Type the relative path manually.</p>
                    <% End If %>
                </div>

                <div class="field">
                    <label for="plays">Initial Reproductions</label>
                    <input class="input" type="number" id="plays" name="plays" min="0" value="0">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Song</button>
                    <a class="btn btn-ghost" href="songs.asp">Cancel</a>
                </div>
            </form>
        </div>

        <p class="page-foot">PoliMusic - ASP Classic + SQL Server - Academic project</p>
    </main>
</div>
</body>
</html>
