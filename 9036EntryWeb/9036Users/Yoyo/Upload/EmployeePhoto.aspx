<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Select ProfilePicture From Employees Where Name = @UserName", cn);
        cmd.Parameters.AddWithValue("@UserName", Request.QueryString["Name"]);
        cn.Open();
        var data = (byte[])cmd.ExecuteScalar();


        Response.BinaryWrite(data);
        Response.ContentType = "image/png";
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
