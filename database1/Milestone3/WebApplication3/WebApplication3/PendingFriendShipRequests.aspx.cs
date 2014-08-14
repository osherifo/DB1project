using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.SqlClient;
namespace WebApplication3
{
    
    public partial class PendingFriendShipRequests : System.Web.UI.Page
    {
        static SqlConnection connection;
        static DBProcedures procedures;
        protected void Page_Load(object sender, EventArgs e)
        {
            procedures = new DBProcedures();
            connection = new SqlConnection
            (@"Data Source=OMAR-PC\SQLEXPRESS;Initial Catalog=MySchoolCommunity;Integrated Security=True");
            LoggedinLiteral.Text = Login.currentlyLoggedIn;

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AcceptCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;
                
                procedures.accept_reject_freq(name,Login.currentlyLoggedIn,true);
                row.Cells[3].Text = "Accepted";

            }
            else if (e.CommandName == "RejectCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;
                procedures.accept_reject_freq(name, Login.currentlyLoggedIn, false);
                row.Cells[3].Text = "Rejected";
            }
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }
    }
}