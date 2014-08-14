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
    public partial class ViewChildrenParents : System.Web.UI.Page
    {

        static DBProcedures procedures;
        static string type;

        protected void Page_Load(object sender, EventArgs e)
        {
            procedures = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            type = Page.Request.QueryString["type"];
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn=null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SendRequestCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                string name = row.Cells[0].Text;
                int id = procedures.retrieve_id(name);
                if (type == "c")
                    procedures.parent_child_request(id, Login.id, type);
                else if (type == "p")
                    procedures.parent_child_request(Login.id, id, type);
                row.Cells[2].Text = "Request Sent";
                    

            }
        }

       
    }
}