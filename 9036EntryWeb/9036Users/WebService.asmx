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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public int AddQuery(int id)
    {
        var db = new Entry9036Entities();
        var press = db.Communities.FirstOrDefault(x => x.Id == id);
        press.Press += 1;
        db.SaveChanges();

        return id;
    }

    [WebMethod]
    public int SubQuery(int id)
    {
        var db = new Entry9036Entities();
        var press = db.Communities.FirstOrDefault(x => x.Id == id);
        press.Press -= 1;
        db.SaveChanges();

        return id;
    }

    [WebMethod]
    public int ShowPress(int id)
    {
        Entry9036Entities db = new Entry9036Entities();
        var query = from c in db.Communities
                    where id == c.Id
                    orderby c.Id descending
                    select c.Press;
        return query.First().GetValueOrDefault();
    }

    [WebMethod(EnableSession = true)]
    public int ShowMsg(int id, string Msg)
    {
        string name = Session["UID"].ToString();
        string time = DateTime.Now.ToString("MM/dd HH:mm");
        using (var db = new Entry9036Entities())
        {
            var cell = db.Set<Message>();
            cell.Add(new Message { Name = name, message1 = Msg, Datetime = time, Id = id });
            try
            {
                db.SaveChanges();
            }
            catch (Exception ex)
            {

                throw;
            }
        };

        return id;
    }

    //Joshua
    public class timeline
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Category { get; set; }
    public DateTime Date { get; set; }
}

      
    [WebMethod]
    public List<timeline> GetTimeLine(string announcer)
    {
        SqlConnection cn = new SqlConnection(
        ConfigurationManager.ConnectionStrings["JoshuaDB"].ConnectionString);

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

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["JoshuaDB"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM Bulletin WHERE (Id = @Id)", cn);
        cmd.Parameters.AddWithValue("@Id", Id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        //Response.Redirect("~/Bulletin_MasterPage.aspx");
        return 0;
    }

}