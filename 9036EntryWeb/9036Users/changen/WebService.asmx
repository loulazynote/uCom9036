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
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public string GetColor()
    {
        List<string> list = new List<string>(){
      "#008080",
      "#808080",
      "#E9967A",
      "#FA8072",
      "#273787",
      "#583E1F",
      "#508913",
      "#328E79",
      "#6691C5",
      "#7F7EC4"
      };
        var r = new Random(DateTime.Now.Second);
        var idx = r.Next(0, 10);
        return list[idx].ToString();
    }
    //public string GetColor()
    //{
    //   int id = int.Parse(Request.QueryString["id"].ToString());
    //var db = new Entry9036Entities();
    //var query = from t in db.Fullevents
    //            where t.SaleID == id
    //            select new MyEvent { title = t.title, start = t.start.ToString(), color = t.color.ToString(), end = dbfun };
    ////t.end.ToString()
    //var result = query.ToList();
    //HiddenField1.Value =
    //        new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
    //}
    [WebMethod]
    public List<TeamMenberList> GetTeamList(string keyword)
    {
        int id = Convert.ToInt32(keyword);
        var db = new Entry9036Entities();
        //var employees = db.Customers;

        var cus = from t in db.Sales
                  join o in db.Orderinformations on t.SaleID equals o.SaleID
                  where o.SaleID == id
                  select new TeamMenberList { SaleID=t.SaleID,SaleName= t.SaleName,OrderAmount= o.OrderAmount,OrderDate= o.OrderDate.ToString(),OrderID= o.OrderID };
        return cus.ToList();
    }

}
public class TeamMenberList
{
    public int SaleID { get; set; }
    public string SaleName { get; set; }
    public int OrderAmount { get; set; }
    public string OrderDate { get; set; }
    public int OrderID { get; set; }

}