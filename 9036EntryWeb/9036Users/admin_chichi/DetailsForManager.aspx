<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">



    protected void Page_Load(object sender, EventArgs e)
    {
        string id = null;

        if (Request.QueryString["id"] != null)
        {
            id = Request.QueryString["id"];
            HiddenField1.Value = id;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title></title>

    <link href="/admin_chichi/Content/bootstrap.css" rel="stylesheet" />
     <link href="/admin_chichi/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" />
    <style>
       body {
            font-family: "微軟正黑體";
            font-size: 28px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/5.jpg")
        }

        #myTable {
            /*margin: 0px auto;*/ /*table 至中*/
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
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenField1" runat="server" />
         <div style="width: 80%;">
                <table class="table table-striped col-md-10">
                    <thead>
                        <tr id="myHead"><td></td><td>用戶資料</td></tr>
                    </thead>
                    <tbody id="mytBody">
                    </tbody>
                </table>               
               <a  href="Default.aspx" class="btn btn-danger btn-lg">首頁</a>
            </div>          
       <%-- <div id="test">
        </div>--%>
       
    </form>
    <script src="/admin_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/admin_chichi/Scripts/bootstrap.js"></script>
    <script>
        $(function () {
            var SignUpId = $("#HiddenField1").val();
            console.log(SignUpId);
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QuerySignUpDetail",
                data: JSON.stringify({
                    id: SignUpId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $(data.d).each(function () {
                         var table = $(` 
                                        <tr class="each_tr"><td>照片</td><td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].Id}" alt="" width="50%" /></td></tr>
                                        <tr class="each_tr"><td>序號</td><td>${$(this)[0].Id}</td></tr>
                                        
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

        });

    </script>
</body>
</html>
