<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void send_Click(object sender, EventArgs e)
    {
        string cmd = "SELECT [EmployeeID],[Email],[Password] FROM [Employees] where Email=@Email";
        string mail = TextBox1.Text;
        SqlDataAdapter da = new SqlDataAdapter(cmd, ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        da.SelectCommand.Parameters.AddWithValue("Email", mail);
        DataSet ds = new DataSet();
        da.Fill(ds, "PWD");
        DataTable rePWDtb = ds.Tables["PWD"];

        if (rePWDtb.Rows.Count > 0)
        {

            //DataRow rePWDdr = rePWDtb.NewRow();
            MailAlert send = new MailAlert();
            PWDRecover re = new PWDRecover();
            string rdnNum = re.RandonNum();
            //rePWDdr["Email"] = re.RandonNum();
            rePWDtb.Rows[0]["Password"] = rdnNum;
            SqlCommandBuilder objCommandBuilder = new SqlCommandBuilder(da);
            da.Update(ds, "PWD");
            send.SendMail(mail, "Your Password was recover!", "您的密碼重置為：" + rdnNum);
            HiddenField1.Value = "1";
        }
        else
        {
            HiddenField1.Value = "2";
        }

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- Web Fonts  -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800|Shadows+Into+Light" rel="stylesheet" type="text/css" />

    <!-- Vendor CSS -->
    <link rel="stylesheet" href="/vendor/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="/vendor/font-awesome/css/font-awesome.css" />
    <link href="/vendor/sweetalert2/sweetalert2.min.css" rel="stylesheet" />
    <!-- Theme CSS -->
    <link rel="stylesheet" href="/stylesheets/theme.css" />

    <!-- Skin CSS -->
    <link rel="stylesheet" href="/stylesheets/skins/default.css" />

    <!-- Head Libs -->
    <script src="/vendor/modernizr/modernizr.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- start: page -->
            <section class="body-sign">
                <div class="center-sign">
                    <a href="/" class="logo pull-left">
                        <img src="/images/logo2.png" height="54" alt="Porto Admin" />
                    </a>

                    <div class="panel panel-sign">
                        <div class="panel-title-sign mt-xl text-right">
                            <h2 class="title text-uppercase text-bold m-none"><i class="fa fa-user mr-xs"></i>Recover Password</h2>
                        </div>
                        <div class="panel-body">
                            <div class="alert alert-info">
                                <p class="m-none text-semibold h6">Enter your e-mail below and we will send you reset instructions!</p>
                            </div>

                            <div class="form-group mb-none">
                                <div class="input-group">
                                    <asp:TextBox ID="TextBox1" runat="server" TextMode="Email" class="form-control input-lg"></asp:TextBox>
                                    <span class="input-group-btn">
                                        <asp:Button ID="send" class="btn btn-primary btn-lg" runat="server" type="submit" Text="Reset!" OnClick="send_Click" />
                                    </span>
                                </div>
                            </div>
                            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                        </div>
                    </div>
                </div>
            </section>
            <!-- end: page -->
        </div>
    </form>
    <script src="/scripts/jquery-3.3.1.min.js"></script>
    <script src="/scripts/sweetalert2.min.js"></script>
    <script>
        $(function () {
            switch ($("#<%=HiddenField1.ClientID%>").val()) {
                case "1":
                    swal(
                        '讚',
                        '重設密碼成功!', 'success').then(
                            function () {
                                window.top.location.href = "/Login.aspx";
                            }
                        );
                    break;
                case "2":
                    swal(
                        '錯誤',
                        'Email not found', 'error')
                    break;
                default:
                    break;
            };
        });
    </script>
</body>
</html>