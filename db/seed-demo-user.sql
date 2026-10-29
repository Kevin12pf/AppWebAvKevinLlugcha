/*
    Laboratorio 03 - WebApp monolítica ASP.NET WebForms
    Normaliza las contraseñas de los usuarios de demostración.

    El login de la aplicación hashea la contraseña con SHA1 antes de comparar,
    por lo que las contraseñas en texto plano de la semilla original no sirven.
    Este script deja todos los usuarios de demo con la contraseña: 12345678

    Uso:
        sqlcmd -S localhost -E -C -i db\seed-demo-user.sql
*/

USE [BDD_PoliMusic];
GO

UPDATE [TBL_USER]
SET [PASSWORD] = UPPER(CONVERT(VARCHAR(40), HASHBYTES('SHA1', '12345678'), 2))
WHERE [USERNAME] IN ('kevin.llugcha', 'userNormal', 'userAdmin');
GO

SELECT [ID_USER], [USERNAME], [PASSWORD], [USER_TYPE]
FROM [TBL_USER]
ORDER BY [ID_USER];
GO
