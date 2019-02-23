<%@ WebService Language="C#" CodeBehind="~/App_Code/WebService.cs" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
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


        [WebMethod]  //搜尋員工
    public List<Employess> SelectProducts(string keyword)
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] WHERE EmpId like N'%' + @SEARCH + '%' ",
          ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);


        //decimal dec_price = Convert.ToDecimal(keyword);
        //da.SelectCommand.Parameters.AddWithValue("@UnitPrice", dec_price);

        da.SelectCommand.Parameters.AddWithValue("@SEARCH", keyword );

        DataTable dt = new DataTable();
        da.Fill(dt);


        var query = from row in dt.AsEnumerable()
                    select new Employess()
                    {

                        Id=(int)row["Id"],
                        EmpId = row["EmpId"].ToString(),
                        Starttime =row["Starttime"].ToString(),
                        Overtime = row["Overtime"].ToString(),  //(DateTime)row["Overtime"]下方轉型成字串了  就改用tostring
                        Event = row["Event"].ToString(),
                        Hour = (int)row["Hour"],
                        Result = row["Result"].ToString(),
                        Content = row["Content"].ToString(),
                        Replay = row["Replay"].ToString(),
                        Nowdate = row["Nowdate"].ToString(),
                        Department = row["Department"].ToString()
                    };

        return query.ToList();

    }








    [WebMethod]//所有員工資料
    public List<Employess> AllEmployess()
    {
        //SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Department] FROM [AllEmployess] where Id=@Id",
        //SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] WHERE Result LIKE N'%未審核%'",
        SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] ",
        ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        DataTable dt = new DataTable();
        da.Fill(dt);


        var query = from row in dt.AsEnumerable()
                    select new Employess()
                    {

                        Id=(int)row["Id"],
                        EmpId = row["EmpId"].ToString(),
                        Starttime =row["Starttime"].ToString(),
                        Overtime = row["Overtime"].ToString(),  //(DateTime)row["Overtime"]下方轉型成字串了  就改用tostring
                        Event = row["Event"].ToString(),
                        Hour = (int)row["Hour"],
                        Result = row["Result"].ToString(),
                        Content = row["Content"].ToString(),
                        Replay = row["Replay"].ToString(),
                        Nowdate = row["Nowdate"].ToString(),
                        Department = row["Department"].ToString()
                    };

        return query.ToList();
    }

    [WebMethod]  //條件審核 (未審核 通過 不通過)
    public List<Employess> QueryEmployess(string aa)
    {
        //SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Department] FROM [AllEmployess] where Id=@Id",
        //SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] WHERE Result LIKE N'%未審核%'",
        SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] WHERE Result = N'" + aa + "'",
        ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        DataTable dt = new DataTable();
        da.Fill(dt);


        var query = from row in dt.AsEnumerable()
                    select new Employess()
                    {

                        Id=(int)row["Id"],
                        EmpId = row["EmpId"].ToString(),
                        Starttime =row["Starttime"].ToString(),
                        Overtime = row["Overtime"].ToString(),  //(DateTime)row["Overtime"]下方轉型成字串了  就改用tostring
                        Event = row["Event"].ToString(),
                        Hour = (int)row["Hour"],
                        Result = row["Result"].ToString(),
                        Content = row["Content"].ToString(),
                        Replay = row["Replay"].ToString(),
                        Nowdate = row["Nowdate"].ToString(),
                        Department = row["Department"].ToString()
                    };

        return query.ToList();
    }


    [WebMethod]
    public void UpdateEmployess(string aa)   //把勾選到的 未審核 改成通過 因為有可能是複選所以要用foreach
    {
        string[] myary = aa.Split(',');
        foreach (var item in myary)
        {

            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand("UPDATE AllEmployess SET Result = N'通過' WHERE Id=@ID", cn);

            //int myId = Convert.ToInt32(bb);
            cmd.Parameters.AddWithValue("@ID",item);
            //cmd.Parameters.AddWithValue("Startime", newE.Starttime);
            //cmd.Parameters.AddWithValue("Overtime", newE.Overtime);
            //cmd.Parameters.AddWithValue("Event", newE.Event);
            //cmd.Parameters.AddWithValue("Hour", newE.Hour);
            //cmd.Parameters.AddWithValue("Content", newE.Content);

            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();
        }


    }
    [WebMethod]
    public void DeleteEmployess(string aa)   //不通過  因為有可能是複選所以要用foreach
    {
        string[] myary = aa.Split(',');
        foreach (var item in myary)
        {

            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand("UPDATE AllEmployess SET Result = N'不通過' WHERE Id=@ID", cn);

            //int myId = Convert.ToInt32(bb);
            cmd.Parameters.AddWithValue("@ID",item);
            //cmd.Parameters.AddWithValue("Startime", newE.Starttime);
            //cmd.Parameters.AddWithValue("Overtime", newE.Overtime);
            //cmd.Parameters.AddWithValue("Event", newE.Event);
            //cmd.Parameters.AddWithValue("Hour", newE.Hour);
            //cmd.Parameters.AddWithValue("Content", newE.Content);

            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();
        }


    }
    [WebMethod]
    public void EditEmployess(string cc) //編輯修改內容  沒有複選
    {
        string[] myary = cc.Split(',');
        //foreach (var item in myary)
        //{

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand("UPDATE AllEmployess SET Replay=@Replay WHERE Id=@ID" , cn);

        //int myId = Convert.ToInt32(bb);
        cmd.Parameters.AddWithValue("@ID", myary[0]);
        cmd.Parameters.AddWithValue("@Replay",myary[1]);
        //cmd.Parameters.AddWithValue("Startime", newE.Starttime);
        //cmd.Parameters.AddWithValue("Overtime", newE.Overtime);
        //cmd.Parameters.AddWithValue("Event", newE.Event);
        //cmd.Parameters.AddWithValue("Hour", newE.Hour);
        //cmd.Parameters.AddWithValue("Content", newE.Content);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        //}


    }

}

    public class Employess
{   public int Id { get; set; }
    public string EmpId { get; set; }
    public string Starttime { get; set; }  //這邊直接轉型成 字串
    public string Overtime { get; set; }//這邊直接轉型成 字串
    public string Event { get; set; }
    public int Hour { get; set; }
    public string Result { get; set; }
    public string Content { get; set; }
    public string Replay { get; set; }
    public string Nowdate { get; set; }
    public string Department { get; set; }
}