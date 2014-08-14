using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication3.database_classes
{
    public class Parent
    {
        public int u_id;
        public string job;
        public string email;
        public int house_number;
        public string st_name;
        public string area;
        public string country;

        public Parent(int u_id, string job, string email, int house_number, string st_name, string area, string country)
        {
            this.u_id = u_id;
            this.job = job;
            this.email=email;
            this.house_number = house_number;
            this.st_name = st_name;
            this.area = area;
            this.country = country;

        }
    }
}