/*
    Laboratorio 03 - WebApp monolítica ASP.NET WebForms
    Normaliza las rutas de las canciones.

    La base de datos trae 10 canciones: 5 apuntan a ~/songFiles/ y 5 a
    assets/audio/ (ruta de otra aplicación). El paquete de recursos solo
    incluye el archivo bensound-adventure.mp3, por lo que se copió a los
    nombres restantes para que todas las filas sean reproducibles.

    Uso:
        sqlcmd -S localhost -E -C -i db\fix-song-paths.sql
*/

USE [BDD_PoliMusic];
GO

UPDATE [TBL_SONG]
SET [SONG_PATH] = '~/songFiles/bensound-' + LOWER([SONG_NAME]) + '.mp3'
WHERE [SONG_PATH] LIKE 'assets/audio/%';
GO

SELECT [ID_SONG], [SONG_NAME], [SONG_PATH], [PLAYS]
FROM [TBL_SONG]
ORDER BY [ID_SONG];
GO
