using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using WebApplication3.database_classes;
using System.Globalization;
using System.Data;

namespace WebApplication3.Profiles
{
    public partial class ChildProfile : System.Web.UI.Page
    {
        static int ownerid;
        static SqlConnection connection;
        static DBProcedures procedures;


        
        protected void Page_Load(object sender, EventArgs e)
        {
            
            connection = new SqlConnection(@"Data Source=OMAR-PC\SQLEXPRESS;Initial Catalog=MySchoolCommunity;Integrated Security=True");
            procedures = new DBProcedures();
            LoggedinLiteral.Text = Login.currentlyLoggedIn;
            
            ownerid = Convert.ToInt32(Page.Request.QueryString["uid"]);
            SqlCommand userquery = new SqlCommand("select * from users u where u.u_id='" + ownerid + "'",connection);
            connection.Open();
            SqlDataReader usereader = userquery.ExecuteReader();

            if (!usereader.Read())

                Page.Response.Redirect("~/ErrorPage.aspx?error=User doesn't exist");

            else if (Login.id == -1)
                Page.Response.Redirect("~/Login.aspx?redirect=~/Profiles/ParentProfile.aspx?uid=" + ownerid);

            else if ((procedures.are_friends(Login.id, ownerid) == false) && Login.id != ownerid&&!procedures.related(Login.id,ownerid))

                Page.Response.Redirect("~/ErrorPage.aspx?error=You are now allowed to view this page");

             

            else
            {
                string n = usereader.GetString(1);
                usereader.Close();
                initAttributes(n);
                if (Login.id == ownerid)
                    Page.Response.Write("You are on you own profile");
            }
        
        
        }


        public void initAttributes(string name)
        {
            SqlCommand childquery = new SqlCommand(
                "select * from children c inner join schools s on s.u_id=c.sc"+
                "hool_id inner join users u on s.u_id=u.u_id  where c.u_id ='" + ownerid + "'",connection);
            SqlDataReader childreader = childquery.ExecuteReader();
            childreader.Read();
            ChildNameLiteral.Text = name;
            AgeLiteral.Text = childreader.GetInt32(2).ToString();
            if (childreader.GetBoolean(5))
            {
                SchoolLabel.Visible=true;
                SchoolLiteral.Visible = true;
                SchoolLiteral.Text = childreader.GetString(13);
            }
            childreader.Close();
            showPersonal();

            initParents();

        }

        protected void initParents()
        {
            SqlCommand parentquery = new SqlCommand("select * from children c inner join Child_of_Parent cop "
                + "on c.u_id=cop.child inner join parents p on cop.parent=p.u_id inner join "
                +"users u on p.u_id=u.u_id where c.u_id='"+ownerid+"' and cop.status= '1'", connection);
            SqlDataReader parentreader = parentquery.ExecuteReader();
            
            while (parentreader.Read())
            {
                Label label = new Label();
                label.Text = "Parent:";
                ParentPanel.Controls.Add(label);
                Literal literal = new Literal();
                literal.Text = parentreader.GetString(18);
                ParentPanel.Controls.Add(literal);

            }
            connection.Close();
        }
        protected void showPersonal()
        {
            if (ownerid == Login.id)
            {
                ViewUsersButton.Visible = true;
                PendingfrButton.Visible = true;
                
                FriendsButton.Visible = true;
                
                ViewParentsButton.Visible = true;
                SearchTextBox.Visible = true;
                SearchButton.Visible = true;
                ViewLDBButton.Visible = true;
                PPButton.Visible = true;
                HobbyTextBox.Visible = true;
                HobbyButton.Visible = true;
                interestButton.Visible = true;
                interestTextBox.Visible = true;
                VLSButton.Visible = true;
            }
            else
                ReturnProfileButton.Visible = true;
        }

        protected void PostButton_Click(object sender, EventArgs e)
        {
            string post = PostTextBox.Text;

            procedures.add_posts_on_user(Login.id, post, ownerid);

            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void LogOutButton_Click(object sender, EventArgs e)
        {
            Login.currentlyLoggedIn = null;
            Login.id = -1;
            Page.Response.Redirect("~/homepage.aspx");
        }

        protected void ViewUsersButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/ViewUsers.aspx");
        }

        protected void PendingfrButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/PendingFriendshipRequests.aspx?uid=" + Convert.ToInt32(Login.id));
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string n = SearchTextBox.Text;
            Page.Response.Redirect("SearchByName.aspx?name=" + n);
        }

        protected void ViewLDBButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("LinkedDiscussionBoards.aspx?uid=" + Login.id + "&type=" + procedures.user_type(Login.id));
        }

        protected void ViewParentsButton_Command(object sender, CommandEventArgs e)
        {
            Page.Response.Redirect("ViewChildrenParents.aspx?type=c");
        }

        protected void FriendsButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("~/Friends.aspx?uid=" + Login.id.ToString());
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

        protected void PPButton_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("PendingChildParentRequests.aspx?uid=" + Login.id + "&type=c");
        }

        protected void HobbyButton_Click(object sender, EventArgs e)
        {
            string hobby = HobbyTextBox.Text;
            SqlCommand cmd = new SqlCommand("enter_hobbies", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", Login.id);
            cmd.Parameters.AddWithValue("@hobby",hobby);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
            Page.Response.Redirect(Page.Request.RawUrl);
        }

        protected void interestButton_Click(object sender, EventArgs e)
        {
            string interest = interestTextBox.Text;
            SqlCommand cmd = new SqlCommand("enter_interests", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@id", Login.id);
            cmd.Parameters.AddWithValue("@interest", interest);
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