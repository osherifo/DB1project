using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;

namespace WebApplication3.Routes
{
    public partial class MyRoutes : System.Web.UI.Page
    {
       static DBProcedures procedures;
       static string uid;

        protected void Page_Load(object sender, EventArgs e)
        {
            procedures = new DBProcedures();
            uid = Page.Request.QueryString["uid"];
        }

        protected void CreatorGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = CreatorGridView.Rows[index];
            string rname = row.Cells[0].Text;
            if (e.CommandName == "ViewRouteCommand")
                Page.Response.Redirect("Routes.aspx?rname=" + rname + "&creator=" + Login.id);

        }

        protected void PendingGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = PendingGridView.Rows[index];
            string creator = row.Cells[0].Text;
            string rname=row.Cells[1].Text;
            int creatorid=procedures.retrieve_id(creator);
            if (e.CommandName == "AcceptCommand")
            {
                procedures.accept_reject_carpool(Login.id, creatorid, rname, true);
                row.Cells[4].Text = "Accepted";
                Page.Response.Redirect(Page.Request.RawUrl);
            }
            else if (e.CommandName == "RejectCommand")
            {
                procedures.accept_reject_carpool(Login.id, creatorid, rname, false);
                row.Cells[4].Text = "Rejected";
                Page.Response.Redirect(Page.Request.RawUrl);
            }
        }

        protected void InvitedGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = InvitedGridView.Rows[index];
            string creator = row.Cells[0].Text;
            string rname = row.Cells[1].Text;
            if (e.CommandName=="ViewRouteCommand")
                Page.Response.Redirect("Routes.aspx?rname=" + rname + "&creator=" + procedures.retrieve_id(creator));
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
                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

     

        
    }
}