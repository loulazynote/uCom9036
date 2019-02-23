<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string UserId = null;
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            UserId = human.Id.ToString();
        }

        BindListView(UserId);
    }

    private void BindListView(string id)
    {
        SqlDataAdapter da = new SqlDataAdapter(
            "select Id,name,pwd,CONVERT(nvarchar(12),birth,111) birthWithoutTime,height,hobby,email from SignUp where Id=@Id",
            ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("@Id", id);

        DataTable dt = new DataTable();
        da.Fill(dt);

        DetailsView1.DataSource = dt;
        DetailsView1.DataBind();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />
    <title></title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            font-family: "微軟正黑體";
            font-size: 24px;
            line-height: 36px;
            background-image: url("images/backgroundImage/1.jpg")
        }

        #btnSendEmail, #btnDatingPlace {
            /*border-radius: 5px;*/
            margin-left: 50px;
            margin-top: 10px;
            /*background-color: #222;
            color: white;*/
        }

        .aa {
            background-color: #F7F6F3;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="col-md-1"></div>
        <div class="col-md-10">
            <h1>用戶資料</h1>
            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" DataKeyNames="Id" ForeColor="Black" Height="50px" Width="80%">
                <EditRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <Fields>
                    <asp:TemplateField HeaderText="相片">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("Id", "~/UploadImageDB.aspx?id={0}") %>'>
                                <asp:Image ID="Image1" ImageUrl='<%# Eval("Id", "~/EmployeePhoto.aspx?id={0}") %>' AlternateText="點我上傳相片" Width="60%" BorderWidth="0" runat="server" />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" HeaderText="序號" InsertVisible="False" ReadOnly="True" SortExpression="Id" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="name" HeaderText="姓名" SortExpression="name" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="pwd" HeaderText="密碼" SortExpression="pwd" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="birthWithoutTime" HeaderText="生日" SortExpression="birth" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="height" HeaderText="身高(cm)" SortExpression="height" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="hobby" HeaderText="興趣" SortExpression="hobby" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                    <asp:BoundField DataField="email" HeaderText="email" SortExpression="email" HeaderStyle-CssClass="col-md-2" ItemStyle-CssClass="col-md-10 aa"/>
                </Fields>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                <RowStyle BackColor="White" />
            </asp:DetailsView>
            <a id="fancyBox1" href="FormFrom_FancyBox.aspx" class="btn btn-danger btn-lg">修改資料</a> 
        </div>
        <div class="col-md-1"></div>
         
    </form>
    <script src="Scripts/jquery-3.1.1.js"></script>
    <script src="Scripts/bootstrap.js"></script>
     <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
    <script src="fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script src="fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script>
        $(function () {
            $("a#fancyBox1").fancybox();

        });
    </script>
</body>
</html>
