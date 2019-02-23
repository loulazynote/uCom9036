<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>


<!DOCTYPE html>

<script runat="server">


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);


        //SqlCommand cmd = new SqlCommand("insert into SignUp (name,pwd,sex,birth,height,hobby,email,roles) values (@name,@pwd,@sex,@birth,@height,@hobby,@email,'client')", cn);
        SqlCommand cmd = new SqlCommand("insert into SignUp (name,pwd,sex,birth,height,hobby,email,roles) values (@name,@pwd,@sex,@birth,@height,@hobby,@email,@roles)", cn);
        //cmd.CommandText = "select count(*) from U2143Users where (UID=@UserId) and (PWD=@Password)";
        //cmd.Connection = cn;
        cmd.Parameters.AddWithValue("@name", txtName.Text);
        cmd.Parameters.AddWithValue("@pwd", txtPwd.Text);
        cmd.Parameters.AddWithValue("@sex", radioButtonListSex.Text);
        cmd.Parameters.AddWithValue("@birth", datepicker.Text);
        cmd.Parameters.AddWithValue("@height", txtHeight.Text);
        cmd.Parameters.AddWithValue("@hobby", txtHobby.Text);
        cmd.Parameters.AddWithValue("@email", txtEmail.Text);

        if (radioButtonListSex.Text == "男")
        {
            cmd.Parameters.AddWithValue("@roles", "man");
        }
        else
        {
            cmd.Parameters.AddWithValue("@roles", "woman");
        }

        /*同時執行兩項任務可行*/
        //SqlCommand cmd2 = new SqlCommand("insert into DatingPlace (PlaceId,description) values (@PlaceId,@description) ", cn);
        //cmd2.Parameters.AddWithValue("@PlaceId",1);
        //cmd2.Parameters.AddWithValue("@description","西堤牛排");

        cn.Open();

        //int count = (int)cmd.ExecuteScalar();
        int count = cmd.ExecuteNonQuery();
        //cmd2.ExecuteNonQuery();
        if (count >= 1)
        {
            FormsAuthentication.RedirectFromLoginPage(txtEmail.Text, false); //找很久的BUG...吾是已Email作為User.Identity.Name，請參照Global.asax
            Response.Redirect("~/User_chichi/Login_mine.aspx");
        }
        else
        {
            Response.Redirect("~/User_chichi/Error.aspx");
        }


        cn.Close();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //txtName.Text = "虛竹";
        //txtPwd.Text = "123";
        //txtConfirmPwd.Text = "123";
        //radioButtonListSex.Text = "男";
        //datepicker.Text = "02/07/2019";
        //txtHeight.Text = "199";
        //txtHobby.Text = "念經";
        //txtEmail.Text = "qqq@gmail.com";
    }


    protected void btnDemo_Click(object sender, EventArgs e)
    {
        txtName.Text = "虛竹";
        txtPwd.Text = "123";
        txtConfirmPwd.Text = "123";
        radioButtonListSex.Text = "男";
        datepicker.Text = "02/07/2019";
        txtHeight.Text = "199";
        txtHobby.Text = "念經";
        txtEmail.Text = "qqq@gmail.com";
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title>Registration</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link href="/admin_chichi/Content/bootstrap.min.css" rel="stylesheet" />

    <%--<link rel="stylesheet" type="text/css" href="css/login/login.css"/>--%>
    <style>
        body {
            background-image: url("images/backgroundImage/10.png");
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
            <div class="row">
                <div class="col-sm-12 text-center">
                    <h1>Registration</h1>
                </div>
            </div>
            <div class="form-group">
                <asp:Label ID="labelAccount" runat="server" class="col-sm-3 control-label">尊姓大名:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="不可為空" ControlToValidate="txtName" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="label7" runat="server" class="col-sm-3 control-label">密碼:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtPwd" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="不可為空" ControlToValidate="txtPwd" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group">
                <asp:Label ID="label8" runat="server" class="col-sm-3 control-label">確認密碼:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="不可為空" ControlToValidate="txtConfirmPwd" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="密碼輸入不同" ControlToValidate="txtConfirmPwd" ControlToCompare="txtPwd" ForeColor="Red"></asp:CompareValidator>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="label2" runat="server" class="col-sm-3 control-label">性別:</asp:Label>
                <div class="col-sm-9">
                    <asp:RadioButtonList ID="radioButtonListSex" runat="server" RepeatDirection="Horizontal" Width="100">
                        <asp:ListItem>男</asp:ListItem>
                        <asp:ListItem>女</asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="必須選填性別" ControlToValidate="radioButtonListSex" ForeColor="Red"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="label1" runat="server" class="col-sm-3 control-label">生日:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="datepicker" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="不可為空" ControlToValidate="datepicker" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group">
                <asp:Label ID="label3" runat="server" class="col-sm-3 control-label">身高:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtHeight" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="不可為空" ControlToValidate="txtHeight" ForeColor="Red" Width="68px"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="身高必須介於100~250公分" MaximumValue="250" MinimumValue="100" ForeColor="Red" ControlToValidate="txtHeight"></asp:RangeValidator>
                </div>
            </div>


            <%-- 嗜好 --%>
            <div class="form-group">
                <asp:Label ID="label5" runat="server" class="col-sm-3 control-label">嗜好:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtHobby" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="不可為空，好比如打球、游泳等等..." ControlToValidate="txtHobby" ForeColor="Red" Width="400px"></asp:RequiredFieldValidator>
                </div>
            </div>

            <%-- Email --%>
            <div class="form-group">
                <asp:Label ID="label6" runat="server" class="col-sm-3 control-label">Email:</asp:Label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="不可為空" ControlToValidate="txtEmail" ForeColor="Red" Width="400px"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email格式錯誤" ControlToValidate="txtEmail" ValidationExpression="^[\w-\.]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$" ForeColor="#ff0000"></asp:RegularExpressionValidator>
                </div>
            </div>


            <br />
            <div class="form-group">
                <div class="col-md-offset-3 col-md-9">
                    <asp:Button ID="btnSubmit" runat="server" Text="確認提交資訊" class="form-control btn btn-primary" OnClick="btnSubmit_Click" />
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-offset-3 col-md-9">
                    <asp:Button ID="btnDemo" runat="server" Text="Demo" class="form-control btn btn-danger" OnClick="btnDemo_Click" CausesValidation="false" />
                </div>
            </div>
            <asp:Label ID="labelHint" runat="server" Text=""></asp:Label>
        </form>
    </div>
    <%--<script src="Scripts/jquery-3.1.1.min.js"></script>--%>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="/admin_chichi/Scripts/bootstrap.min.js"></script>
    <script>
        $(function () {
            $("#datepicker").datepicker({
                changeYear: true, // 年份下拉選單
                yearRange: "1950:2019"
            });
        });
    </script>
</body>
</html>
