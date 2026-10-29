using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV2
{
    public partial class Song : System.Web.UI.Page
    {
        private string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LoadUserInformation();
                BindSongs();
            }
        }

        private void LoadUserInformation()
        {
            Entities.User user = Session[Util.Constants.USER] as Entities.User;
            if (user != null)
            {
                litUserName.Text = Server.HtmlEncode(user.UserName);
                string photo = string.IsNullOrEmpty(user.Photo) ? "~/userImages/default.jpg" : user.Photo;
                imgUser.ImageUrl = ResolveUrl(photo);
            }
            else
            {
                litUserName.Text = "Invitado";
                imgUser.ImageUrl = ResolveUrl("~/userImages/default.jpg");
            }
        }

        private void BindSongs()
        {
            DataTable dtSongs = new BLL.Song(strConnString).Read();
            gvSongs.DataSource = dtSongs;
            gvSongs.DataBind();
            litSummary.Text = dtSongs.Rows.Count.ToString();
        }

        protected void GvSongs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Play")
            {
                return;
            }

            int idSong = 0;
            GridViewRow row = null;
            Control commandSource = e.CommandSource as Control;
            if (commandSource != null)
            {
                row = commandSource.NamingContainer as GridViewRow;
            }

            if (row != null && row.RowIndex >= 0 && row.RowIndex < gvSongs.DataKeys.Count)
            {
                idSong = Convert.ToInt32(gvSongs.DataKeys[row.RowIndex].Value);
            }
            else if (!int.TryParse(Convert.ToString(e.CommandArgument), out idSong))
            {
                return;
            }

            BLL.Song bllSong = new BLL.Song(strConnString);
            DataTable dtSong = bllSong.ReadById(idSong);
            if (dtSong == null || dtSong.Rows.Count == 0)
            {
                return;
            }

            string songPath = ResolveUrl(Convert.ToString(dtSong.Rows[0]["SONG_PATH"]));
            string songName = Convert.ToString(dtSong.Rows[0]["SONG_NAME"]);

            bllSong.IncrementPlays(idSong);
            BindSongs();

            string script = "playSong('" + EscapeJs(songPath) + "', '" + EscapeJs(songName) + "');";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "playSong", script, true);
        }

        private static string EscapeJs(string value)
        {
            return value.Replace("\\", "\\\\").Replace("'", "\\'");
        }
    }
}
