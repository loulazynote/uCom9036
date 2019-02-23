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

            if (UploadEmployeePhoto(FileUpload1.FileBytes, Request.QueryString["Title"]) > 0)
            {
                Label1.Text = "上傳成功!!";
                Image1.Visible = true;
                //Image1.ImageUrl = "~/Yoyo/Upload/Userimg.aspx?Title=" + Request.QueryString["Title"];
                
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
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Update Forum Set Userimg = @Userimg Where Title = @Id", cn);
        cmd.Parameters.AddWithValue("@Userimg", data);
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
    <h1>上傳封面檔</h1>
        <asp:FileUpload ID="FileUpload1" runat="server" Width="630px" />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上傳" />
        <br />
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
    
        <asp:Image ID="Image1" runat="server" Visible="False" />
    
        <br />
        <%--<button onclick="myFunction()">回首頁</button>--%>
        <button onclick="myFunction1()" >回討論區首頁</button></div>
    </form>
     <script>
        
        //function myFunction() {
        //    window.top.location.href = "../List(admin).aspx";
        //}
   function myFunction1() {
            window.top.location.href = "../List(Users).aspx";
        }
   
         



     </script>
</body>
</html>
