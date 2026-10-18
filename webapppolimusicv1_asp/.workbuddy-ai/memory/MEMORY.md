# Memoria del proyecto — PoliMusic (ASP Clásico)

## Contexto de base de datos
- La BD **real** del usuario vive en su SQL Server 2022 de Windows (`localhost,14333`),
  con datos propios en `TBL_USER` (usuarios tipo `userAdmin`, `kevin llugcha`, etc.).
- El entorno de trabajo tiene además un contenedor SQL Server 2025 (Linux) en el mismo
  puerto; **no es la BD del usuario**. No confundirlos.
- Nunca crear/alterar el esquema del usuario sin pedirlo. La app solo consulta y escribe
  filas en `TBL_USER` y `TBL_SONG`.

## Convenciones del proyecto
- ASP Clásico con VBScript, archivos en UTF-8 y acentos escritos como entidades HTML
  (`&oacute;`, `&ntilde;`) para no depender de la codificación.
- Cada página incluye, en orden: `includes/config.asp`, `includes/db.asp`,
  `includes/auth.asp`.
- Roles: `USER_TYPE = 1` admin, `0` normal. Guardas en servidor con `RequireAdmin()`.
- SQL siempre parametrizado; HTML siempre escapado con `H()`.
- Los mensajes flash se guardan ya escapados y se imprimen sin volver a escapar.

## Cómo probar sin IIS
`tools/render_asp.py` genera un VBScript con objetos ASP simulados y lo ejecuta con
cscript contra SQL Server. Ejemplo:
`python tools/render_asp.py songs.asp --user admin --role 1 --out out/songs.html`
