using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;

namespace WebApplication3.Profiles
{
    public partial class LinkedDiscussionBoards : System.Web.UI.Page
    {
        static string type;
        static int uid;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            uid = Convert.ToInt32(Page.Request.QueryString["uid"]);
            type = Page.Request.QueryString["type"];
            procedures = new DBProcedures();
        }

        protected void LogOutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = GridView1.Rows[index];
            string subject=row.Cells[0].Text;
            string school=row.Cells[1].Text;
            int schoolid= procedures.retrieve_id(school);
            if (e.CommandName == "ViewDBCommand")
            {
                Page.Response.Redirect("~/DiscussionBoards/DiscussionBoard.aspx?sid="+schoolid+"&subject="+subject);


            }
        }
    }
}