<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Configuration;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public List<Conference> GetConferenceInfo()
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        //SqlDataAdapter da = new SqlDataAdapter("SELECT ProductName, UnitPrice FROM products where UnitPrice >  @priceKey  ORDER BY UnitPrice DESC", @"Data Source=hp;Initial Catalog=Northwind;Integrated Security=SSPI;");
        SqlDataAdapter da = new SqlDataAdapter("SELECT c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c JOIN Employees AS e ON c.Creator = e.Name ORDER BY c.CreatedTime", cn);


        DataTable dt = new DataTable();
        da.Fill(dt);


        var query = from t in dt.AsEnumerable()
                    select new Conference()
                    {
                        Topic = t["Topic"].ToString(),
                        StartTime = Convert.ToDateTime(t["StartTime"]),
                        CreatedTime = Convert.ToDateTime(t["CreatedTime"]),
                        Creator = t["Name"].ToString(),

                    };

        return query.ToList();
    }

    [WebMethod]
    public List<Conference2> QueryConference(string keyword)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlDataAdapter da = new SqlDataAdapter("SELECT c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c JOIN Employees AS e ON c.Creator = e.Name Where c.StartTime >= '" + keyword + "' AND c.Application=N'審核成功' ORDER BY c.CreatedTime", cn);//CONVERT(datetime,N' ',120) 



        da.SelectCommand.Parameters.AddWithValue("@StartTime", keyword);

        DataTable dt = new DataTable();
        da.Fill(dt);

        var query = from t in dt.AsEnumerable()
                    select new Conference()
                    {
                        Topic = t["Topic"].ToString(),
                        StartTime = DateTime.Parse(t["StartTime"].ToString()),
                        CreatedTime = DateTime.Parse(t["CreatedTime"].ToString()),
                        Creator = t["Name"].ToString(),
                    };

        List<Conference2> ff = new List<Conference2>();
        foreach (var item in query.ToList())
        {
            ff.Add(new Conference2()
            {
                Topic = item.Topic,
                StartTime = item.StartTime.ToString(),
                CreatedTime = item.CreatedTime.ToString(),
                Creator = item.Creator
            });
        }
        return ff;
    }


    public class Conference2
    {
        public string Topic { get; set; }
        public string StartTime { get; set; }
        public string CreatedTime { get; set; }
        public string Creator { get; set; }
    }
    public class Conference
    {
        public int Id { get; set; }
        public string Topic { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public DateTime CreatedTime { get; set; }
        public string Host { get; set; }
        public string Recorder { get; set; }
        public string Participant { get; set; }
        public string Creator { get; set; }
        public string Content { get; set; }
        public int Application { get; set; }

    }

}