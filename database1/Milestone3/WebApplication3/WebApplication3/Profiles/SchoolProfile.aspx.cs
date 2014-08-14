using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication3.database_classes;
using System.Data.SqlClient;
namespace WebApplication3.Profiles
{
    public partial class SchoolProfile : System.Web.UI.Page
    {
        static int ownerid;
        
        static SqlConnection connection;
        static DBProcedures procedures;
        protected void Page_Load(object sender, EventArgs e)
        {
            connection = new SqlConnection(@"Data Source=OMAR-PC\SQLEXPRESS;Initial Catalog=MySchoolCommunity;Integrated Security=True");
            procedures = new DBProcedures();
            
            ownerid = Convert.ToInt32(Page.Request.QueryString["uid"]);
            SqlCommand userquery = new SqlCommand("select * from Users s where s.u_id='"+
                ownerid+"'", connection);
            connection.Open();
            SqlDataReader usereader= userquery.ExecuteReader();
                
                if (!usereader.Read())

                    Page.Response.Redirect("~/ErrorPage.aspx?error=User doesn't exist");


         else if (!(procedures.are_friends(Login.id, ownerid))&&Login.id!=ownerid&&!procedures.user_linkedto_school(Login.id,ownerid))

                    Page.Response.Redirect("~/ErrorPage.aspx?error=You are now allowed to view this page");

                else if (Login.id == -1)
                {
                    Page.Response.Redirect("~/Login.aspx?redirect=~/Profiles/SchoolProfile.aspx?uid=" + ownerid);
                }
                
                else
                {
                    string n = usereader.GetString(1);
                    usereader.Close();
                    initAttributes(n);

                    


                    if (Login.id == ownerid) { 
                        Page.Response.Write("you are on your own profile");
                        showPersonal();
                       
                }
                    else
                    {
                        ReturnButton.Visible = true;
                    }

                }

            
        }
        protected void showPersonal()
        {
            ViewUsersButton.Visible = true;
            PendingcrButton.Visible = true;
            CreateDBButton.Visible = true;
            PendingfrButton.Visible = true;
            SearchButton.Visible = true;
            FriendsButton.Visible = true;
            ViewLDBButton.Visible = true;
            SearchTextBox.Visible = true;
            
        }
        protected void initAttributes(string name)
        {
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            SchoolNameLiteral.Text = name;
            SqlCommand schoolquery = new SqlCommand("select * from Schools s where s.u_id='" + ownerid + "'",
                connection);
            
            SqlDataReader schoolreader = schoolquery.ExecuteReader();
            schoolreader.Read();
            EdSystemLiteral.Text = schoolreader.GetString(1);
            AddressLiteral.Text = schoolreader.GetInt32(2).ToString() + " " + schoolreader.GetString(3) + " " +
                schoolreader.GetString(4) + " " + schoolreader.GetString(5);
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

        protected void PendingfrButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/PendingFriendshipRequests.aspx?uid="+Login.id);
        }

        protected void PendingcrButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("PendingChildRequests.aspx?sid=" + Login.id);
            
        }

        protected void PostButton_Click(object sender, EventArgs e)
        {
            string post = PostTextBox.Text;

            procedures.add_posts_on_user(Login.id, post, ownerid);

            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void CreateDBButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/DiscussionBoards/CreateDiscussionBoard.aspx");
        }

        protected void ViewLDBButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("LinkedDiscussionBoards.aspx?uid=" + Login.id + "&type=" + procedures.user_type(Login.id));
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string n = SearchTextBox.Text;
            Page.Response.Redirect("SearchByName.aspx?name=" + n);
        }

        protected void FriendsButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Friends.aspx?uid=" + Login.id.ToString());
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

                Page.Response.Redirect("Posts.aspx?poster=" + poster + "&dt=" + dt + "&post=" + post +
                    "&postedonuserid=" + postedonuser);
            }
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
    }
}