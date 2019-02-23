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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>sortable</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css" />
    <link href="/User_chichi/Content/sweetalert2.css" rel="stylesheet" />
    <link rel="stylesheet" href="http://jqueryui.com/resources/demos/style.css" />
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            font-family: "微軟正黑體";
            font-size: 28px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/7.jpg");
        }

        #element{
            margin-left: 300px;
        }

        #choicePlace {
            margin: 0px auto; /*table 至中*/
            /*text-align:center;*/
            /*margin-left: 300px;*/
        }

        #btnSubmit {
            /*margin-left: 300px;*/
            margin-top: 20px;
        }

        #HyperLinkHome{
            margin-left: 300px;
            margin-top: 20px;
        }

        #sortable {
            list-style-type: none;
            margin: 0;
            padding: 0;
            width: 60%;
        }

            #sortable li {
                margin: 0 3px 3px 3px;
                padding: 0.4em;
                padding-left: 1.5em;
                font-size: 1.4em;
                height: 120px;
            }

                #sortable li span {
                    position: absolute;
                    margin-left: -1.3em;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="element">
            <h1>男士排序列表</h1>
            <p>請使用者依喜歡程度照順序排列，越喜歡的排越上面</p>
            <div id="choicePlace"></div>
            <input id="btnSubmit" type="button" value="確認提交數據" class="btn btn-primary btn-lg" />
            <div id="result"></div>
        </div>

      
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <asp:HyperLink ID="HyperLinkHome" runat="server" CssClass="btn btn-danger btn-lg" NavigateUrl="~/User_chichi/Default_mine.aspx">首頁</asp:HyperLink>
    </form>

    <script src="//code.jquery.com/jquery-1.9.1.js"></script>
    <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <script src="/User_chichi/Scripts/sweetalert2.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
    <script>

        $(function () {
            var manId = $("#HiddenField1").val();
            console.log(manId); //抓取女性Id
            //console.log("123");
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryWomanInfo",
                data: JSON.stringify({
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert("bb");
                    var idAry = new Array();
                    var nameAry = new Array();
                    var heightAry = new Array();


                    $(data.d).each(function () {
                        idAry.push($(this)[0].WId);
                        nameAry.push($(this)[0].name);
                        heightAry.push($(this).get(0).height);
                    });
                    //alert("TT");

                    //顯示選擇列表
                    $("#choicePlace").append("<ul id='sortable' >");

                    for (var i = 0; i < idAry.length; i++) {
                        $("#choicePlace ul").append("<li id=" + idAry[i] + " class='ui-state-defaulta' > " +
                            "<img  src='EmployeePhoto.aspx?id=" + idAry[i] + "' height='100' width='150' />" +
                            nameAry[i] +
                            "</li>");
                    }
                }
            });

            //$("#sortable li").css("background-color", "#02df82").css("border-radius","20px"); //?????????? 上不了色
            $("#sortable li").addClass("btn-info");
            $("#sortable li").css("border-radius", "20px");
            //$("#sortable").css("background-color", "#333");

            $("#sortable").sortable();
            $("#sortable").disableSelection();


            $("#btnSubmit").click(function () {
                //alert("aa");

                swal({
                    title: '確認?',
                    text: "資料即將上傳!",
                    type: 'warning',
                    showCancelButton: true,
                }).then(
                    function () {

                        var lis = document.getElementById("sortable").getElementsByTagName("li"); //lis並非陣列而為一List,因此吾將其ID取出組成一數組tempAry

                        var tempAry = new Array();
                        for (var i = 0; i < lis.length; i++) {
                            tempAry.push(lis[i].id);
                            console.log(lis[i].id);
                        }
                        var lis_String = tempAry.join(','); //陣列合併為字串

                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "WebService.asmx/GetListFromMan",
                            data: JSON.stringify({
                                Id: manId,
                                sort: lis_String
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                $("#result").html(data.d);
                            }
                        });

                        swal('完成!', '資料已上傳', 'success')
                    },
                    function (dismiss) {
                        if (dismiss === 'cancel') {
                            swal('取消', '資料未上傳', 'error')
                        }
                    });


            });
        });
    </script>
</body>
</html>
