<%@ WebService Language="C#" Class="WebService" %>

using System.Data.Entity;
using System.Collections.Generic;
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
public class product
{
    public string ProductName { get; set; }
    public string UnitPrice { get; set; }
}

public class timeline
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Category { get; set; }
    public DateTime Date { get; set; }
    public int View { get; set; }
    public int Total { get; set; }
}


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    //[WebMethod]
    //public int AddQuery(int id)
    //{
    //    var db = new RolesEntities1();
    //    var press = db.Communities.FirstOrDefault(x => x.Id == id);
    //    press.Press += 1;
    //    db.SaveChanges();

    //    return id;
    //}

    //[WebMethod]
    //public int SubQuery(int id)
    //{
    //    var db = new RolesEntities1();
    //    var press = db.Communities.FirstOrDefault(x => x.Id == id);
    //    press.Press -= 1;
    //    db.SaveChanges();

    //    return id;
    //}
    [WebMethod]
    public List<timeline> GetTimeLine(string announcer)
    {
        SqlConnection cn = new SqlConnection(
        ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

        string queryString = String.Format("SELECT * FROM [Bulletin]  where Announcer like N'%{0}%' ORDER BY Date", announcer);
        //AND title like N'%" + title + "%'"
        SqlDataAdapter da = new SqlDataAdapter(queryString,
       cn);

        DataTable dt = new DataTable();
        da.Fill(dt);

        List<timeline> timeList = new List<timeline>();

        int i = 0;
        while (dt.Rows.Count > 0 && i < dt.Rows.Count)
        {
            timeList.Add(new timeline
            {
                Id = int.Parse(dt.Rows[i]["Id"].ToString()),
                Title = dt.Rows[i]["Title"].ToString(),
                Category = dt.Rows[i]["Category"].ToString(),
                Date = DateTime.Parse(dt.Rows[i]["Date"].ToString())
            });
            i++;
        }

        return timeList;
    }



    [WebMethod]
    public int DeleteArticle(int Id)
    {

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM Bulletin WHERE (Id = @Id)", cn);
        cmd.Parameters.AddWithValue("@Id", Id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        //Response.Redirect("~/Bulletin_MasterPage.aspx");
        return 0;
    }

        [WebMethod]
    public List<timeline> QueryProducts1()
    {
        SqlConnection cn = new SqlConnection(
        ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

        string queryString = String.Format("SELECT [Title], [View] FROM (SELECT TOP 5 * FROM Bulletin ORDER BY [View] DESC) as my ORDER BY [View] DESC");
        //AND title like N'%" + title + "%'"
        //SELECT [Title], [View] FROM (SELECT TOP 5 * FROM Bulletin ORDER BY [View] DESC) as my ORDER BY [View] DESC
        SqlDataAdapter da = new SqlDataAdapter(queryString,
       cn);

        DataTable dt = new DataTable();
        da.Fill(dt);

        List<timeline> timeList = new List<timeline>();

        int i = 0;
        while (dt.Rows.Count > 0 && i < dt.Rows.Count)
        {
            timeList.Add(new timeline
            {
                //Id = int.Parse(dt.Rows[i]["Id"].ToString()),
                Title = dt.Rows[i]["Title"].ToString(),
                //Category = dt.Rows[i]["Category"].ToString(),
                //Date = DateTime.Parse(dt.Rows[i]["Date"].ToString())
                View = int.Parse(dt.Rows[i]["View"].ToString())
            });
            i++;
        }

        return timeList;

    }

    [WebMethod]
    public List<timeline> QueryProducts3()
    {

        SqlConnection cn = new SqlConnection(
    ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

        string queryString = String.Format("SELECT COUNT(Category) as total, Category FROM Bulletin GROUP BY Category ORDER BY total DESC");
        //AND title like N'%" + title + "%'"
        //SELECT [Title], [View] FROM (SELECT TOP 5 * FROM Bulletin ORDER BY [View] DESC) as my ORDER BY [View] DESC
        SqlDataAdapter da = new SqlDataAdapter(queryString,
       cn);

        DataTable dt = new DataTable();
        da.Fill(dt);

        List<timeline> timeList = new List<timeline>();

        int i = 0;
        while (dt.Rows.Count > 0 && i < dt.Rows.Count)
        {
            timeList.Add(new timeline
            {
                //Id = int.Parse(dt.Rows[i]["Id"].ToString()),
                Category = dt.Rows[i]["Category"].ToString(),
                //Category = dt.Rows[i]["Category"].ToString(),
                //Date = DateTime.Parse(dt.Rows[i]["Date"].ToString())
                Total = int.Parse(dt.Rows[i]["Total"].ToString())
            });
            i++;
        }

        return timeList;
    }


}