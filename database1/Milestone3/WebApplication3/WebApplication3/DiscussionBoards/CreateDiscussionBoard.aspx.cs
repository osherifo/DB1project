using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using WebApplication3.database_classes;
namespace WebApplication3.DiscussionBoards
{
    public partial class CreateDiscussionBoard : System.Web.UI.Page
    {
        
        static DBProcedures proc;


        protected void Page_Load(object sender, EventArgs e)
        {

            
            proc = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;

        }

        protected void CreateButton_Click(object sender, EventArgs e)
        {
            string subject = SubjectTextBox.Text;
            subjectValidator.Enabled = true;
            proc.create_discussion_board(Login.id, subject);
            Page.Response.Redirect("intermediateCreation.aspx?sid=" + Login.id + "&subject=" + subject);
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
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
            if (proc.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }
    }
}