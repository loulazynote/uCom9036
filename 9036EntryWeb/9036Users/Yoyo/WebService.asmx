<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Configuration;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService]
public class WebService  : System.Web.Services.WebService {
        [WebMethod]
    public List<ProductInfo1> QueryProducts1()
    {
        SqlDataAdapter da = new SqlDataAdapter(
            "SELECT [Title], [Commentcount] FROM (SELECT TOP 5 * FROM Forum ORDER BY Commentcount DESC) as my ORDER BY Commentcount DESC",
            WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
            
        

        DataTable dt = new DataTable();
        da.Fill(dt);
        var query = from row in dt.AsEnumerable()
                    select new ProductInfo1() {
                        ProductName = row["Title"].ToString(),
                        UnitPrice = (int)row["Commentcount"] };

        return query.ToList();
    }

    [WebMethod]
    public List<ProductInfo> QueryProducts2()
    {
        SqlDataAdapter da = new SqlDataAdapter(
       "select [Id],[Title],[Author] from Forum where Head=@head", WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        da.SelectCommand.Parameters.AddWithValue("head", "true");

        DataTable dt = new DataTable();
        da.Fill(dt);
        var query = from row in dt.AsEnumerable()
                    select new ProductInfo() {
                        ProductName = row["Id"].ToString(),
                        UnitPrice = row["Title"].ToString(),
                        Author = row["Author"].ToString() };
            

        return query.ToList();
    }
        [WebMethod]
    public List<ProductInfo1> QueryProducts3()
    {
        SqlDataAdapter da = new SqlDataAdapter(
       "SELECT COUNT(UserName) as total, UserName FROM comment GROUP BY UserName", WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        
            
        DataTable dt = new DataTable();
        da.Fill(dt);
        var query = from row in dt.AsEnumerable()
                    select new ProductInfo1() {
                        ProductName = row["UserName"].ToString(),
                        UnitPrice = Convert.ToInt32(row["total"]) };
            

        return query.ToList();
    }

[WebMethod]
public List<string> select()
{
    SqlDataAdapter da = new SqlDataAdapter(
    "SELECT  DISTINCT [CategoryName] FROM [Forum] ",
    WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    DataTable dt = new DataTable();
    da.Fill(dt);
    var Users = dt.AsEnumerable().Select(n => n.Field<string>(0)).ToList();
    return Users.ToList();
}
[WebMethod]
public string select1(string keyword)
{
    int id = int.Parse(keyword);
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    cn.Open();
    SqlCommand cmd3 = new SqlCommand("select [Content] from Forum where  [Id] = @Id", cn);
    cmd3.Parameters.AddWithValue("@Id", id);
    cmd3.Connection = cn;
    object value = cmd3.ExecuteScalar();
    string messageID = Convert.ToString(value);
    cmd3.ExecuteNonQuery();
    cmd3.Dispose();
    cn.Close();
    return messageID;
}
[WebMethod]
public string select2(string keyword)
{
    int id = int.Parse(keyword);
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    cn.Open();
    SqlCommand cmd3 = new SqlCommand("select [Title] from Forum where  [Id] = @Id", cn);
    cmd3.Parameters.AddWithValue("@Id", id);
    cmd3.Connection = cn;
    object value = cmd3.ExecuteScalar();
    string messageID = Convert.ToString(value);
    cmd3.ExecuteNonQuery();
    cmd3.Dispose();
    cn.Close();
    return messageID;
}
[WebMethod]
public string select3(string keyword)
{
    int id = int.Parse(keyword);
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    cn.Open();
    SqlCommand cmd3 = new SqlCommand("select [Author] from Forum where  [Id] = @Id", cn);
    cmd3.Parameters.AddWithValue("@Id", id);
    cmd3.Connection = cn;
    object value = cmd3.ExecuteScalar();
    string messageID = Convert.ToString(value);
    cmd3.ExecuteNonQuery();
    cmd3.Dispose();
    cn.Close();
    return messageID;
}
[WebMethod]
public string select4(string keyword)
{
    int id = int.Parse(keyword);
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    cn.Open();
    SqlCommand cmd3 = new SqlCommand("select [CategoryName] from Forum where  [Id] = @Id", cn);
    cmd3.Parameters.AddWithValue("@Id", id);
    cmd3.Connection = cn;
    object value = cmd3.ExecuteScalar();
    string messageID = Convert.ToString(value);
    cmd3.ExecuteNonQuery();
    cmd3.Dispose();
    cn.Close();
    return messageID;
}
[WebMethod]
public void UpSavethediv3(string keyword, string title, string author, string content, string categoryName)
{
    int ID = int.Parse(keyword);
    DateTime datetime = DateTime.Now;
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    SqlCommand cmd = new SqlCommand(
        "UPDATE [Forum] SET [Title] = @Title, [DateTime] = @DateTime, [Author] = @Author, [Content] = @Content, [CategoryName] = @CategoryName WHERE [Id] = @Id", cn);
    cmd.Parameters.AddWithValue("Id", ID);
    cmd.Parameters.AddWithValue("Title", title);
    cmd.Parameters.AddWithValue("DateTime", datetime);
    cmd.Parameters.AddWithValue("Author", author);
    cmd.Parameters.AddWithValue("Content", content);
    cmd.Parameters.AddWithValue("CategoryName", categoryName);
    cn.Open();
    cmd.ExecuteNonQuery();
    cn.Close();
}
[WebMethod]//insert後馬上抓id
public void Savethediv4(string title, string author, string content, string categoryName)
{
    SqlConnection cn = new SqlConnection(
WebConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
    DateTime datetime = DateTime.Now;
    SqlCommand cmd = new SqlCommand(
        "INSERT INTO [Forum] ([Title], [DateTime], [Author], [Content], [CategoryName], [Commentcount]) VALUES (@title, @datetime, @author, @content,  @categoryname, @commentcount);SELECT @@IDENTITY as id;", cn);
    cmd.Parameters.AddWithValue("title", title);
    cmd.Parameters.AddWithValue("datetime", datetime);
    cmd.Parameters.AddWithValue("Author", author);
    cmd.Parameters.AddWithValue("Content", content);
    cmd.Parameters.AddWithValue("CategoryName", categoryName);
    cmd.Parameters.AddWithValue("commentcount", 0);
    cn.Open();
    cmd.Connection = cn;
    object value = cmd.ExecuteScalar();
    string messageID = Convert.ToString(value);
    int idid = int.Parse(messageID);
    cmd.Dispose();
    cn.Close();

    SqlCommand cmd1 = new SqlCommand(
        "UPDATE [Document] SET [CONTENT_TYPE] = @CONTENT_TYPE WHERE [MNT_USER] = @MNT_USER", cn);
    cmd1.Parameters.AddWithValue("MNT_USER", title);
    cmd1.Parameters.AddWithValue("CONTENT_TYPE", messageID);
    cn.Open();
    cmd1.ExecuteNonQuery();
    cn.Close();
}

public class ProductInfo
{
    public string ProductName { get; set; }
    public string UnitPrice { get; set; }
    public string Author { get; set; }
}
public class ProductInfo1
{
    public string ProductName { get; set; }
    public int UnitPrice { get; set; }
}

}