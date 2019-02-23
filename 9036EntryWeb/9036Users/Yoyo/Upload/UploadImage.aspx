<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<!DOCTYPE html>

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {

            if (UploadEmployeePhoto(FileUpload1.FileBytes, Request.QueryString["Name"]) > 0)
            {
                Label1.Text = "上傳成功!!";
                Image1.Visible = true;
                Image1.ImageUrl = "EmployeePhoto.aspx?Name=" + Request.QueryString["Name"];
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

    int UploadEmployeePhoto(byte[] data, string Id)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Update Employees Set ProfilePicture = @Photo Where Name = @Id", cn);
        cmd.Parameters.AddWithValue("@Photo", data);
        cmd.Parameters.AddWithValue("@Id", Id);

        cn.Open();
        int affected = cmd.ExecuteNonQuery();
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
        <a href="ListEmployees.aspx">回員工列表</a></div>
    </form>
</body>
</html>
