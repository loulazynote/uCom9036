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
                Image1.ImageUrl = "~/DatingPlacePhoto.aspx?id=" + Request.QueryString["id"];
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
        SqlCommand cmd = new SqlCommand("Update DatingPlace Set Photo = @Photo Where PlaceId = @Id", cn);
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
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:FileUpload ID="FileUpload1" runat="server" Width="630px" />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上傳" />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    
        <asp:Image ID="Image1" runat="server" Visible="False" />
    
        <br />
        <%--<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/admins/admin.aspx">回員工列表</asp:HyperLink>--%>
        <a href="Default.aspx">首頁</a>

    </div>
    </form>
</body>
</html>
