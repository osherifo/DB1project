using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Configuration;
namespace WebApplication3.database_classes

{
    public class DBProcedures
    {

        
    
            private static SqlConnection connection ; 
        
        
        public DBProcedures()
        {
            connection = new SqlConnection
                ( ConfigurationManager.ConnectionStrings["MySchoolCommunityConnectionString"].ConnectionString);


        }

        public void create_child(string username, string password, string schoolname, DateTime birthdate)
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand("create_child",connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@username", username);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@schoolname", schoolname);
            cmd.Parameters.AddWithValue("@birthdate", birthdate);
            cmd.ExecuteNonQuery();
            connection.Close();
        }

        public void create_parent(string username,string password,string email,
            string job,int housenumber,string streetname,string area,string country,int phone)
        {
            connection.Open();
            SqlCommand cmd=new SqlCommand("create_parent",connection);
            cmd.CommandType=CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@username", username);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@job", job);
            cmd.Parameters.AddWithValue("@house_number", housenumber);
            cmd.Parameters.AddWithValue("@st_name", streetname);
            cmd.Parameters.AddWithValue("@area", area);
            cmd.Parameters.AddWithValue("@country", country);
            cmd.Parameters.AddWithValue("@phone", phone);
            cmd.ExecuteNonQuery();


            connection.Close();

        }

        public void create_school(string username,string password,string edsystem,int housenumber
            , string st_name, string area, string country)
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand("create_school",connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@username", username);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@ed_system", edsystem);
            cmd.Parameters.AddWithValue("@house_number", housenumber);
            cmd.Parameters.AddWithValue("@st_name", st_name);
            cmd.Parameters.AddWithValue("area", area);
            cmd.Parameters.AddWithValue("country", country);
            cmd.ExecuteNonQuery();
            connection.Close();
        }

        public bool are_friends(int user1,int user2)
        {
            SqlCommand cmd = new SqlCommand("select dbo.are_friends(@user1,@user2)", connection);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@user1",user1);
            cmd.Parameters.AddWithValue("@user2",user2);
           connection.Open();
            bool r= (bool)cmd.ExecuteScalar();
            connection.Close();
            return r;
        }

        public string user_type(int user)
        {
            SqlCommand cmd = new SqlCommand("select dbo.user_type(@u_id)", connection);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@u_id", user);
            connection.Open();
            string r;
            try
            {
                 r = (string)cmd.ExecuteScalar();
            }
            catch (System.InvalidCastException)
            {
                 r = "E";
            }
            connection.Close();
            return r;
        }

        public bool user_linkedto_school(int u_id, int s_id)
        {
            SqlCommand cmd = new SqlCommand("select dbo.user_linkedto_school(@u_id,@s_id)", connection);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@u_id", u_id);
            cmd.Parameters.AddWithValue("@s_id", s_id);
            connection.Open();
            bool r = (bool)cmd.ExecuteScalar();
            connection.Close();
            return r;
        }

        public SqlDataReader pending_req(int user)
        {
            connection.Open();
            SqlCommand cmd = new SqlCommand("pending_req", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@user",user);
            return cmd.ExecuteReader();//may cause problems

        }

        public void friend_request(string name1, string name2)
        {
            int id1 = retrieve_id(name1);
            int id2 = retrieve_id(name2);
            if (!freqrecordexists(name1,name2))
            {
                SqlCommand cmd = new SqlCommand("Friendship_request", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@user1", id1);
                cmd.Parameters.AddWithValue("@user2", id2);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();
            }
        }

        public bool freqrecordexists(string name1,string name2)
        {
            int id1=retrieve_id(name1);
            int id2=retrieve_id(name2);
            SqlCommand cmd = new SqlCommand("select * from User1_freq_User2  where sender='"
                + id1 + "' and receiver='" + id2 + "'",connection);//addotherwayround
            connection.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            bool r = (reader.Read());
            connection.Close();
            return r;
               

            
        }

        public int retrieve_id(string name)
        {
            SqlCommand cmd = new SqlCommand("select u.u_id from users u where u.username='" + name + "'", connection);
            connection.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            reader.Read();
            int id = reader.GetInt32(0);
            connection.Close();
            return id;

        }

        public void accept_reject_freq(string sender, string receiver, bool status)
        {
            int senderid = retrieve_id(sender);
            int receiverid = retrieve_id(receiver);
            if (freqrecordexists(sender, receiver))
            {

                SqlCommand cmd = new SqlCommand("accept_reject_fr", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@sender", senderid);
                cmd.Parameters.AddWithValue("@receiver", receiverid);
                cmd.Parameters.AddWithValue("@status", status);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();

            }
        }

            public void create_route(int creator,string rname){

                SqlCommand cmd = new SqlCommand("create_route",connection);
                cmd.CommandType=CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id",creator);
                cmd.Parameters.AddWithValue("@r_name", rname);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();


            }


            public void specify_start_end_route(int creator, string rname, string start, string end)
            {
                SqlCommand cmd = new SqlCommand("specify_start_end_route", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", creator);
                cmd.Parameters.AddWithValue("@r_name", rname);
                cmd.Parameters.AddWithValue("@start", start);
                cmd.Parameters.AddWithValue("@end", end);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();
            }
            public void specify_frequecny_max(int id, string rname, string frequency, int max)
            {
                SqlCommand cmd = new SqlCommand("specify_frequency_max", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@r_name", rname);
                cmd.Parameters.AddWithValue("@frequency", frequency);
                cmd.Parameters.AddWithValue("@max", max);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();
            }

            public bool routeRecordExists(int creator, string rname)
            {
                SqlCommand cmd = new SqlCommand("select * from routes r where r.creator='" + creator +
                    "' and r.r_name='" + rname + "'", connection);
                connection.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                bool r = rdr.Read();
                connection.Close();
                return r;

                
            }

            public string retrieve_name(int id)
            {
                SqlCommand cmd = new SqlCommand("select * from users u where u.u_id='" +
                id + "'",connection);
                connection.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                rdr.Read();
                string name = rdr.GetString(1);
                connection.Close();
                return name;
            }

            public int slotsAvailableRoute(int creator, string rname,int max)
            {
                SqlCommand cmd = new SqlCommand("select count(*) from route_invite_user1_user2 r where r.r_name='"
                    + rname + "' and r.creator='" + creator.ToString() + 
                    "' and (r.status ='1' or r.status is null)",connection);
                connection.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                rdr.Read();
                int taken = rdr.GetInt32(0);
                connection.Close();
                return max - taken;

            }

            public bool validRouteInvitor(int invitor,string name,int creator)
            {
                if (invitor == creator)
                    return true;
                else
                {
                    SqlCommand cmd = new SqlCommand("select * from route_invite_user1_user2 r where r.invited='"
                        +invitor+"'", connection);
                    connection.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();

                    bool r = rdr.Read();
                    connection.Close();
                    return r;




                }
            }

            public void InviteToRoute(int creator, string rname, int invitor, int invited)
            {
                SqlCommand cmd = new SqlCommand("invite_to_carpool", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@invitor", invitor);
                cmd.Parameters.AddWithValue("@invited", invited);
                cmd.Parameters.AddWithValue("@creator",creator);
                cmd.Parameters.AddWithValue("@route", rname);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();
            }


            public void accept_reject_child(string child, bool status)
            {
                int id = retrieve_id(child);
                SqlCommand cmd = new SqlCommand("accept_reject_child", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@child", id);
                cmd.Parameters.AddWithValue("@status", status);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();

            }


        public void create_discussion_board(int id,string dsubject){
           if (!dbexists(id, dsubject)) { 

            SqlCommand cmd = new SqlCommand("create_discussion_board", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@d_subject", dsubject);
            cmd.Parameters.AddWithValue("@school", id);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
                }
        }

        public bool dbexists(int school, string dsubject)
        {
            SqlCommand cmd = new SqlCommand("select * from discussion_boards where school='" + school +
                "' and subject='" + dsubject + "'",connection);
            connection.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            bool r = rdr.Read();
            connection.Close();
            return r;
        }


        public void start_thread(int starter, int school, string d_subject, string subject, string topic)
        {
            SqlCommand cmd = new SqlCommand("start_thread", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@starter", starter);
            cmd.Parameters.AddWithValue("@school", school);
            cmd.Parameters.AddWithValue("@d_subject", d_subject);
            cmd.Parameters.AddWithValue("@subject", subject);
            cmd.Parameters.AddWithValue("@topic", topic);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
        }
        public int thread_count(int school, string d_subject)
        {
            SqlCommand cmd = new SqlCommand("select dbo.thread_count(@school,@d_subject)", connection);
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@school", school);
            cmd.Parameters.AddWithValue("@d_subject", d_subject);
            int r;
            connection.Open();
            r =(int)cmd.ExecuteScalar();
            connection.Close();
            return r;
        }

        public void reply_to_thread(int replier,int school,string d_subject,int thread,string reply)
        {
            SqlCommand cmd = new SqlCommand("reply_to_thread", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@replier", replier);
            cmd.Parameters.AddWithValue("@d_subject", d_subject);
            cmd.Parameters.AddWithValue("@thread", thread);
            cmd.Parameters.AddWithValue("@reply", reply);
            cmd.Parameters.AddWithValue("@school", school);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
        }

        public void comment_on_post(int commenter, DateTime date_time, int poster, string words)
        {
            SqlCommand cmd = new SqlCommand("comment_on_post", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@commenter", commenter);
            cmd.Parameters.AddWithValue("@date_time", date_time);
            cmd.Parameters.AddWithValue("@poster", poster);
            cmd.Parameters.AddWithValue("@words", words);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();


        }

        public void parent_child_request(int parent, int child,string sender)
        {
            SqlCommand cmd = new SqlCommand("parent_child_request", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@parent", parent);
            cmd.Parameters.AddWithValue("@child", child);
            cmd.Parameters.AddWithValue("@sender", sender);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
        
        }

        public void approve_reject_child_parent(int child, int parent, bool status)
        {
            SqlCommand cmd = new SqlCommand("approve_reject_child_parent", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@child", child);
            cmd.Parameters.AddWithValue("@parent", parent);
            cmd.Parameters.AddWithValue("@status", status);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();

        }

        public void add_posts_on_user(int poster, string words, int user)
        {

            SqlCommand exists = new SqlCommand("select * from posts p where p.poster='" + poster +
                "' and p.words='" + words + "' and p.posted_on_user='" + user + "'",connection);
            connection.Open();
            SqlDataReader rdr = exists.ExecuteReader();
            if (!rdr.Read())
            {
                rdr.Close();
                connection.Close();
                
                SqlCommand cmd = new SqlCommand("add_posts_on_user", connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@poster", poster);
                cmd.Parameters.AddWithValue("@words", words);
                cmd.Parameters.AddWithValue("@user", user);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();

            }
        }



        public void accept_reject_carpool(int invited, int creator, string route, bool status)
        {
            SqlCommand cmd = new SqlCommand("accept_reject_carpool", connection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@invited", invited);
            cmd.Parameters.AddWithValue("@creator", creator);
            cmd.Parameters.AddWithValue("@route", route);
            cmd.Parameters.AddWithValue("@status", status);
            connection.Open();
            cmd.ExecuteNonQuery();
            connection.Close();
        }

        public bool related(int parent, int child)
        {
            if (user_type(parent) == "P" && user_type(child) == "C")
            {
                SqlCommand cmd = new SqlCommand("select * from child_of_parent cop where cop.child='" +
                "' and cop.parent='" + parent + "' and cop.status='1'");
                connection.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                bool r = rdr.Read();
                connection.Close();
                return r;





            }

            return false;

        }


    
    }
}