<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowLogs.aspx.cs" Inherits="EquipmentRentSystem_ShowLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .table tbody tr td {
            vertical-align: middle;
        }

        table {
            margin-left: auto;
            margin-right: auto;
        }

        body, button, input, select, textarea, h1, h2, h3, h4, h5, h6 {
            font-family: Microsoft YaHei,'宋体', Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="#">器材租借管理系統</a>
                </div>
                <ul class="nav navbar-nav">
                    <li>
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/EquipmentRentSystem/Index.aspx">首頁</asp:HyperLink></li>
                    <li class="active">
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/EquipmentRentSystem/ShowLogs.aspx">租借紀錄查詢</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/EquipmentRentSystem/EditEvent.aspx">管理租借紀錄</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/EquipmentRentSystem/Insert.aspx">新增器材</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/EquipmentRentSystem/Condition.aspx">報銷器材</asp:HyperLink></li>
                </ul>
            </div>
        </nav>
    </div>
    <table id="example" class="talbe row-border hover" style="width: 100%">
        <thead>
            <tr>
                <th>紀錄編號</th>
                <th>租借人</th>
                <th>器材編號</th>
                <th>器材名稱</th>
                <th>器材資訊</th>
                <th>租借起始日</th>
                <th>租借歸還日</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>紀錄編號</th>
                <th>租借人</th>
                <th>器材編號</th>
                <th>器材名稱</th>
                <th>器材資訊</th>
                <th>租借起始日</th>
                <th>租借歸還日</th>
            </tr>
        </tfoot>
    </table>
    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#home">歷年統計</a></li>
    </ul>
    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">
            <canvas id="myChart" style="height:200px; width:400px"></canvas>
        </div>
    </div>
    <asp:HiddenField ID="HiddenField1" runat="server" />
    <asp:HiddenField ID="HiddenField2" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>

    <script>
        $(function () {
            showtable();
            var arrayReturn1 = [];
            var arrayReturn2 = [];
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/getDepartmentName",
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    arrayReturn1 = data.d;
                }
            });
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/getLogsGroupbydepartment",
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data);
                    console.log(data.d);
                    arrayReturn2 = data.d;
                    console.log(arrayReturn2);
                }
            });
            var dynamicColors = function () {
                var r = Math.floor(Math.random() * 255);
                var g = Math.floor(Math.random() * 255);
                var b = Math.floor(Math.random() * 255);
                return "rgb(" + r + "," + g + "," + b + ")";
            }
            var ctx = document.getElementById('myChart').getContext('2d');
            var chart = new Chart(ctx, {
                // The type of chart we want to create
                type: 'pie',

                // The data for our dataset
                data: {
                    labels: arrayReturn1,
                    datasets: [{
                        label: "My First dataset",
                        backgroundColor: [
                            "red", "green", "blue", "purple", "magenta","black","white","pink","orange"
                        ],
                        borderColor: 'rgb(255, 99, 132)',
                        data: arrayReturn2,
                    }]
                },

                // Configuration options go here
                options: {}
            });
        });

        function showtable() {

            var arrayReturn = [];
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/GetAllEvent",
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data.d);
                    $(data.d).each(function () {
                        arrayReturn.push(
                            [
                                $(this)[0].EventID,
                                $(this)[0].DepartmentName + '-' + $(this)[0].Name,
                                $(this)[0].EquipmentID,
                                $(this)[0].EquipmentName,
                                $(this)[0].EquipmentDescription,
                                $(this)[0].StartDate,
                                $(this)[0].EndDate
                            ]);
                    });
                    console.log(arrayReturn);
                    $('#example').DataTable({
                        "bDestroy": true,
                        "aaData": arrayReturn,
                    });
                }
            });
        }

    </script>
</asp:Content>

