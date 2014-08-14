using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using WebApplication3.database_classes;
namespace WebApplication3.Profiles
{
    public partial class PendingChildRequests : System.Web.UI.Page
    {

        static SqlConnection connection;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            connection = new SqlConnection
                (ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);

            procedures = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;

        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AcceptCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;

                procedures.accept_reject_child(name,true);
                row.Cells[3].Text = "Accepted";

            }
            else if (e.CommandName == "RejectCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;
                procedures.accept_reject_child(name, false);
                row.Cells[3].Text = "Rejected";
            }
        }


    }
}