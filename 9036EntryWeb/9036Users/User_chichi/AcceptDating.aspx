<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net.Mail" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string Id = null;
            if (Session["human"] != null)
            {
                Human human = (Human)Session["human"];
                Id = human.Id.ToString();
            }

            BindListView(Id);
        }
    }

    private void BindListView(string Id)
    {
        SqlDataAdapter da = new SqlDataAdapter(
                "select * from (select temp.MId,temp.WId,m.email MEmail,temp.email WEmail,temp.PlaceId,temp.place,temp.description from (select g.MId,g.WId,g.PlaceId,g.place,g.description,w.email from GaleShapley g,WomanAttend w where g.WId=w.WId) as temp,ManAttend m where temp.MId=m.MId) temp2 where WId=@WId",
                ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("@WId", Id);
        DataTable dt = new DataTable();
        da.Fill(dt);

        DetailsView1.DataSource = dt;
        DetailsView1.DataBind();
    }

    protected void btnAcceot_Click(object sender, EventArgs e)
    {
        string Id = null;
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            Id = human.Id.ToString();
        }

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("UPDATE GaleShapley SET status=N'女方答應赴約' where  WId=@WId ", cn);
        SqlCommand cmd2 = new SqlCommand("select * from (select temp.MId,temp.WId,m.email MEmail,temp.email WEmail from (select g.MId,g.WId,g.PlaceId,g.place,g.description,w.email from GaleShapley g,WomanAttend w where g.WId=w.WId) as temp,ManAttend m where temp.MId=m.MId) temp2 where WId=@WId;", cn);
        cmd.Parameters.AddWithValue("@WId", Id);
        cmd2.Parameters.AddWithValue("@WId", Id);
        cn.Open();

        cmd.ExecuteNonQuery();

        //將女生電郵寄給男士，使雙方自行聯繫
        SqlDataReader dr = cmd2.ExecuteReader();
        if (dr.HasRows)
        {
            while (dr.Read())
            {
                SendEmail(dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString());
            }
        }

        dr.Close();
        cn.Close();

        Response.Write("女方答應赴約");
    }

    protected void btnRefuse_Click(object sender, EventArgs e)
    {
        string Id = null;
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            Id = human.Id.ToString();
        }

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("UPDATE GaleShapley SET status=N'女方拒絕赴約' where  WId=@WId ", cn);
        cmd.Parameters.AddWithValue("@WId", Id);

        cn.Open();

        cmd.ExecuteNonQuery();

        cn.Close();

        Response.Write("女方拒絕赴約");
    }

    protected void SendEmail(string MId, string WId, string MEmail,string WEmail)
    {
        MailMessage msg = new MailMessage();

        msg.To.Add(MEmail);
        msg.From = new MailAddress("ucominst@gmail.com",
            "tony", System.Text.Encoding.UTF8);
        msg.Subject = "9036Chichi 交友系統";
        //指定Subject的編碼  
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        //string mid = MId.ToString();
        //string wid = WId.ToString();<img src="" alt="" />
        msg.Body = $"親愛的{MId}號用戶你好,你所邀請的{WId}號女士答應赴約，<br>這是她的Email:{WEmail},請自行與她連絡。<br> 感謝您參與本系統地的配對，並祝您倆約會愉快 ^_^";       
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
<head id="Head1" runat="server">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />
    <title></title>
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {           
            font-family: "微軟正黑體";
            font-size: 24px;
            line-height: 36px;
            background-image: url("images/backgroundImage/wallpapers.jpg")
        }

        #btnAccept, #btnRefuse {
            border-radius: 5px;
            margin-left: 50px;
            margin-top: 10px;
            /*background-color: #222;
            color: white;*/
        }

        .aa{
            background-color:#CCEEFF;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="col-md-2"></div>
        <div class="col-md-8">
            <h1>是否接受邀約</h1>
            <asp:DetailsView ID="DetailsView1" CssClass="table" runat="server" AutoGenerateRows="False" CellPadding="4" ForeColor="#333333" GridLines="None" RowStyle-VerticalAlign="NotSet" HeaderStyle-VerticalAlign="Middle">
                <AlternatingRowStyle BackColor="White" />
                <CommandRowStyle BackColor="#D1DDF1" Font-Bold="True" />
                <EditRowStyle BackColor="#2461BF" />
                <FieldHeaderStyle BackColor="#FFCCCC" Font-Bold="True" />
                <Fields>
                    <asp:BoundField  DataField="place" HeaderText="約會地點" SortExpression="place"  HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"   />
                    <%--<asp:BoundField DataField="PlaceId" HeaderText="PlaceId" SortExpression="PlaceId" />
                    <asp:BoundField DataField="WId" HeaderText="WId" SortExpression="WId" />
                    <asp:BoundField DataField="MId" HeaderText="MId" SortExpression="MId" />--%>
                    <asp:BoundField DataField="description" HeaderText="描述" SortExpression="description"  HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa" />
                    <asp:TemplateField HeaderText="示意圖片"  ItemStyle-CssClass="aa" ItemStyle-BorderStyle="NotSet">                       
                        <ItemTemplate>
                            <asp:Image ID="Image1" ImageUrl='<%# Eval("PlaceId", "~/User_chichi/DatingPlacePhoto.aspx?id={0}") %>'  BorderWidth="0" runat="server" CssClass="img-rounded" Width="50%" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle BackColor="#EFF3FB"/>
            </asp:DetailsView>
                          <asp:Button ID="btnAccept" runat="server" Text="赴約" OnClick="btnAcceot_Click" CssClass="btn btn-danger btn-lg"/>
        <asp:Button ID="btnRefuse" runat="server" Text="拒絕" OnClick="btnRefuse_Click" CssClass="btn btn-danger btn-lg" />
  </div>
        <div class="col-md-2"></div>
        


        </form>
    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
    <script>

</script>
</body>
</html>
