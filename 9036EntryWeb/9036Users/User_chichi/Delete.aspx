<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = null;
        if (Request.QueryString["id"] != null)
        {
            id = Request.QueryString["id"];

            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
            SqlCommand cmd = new SqlCommand("delete from SignUp where Id=@Id", cn);
            cmd.Parameters.AddWithValue("@Id",id);

            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();

        }

        Response.Redirect("~/admin/GenTable.aspx");
        



    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Delete</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Delete</h1>
        </div>
    </form>
</body>
</html>
