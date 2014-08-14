using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
namespace WebApplication3.DiscussionBoards
{
    public partial class CreateThread : System.Web.UI.Page
    {
        static string sid;
        static string subject;
        static string starter;
        DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            sid = Page.Request.QueryString["sid"];
            subject = Page.Request.QueryString["subject"];
            starter = Page.Request.QueryString["starter"];
            procedures = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            StarterSchoolLiteral.Text = procedures.retrieve_name(Convert.ToInt32(sid));
            dsubjectLiteral.Text = subject;
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
                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void CreateButton_Click(object sender, EventArgs e)
        {
            subjectValidator.Enabled = true;
            string thsubject = ThreadSubjectTextBox.Text;
            string topic = TopicTextBox.Text;
            Page.Response.Write(sid + " " + subject);
             procedures.start_thread(Convert.ToInt32(starter), Convert.ToInt32(sid), subject, thsubject, topic);
            int thid=procedures.thread_count(Convert.ToInt32(sid), subject)-1;
            Page.Response.Redirect("Thread.aspx?sid="+sid+"&subject="+subject+"&thid="+thid);

        }
    }
}