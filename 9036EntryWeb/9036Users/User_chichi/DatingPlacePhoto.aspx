<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Select Photo From DatingPlace Where PlaceId = @Id", cn);
        cmd.Parameters.AddWithValue("@Id", Request.QueryString["id"]); //Request.QueryString["id"] 來自 UploadImageDB.aspx
        cn.Open();
        var data = (byte[])cmd.ExecuteScalar();
        Response.BinaryWrite(data);
        Response.ContentType = "image/png"; //要求瀏覽器以image/png讀檔，防止亂碼
        cn.Close();
    }
</script>

<%--<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>--%>
