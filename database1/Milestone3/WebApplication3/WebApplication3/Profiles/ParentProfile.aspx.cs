using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using WebApplication3.database_classes;
using System.Data;
using System.Configuration;
namespace WebApplication3.Profiles
{
    public partial class ParentProfile : System.Web.UI.Page
    {
        static int ownerid;
        static SqlConnection connection;
        static DBProcedures procedures;
        protected void Page_Load(object sender, EventArgs e)
        {         connection = new SqlConnection
            (ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);
        procedures = new DBProcedures();
            
            ownerid = Convert.ToInt32(Page.Request.QueryString["uid"]);
            
                SqlCommand userquery = new SqlCommand("SELECT * FROM Users u WHERE u.u_id='"+ownerid+"'",connection);
               connection.Open() ;
                SqlDataReader usereader = userquery.ExecuteReader();
                
                if (!usereader.Read())

                    Page.Response.Redirect("~/ErrorPage.aspx?error=User doesn't exist");

                else if (Login.id == -1)
                    Page.Response.Redirect("~/Login.aspx?redirect=~/Profiles/ParentProfile.aspx?uid=" + ownerid);

                else if ((procedures.are_friends(Login.id, ownerid)==false) && Login.id != ownerid&&!procedures.related(ownerid,Login.id))

                    Page.Response.Redirect("~/ErrorPage.aspx?error=You are now allowed to view this page");

                
                else
                {

                    showPersonal();
                    
                    
                    
                    
                    string name = usereader.GetString(1);
                    usereader.Close();
                    initAttributes(name);
                   
                    if (Login.id == ownerid)
                        Page.Response.Write("you are on your own profile");

                    connection.Close();
                

            }

        }

        protected void showPersonal()
        {
            if (ownerid == Login.id)
            {
                ViewUsersButton.Visible = true;
                PendingfrButton.Visible = true;
                CreateRouteButton.Visible = true;
                FriendsButton.Visible = true;
                MyRoutesButton.Visible = true;
                ViewChildrenButton.Visible = true;
                SearchTextBox.Visible = true;
                SearchButton.Visible = true;
                ViewLDBButton.Visible = true;
                PCHRButton.Visible = true;
                PhoneTextBox.Visible = true;
                PhoneButton.Visible = true;
                VLSButton.Visible = true;
            }
            else
                ReturnProfileButton.Visible = true;
        }

        protected void initAttributes(string name)
        {
            NameLiteral.Text = name;
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            SqlCommand parentquery = new SqlCommand("select * from parents p where p.u_id='"
                + ownerid + "'", connection);

            SqlDataReader parentreader = parentquery.ExecuteReader();
            parentreader.Read();
            JobLiteral.Text = parentreader.GetString(2);
            EmailLiteral.Text = parentreader.GetString(1);
            AdressLiteral.Text = parentreader.GetInt32(3) + " " + parentreader.GetString(4) + "," +
                parentreader.GetString(5) + "," + parentreader.GetString(6);

        }


        protected void LogOutButton_Click(object sender, EventArgs e)
        {
            Login.id = -1;
            Login.currentlyLoggedIn = null;
            Page.Response.Redirect("~/homepage.aspx");

        }

        protected void ViewUsersButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/ViewUsers.aspx");
        }

        protected void CreateRouteButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Routes/CreateRoute.aspx");
        }

        protected void PendingfrButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/PendingFriendshipRequests.aspx?uid="+Convert.ToInt32(Login.id));
        }

        protected void FriendsButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Friends.aspx?uid="+Login.id.ToString());
        }

        protected void ReturnProfileButton_Click(object sender, EventArgs e)
        {
            if (procedures.user_type(Login.id) == "C")
                Page.Response.Redirect("ChildProfile.aspx?uid=" + Login.id.ToString());
            else if (procedures.user_type(Login.id) == "P")
                Page.Response.Redirect("ParentProfile.aspx?uid=" + Login.id.ToString());
            if (procedures.user_type(Login.id) == "S")
                Page.Response.Redirect("SchoolProfile.aspx?uid=" + Login.id.ToString());
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewPostCommand")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[index];

                string n = row.Cells[0].Text;
              int poster = procedures.retrieve_id(n);
                string dt = row.Cells[1].Text;
                string post = row.Cells[2].Text;
                int postedonuser = ownerid;

                Page.Response.Redirect("Posts.aspx?poster=" + poster + "&dt=" + dt+"&post="+post+
                    "&postedonuserid="+postedonuser);
            }
        }

        protected void PostButton_Click(object sender, EventArgs e)
        {
            string post = PostTextBox.Text;

            procedures.add_posts_on_user(Login.id, post, ownerid);
            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void ViewChildrenButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("ViewChildrenParents.aspx?type=p");
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string n = SearchTextBox.Text;
            Page.Response.Redirect("SearchByName.aspx?name=" + n);
        }

        protected void MyRoutesButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Routes/MyRoutes.aspx?uid=" + Login.id);
        }

        protected void ViewLDBButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("LinkedDiscussionBoards.aspx?uid=" + Login.id + "&type=" + procedures.user_type(Login.id));
        }

        protected void PCHRButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("PendingChildParentRequests.aspx?uid="+Login.id+"&type=p");
        }

        protected void PhoneButton_Click(object sender, EventArgs e)
        {
            int phone = Convert.ToInt32(PhoneTextBox.Text);
            SqlCommand cmd = new SqlCommand("add_parent_phone", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", Login.id);
            cmd.Parameters.AddWithValue("@phone", phone);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void VLSButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("LinkedSchools.aspx?uid=" + Login.id);
        }



        
    }
}