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
    public partial class Posts : System.Web.UI.Page
    {

        static int posterid;
        static string postername;
        static string dt;
        static string post;
        static int postedonuserid;
        static string postedonusername;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
            procedures = new DBProcedures();
            
            posterid = Convert.ToInt32(Page.Request.QueryString["poster"]);
            postername = procedures.retrieve_name(posterid);
            dt=Page.Request.QueryString["dt"];
            post = Page.Request.QueryString["post"];
            postedonuserid = Convert.ToInt32(Page.Request.QueryString["postedonuserid"]);
            postedonusername = procedures.retrieve_name(postedonuserid);
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            PosterLiteral.Text = postername;
            DateTimeLiteral.Text = dt;
            PostLiteral.Text = post;
            PostedOnLiteral.Text = postedonusername;
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

       

        protected void AddCommentButton_Click(object sender, EventArgs e)
        {
            string comment = CommentTextBox.Text;
            procedures.comment_on_post(Login.id, Convert.ToDateTime(dt), posterid, comment);
            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void Return2Button_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(postedonuserid) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + postedonuserid.ToString());
            else if (procedures.user_type(postedonuserid) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + postedonuserid.ToString());
            if (procedures.user_type(postedonuserid) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + postedonuserid.ToString());
        }
    }
}