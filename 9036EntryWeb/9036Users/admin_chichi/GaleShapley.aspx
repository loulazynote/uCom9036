<%--GaleShapley之後，系統通知男性配對的女性Id,然後要男性發送邀請信給女生--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net.Mail" %>



<script runat="server">


    protected void SendEmail(int MId, int WId, string ManEmail)
    {
        MailMessage msg = new MailMessage();

        msg.To.Add(ManEmail);
        msg.From = new MailAddress("ucominst@gmail.com",
            "tony", System.Text.Encoding.UTF8);
        msg.Subject = "9036Chichi 交友系統";
        //指定Subject的編碼  
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        string mid = MId.ToString();
        string wid = WId.ToString();
        msg.Body = $"親愛的{mid}號用戶你好,<br>你所配對的女性為{wid}號，<br>請盡快至系統發送約會邀請信...";
       
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

    protected void btnEmail_Click(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("select g.MId,g.WId,m.email from GaleShapley g,ManAttend m where g.MId=m.MId ", cn);

        cn.Open();

        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.HasRows)
        {
            while (dr.Read())
            {
                SendEmail((int)dr[0], (int)dr[1], dr[2].ToString());

            }
        }

        dr.Close();
        cn.Close();

        Response.Redirect("~/Default.aspx");
    }

    protected void btnHome_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Default.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">


    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
   
   
    <style>
        #btnEmail, #btnHome {
            border-radius: 5px;
            margin-left: 100px;
            margin-top: 10px;
        }

        #myJumbotron {
            background-color: #999;
            color: aliceblue;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <!--jumbotron-->
    <div class="container">
        <div class="jumbotron" id="myJumbotron">
            <h1>管理者操作處</h1>
            <%--<p>Youtube Test</p>--%>
            <asp:Button ID="btnEmail" runat="server" Text="通知男性發出邀約" OnClick="btnEmail_Click" CssClass="btn btn-danger btn-lg" />
            <a id="btnHome" href="/admin_chichi/Default.aspx" class="btn btn-primary btn-lg">首頁</a>
        </div>
    </div>
    <div class="container">
        <div id="test2">
        </div>
    </div>

    <%--<asp:Button ID="btnEmail" runat="server" Text="通知男性發出邀約" OnClick="btnEmail_Click" CssClass="btn btn-danger btn-lg" />--%>
    <%--<asp:Button ID="btnHome" runat="server" Text="首頁" OnClick="btnHome_Click" CssClass="btn btn-danger btn-lg" />--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <script src="Scripts/jquery-3.1.1.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script>
        $(function () {

            // 將男女的Sortable表合併
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/CombineTwoSortable",
                data: JSON.stringify({

                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    //alert("TT");

                    $("#test").html(data.d);
                    //alert("bb");

                }

            });

            //Gale-Shapley
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryMatch",
                data: JSON.stringify({

                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert("TT");                      
                    $("#test2").html(data.d);
                    //alert("bb");                                                                   
                }
            });
        });

    </script>
</asp:Content>
