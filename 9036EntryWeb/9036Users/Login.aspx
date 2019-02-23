<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- Web Fonts  -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800|Shadows+Into+Light" rel="stylesheet" type="text/css" />

    <!-- Vendor CSS -->
    <link rel="stylesheet" href="vendor/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.css" />
    <link rel="stylesheet" href="vendor/magnific-popup/magnific-popup.css" />
    <link href="/vendor/sweetalert2/sweetalert2.min.css" rel="stylesheet" />
    <!-- Theme CSS -->
    <link rel="stylesheet" href="stylesheets/theme.css" />

    <!-- Skin CSS -->
    <link rel="stylesheet" href="stylesheets/skins/default.css" />

    <!-- Theme Custom CSS -->
    <link rel="stylesheet" href="stylesheets/theme-custom.css" />

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <section class="body-sign">
            <div class="center-sign">
                <div class="logo pull-left">
                    <img src="images/logo2.png" height="54" alt="9036 Admin" />
                </div>
                <div class="panel panel-sign">
                    <div class="panel-title-sign mt-xl text-right">
                        <h2 class="title text-uppercase text-bold m-none"><i class="fa fa-user mr-xs"></i>Log In</h2>
                    </div>
                    <div class="panel-body">
                        <div class="form-group mb-lg">
                            <label>UserID</label>
                            <div class="input-group input-group-icon">
                                <asp:TextBox ID="TextBox1" runat="server" class="form-control input-lg"></asp:TextBox>
                                <span class="input-group-addon">
                                    <span class="icon icon-lg">
                                        <i class="fa fa-user"></i>
                                    </span>
                                </span>
                            </div>
                        </div>

                        <div class="form-group mb-lg">
                            <div class="clearfix">
                                <label class="pull-left">Password</label>
                                <a href="Louis/recover.aspx" class="pull-right">Lost Password?</a>
                            </div>
                            <div class="input-group input-group-icon">
                                <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" class="form-control input-lg"></asp:TextBox>
                                <span class="input-group-addon">
                                    <span class="icon icon-lg">
                                        <i class="fa fa-lock"></i>
                                    </span>
                                </span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-5">
                                <asp:TextBox ID="TextBox3" runat="server" class="form-control input-lg"></asp:TextBox>
                            </div>
                            <div class="col-sm-3">
                                <asp:Image ID="Image1" runat="server" ImageUrl="~/Louis/GenCode.aspx" />
                                <%-- <div class="checkbox-custom checkbox-default">
                                    <input id="RememberMe" name="rememberme" type="checkbox" />
                                    <label for="RememberMe">Remember Me</label>
                                </div>--%>
                            </div>
                            <div class="col-sm-4 text-right">
                                <asp:Button ID="Button1" runat="server" class="btn btn-primary btn btn-primary" Text="Login" OnClick="Button1_Click" />
                            </div>
                        </div>
                        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                        <asp:HiddenField ID="HiddenField1" runat="server" />
                        <%--<p class="text-center">
                            Don't have an account yet? <a href="pages-signup.html">Sign Up!</a>--%>
                    </div>
                </div>
            </div>
        </section>
    </form>
    <script src="/scripts/jquery-3.3.1.min.js"></script>
    <script src="/scripts/sweetalert2.min.js"></script>
    <script>
        $(function () {
            $("#<%=Image1.ClientID%>").click(function () {
                $("#<%=Image1.ClientID%>").attr("src", "/Louis/GenCode.aspx?" + new Date().getTime());
            })
            switch ($("#<%=HiddenField1.ClientID%>").val()) {
                case "1":
                    swal(
                        '錯誤',
                        '帳號密碼不存在!', 'error')

                    break;
                case "2":
                    swal(
                        '錯誤',
                        'Code error', 'error')

                    break;
                default:
                    break;
            };
        });
    </script>
</body>
</html>