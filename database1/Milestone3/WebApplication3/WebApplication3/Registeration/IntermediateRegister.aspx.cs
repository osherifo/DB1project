using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3.Registeration
{
    public partial class IntermediateRegisteration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

      
        protected void Login2Button_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Login.aspx");
        }
    }
}