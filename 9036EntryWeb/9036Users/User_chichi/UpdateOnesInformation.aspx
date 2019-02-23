<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = null;
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            id = human.Id.ToString() ;
        }

        string password = null;
        if (Request.Form["TextBox1"] != null)
        {
            password = Request.Form["TextBox1"];

        }

        string name = null;
        if (Request.Form["TextBox2"] != null)
        {
            name = Request.Form["TextBox2"];
        }

        string height = null;
        if (Request.Form["TextBox3"] != null)
        {
            height = Request.Form["TextBox3"];
        }

        //string birth = null;
        //if (Request.Form["TextBox4"] != null)
        //{
        //    birth = Request.Form["TextBox4"];

        //}

        string hobby = null;
        if (Request.Form["TextBox4"] != null)
        {
            hobby = Request.Form["TextBox4"];

        }

        string email = null;
        if (Request.Form["TextBox5"] != null)
        {
            email = Request.Form["TextBox5"];
        }

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("UPDATE SignUp SET name = @name,pwd = @pwd,height = @height,hobby = @hobby,email= @email where Id = @Id", cn);

        cmd.Parameters.AddWithValue("@name", name);
        cmd.Parameters.AddWithValue("@pwd", password);      
        cmd.Parameters.AddWithValue("@height", height);
        cmd.Parameters.AddWithValue("@hobby", hobby);
        cmd.Parameters.AddWithValue("@email", email);

        cmd.Parameters.AddWithValue("@Id", id);

        cn.Open();

        //int count = (int)cmd.ExecuteScalar();
        int count = cmd.ExecuteNonQuery();
        //cmd2.ExecuteNonQuery();
        if (count >= 1)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("~/User_chichi/Login_mine.aspx");
        }
        else
        {
            Response.Redirect("~/Error.aspx");
        }


        cn.Close();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <asp:Label ID="labelUserId" runat="server" Text="Label"></asp:Label><br />
    <asp:Label ID="labelInformation" runat="server" Text="Label"></asp:Label>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
