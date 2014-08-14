using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using WebApplication3.database_classes;
namespace WebApplication3.DiscussionBoards
{
    public partial class DiscussionBoard : System.Web.UI.Page
    {
        static SqlConnection connection;
        static DBProcedures procedures;
        static string sid, subject;
        protected void Page_Load(object sender, EventArgs e)
        {
            connection = new SqlConnection(ConfigurationManager.
                ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
            procedures = new DBProcedures();
            sid = Page.Request.QueryString["sid"];
            subject = Page.Request.QueryString["subject"];

            dsubjectLiteral.Text = subject;
            schoolLiteral.Text = procedures.retrieve_name(Convert.ToInt32(sid));

        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
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

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VisitThreadCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string thid = row.Cells[1].Text;

                Page.Response.Redirect("Thread.aspx?sid="+sid+"&subject="+subject+"&thid="+thid);

            }
        }

        protected void CreateThreadButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("CreateThread.aspx?sid=" + sid + "&subject=" + subject + "&starter=" + Login.id);
        }
    }
}