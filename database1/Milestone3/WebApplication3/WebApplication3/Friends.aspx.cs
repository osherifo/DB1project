using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using WebApplication3.database_classes;

namespace WebApplication3
{
    public partial class Friends : System.Web.UI.Page
    {
        static SqlConnection conn;
        static DBProcedures proc;


        protected void Page_Load(object sender, EventArgs e)
        {
            conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
            proc = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewProfileCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;
                int id = proc.retrieve_id(name);
                if (proc.user_type(id) == "C")
                    Page.Response.Redirect("Profiles/ChildProfile.aspx?uid=" + id.ToString());
                else if (proc.user_type(id) == "P")
                    Page.Response.Redirect("Profiles/ParentProfile.aspx?uid=" + id.ToString());
                if (proc.user_type(id) == "S")
                    Page.Response.Redirect("Profiles/SchoolProfile.aspx?uid=" + id.ToString());
                
                

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
            if (proc.user_type(Login.id) == "C")
                Page.Response.Redirect("Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (proc.user_type(Login.id) == "P")
                Page.Response.Redirect("Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            if (proc.user_type(Login.id) == "S")
                Page.Response.Redirect("Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }
    }
}