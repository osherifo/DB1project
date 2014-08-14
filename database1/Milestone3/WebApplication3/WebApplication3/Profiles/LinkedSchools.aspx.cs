using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;

namespace WebApplication3.Profiles
{
    public partial class LinkedSchools : System.Web.UI.Page
    {
        static string uid;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            uid = Page.Request.QueryString["uid"];
            procedures = new DBProcedures();


        }

        protected void LogOutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnProfileButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = GridView1.Rows[index];
            if (e.CommandName == "VisitProfileCommand")
            {
                string sn = row.Cells[0].Text;
                int id = procedures.retrieve_id(sn);
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + id);
            }
        }
    }
}