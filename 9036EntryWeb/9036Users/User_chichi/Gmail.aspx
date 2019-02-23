<%@ Page Language="C#" %>

<%@ Import Namespace="System.Net.Mail" %>
<!DOCTYPE html>

<script runat="server">

    //smtp寄信要到下面網址把[Allow less secure apps]設定為ON
    //https://myaccount.google.com/lesssecureapps?pli=1
    protected void Button1_Click(object sender, EventArgs e)
    {
        MailMessage msg = new MailMessage();

        msg.To.Add("hokagechichi@gmail.com");
        msg.From = new MailAddress("ucominst@gmail.com",
            "tony", System.Text.Encoding.UTF8);
        msg.Subject = "封印卷軸";
        //指定Subject的編碼  
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        msg.Body = "我是三代目,<br>正式任命波風水門為四代目";
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
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />

        </div>
    </form>
</body>
</html>
