using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{            
    public partial class ErrorPage : System.Web.UI.Page
    {
        static string errormessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            errormessage = Page.Request.QueryString["error"];
            Page.Response.Write(errormessage);
        }
    }
}