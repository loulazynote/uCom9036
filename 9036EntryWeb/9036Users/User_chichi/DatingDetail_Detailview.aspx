<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];

        }

        string PlaceId = null;
        if (Request.QueryString["id"] != null)
        {
            PlaceId = Request.QueryString["id"];

        }

        BindListView(PlaceId);
    }

    private void BindListView(string PlaceId)
    {
        SqlDataAdapter da = new SqlDataAdapter(
                "select PlaceId,place,description from DatingPlace where PlaceId=@PlaceId",
                ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("@PlaceId", PlaceId);
        DataTable dt = new DataTable();
        da.Fill(dt);

        DetailsView1.DataSource = dt;
        DetailsView1.DataBind();
    }



    protected void btnDatingPlace_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/User_chichi/DatingPlace.aspx");
    }

    protected void btnSendEmail_Click(object sender, EventArgs e)
    {

        //Response.Write(DetailsView1.Rows[0].Cells[0].Text);
        //Response.Write(DetailsView1.Rows[0].Cells[1].Text); //Id
        //Response.Write(DetailsView1.Rows[1].Cells[1].Text); //place
        //Response.Write(DetailsView1.Rows[2].Cells[1].Text); //description


        string UserId = null;
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            UserId = human.Id.ToString();
        }

        string PlaceId = DetailsView1.Rows[0].Cells[1].Text;
        string place = DetailsView1.Rows[1].Cells[1].Text;
        string description = DetailsView1.Rows[2].Cells[1].Text;

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("UPDATE GaleShapley SET PlaceId=@PlaceId,place=@place,description=@description,status=N'男方已寄出邀請' where  MId=@MId ", cn);
       
        cmd.Parameters.AddWithValue("@PlaceId", PlaceId);
        cmd.Parameters.AddWithValue("@place", place);
        cmd.Parameters.AddWithValue("@description", description);
        cmd.Parameters.AddWithValue("@MId", UserId);

        cn.Open();
        cmd.ExecuteNonQuery();

        cn.Close();

        Response.Redirect("~/User_chichi/SendEmailToWoman.aspx");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />
    <title></title>
     <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
     <style>
        body {           
            font-family: "微軟正黑體";
            font-size: 24px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/1.jpg")
        }

        #btnSendEmail, #btnDatingPlace {
            /*border-radius: 5px;*/
            margin-left: 50px;
            margin-top: 10px;
            /*background-color: #222;
            color: white;*/
        }

        .aa{
            background-color:#F7F6F3;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="col-md-1"></div>
        <div class="col-md-10">
             <h1>你所選擇的約會地點</h1>
            <asp:DetailsView ID="DetailsView1" CssClass="table" runat="server" AutoGenerateRows="False" DataKeyNames="PlaceId"  CellPadding="4" ForeColor="#333333" GridLines="None" Width="80%">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <CommandRowStyle BackColor="#E2DED6" Font-Bold="True" />
                <EditRowStyle BackColor="#999999" />
                <FieldHeaderStyle BackColor="#E9ECF1" Font-Bold="True" />
                <Fields>
                    <asp:BoundField DataField="PlaceId" HeaderText="地點序號" InsertVisible="False" ReadOnly="True" SortExpression="PlaceId" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa" />
                    <asp:BoundField DataField="place" HeaderText="地點" SortExpression="place" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa" />
                    <asp:BoundField DataField="description" HeaderText="描述" SortExpression="description" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:TemplateField HeaderText="示意圖片">
                        <ItemTemplate>
                            <asp:Image ID="Image1" ImageUrl='<%# Eval("PlaceId", "~/User_chichi/DatingPlacePhoto.aspx?id={0}") %>' BorderWidth="0" runat="server" CssClass="img-rounded" Width="50%" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            </asp:DetailsView>
             <asp:Button ID="btnSendEmail" runat="server" Text="寄送邀請" CssClass="btn btn-success btn-lg" OnClick="btnSendEmail_Click" />
         <asp:Button ID="btnDatingPlace" runat="server" Text="返回約會地點選項" OnClick="btnDatingPlace_Click" CssClass="btn btn-danger btn-lg"/>
        </div>
        <div class="col-md-1"></div>
    </form>
   <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
</body>
</html>
