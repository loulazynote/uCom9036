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
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using NPOI;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.SS.UserModel;
using System.IO;
using System.Diagnostics;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{
    [WebMethod]
    public string download(string EmployeeID, int Id, string fileName, string qs)
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {

            DataTable dt = new DataTable();
            SqlDataAdapter cm = new SqlDataAdapter(qs, con);
            cm.SelectCommand.Parameters.AddWithValue("@groupId", Id);
            cm.SelectCommand.Parameters.AddWithValue("@EmployeeID", EmployeeID.ToString());

            cm.Fill(dt);
            ////建立Excel 2007檔案
            IWorkbook wb = new XSSFWorkbook();
            ISheet ws;
            if (dt.TableName != string.Empty)
            {
                ws = wb.CreateSheet(dt.TableName);
            }
            else
            {
                ws = wb.CreateSheet("Sheet1");
            }

            ws.CreateRow(0);//第一行為欄位名稱
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ws.GetRow(0).CreateCell(i).SetCellValue(dt.Columns[i].ColumnName);
            }

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                ws.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    ws.GetRow(i + 1).CreateCell(j).SetCellValue(dt.Rows[i][j].ToString());
                }
            }

            string f = Server.MapPath(@"Output\" + fileName + ".xlsx");
            FileStream file = new FileStream(f, FileMode.Create);//產生檔案
            wb.Write(file);
            string g = "~/9036GroupBuy/Output/" + fileName + ".xlsx";
            file.Close();
            return g;
        };
    }



    [WebMethod]
    public string email(string title, List<string> MailList, string Subject, string Body)
    {
        MailMessage msg = new MailMessage();
        //收件者，以逗號分隔不同收件者 ex "test@gmail.com,test2@gmail.com"
        msg.Bcc.Add(string.Join(",", MailList.ToArray()));
        msg.From = new MailAddress("scualtley@gmail.com", title, System.Text.Encoding.UTF8);
        //郵件標題 
        msg.Subject = Subject;
        //郵件標題編碼  
        msg.SubjectEncoding = System.Text.Encoding.UTF8;
        //郵件內容
        msg.Body = Body;
        msg.IsBodyHtml = true;
        msg.BodyEncoding = System.Text.Encoding.UTF8;//郵件內容編碼 
        msg.Priority = MailPriority.Normal;//郵件優先級 
                                           //建立 SmtpClient 物件 並設定 Gmail的smtp主機及Port 
        #region 其它 Host
        /*
         *  outlook.com smtp.live.com port:25
         *  yahoo smtp.mail.yahoo.com.tw port:465
        */
        #endregion
        SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);
        //設定你的帳號密碼
        MySmtp.Credentials = new System.Net.NetworkCredential("scualtley", "ubfksvqzehiabiba");
        //Gmial 的 smtp 使用 SSL
        MySmtp.EnableSsl = true;
        MySmtp.Send(msg);
        //放掉宣告出來的MySmtp
        MySmtp = null;
        //放掉宣告出來的mail
        msg.Dispose();
        string a = "true";
        return a;
    }


    [WebMethod]
    public int[] btnVisable(string Name)
    {
        string a = "SELECT Id FROM groupList INNER JOIN Employees ON groupList.EmployeeID = Employees.EmployeeID INNER JOIN dbo.[Order] ON groupList.groupId = [Order].groupId  WHERE EmpName = @Name AND DeadLine < GETDATE() ";
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            List<int> MYgroupidlist = new List<int>();
            SqlDataAdapter MY = new SqlDataAdapter(a, con);
            MY.SelectCommand.Parameters.AddWithValue("@Name", Name);
            con.Open();
            SqlDataReader drMY = MY.SelectCommand.ExecuteReader();
            if (drMY.HasRows)
            {
                while (drMY.Read())
                {
                    MYgroupidlist.Add(int.Parse(drMY["Id"].ToString()));
                };
            };
            drMY.Close();
            drMY.Dispose();
            int[] MYgroupidArray = MYgroupidlist.ToArray();
            return MYgroupidArray;
        }
    }

    [WebMethod]
    public string Update()
    {
        DataTable dt1 = new DataTable();
        string a = "select g.groupId,g.ProductName,g.Limit,o.A from [dbo].[groupList] g join (select groupid,sum(Amount) A from [dbo].[Order] group by groupId) AS o on g.groupId = o.groupId where o.A > g.Limit";
        DataTable dt2 = new DataTable();
        string b = "select g.groupId,g.ProductName,g.Limit,o.A from [dbo].[groupList] g join (select groupid,sum(Amount) A from [dbo].[Order] group by groupId) AS o on g.groupId = o.groupId where o.A < g.Limit";
        string c = "Update groupList SET State=N'開團中' WHERE  DeadLine > GETDATE()";
        string d = "Update groupList SET State=N'未成團' WHERE  DeadLine < GETDATE()";
        List<int> MYgroupidlist = new List<int>();
        List<int> MNgroupidlist = new List<int>();

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            SqlDataAdapter ca = new SqlDataAdapter(c, con);
            SqlDataAdapter cm = new SqlDataAdapter(d, con);
            con.Open();
            cm.SelectCommand.ExecuteNonQuery();
            ca.SelectCommand.ExecuteNonQuery();

            //MY
            SqlDataAdapter MY = new SqlDataAdapter(a, con);
            MY.Fill(dt1);
            SqlDataReader drMY = MY.SelectCommand.ExecuteReader();
            if (drMY.HasRows)
            {
                while (drMY.Read())
                {
                    MYgroupidlist.Add(int.Parse(drMY["groupId"].ToString()));
                };
            };
            drMY.Close();
            drMY.Dispose();
            int[] MYgroupidArray = MYgroupidlist.ToArray();
            //MN
            SqlDataAdapter MN = new SqlDataAdapter(b, con);
            MN.Fill(dt2);
            SqlDataReader drMN = MN.SelectCommand.ExecuteReader();
            if (drMN.HasRows)
            {
                while (drMN.Read())
                {
                    MNgroupidlist.Add(int.Parse(drMN["groupId"].ToString()));
                };
            };
            drMN.Close();
            drMN.Dispose();
            int[] MNgroupidArray = MNgroupidlist.ToArray();
            //MN
            string MNDNcmd = @"update [groupList] set [State] = N'開團中' where deadline > getdate() AND groupid in( ";
            string MNDYcmd = @"update [groupList] set [State] = N'未成團' where deadline < getdate() AND groupid in( ";
            if (MNgroupidArray.Length > 0)
            {
                for (int i = 0; i < MNgroupidArray.Length; i++)
                {
                    MNDNcmd += String.Format("{0},", MNgroupidArray[i]);
                    MNDYcmd += String.Format("{0},", MNgroupidArray[i]);
                }

                MNDNcmd = MNDNcmd.Substring(0, MNDNcmd.Length - 1);
                MNDYcmd = MNDYcmd.Substring(0, MNDYcmd.Length - 1);
                MNDNcmd += ")";
                MNDYcmd += ")";
                SqlDataAdapter MNDN = new SqlDataAdapter(MNDNcmd, con);
                SqlDataAdapter MNDY = new SqlDataAdapter(MNDYcmd, con);
                MNDY.SelectCommand.ExecuteNonQuery();
                MNDN.SelectCommand.ExecuteNonQuery();
            }


            //MY
            string MYDNcmd = @"update [groupList] set [State] = N'已成團' where deadline > getdate() AND groupid in( ";
            string MYDYcmd = @"update [groupList] set [State] = N'已結標' where deadline < getdate() AND groupid in( ";
            if (MYgroupidArray.Length > 0)
            {
                for (int i = 0; i < MYgroupidArray.Length; i++)
                {
                    MYDNcmd += String.Format("{0},", MYgroupidArray[i]);
                    MYDYcmd += String.Format("{0},", MYgroupidArray[i]);

                }
                MYDNcmd = MYDNcmd.Substring(0, MYDNcmd.Length - 1);
                MYDNcmd += ")";
                MYDYcmd = MYDYcmd.Substring(0, MYDYcmd.Length - 1);
                MYDYcmd += ")";

                SqlDataAdapter MYDN = new SqlDataAdapter(MYDNcmd, con);
                SqlDataAdapter MYDY = new SqlDataAdapter(MYDYcmd, con);

                MYDN.SelectCommand.ExecuteNonQuery();
                MYDY.SelectCommand.ExecuteNonQuery();

            }

            con.Close();
        }
        return null;
    }



    [WebMethod]

    public List<string> GetNames(string prefixText, string dds)
    {
        string qs = "";
        List<string> listString = new List<string>();
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            if (dds == "groupList.ProductName")
            {
                qs = "SELECT [ProductName] FROM [groupList]  INNER JOIN Employees ON Employees.EmployeeID = groupList.EmployeeID WHERE " + dds + " like N'%' + @SEARCH + '%' GROUP BY " + dds;

            }
            else if (dds == "Employees.Name")
            {
                qs = "SELECT [Name] FROM [groupList]  INNER JOIN Employees ON Employees.EmployeeID = groupList.EmployeeID WHERE " + dds + " like N'%' + @SEARCH + '%' GROUP BY " + dds;

            }
            SqlCommand cm = new SqlCommand(qs, con);
            cm.Parameters.AddWithValue("@SEARCH", prefixText);
            con.Open();
            SqlDataReader dr = cm.ExecuteReader();
            if (dr.HasRows)
            {
                if (dds == "groupList.ProductName")
                {
                    while (dr.Read())
                    {
                        listString.Add(dr["ProductName"].ToString());
                    }
                }
                else if (dds == "Employees.Name")
                {
                    while (dr.Read())
                    {
                        listString.Add(dr["Name"].ToString());
                    }
                }

            };
            dr.Close();
            dr.Dispose();
        };

        return listString;
    }

 [WebMethod]

    public List<string> GetNames2(string prefixText)
    {
        List<string> listString = new List<string>();
        using (SqlConnection con = new SqlConnection(@"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\GroupBuy2.mdf;Integrated Security=True"))
        {
            SqlCommand cm = new SqlCommand("SELECT [ProductName] FROM [groupList]  where ProductName like N'%' + @SEARCH + '%' ", con);
            cm.Parameters.AddWithValue("@SEARCH", prefixText);
            con.Open();
            SqlDataReader dr = cm.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    listString.Add(dr["ProductName"].ToString());
                };
            };
            dr.Close();
            dr.Dispose();
        };

        return listString;
    }



    [WebMethod]

    public string deletea(string id)
    {
        int a = int.Parse(id);
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM [groupList] WHERE groupId = @groupId", cn);
        cmd.Parameters.AddWithValue("@groupId", a);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        return null;

    }


}