using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class homepage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Registeration/Register.aspx");
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("Login.aspx");
        }
    }
}