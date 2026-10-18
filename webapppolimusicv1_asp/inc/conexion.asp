<%
' ============================================================================
'  inc/conexion.asp
'  Conexion ADO/OLE DB contra la instancia local de SQL Server:
'      Servidor : localhost,1433  (instancia "Muchachos")
'      Base     : BDD_PoliMusic
'      Seguridad: autenticacion de Windows (Integrated Security)
'
'  Se usa MSOLEDBSQL porque soporta Encrypt / TrustServerCertificate.
'  Si el sitio se publica en IIS, la identidad del App Pool debe tener un
'  login en SQL Server (ver sql/grant_iis.sql).
' ============================================================================

Dim CONN_STRING
CONN_STRING = "Provider=MSOLEDBSQL;Server=localhost,1433;Database=BDD_PoliMusic;Integrated Security=SSPI;Encrypt=true;TrustServerCertificate=true;"

Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.ConnectionTimeout = 15
conn.CommandTimeout = 30
conn.Open CONN_STRING
%>
