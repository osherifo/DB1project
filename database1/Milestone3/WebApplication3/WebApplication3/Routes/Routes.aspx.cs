using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using WebApplication3.database_classes;
namespace WebApplication3.Routes
{
    public partial class Routes : System.Web.UI.Page
    {

        static SqlConnection connection;
        static DBProcedures proc;
        static string rname;
        static string creator;

        protected void Page_Load(object sender, EventArgs e)
        {
             rname = Page.Request.QueryString["rname"];
             creator = Page.Request.QueryString["creator"];
            connection=new SqlConnection(ConfigurationManager.
                ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
            proc = new DBProcedures();

            initAttributes();
            if (proc.validRouteInvitor(Login.id,rname,Convert.ToInt32(creator)))
                InviteButton.Visible = true;




        }


        protected void initAttributes()
        {
           
            SqlCommand cmd = new SqlCommand("select * from routes r where r.r_name='" + rname +
                "' and r.creator='" + creator + "'",connection);
            connection.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            rdr.Read();
            RouteNameLiteral.Text = rname;
            CreatorLiteral.Text = proc.retrieve_name(Convert.ToInt32(creator));
            MaxNumberLiteral.Text = rdr.GetInt32(5).ToString();
            StartLiteral.Text = rdr.GetString(2);
            EndLiteral.Text = rdr.GetString(3);
            FrequencyLiteral.Text = rdr.GetString(4);
            FreeSlotsLiteral.Text = proc.slotsAvailableRoute(Convert.ToInt32(creator),rname,rdr.GetInt32(5)).ToString();

        }


        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.id = -1;
            Login.currentlyLoggedIn = null;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            if (proc.user_type(Login.id) == "C")
                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (proc.user_type(Login.id) == "P")
                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Login.id.ToString());
            else if (proc.user_type(Login.id) == "S")
                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void InviteButton_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(FreeSlotsLiteral.Text) == 0)
                NoSpaceLiteral.Visible = true;
            else 
            {
                Page.Response.Redirect("InvitedRoute.aspx?creator="+creator+"&rname="+
                    RouteNameLiteral.Text+"&uid="+Login.id.ToString());
            }
        }
    }
}