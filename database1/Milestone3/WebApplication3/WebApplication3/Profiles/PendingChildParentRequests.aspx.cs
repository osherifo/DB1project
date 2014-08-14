using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.Sql;
using System.Configuration;

namespace WebApplication3.Profiles
{
    public partial class PendingChildParentRequests : System.Web.UI.Page
    {
        static DBProcedures procedures;
        static string type;
        static string uid;



        protected void Page_Load(object sender, EventArgs e)
        {
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            procedures = new DBProcedures();
            type = Page.Request.QueryString["type"];
            uid = Page.Request.QueryString["uid"];

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
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id);
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id);
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AcceptCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                int senderid=procedures.retrieve_id(row.Cells[0].Text);
                if (type == "c")
                    procedures.approve_reject_child_parent(Login.id, senderid, true);
                else if (type == "p")
                    procedures.approve_reject_child_parent(senderid, Login.id, true);

                row.Cells[3].Text = "Accepted";

            }

            else if (e.CommandName == "RejectCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];
                int senderid = Convert.ToInt32(row.Cells[0].Text);
                if (type == "c")
                    procedures.approve_reject_child_parent(Login.id, senderid, false);
                else if (type == "p")
                    procedures.approve_reject_child_parent(senderid, Login.id, false);

                row.Cells[3].Text = "Rejected";

            }
        }
    }
}