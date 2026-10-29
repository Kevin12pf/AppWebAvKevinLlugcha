using System;
using System.Data;
using System.Data.SqlClient;

namespace WebAppPoliMusicV2.DAL
{
    /// <summary>
    /// Capa de acceso a datos para las canciones (TBL_SONG / TBL_PLAYER / TBL_ARTIST).
    /// </summary>
    public class Song
    {
        private string strConnectionString;

        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        /// <summary>
        /// Devuelve el listado de canciones con su artista principal.
        /// </summary>
        public DataTable Read()
        {
            DataTable dtSong = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                string sentence =
                    "SELECT s.[ID_SONG], s.[SONG_NAME], s.[SONG_PATH], ISNULL(s.[PLAYS], 0) AS [PLAYS], " +
                    "ISNULL((SELECT TOP 1 a.[ARTIST_NAME] + ' ' + ISNULL(a.[ARTIST_LASTNAME], '') " +
                    "        FROM [TBL_PLAYER] p " +
                    "        INNER JOIN [TBL_ARTIST] a ON a.[ID_ARTIST] = p.[ID_ARTIST] " +
                    "        WHERE p.[ID_SONG] = s.[ID_SONG]), 'Artista desconocido') AS [ARTIST_NAME] " +
                    "FROM [TBL_SONG] s " +
                    "ORDER BY s.[ID_SONG]";

                using (SqlCommand cmd = new SqlCommand(sentence, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }

        /// <summary>
        /// Obtiene una canción por su identificador.
        /// </summary>
        public DataTable ReadById(int idSong)
        {
            DataTable dtSong = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT [ID_SONG], [SONG_NAME], [SONG_PATH], ISNULL([PLAYS], 0) AS [PLAYS] FROM [TBL_SONG] WHERE [ID_SONG] = @ID_SONG", con))
                {
                    cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }

        /// <summary>
        /// Incrementa el contador de reproducciones de una canción.
        /// </summary>
        public int IncrementPlays(int idSong)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "UPDATE [TBL_SONG] SET [PLAYS] = ISNULL([PLAYS], 0) + 1 WHERE [ID_SONG] = @ID_SONG";
                    cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
