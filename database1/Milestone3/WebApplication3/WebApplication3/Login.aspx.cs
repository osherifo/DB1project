using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using WebApplication3.database_classes;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
    {
      public static string currentlyLoggedIn;
      public static int id;
      static bool redirect;
        static SqlConnection connection;
        static DBProcedures procedures;

        protected void Page_Load(object sender, EventArgs e)
        {
      connection = new SqlConnection(@"Data Source=OMAR-PC\SQLEXPRESS;Initial Catalog=MySchoolCommunity;Integrated Security=True");
      procedures = new DBProcedures();
            
            if (Page.Request.QueryString["redirect"] != null)
                redirect=true;
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            
                connection.Open();
                SqlCommand userquery = new SqlCommand(
                    "select * from Users u where u.username='" + UsernameLoginTextBox.Text
                    + "' and u.password='" + PasswordTextBox.Text + "'", connection);
                SqlDataReader usereader = userquery.ExecuteReader();

                
          if (usereader.Read())
                    {
                        currentlyLoggedIn = UsernameLoginTextBox.Text;
                        id = usereader.GetInt32(0);


                        if (redirect) { Page.Response.Redirect(Page.Request.QueryString["redirect"]); }

                        else
                        {
                            if (procedures.user_type(id) == "C")
                                Page.Response.Redirect("~/Profiles/ChildProfile.aspx?uid=" + id);
                            else if (procedures.user_type(id) == "P")

                                Page.Response.Redirect("~/Profiles/ParentProfile.aspx?uid=" + id);

                            else if (procedures.user_type(id) == "S")
                                Page.Response.Redirect("~/Profiles/SchoolProfile.aspx?uid=" + id);
                        }
                    }
                
          else
           ErrorLiteral.Visible = true;
           
            
        }
   
    
    
    
    
    
    
    
    
    
    }
}