using System;
using System.Web.Security;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx", true);
        }
    }
}
