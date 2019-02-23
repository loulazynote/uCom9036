<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="GemBox.Spreadsheet" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {


        //SqlDataAdapter da = new SqlDataAdapter(
        //    " SELECT   Hour, EmpId FROM AllEmployess ",
        //    @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Database.mdf;Integrated Security=True"
        //    );

        //SqlDataAdapter da = new SqlDataAdapter("SELECT [EmpId] , sum(Hour) AS TOTAL  FROM [AllEmployess] WHERE Result = N'通過' GROUP BY EmpId ",
        SqlDataAdapter da = new SqlDataAdapter("SELECT [EmpId] ,sum(Hour) AS TOTAL  FROM [AllEmployess]  WHERE Result = N'通過' GROUP BY EmpId ",
        ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        DataTable dt = new DataTable();
        da.Fill(dt);
        var EmpIdAry = dt.AsEnumerable().Select(r => r["EmpId"].ToString()).ToArray();
        var HourAry = dt.AsEnumerable().Select(r => r["TOTAL"].ToString()).ToArray();
        HiddenField1.Value = string.Join(",", EmpIdAry);
        HiddenField2.Value = string.Join(",", HourAry);

    }

    protected void But1_Click(object sender, EventArgs e) //列印輸出事件
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM [AllEmployess] ",
        ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        DataTable dt = new DataTable("MyTable");
        da.Fill(dt);


        SpreadsheetInfo.SetLicense("FREE-LIMITED-KEY");
        ExcelFile xlsx = new ExcelFile();
        ExcelWorksheet mySheet = xlsx.Worksheets.Add("sheet1");
        mySheet.InsertDataTable(dt,
           new InsertDataTableOptions()
           {
               StartColumn = 2,
               StartRow = 2,
               ColumnHeaders = true
           });
        xlsx.Save(Server.MapPath(@"Output\AllEmplyoess.xlsx"));
        Response.Redirect("~/NewPP/Output/AllEmplyoess.xlsx");
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        text {
            font-family: '微軟正黑體';
            
        }

        .table-hover > tbody > tr:hover > td,
        .table-hover > tbody > tr:hover > th {
            background-color: darkgray !important;
        }
    </style>

    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <asp:Button ID="But1" runat="server" Text="EXCEL 輸出" CssClass="col-sm-1.5 text-center btn btn-success" OnClick="But1_Click" />

    <div class="row">
        <div class="col-sm-12 text-center text-primary ">
            <h1>全員總明細<small>圖表</small></h1>
        </div>

    </div>

<%--    <div class="row">
        <div class="col-sm-12 text-center text-primary">
            <p class="lead">
            <span class="word-rotate highlight active form-control">
                <span class="word-rotate-items"style="font-size:x-large;">
                    <span >9036員工系統</span>
                    <span >全員總明細<</span>
                    <span >假務系統</span>
                    </span>
            </span>
            </p>
        </div>
    </div>--%>
    <%-- <span class="glyphicon glyphicon-apple" style="font-size:30px;color:red;"></span>

    <input type="text" id="keyword" value="" />
    <button>
        Search <span id="btn1" class="glyphicon glyphicon-search"></span>
    </button>--%>



    <section class="panel">
        <header class="panel-header">
            <div class="panel-actions">
                <a href="#" class="fa fa-caret-down">
                    <%-- ::before--%>
                </a>
            </div>
            <h2 class="header-title"></h2>
        </header>

        <div class="panel-body">
            <%-- ::before--%>
            <div class="table-resopnsive">
                <table class="table table-bordered mb-none table-hover" id="dataTable">
                    <thead>
                        <tr class="dark">

                            <td>假單編號</td>
                            <td>員工名稱</td>
                            <td>開始時間</td>
                            <td>結束時間</td>
                            <td>假單</td>
                            <td>時數</td>
                            <td>審核</td>
                            <td>備註原因</td>
                            <td>回覆備註</td>
                            <td>申請時間</td>
                            <td>部門</td>

                        </tr>
                    </thead>
                    <tbody id="mytBody">
                    </tbody>
                </table>
            </div>
            <%--::after--%>
        </div>
    </section>

    <div style="width: 90%;">
        <canvas id="myChart"></canvas>
    </div>

    <asp:HiddenField ID="HiddenField1" runat="server" />
    <asp:HiddenField ID="HiddenField2" runat="server" />

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

<%--    <script src="Scripts/jquery-3.3.1.min.js"></script>
     <script src="Scripts/bootstrap.min.js"></script>--%>
<%--    <script src="Scripts/Chart.js"></script>--%>
    <script src="utils.js"></script>
    <script src="script/Chart.min.js"></script>
    <%--<script src="utils.js"></script>--%>
    <script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

    <script>

        function myfunction() {
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/AllEmployess",
                data: JSON.stringify({
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $(data.d).each(function () {
                        var tr1 = $(`<tr class="info">
                                            
                                            <td>${$(this)[0].Id}</td>
                                            <td>${$(this)[0].EmpId}</td>
                                            <td>${$(this)[0].Starttime}</td>
                                            <td>${$(this)[0].Overtime}</td>
                                            <td>${$(this)[0].Event}</td>
                                            <td>${$(this)[0].Hour}</td>
                                            <td>${$(this)[0].Result}</td>
                                            <td>${$(this)[0].Content}</td>
                                            <td>${$(this)[0].Replay}</td>
                                            <td>${$(this)[0].Nowdate}</td>
                                            <td>${$(this)[0].Department}</td>
                                            
                                        </tr>`);
                        $("#mytBody").append(tr1);
                    });
                }
            });
        }


        //建立圖型
        $(function () {
            myfunction();
            $('#dataTable').DataTable({
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sUrl": "../NewPP/script/dataTables.Chinese.traditional.txt"
                }
            });

        });

        var ctx = document.getElementById("myChart");
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: document.getElementById("ContentPlaceHolder1_HiddenField1").value.split(","),  //注意 配合manger關係 會有在client變動的問題存在
                datasets: [{
                    label: '已通過核准時數',
                    data: document.getElementById("ContentPlaceHolder1_HiddenField2").value.split(","),
                    borderWidth: 1,
                    backgroundColor: GetRandomColors(22)
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });

        ////收尋功能
        //$(function () {
        //    $("#btn1").click(function () {

        //        $("#mytable").empty();
        //        $("#HiddenField1", "#HiddenField2").empty();

        //        $.ajax({
        //            type: "POST",
        //            async: false,
        //            url: "WebService.asmx/SelectProducts",
        //            data: JSON.stringify({

        //                keyword: $("#keyword").val()
        //            }),
        //            contentType: "application/json; charset=utf-8",
        //            dataType: "json",
        //            success: function (data) {
        //                $(data.d).each(function () {
        //                    var tr1 = $(`<tr class="success">

        //                                    <td>${$(this)[0].Id}</td>
        //                                    <td>${$(this)[0].EmpId}</td>
        //                                    <td>${$(this)[0].Starttime}</td>
        //                                    <td>${$(this)[0].Overtime}</td>
        //                                    <td>${$(this)[0].Event}</td>
        //                                    <td>${$(this)[0].Hour}</td>
        //                                    <td>${$(this)[0].Result}</td>
        //                                    <td>${$(this)[0].Content}</td>
        //                                    <td>${$(this)[0].Replay}</td>
        //                                    <td>${$(this)[0].Nowdate}</td>
        //                                    <td>${$(this)[0].Department}</td>

        //                                </tr>`);
        //                    $("#mytBody").append(tr1);
        //                });
        //            }
        //        });
        //    });
        //});
    </script>

</asp:Content>

