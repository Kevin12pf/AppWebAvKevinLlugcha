# PoliMusic

Clon de un reproductor tipo Spotify construido con **ASP Clásico (VBScript)** y
**SQL Server**. Interfaz propia en tonos azul oscuro ("Midnight Blue"), con login,
roles Admin/Normal, CRUD de canciones y reproducción desde `assets/`.

## Base de datos

- **Instancia:** `localhost,1433` (instancia nativa "Muchachos").
- **Base:** `BDD_PoliMusic`.
- **Seguridad:** autenticación de Windows (`Integrated Security=SSPI`).
- **Proveedor ADO:** `MSOLEDBSQL` (necesario para `Encrypt` / `TrustServerCertificate`).
- La cadena está en `inc/conexion.asp`:

```
Provider=MSOLEDBSQL;Server=localhost,1433;Database=BDD_PoliMusic;Integrated Security=SSPI;Encrypt=true;TrustServerCertificate=true;
```

La base ya contiene las tablas `TBL_USER` y `TBL_SONG` con datos, por lo que no
hay que crear nada.

## Usuarios de prueba

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| `userAdmin` | `12345678` | Admin (`USER_TYPE = 1`) — ve y ejecuta el CRUD |
| `userNormal` | `12345678` | Normal (`USER_TYPE = 0`) — solo listado y reproducción |
| `kevin.llugcha` | `123456` | Admin |
| `estudiante.normal` | `123456` | Normal |

## Características

- **Login** (`login.asp`): consulta parametrizada contra `TBL_USER`; guarda
  `Session("username")` y `Session("role")` (`1 = Admin`, `0 = Normal`).
- **Control de acceso real**: las páginas de CRUD validan la sesión y el rol en el
  servidor; un usuario Normal no puede entrar escribiendo la URL.
- **Song List** (`songs.asp`): mensaje "Welcome" con el usuario de la sesión, tabla
  con ID, Song Name, Play (`<audio controls>`), Reproductions y Actions.
- **Logout** (`logout.asp`) con `Session.Abandon()`.
- **Contador de reproducciones**: al iniciar un audio, JavaScript llama a
  `song_play.asp`, que incrementa `PLAYS` y responde en JSON; la celda se actualiza
  sin recargar la página.
- **Buscador** de canciones en el cliente y **confirmación** antes de eliminar.
- **CRUD admin**: agregar, editar y eliminar; el formulario detecta automáticamente
  los audios de `assets/` con `Scripting.FileSystemObject`.
- **Seguridad**: consultas ADO con parámetros y salida escapada con
  `Server.HTMLEncode`.

## Estructura

```
├─ login.asp            Login y validación de credenciales
├─ logout.asp           Cierra la sesión
├─ default.asp          Redirige al login
├─ songs.asp            Pantalla principal (Song List)
├─ song_new.asp         Formulario "Add Song" (Admin)
├─ song_create.asp      INSERT (Admin)
├─ song_edit.asp        Formulario "Edit Song" (Admin)
├─ song_update.asp      UPDATE (Admin)
├─ song_delete.asp      DELETE (Admin)
├─ song_play.asp        Endpoint JSON del contador de reproducciones
├─ inc/conexion.asp     Conexión ADO / MSOLEDBSQL
├─ css/style.css        Tema azul oscuro
├─ js/app.js            Contador, buscador y confirmación
├─ assets/
│  ├─ audio/            Audios referenciados por la base (adventure.mp3)
│  └─ songs/            6 pistas WAV de demostración
└─ sql/grant_iis.sql    Permisos del App Pool de IIS (solo si publica en IIS)
```

## Cómo ejecutar

1. **Requisito:** Windows con la característica **ASP** de IIS habilitada
   (Panel de control → Programas → Activar o desactivar características de Windows →
   IIS → World Wide Web Services → Application Development Features → **ASP**).

2. **Opción rápida — IIS Express** (usa su usuario de Windows, por lo que la
   conexión integrada funciona directamente). Desde una consola:

```
"C:\Program Files\IIS Express\iisexpress.exe" /path:"C:\Users\kevin\OneDrive\Desktop\WebAvanzadas\Labo2\AppWebAvKevinLlugcha\webapppolimusicv1_asp" /port:8099
```

   Abra `http://localhost:8099/login.asp`.

3. **Opción IIS completo**

   - Copie la carpeta a `C:\inetpub\wwwroot\polimusic` (o cree una aplicación en
     IIS apuntando a esta carpeta).
   - Dé permisos de lectura a `IIS_IUSRS` sobre la carpeta del sitio.
   - Ejecute `sql/grant_iis.sql` con una cuenta sysadmin. El script crea el login
     `IIS APPPOOL\DefaultAppPool` y lo agrega a `db_datareader` / `db_datawriter`.
     Si su sitio usa otro App Pool, cambie el nombre en el script.
   - Abra `http://localhost/polimusic/login.asp`.

## Notas sobre las canciones existentes

La base trae 10 canciones. Las rutas `assets/audio/...` funcionan si el archivo
existe (por ejemplo `adventure.mp3`). Algunas filas antiguas apuntan a
`~/songFiles/...`, que no es una ruta web válida; para corregirlas:

1. Entre como `userAdmin`.
2. Pulse **Edit** en la canción.
3. Elija un archivo del desplegable (se listan los audios de `assets/audio` y
   `assets/songs`).
4. Guarde los cambios.

Para agregar música propia, copie los `.mp3` a `assets/audio/` y use **Add Song**:
el formulario los detecta automáticamente.

## Solución de problemas

- **Error de conexión / login**: verifique que el servicio de SQL Server de la
  instancia `Muchachos` esté activo y que `Provider=MSOLEDBSQL` esté instalado
  (si no, instale "Microsoft OLE DB Driver for SQL Server").
- **Publicado en IIS y error de login SQL**: falta ejecutar `sql/grant_iis.sql`
  para la identidad del App Pool.
- **Se descarga el `.asp` en vez de ejecutarse**: la característica ASP de IIS no
  está habilitada.
- **"Add Song" no lista archivos**: IIS debe poder leer `assets/` con
  `Scripting.FileSystemObject`; como respaldo, el formulario permite escribir la
  ruta manualmente (`assets/...`).
- **Audio no suena**: confirme que el archivo exista y que `SONG_PATH` sea relativo
  al sitio, por ejemplo `assets/audio/mi-cancion.mp3`.

## Nota de seguridad

Proyecto académico: las contraseñas se comparan en texto plano y la instancia usa
autenticación de Windows a nivel de servidor. En producción se deben usar hashes,
HTTPS obligatorio y una cuenta de base de datos con permisos mínimos.
