<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
     protected void Button1_Click(object sender, EventArgs e)
    {
        string email = Request.QueryString["email"].ToString();
        string com = comment.InnerText;
        string textsub = TextBox1.Text.ToString();
        MailMessage msg = new MailMessage();

        msg.To.Add(email);
        msg.From = new MailAddress("9036.UUU@gmail.com",
            "9036.Service", System.Text.Encoding.UTF8);
        msg.Subject = textsub;
        //指定Subject的編碼
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        msg.Body = com;
        msg.IsBodyHtml = true;
        msg.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);

        //寄件者的帳號密碼
        MySmtp.Credentials = new System.Net.NetworkCredential(
            "9036.UUU@gmail.com", "20190129");
        //啟用 SSL
        MySmtp.EnableSsl = true;
        MySmtp.Send(msg);
        Response.Redirect("~/ChangEn/TeamMenberMaster.aspx");

    }


    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/TeamMenberMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="container">
        
            <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>發送信件</B></h1><br/>
            <div>
                <div class="form-group">
                    <br />
                    <asp:Label for="TextBox1" Font-Size="Medium" Font-Bold="True" ID="Label1" runat="server" Text="Label">信件標題:</asp:Label>
                    <br/>
                    <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox>
                    <br />
                    <asp:Label for="comment" ID="Label2" runat="server" Text="Label" Font-Size="Medium" Font-Bold="True">信件內容:</asp:Label>
                    
                    <textarea  class="form-control" rows="5" id="comment" runat="server"></textarea><br />
                    <asp:Button CssClass="btn  btn-success" ID="Button1" runat="server" Text="送出" OnClick="Button1_Click" />
                    <asp:Button CssClass="btn  btn-danger" ID="Button2" runat="server" Text="返回" OnClick="Button2_Click"/>
                </div>
            </div>

        
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

