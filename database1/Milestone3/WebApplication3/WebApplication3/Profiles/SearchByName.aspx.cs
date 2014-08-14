using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;

namespace WebApplication3.Profiles
{
    public partial class SearchByName : System.Web.UI.Page
    {
        static string name;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            name = Page.Request.QueryString["name"];
            procedures = new DBProcedures();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = GridView1.Rows[index];
            string vname = row.Cells[0].Text;
            int id = procedures.retrieve_id(vname);
            
            if (e.CommandName == "VisitProfileCommand")
            {
               

                if (procedures.user_type(id) == "C")
                    Page.Response.Redirect("ChildProfile.aspx?uid=" + id.ToString());
                else if (procedures.user_type(id) == "P")
                    Page.Response.Redirect("ParentProfile.aspx?uid=" + id.ToString());
                if (procedures.user_type(id) == "S")
                    Page.Response.Redirect("SchoolProfile.aspx?uid=" + id.ToString());

            }

            else if (e.CommandName == "SendRequestCommand")
            {
                procedures.friend_request(Login.currentlyLoggedIn, vname);
                row.Cells[3].Text = "Request Sent";
            }
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
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + Login.id.ToString());
        }
    }
}