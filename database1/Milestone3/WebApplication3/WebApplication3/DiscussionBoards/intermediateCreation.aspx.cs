using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;

namespace WebApplication3.DiscussionBoards
{
    public partial class intermediateCreation : System.Web.UI.Page
    {
        static string sid;
        static string subject;
        static DBProcedures procedures;


        protected void Page_Load(object sender, EventArgs e)
        {
            sid = Page.Request.QueryString["sid"];
            subject = Page.Request.QueryString["subject"];
            procedures = new DBProcedures();
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void CreateThreadButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("CreateThread.aspx?sid=" + sid + "&subject=" + subject+"&starter="+sid);
        }
    }
}