using System;
using System.Configuration;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class SignUp : System.Web.UI.Page
    {
        private static readonly Color ErrorColor = Color.FromArgb(255, 128, 128);
        private static readonly Color SuccessColor = Color.FromArgb(110, 231, 183);

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSumbit_Click(object sender, EventArgs e)
        {
            string messageValidations = string.Empty;
            string userName = txtUserName.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            string email = txtEmail.Text.Trim();
            string birthday = string.Empty;

            if (!string.IsNullOrEmpty(txtBirthDate.Text.Trim()))
            {
                DateTime d;
                if (DateTime.TryParseExact(txtBirthDate.Text.Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out d))
                {
                    birthday = d.ToString("yyyy-MM-dd");
                }
                else
                {
                    ShowMessage("La fecha de nacimiento debe tener el formato dd/MM/yyyy.", false);
                    return;
                }
            }

            string photoName = fupPhoto.FileName;
            int type = Util.Constants.ID_USER_NORMAL;

            string newImageName = SanitizeFileName(userName);

            string strImageFolder = ConfigurationManager.AppSettings["userPhotoPath"];
            string strFileNameExtension = Path.GetExtension(fupPhoto.FileName);
            string newFileNameWithExtension = strImageFolder + newImageName + strFileNameExtension;

            Entities.User user = new Entities.User();
            user.UserName = userName;
            user.Email = email;
            user.Password = password;
            user.Birthday = birthday;
            user.UserType = type;
            user.Photo = newFileNameWithExtension;

            string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;

            messageValidations = UserFieldsRequiredValidations(user);
            if (messageValidations != string.Empty)
            {
                ShowMessage(messageValidations, false);
                return;
            }

            if (password != confirmPassword)
            {
                ShowMessage("Las contraseñas no coinciden.", false);
                return;
            }

            if (password.Length < 6)
            {
                ShowMessage("La contraseña debe tener al menos 6 caracteres.", false);
                return;
            }

            messageValidations = new BLL.User(strConnString).ValidationsDuplicated(user);
            if (messageValidations != string.Empty)
            {
                ShowMessage(messageValidations, false);
                return;
            }

            if (fupPhoto.HasFile)
            {
                messageValidations = new FileManagement().SaveImageOnServer(fupPhoto, strImageFolder, newImageName);
            }
            else
            {
                messageValidations = new FileManagement().SaveDefaultImageOnServer(strImageFolder, newImageName);
                user.Photo += ".jpg";
            }

            if (messageValidations != string.Empty)
            {
                ShowMessage(messageValidations, false);
                return;
            }

            user.Password = Util.Hash.GeneratePasswordHash(password);
            new BLL.User(strConnString).Save(user);

            ShowMessage("Usuario registrado correctamente. Ya puedes iniciar sesión.", true);
            ClearFields();
        }

        public string UserFieldsRequiredValidations(Entities.User user)
        {
            if (string.IsNullOrEmpty(user.UserName))
            {
                return "El nombre de usuario es obligatorio.";
            }
            if (string.IsNullOrEmpty(user.Email))
            {
                return "El correo electrónico es obligatorio.";
            }
            if (string.IsNullOrEmpty(user.Password))
            {
                return "La contraseña es obligatoria.";
            }
            if (!IsValidEmail(user.Email))
            {
                return "El correo electrónico no es válido.";
            }
            return string.Empty;
        }

        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrEmpty(email) || email.Replace(" ", "") == string.Empty)
            {
                return false;
            }

            try
            {
                // Normalize the domain
                email = Regex.Replace(email, @"(@)(.+)$", DomainMapper, RegexOptions.None);
            }
            catch (Exception)
            {
                return false;
            }

            try
            {
                return Regex.IsMatch(email,
                    @"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                    RegexOptions.IgnoreCase);
            }
            catch (Exception)
            {
                return false;
            }
        }

        private static string DomainMapper(Match match)
        {
            // Use IdnMapping class to convert Unicode domain names.
            IdnMapping idn = new IdnMapping();

            // Pull out and process domain name (throws ArgumentException on invalid)
            string domainName = idn.GetAscii(match.Groups[2].Value);

            return match.Groups[1].Value + domainName;
        }

        private static string SanitizeFileName(string value)
        {
            foreach (char c in Path.GetInvalidFileNameChars())
            {
                value = value.Replace(c, '_');
            }
            return value.Replace(" ", string.Empty);
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.ForeColor = success ? SuccessColor : ErrorColor;
            lblMessage.Text = message;
        }

        private void ClearFields()
        {
            txtUserName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
            txtBirthDate.Text = string.Empty;
        }
    }
}
