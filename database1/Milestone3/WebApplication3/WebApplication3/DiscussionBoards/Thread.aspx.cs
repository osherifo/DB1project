using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication3.DiscussionBoards
{
    public partial class Thread : System.Web.UI.Page
    {

        static string sid;
        static string subject;
        static string thid;
        static DBProcedures procedures;
        static SqlConnection connection;


        protected void Page_Load(object sender, EventArgs e)
        {
            connection = new SqlConnection(ConfigurationManager.
            ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
            sid = Page.Request.QueryString["sid"];
            subject = Page.Request.QueryString["subject"];
            thid = Page.Request.QueryString["thid"];
            procedures = new DBProcedures();
            initAttributes();

        }


        public void initAttributes()
        {     SqlCommand cmd=new SqlCommand("select * from threads t where t.d_subject='"+
            subject+"' and t.school='"+sid+"' and t.th_id='"+thid+"'",connection);
        connection.Open();
        SqlDataReader rdr = cmd.ExecuteReader();
        rdr.Read();
        thSubjectLiteral.Text = rdr.GetString(3);
        thTopicLiteral.Text = rdr.GetString(4);    
        }


        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void DiscussionBoardReturnButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("DiscussionBoard.aspx?sid=" + sid + "&subject=" + subject);
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

        protected void ReplyButton_Click(object sender, EventArgs e)
        {
            replyValidator.Enabled = true;
            string reply = ReplyTextBox.Text;
            procedures.reply_to_thread(Login.id, Convert.ToInt32(sid), subject, Convert.ToInt32(thid), reply);
         
            Page.Response.Redirect(Page.Request.RawUrl);
        }
    }
}