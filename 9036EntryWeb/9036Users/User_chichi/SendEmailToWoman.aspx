<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net.Mail" %>


<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string MId = null;

        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            MId = human.Id.ToString();
        }

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("select * from (select g.MId,g.WId,g.PlaceId,g.place,g.description,w.email from GaleShapley g,WomanAttend w where g.WId=w.WId)as temp where MId=@MId; ", cn);

        cn.Open();
        cmd.Parameters.AddWithValue("@MId",MId);

        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.HasRows)
        {
            while (dr.Read())
            {
                SendEmail(dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString(), dr[4].ToString(), dr[5].ToString());
            }
        }

        dr.Close();
        cn.Close();

        Response.Redirect("~/User_chichi/Default_mine.aspx");
    }

    protected void SendEmail(string MId, string WId, string PlaceId,string place,string description,string WomanEmail)
    {
        MailMessage msg = new MailMessage();

        msg.To.Add(WomanEmail);
        msg.From = new MailAddress("ucominst@gmail.com",
            "tony", System.Text.Encoding.UTF8);
        msg.Subject = "9036Chichi 交友系統";
        //指定Subject的編碼  
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        //string mid = MId.ToString();
        //string wid = WId.ToString();<img src="" alt="" />
        msg.Body = $"親愛的{WId}號用戶你好,<br>你所配對的男性為{MId}號，<br>他誠摯地邀請妳到{place}約會<br><br>{description}<br>請盡快至系統確認是否赴約...";
        // msg.Body = "我是三代目,<br>正式任命波風水門為四代目";
        msg.IsBodyHtml = true;
        msg.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);

        //寄件者的帳號密碼
        MySmtp.Credentials = new System.Net.NetworkCredential(
            "ucominst@gmail.com", "ucom5201314");
        //啟用 SSL
        MySmtp.EnableSsl = true;
        MySmtp.Send(msg);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
