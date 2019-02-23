<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];

            HiddenField1.Value = human.Id.ToString();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title></title>

    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
     <link href="/User_chichi/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" />
    <style>
       body {
            font-family: "微軟正黑體";
            font-size: 28px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/5.jpg")
        }

        #myTable {
            margin: 0px auto; /*table 至中*/
        }

        .my_th {
            background-color: #666;
        }

        

        #myHead{
            background-color: #666;
        }

        #myHead td{
            font-size: 36px;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="form1" runat="server">
            <asp:HiddenField ID="HiddenField1" runat="server" />
           <%-- <table id="information">
            </table>--%>            
            <div style="width: 80%;">
                <table class="table table-striped col-md-10">
                    <thead>
                        <tr id="myHead"><td></td><td>用戶資料</td></tr>
                    </thead>
                    <tbody id="mytBody">
                    </tbody>
                </table>
                 <a id="fancyBox1" href="FormFrom_FancyBox.aspx" class="btn btn-danger btn-lg">修改資料</a>
               <a  href="Default_mine.aspx" class="btn btn-danger btn-lg">首頁</a>
            </div>          
        </form>
    </div>

    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>

     <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
    <script src="/User_chichi/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script src="/User_chichi/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>

    <script>
        $(function () {
            //alert("aa");
            var UserId = $("#HiddenField1").val();
            console.log(UserId); //抓取使用者Id

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QuerySignUpDetail",
                data: JSON.stringify({
                    id: UserId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                   // alert("bb");
                    $(data.d).each(function () {
                                           
                        var table = $(` 
                                        <tr class="each_tr"><td>照片</td><td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].Id}" alt="" /></td></tr>
                                        <tr class="each_tr"><td>序號</td><td>${$(this)[0].Id}</td></tr>
                                        <tr class="each_tr"><td>密碼</td><td>${$(this)[0].passwd}</td></tr>
                                        <tr class="each_tr"><td>姓名</td><td>${$(this)[0].name}</td></tr>                                      
                                        <tr class="each_tr"><td>身高</td><td>${$(this)[0].height}cm</td></tr>
                                        <tr class="each_tr"><td>生日</td><td>${$(this)[0].birth}</td></tr>
                                        <tr class="each_tr"><td>興趣</td><td>${$(this)[0].hobby}</td></tr>
                                        <tr class="each_tr"><td>電郵</td><td>${$(this)[0].email}</td></tr> 
                                        `);
                        $("#mytBody").append(table);
                    });
                }
            });
            //$(".each_tr").css("background-color", "wheat");
            $("a#fancyBox1").fancybox();


        });
    </script>
</body>
</html>
