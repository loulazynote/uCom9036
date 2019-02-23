<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>


<!DOCTYPE html>

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {

            if (UploadEmployeePhoto(FileUpload1.FileBytes, Request.QueryString["id"]) > 0)
            {
                Label1.Text = "上傳成功!!";
                Image1.Visible = true;
                Image1.ImageUrl = "~/User_chichi/EmployeePhoto.aspx?id=" + Request.QueryString["id"];
            }
            else
            {
                Label1.Text = "上傳失敗!!";
            }
        }
        else
        {
            Label1.Text = "請選擇要上傳的檔案!!";
        }
    }

    int UploadEmployeePhoto(byte[] data, string UID)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Update SignUp Set Photo = @Photo Where Id = @Id", cn);
        cmd.Parameters.AddWithValue("@Photo", data);
        cmd.Parameters.AddWithValue("@Id", UID);

        cn.Open();
        int affected = cmd.ExecuteNonQuery(); //affected:引響了幾列資料
        cn.Close();

        return affected;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="width=device-width" name="viewport" />
    <title></title>
     <style>
        body {           
            font-family: "微軟正黑體";
            font-size: 24px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/wallpapers.jpg")
        }

        #btnHome {           
            margin-left: 300px;                    
        }

        .aa{
            background-color:#CCEEFF;
        }

        #uploadImage{
            background-color:#ccc;
            margin-left:300px;
            border:solid 5px black;
            width:1200px;
            height:800px;
        }

    </style>
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="uploadImage">

            <asp:FileUpload ID="FileUpload1" runat="server" Width="630px" />
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上傳" CssClass="btn btn-primary btn-lg"/>
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" ></asp:Label>

            <asp:Image ID="Image1" runat="server" Visible="False" />

            <br />
            <%--<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/admins/admin.aspx">回員工列表</asp:HyperLink>--%>
            

        </div>
        <a id="btnHome" href="Default_mine.aspx" class="btn btn-danger btn-lg">首頁</a>
    </form>
     <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
</body>
</html>
