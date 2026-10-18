/* ============================================================================
   Permisos para publicar PoliMusic en IIS

   La instancia de SQL Server usa SOLO autenticacion de Windows, por lo que
   la identidad del App Pool necesita un login en SQL Server.

   Ejecutar con una cuenta sysadmin (por ejemplo, SSMS con autenticacion
   de Windows). Si su sitio usa otro App Pool, cambie el nombre en todas
   las apariciones de [IIS APPPOOL\DefaultAppPool].

   Para conocer los App Pools disponibles:
       C:\Windows\System32\inetsrv\appcmd.exe list apppool
   ============================================================================ */

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'IIS APPPOOL\DefaultAppPool')
    CREATE LOGIN [IIS APPPOOL\DefaultAppPool] FROM WINDOWS;
GO

USE BDD_PoliMusic;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'IIS APPPOOL\DefaultAppPool')
    CREATE USER [IIS APPPOOL\DefaultAppPool] FOR LOGIN [IIS APPPOOL\DefaultAppPool];
GO

ALTER ROLE db_datareader ADD MEMBER [IIS APPPOOL\DefaultAppPool];
ALTER ROLE db_datawriter ADD MEMBER [IIS APPPOOL\DefaultAppPool];
GO

PRINT 'Permisos otorgados a IIS APPPOOL\DefaultAppPool sobre BDD_PoliMusic.';
GO
