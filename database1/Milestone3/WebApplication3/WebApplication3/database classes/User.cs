using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace WebApplication3.database_classes
{
    public class User
    {
        public int u_id;
        public string username;
        public string password;
        public SqlDataReader reader;

        public User(SqlDataReader record)
        {
            reader = record;
            u_id = reader.GetInt32(0);
            username = reader.GetString(1);
            password = reader.GetString(2);
        }
    }
}