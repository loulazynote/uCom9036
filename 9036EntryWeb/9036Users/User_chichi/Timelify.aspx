<%--留言區--%>

<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            HiddenField1.Value = human.Sex;
        }
    }

    protected void btnHome_Click(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Response.Redirect("~/User_chichi/Default_mine.aspx");
        }
        else
        {
            Response.Redirect("~/admin_chichi/Default.aspx");
        }

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        #TextArea1, #Button1 {
            margin: 0 auto;
        }

        body {
            /*background-color: #FFB7DD;*/ /*淡紫色*/
            font-family: "微軟正黑體";
            font-size: 16px;
            background-image: url("../images/backgroundImage/9.jpg");
        }
    </style>
    <link href="/User_chichi/Content/animate.css" rel="stylesheet" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="/User_chichi/Content/timelify.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <div class="timeline">
            <h2>2019</h2>
            <ul class="timeline-items" id="userComment">
            </ul>
        </div>
        <textarea id="TextArea1" cols="60" rows="10"></textarea>
        <input id="btnComment" type="button" value="送出留言" class="btn btn-primary" />
        <asp:Button ID="btnHome" runat="server" Text="首頁" CssClass="btn btn-danger" OnClick="btnHome_Click" />
    </form>


    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="/User_chichi/Scripts/jquery.timelify.js"></script>
    <script>
        $(function () {
            var sex = $("#HiddenField1").val();
            console.log(sex);

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryComment",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {
                        var direction = "";
                        var rnd = Math.floor((Math.random() * 2) + 1);
                        if (rnd == 1) {
                            direction = "inverted";
                        }
                        var Comment = $(`
                                         <li class="is-hidden timeline-item ${direction}">              
                                             <h3>${$(this)[0].sex}</h3>
                                             <hr />
                                             <p>${$(this)[0].comment}</p>
                                             <hr />
                                            <time>${$(this)[0].HMS}</time>
                                        </li>
                                    `);

                        $("#userComment").append(Comment);
                    });
                }
            });

            $(".timeline").timelify({
                // animation types
                animLeft: "bounceInLeft",
                animRight: "bounceInRight",
                animCenter: "bounceInUp",

                // animation speed
                animSpeed: 1000,

                // trigger position in pixels
                offset: 150

            });

            $("#btnComment").click(function () {
                console.log("qq");
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/InsertComment",
                    data: JSON.stringify({
                        sex: sex,
                        comment: $("#TextArea1").val()
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        console.log("kk");
                        $("#result").html(data.d);
                    }
                });

                window.location = 'Timelify.aspx';//reset頁面

            });
        });
    </script>
</body>
</html>


