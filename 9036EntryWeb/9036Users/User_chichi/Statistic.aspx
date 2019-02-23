<%--檢視男女邀約情況--%>

<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

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
<head id="Head1" runat="server">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />
    <title></title>
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-color: #CCDDFF; /*淡紫色*/
        }

        #staChart{
            margin-left:100px;
        }

        #btnHome{
            margin-left:500px;
            margin-top:50px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <div id="staChart">
            <h1>約會情況</h1>
            <div id="myChartParent" style="width: 75%;">
                <canvas id="myChart"></canvas>
            </div>
        </div>
        <%--<asp:HyperLink ID="HyperLinkHome" runat="server" CssClass="btn btn-danger btn-lg" NavigateUrl="~/User_chichi/Default_mine.aspx">首頁</asp:HyperLink>--%>
        <asp:Button ID="btnHome" runat="server" Text="首頁" CssClass="btn btn-danger" OnClick="btnHome_Click"/>
    </form>
    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/Chart.js"></script>
    <script src="/User_chichi/Scripts/utils.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
    <script>
        $(function () {
            var Id = $("#HiddenField1").val();
            console.log(Id);

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryStatistics",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    var xAry = new Array();
                    var yAry = new Array();
                    var zAry = new Array();

                    //each迴圈
                    //d是asp.net webservice返回之json对象的属性
                    $(data.d).each(function () {

                        //获得第一个 data.d 元素的名称和值：
                        //xAry.push($(this)[0].ProductName);
                        xAry.push($(this).get(0).success);
                        yAry.push($(this)[0].failure);
                        zAry.push($(this)[0].uncertainty);
                    });

                    var ctx = document.getElementById("myChart");
                    var myChart = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: ["一期", "二期", "三期", "四期", "五期", "六期", "七期", "八期", "九期", "十期"],
                            datasets: [
                                {
                                    label: '配對成功',
                                    borderColor: window.chartColors.red,
                                    backgroundColor: window.chartColors.red,
                                    data: xAry,
                                    fill: false
                                },
                                {
                                    label: '配對失敗',
                                    borderColor: window.chartColors.green,
                                    backgroundColor: window.chartColors.green,
                                    data: yAry,
                                    fill: false
                                },
                                {
                                    label: '未表態',
                                    borderColor: window.chartColors.blue,
                                    backgroundColor: window.chartColors.blue,
                                    data: zAry,
                                    fill: false
                                },
                            ]
                        },


                    });
                }
            });





        });
    </script>
</body>
</html>
