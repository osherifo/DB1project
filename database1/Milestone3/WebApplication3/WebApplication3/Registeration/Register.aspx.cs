using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.SqlClient;
namespace WebApplication3
{
    public partial class Register : System.Web.UI.Page
    {
        static int lastselected;
        static SqlConnection connection;
        protected void Page_Load(object sender, EventArgs e)
        {
        connection = new SqlConnection
            (@"Data Source=OMAR-PC\SQLEXPRESS;Initial Catalog=MySchoolCommunity;Integrated Security=True");

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            connection.Open();
            
               string username=UsernameTextBox.Text;
                string password=PasswordTextBox.Text;
            SqlCommand userquery=new SqlCommand("select * from Users u where u.username='"+username+"'",connection);
            SqlDataReader usereader= userquery.ExecuteReader();
                
                DBProcedures proc=new DBProcedures();
                if (!usereader.Read())
                {

                    if (lastselected == 1)
                    proc.create_child(username,password, ChildSchoolName.Text, Convert.ToDateTime(ChildYear.SelectedValue.ToString() +
                        "/" + ChildMonth.SelectedValue.ToString()+ "/"+ ChildDay.SelectedValue.ToString()+" 00:00:00"));

                    else if (lastselected == 2)
                     proc.create_parent(username, password, ParentEmail.Text, ParentJob.Text, Convert.ToInt32(ParentHouseNumber.Text), ParentStreetName.Text, ParentArea.Text, ParentCountry.Text, Convert.ToInt32(ParentPhone.Text));

                    else if (lastselected == 3)
                    proc.create_school(username, password, SchoolEducationalSystem.Text, Convert.ToInt32(SchoolHouseNumber.Text), SchoolStreetName.Text, SchoolArea.Text, SchoolCountry.Text);



                    Page.Response.Redirect("intermediateRegister.aspx");
                }

                else
                {
                    UserTakenLiteral.Visible = true;



                }

            
            

        }

     

       
        protected void ChildRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            ParentPanel.Enabled = false;
            SchoolPanel.Enabled = false;
            ChildPanel.Enabled = true;
            lastselected = 1;
        }

        protected void ParentRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            ChildPanel.Enabled = false;
            SchoolPanel.Enabled = false;
            ParentPanel.Enabled = true;
            lastselected = 2;
        }

        protected void SchooRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            ChildPanel.Enabled = false;
            ParentPanel.Enabled = false;
            SchoolPanel.Enabled = true;
            lastselected = 3;
        }

       protected void ChildYear0_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

       
      
  
    }
       
  
}