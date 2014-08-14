using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.SqlClient;
using System.Configuration;
namespace WebApplication3.Routes
{
    public partial class CreateRoute : System.Web.UI.Page
    {

        static SqlConnection connection;
        static DBProcedures proc;
        protected void Page_Load(object sender, EventArgs e)
        {
            connection=new SqlConnection
                (ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);

            proc = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
        }

        protected void CreateButton_Click(object sender, EventArgs e)
        {
                string rname = RouteNameTextBox.Text;
                
            if(!proc.routeRecordExists(Login.id,rname)){
            
            
                proc.create_route(Login.id, rname);

                string start = StartTextBox.Text;
                string end = EndTextBox.Text;
                string frequency = FrequencyDropDownList.SelectedValue.ToString();
                int max = Convert.ToInt32(MaxNumberTextBox.Text);


                if (start != null || end != null)
                    proc.specify_start_end_route(Login.id, rname, start, end);

                if (frequency != null || max > 0 )
                    proc.specify_frequecny_max(Login.id, rname, frequency, max);

                Page.Response.Redirect("Routes.aspx?creator=" + Login.id + "&rname=" + rname);
            }

        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            Login.id = -1;
            Login.currentlyLoggedIn = null;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + Convert.ToInt32(Login.id));
        }
    }
}