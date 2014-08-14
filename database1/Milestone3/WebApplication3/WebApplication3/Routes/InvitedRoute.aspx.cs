using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using WebApplication3.database_classes;
namespace WebApplication3.Routes
{
    public partial class InvitedRoute : System.Web.UI.Page
    {

        static SqlConnection conn;
        static DBProcedures proc;
        static int creator;
        static string rname;
        static string uid;

        protected void Page_Load(object sender, EventArgs e)
        {
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
            proc = new DBProcedures();
            creator = Convert.ToInt32(Page.Request.QueryString["creator"]);
            rname=Page.Request.QueryString["rname"];
            uid = Page.Request.QueryString["uid"];
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "InviteCommand")
            {

                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string invited = row.Cells[0].Text;

                proc.InviteToRoute(creator,rname,Login.id,proc.retrieve_id(invited));
                row.Cells[2].Text = "Request sent";
            }
            
        }

        protected void LogOutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (proc.user_type(Login.id) == "C")
                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (proc.user_type(Login.id) == "P")
                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            else if (proc.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }
    }
}