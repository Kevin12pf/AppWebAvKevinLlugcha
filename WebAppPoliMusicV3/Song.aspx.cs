using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using EntityLayer.PoliMusicV3;
using EntityLayer.PoliMusicV3.Util;

namespace WebAppPoliMusicV3
{
    public partial class Song : Page
    {
        private readonly string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserInformation();
                BindSongs();
            }
        }

        private void LoadUserInformation()
        {
            User user = Session[Constants.USER] as User;
            string userName = user != null ? user.UserName : "kevin.llugcha";
            litUserName.Text = Server.HtmlEncode(userName);
        }

        private void BindSongs()
        {
            DataTable dtSongs = ReadSongs();
            gvSongs.DataSource = dtSongs;
            gvSongs.DataBind();
            litSummary.Text = dtSongs.Rows.Count.ToString(CultureInfo.InvariantCulture);
        }

        private DataTable ReadSongs()
        {
            try
            {
                return ReadSongsFull();
            }
            catch (SqlException)
            {
                return ReadSongsWithoutAlbum();
            }
        }

        /// <summary>
        /// Consulta completa: incluye artista (TBL_PLAYER/TBL_ARTIST), álbum (TBL_ALBUM) y duración.
        /// </summary>
        private DataTable ReadSongsFull()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnString))
            {
                string sql =
                    "SELECT s.[ID_SONG], s.[SONG_NAME], s.[SONG_PATH], ISNULL(s.[PLAYS], 0) AS [PLAYS], " +
                    "ISNULL((SELECT TOP 1 a.[ARTIST_NAME] + ' ' + ISNULL(a.[ARTIST_LASTNAME], '') " +
                    "        FROM [TBL_PLAYER] p " +
                    "        INNER JOIN [TBL_ARTIST] a ON a.[ID_ARTIST] = p.[ID_ARTIST] " +
                    "        WHERE p.[ID_SONG] = s.[ID_SONG]), 'Artista desconocido') AS [ARTIST_NAME], " +
                    "ISNULL(al.[ALBUM_NAME], 'Álbum desconocido') AS [ALBUM_NAME], " +
                    "s.[DURATION] " +
                    "FROM [TBL_SONG] s " +
                    "LEFT JOIN [TBL_ALBUM] al ON al.[ID_ALBUM] = s.[ID_ALBUM] " +
                    "ORDER BY s.[ID_SONG]";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    sda.Fill(dt);
                }
            }
            return dt;
        }

        /// <summary>
        /// Consulta de respaldo si el esquema no tiene columnas de álbum/duración.
        /// </summary>
        private DataTable ReadSongsWithoutAlbum()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnString))
            {
                string sql =
                    "SELECT s.[ID_SONG], s.[SONG_NAME], s.[SONG_PATH], ISNULL(s.[PLAYS], 0) AS [PLAYS], " +
                    "ISNULL((SELECT TOP 1 a.[ARTIST_NAME] + ' ' + ISNULL(a.[ARTIST_LASTNAME], '') " +
                    "        FROM [TBL_PLAYER] p " +
                    "        INNER JOIN [TBL_ARTIST] a ON a.[ID_ARTIST] = p.[ID_ARTIST] " +
                    "        WHERE p.[ID_SONG] = s.[ID_SONG]), 'Artista desconocido') AS [ARTIST_NAME], " +
                    "CAST('Álbum desconocido' AS NVARCHAR(100)) AS [ALBUM_NAME], " +
                    "CAST(NULL AS INT) AS [DURATION] " +
                    "FROM [TBL_SONG] s " +
                    "ORDER BY s.[ID_SONG]";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                {
                    sda.Fill(dt);
                }
            }
            return dt;
        }

        protected void GvSongs_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
            {
                return;
            }

            DataRowView row = (DataRowView)e.Row.DataItem;
            object duration = row["DURATION"];
            e.Row.Cells[5].Text = FormatDuration(duration);
        }

        private static string FormatDuration(object value)
        {
            if (value == null || value == DBNull.Value)
            {
                return "--:--";
            }

            string text = Convert.ToString(value, CultureInfo.InvariantCulture).Trim();
            if (string.IsNullOrEmpty(text))
            {
                return "--:--";
            }

            int seconds;
            if (int.TryParse(text, NumberStyles.Integer, CultureInfo.InvariantCulture, out seconds))
            {
                TimeSpan ts = TimeSpan.FromSeconds(seconds);
                return ts.ToString(@"m\:ss", CultureInfo.InvariantCulture);
            }

            return text.Length > 5 ? text.Substring(0, 5) : text;
        }
    }
}
