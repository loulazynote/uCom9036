<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        //SqlCommand cmd = new SqlCommand("SELECT COUNT(RegionID) AS [Count] FROM Region",cn);
        SqlCommand cmd = new SqlCommand("select count(*) from SignUp where (email=@email) and (pwd=@Password)", cn);
        //cmd.CommandText = "select count(*) from U2143Users where (UID=@UserId) and (PWD=@Password)";
        //cmd.Connection = cn;       
        cmd.Parameters.AddWithValue("@email", txtEmail.Text);
        cmd.Parameters.AddWithValue("@Password", txtPwd.Text);

        //取得登錄者Id
        SqlCommand cmd2 = new SqlCommand("select Id from SignUp where (email=@email) and (pwd=@Password)", cn);
        cmd2.Parameters.AddWithValue("@email", txtEmail.Text);
        cmd2.Parameters.AddWithValue("@Password", txtPwd.Text);

        //取得登錄者性別sex
        SqlCommand cmd3 = new SqlCommand("select sex from SignUp where (email=@email) and (pwd=@Password)", cn);
        cmd3.Parameters.AddWithValue("@email", txtEmail.Text);
        cmd3.Parameters.AddWithValue("@Password", txtPwd.Text);


        #region SqlDataReader
        //string query = "select Id,sex from SignUp";
        //List<Human> human = new List<Human>();
        //using (cn)
        //{
        //    using (SqlCommand command = new SqlCommand(query, cn))
        //    {
        //        using (SqlDataReader dr = command.ExecuteReader())
        //        {
        //            while (dr.Read())
        //            {
        //                //var someComplexItem = new SomeComplexItem();
        //                //someComplexItem.SomeColumnValue = reader[1].ToString();
        //                //someComplexItem.SomeColumnValue2 = reader[2].ToString();
        //                //someComplexItem.SomeColumnValue3 = reader[3].ToString();

        //                //active.Add(someComplexItem);
        //            }
        //        }
        //    }
        //}
        #endregion



        cn.Open();

        int count = (int)cmd.ExecuteScalar();

        //藉由email password獲取userId
        int userId = Convert.ToInt32(cmd2.ExecuteScalar());
        string sex = cmd3.ExecuteScalar().ToString();

        //確認此用戶於數據庫內
        if (count >= 1)
        {
            FormsAuthentication.RedirectFromLoginPage(txtEmail.Text, false);
            //Request.QueryString["UserId"] = userId;

            Human human = new Human();
            human.Id = userId;
            human.Sex = sex;

            Session["human"] = human;
            Response.Redirect("~/User_chichi/Default_mine.aspx");
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
    <%--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--%>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title>Login</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link href="/User_chichi/Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            /*background-color: #CCDDFF;*/ /*淡紫色*/
            background-image: url("images/backgroundImage/8.jpg");
        }
        /*對超連接的樣式指定*/
        a:link {
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="form1" runat="server" class="form-horizontal">
            <%--form-horizontal 切記要加，不然control-label出不來--%>
            <div class="row">
                <div class="col-sm-12 text-center">
                    <h1>登錄本系統</h1>
                </div>
            </div>
            <div class="form-group">
                <asp:Label ID="labelEmail" runat="server" class="col-sm-3 control-label">Email:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="不可為空" ControlToValidate="txtEmail" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email格式錯誤" ControlToValidate="txtEmail" ValidationExpression="^[\w-\.]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="labelPasswd" runat="server" class="col-sm-3 control-label">密碼:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtPwd" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="不可為空" ControlToValidate="txtPwd" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                </div>
            </div>

            <br />
            <div class="form-group">
                <div class="col-md-offset-3 col-md-9">
                    <asp:Button ID="btnLogin" runat="server" Text="登錄" class="form-control btn btn-primary" OnClick="btnLogin_Click" />
                </div>
            </div>
            <br />
            <div class="form-group">
                <div class="col-md-offset-3 col-md-9">
                    <asp:HyperLink ID="hyperlinkRegister" runat="server" NavigateUrl="~/User_chichi/Register.aspx" class="form-control btn btn-warning">註冊</asp:HyperLink>
                    <%--btn-warning：黃色--%>
                </div>
            </div>

        </form>
    </div>
    <%--<script src="Scripts/jquery-3.1.1.min.js"></script>--%>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.min.js"></script>
</body>
</html>
