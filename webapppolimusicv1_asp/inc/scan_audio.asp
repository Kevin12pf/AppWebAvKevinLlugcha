<%
' ============================================================================
'  inc/scan_audio.asp
'  Recorre recursivamente una carpeta y acumula las rutas web relativas de
'  los archivos de audio (mp3, wav, ogg, m4a, flac) en un arreglo.
'
'  Uso:
'      ReDim lista(127)
'      contador = 0
'      ScanAudioFiles fso, carpeta, "assets/", lista, contador
' ============================================================================

Sub ScanAudioFiles(fsoObj, folderObj, relativePath, ByRef fileList, ByRef fileCount)
    Dim item, subFolder, ext

    For Each item In folderObj.Files
        ext = LCase(fsoObj.GetExtensionName(item.Name))
        Select Case ext
            Case "mp3", "wav", "ogg", "m4a", "flac"
                If fileCount <= UBound(fileList) Then
                    fileList(fileCount) = relativePath & item.Name
                    fileCount = fileCount + 1
                End If
        End Select
    Next

    For Each subFolder In folderObj.SubFolders
        ScanAudioFiles fsoObj, subFolder, relativePath & subFolder.Name & "/", fileList, fileCount
    Next
End Sub
%>
