<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="EquipmentRentSystem_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        body, button, input, select, textarea, h1, h2, h3, h4, h5, h6 {
            font-family: Microsoft YaHei,'宋体', Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif;
        }

        .table tbody tr td {
            vertical-align: middle;
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
                    <li class="active">
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/EquipmentRentSystem/Index.aspx">首頁</asp:HyperLink></li>
                    <li>
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
    <div class="row">
        <div class="col-xs-2">
            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" DataTextField="EquipmentTypeName" DataValueField="EquipmentTypeID" AppendDataBoundItems="True">
                <asp:ListItem Value="0">--器材類別--</asp:ListItem>
            </asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT * FROM [EquipmentType]"></asp:SqlDataSource>
        </div>
        <div class="col-xs-8">
        </div>
        <div class="col-xs-2">
        </div>
    </div>
    <div class="row">
        <div class="col-xs-5">
            <table id="example" class="talbe row-border hover" style="width: 100%">
                <thead>
                    <tr>
                        <th>編號</th>
                        <th>器材名稱</th>
                        <th>State</th>
                    </tr>
                </thead>
                <%--                <tfoot>
                    <tr>
                        <th>編號</th>
                        <th>器材名稱</th>
                        <th>State</th>
                    </tr>
                </tfoot>--%>
            </table>

        </div>
        <div class="row col-xs-7">
            <table class="table table-bordered table-striped" style="margin-top: 38px">
                <tr>
                    <td colspan="3" style="text-align: center">
                        <p class="h1">器材明細</p>
                    </td>
                </tr>
                <tr>
                    <td class="col-xs-2">器材編號</td>
                    <td class="col-xs-4" id="EquipmentID"></td>
                    <td class="col-xs-6" rowspan="6">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/EquipmentRentSystem/images/white.png" Height="300" Width="300" />
                    </td>
                </tr>
                <tr>
                    <td>器材名稱</td>
                    <td id="EquipmentName"></td>
                </tr>
                <tr>
                    <td>器材描述</td>
                    <td id="EquipmentDescription"></td>
                </tr>
                <tr>
                    <td>租借狀況</td>
                    <td id="State1"></td>
                </tr>
                <tr>
                    <td>報銷</td>
                    <td id="State2"></td>
                </tr>
                <tr>
                    <td>報銷原因</td>
                    <td id="Reason"></td>
                </tr>
            </table>
        </div>
    </div>
    <div id='calendar'></div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.js"></script>
    <%--    <link href="sweetalert2-8.0.7/package/dist/sweetalert2.min.css" rel="stylesheet" />--%>
    <%--<script src="sweetalert2-8.0.7/package/dist/sweetalert2.all.min.js"></script>--%>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <%--fullcalendar--%>
    <link href="../EquipmentRentSystem/fullcalendar-3.10.0/fullcalendar.css" rel="stylesheet" />
    <script src="../EquipmentRentSystem/fullcalendar-3.10.0/lib/moment.min.js"></script>
    <script src="../EquipmentRentSystem/fullcalendar-3.10.0/fullcalendar.js"></script>
    <script>
        $(document).ready(function () {
            myfunction(0);
            calendar();
            // Setup - add a text input to each footer cell
            //$('#example tfoot th').each(function () {
            //    var title = $(this).text();
            //    $(this).html('<input type="text" placeholder="Search ' + title + '" />');
            //});
            //Datatbale
            var table = $('#example').DataTable();
            //// Apply the search
            //table.columns().every(function () {
            //    var that = this;

            //    $('input', this.footer()).on('keyup change', function () {
            //        if (that.search() !== this.value) {
            //            that
            //                .search(this.value)
            //                .draw();
            //        }
            //    });
            //});
            //Apply Selected
            $('#example tbody').on('click', 'tr', function () {
                if ($(this).hasClass('selected')) {
                    $(this).removeClass('selected');

                }
                else {
                    $('#example').DataTable().$('tr.selected').removeClass('selected');
                    $(this).addClass('selected');
                    //alert($(this).children('td').eq(0).text());
                    console.log($('tr.selected').find('td:first').text());
                    GetDetails($('tr.selected').find('td:first').text());

                    getEvent($('tr.selected').find('td:first').text());
                }
            });
            $('#ContentPlaceHolder1_DropDownList1').change(function () {
                myfunction(this.value)
            });
        });
        function myfunction(Typeid) {

            var arrayReturn = [];
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/GetEquipmentByTypeID",
                data: JSON.stringify({
                    typeid: Typeid
                }),
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data.d);
                    $(data.d).each(function () {
                        arrayReturn.push(
                            [
                                $(this)[0].EquipmentID,
                                $(this)[0].EquipmentName,
                                $(this)[0].State == 1 ? "已報銷" : "未報銷"
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
        function GetDetails(equipID) {
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/GetEquipmentinfoByID",
                data: JSON.stringify({
                    EquipID: equipID
                }),
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data.d);
                    $(data.d).each(function () {
                        $('#EquipmentID').text($(this)[0].EquipmentID);
                        $('#EquipmentName').text($(this)[0].EquipmentName);
                        $('#EquipmentDescription').text($(this)[0].EquipmentDescription);
                        $('#Reason').text($(this)[0].Reason);
                        $('#State1').text($(this)[0].RentedState == 1 ? $(this)[0].DepartmentName+"已租借" : "未租借");
                        $('#State2').text($(this)[0].State == 1 ? "已報銷" : "未報銷");
                        $("#ContentPlaceHolder1_Image1").attr("src", $(this)[0].ImageUrl);
                    });
                }
            });
        }
        function calendar() {
            $('#calendar').fullCalendar({
                //height: 650,
                contentHeight: 400,
                selectable: true,
                select: function (startDate, endDate) {
                    //Rent(startDate.format(), endDate.format());
                    swal({
                        title: '是否要租借?',
                        html: "起始日:" + startDate.format() + "</br>結束日:" + endDate.format(),
                        type: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '租借器材'
                    }).then(function () {
                        swal(
                            '租借成功!',
                            '已發送信件至信箱!',
                            'success'
                        );
                        Rent(startDate.format(), endDate.format());
                    }, function (dismiss) {
                        if (dismiss == 'cancel') {

                        }
                    });

                }
            })
        }
        function Rent(sd, ed) {
            console.log($('#HiddenField3').val());
            console.log($('tr.selected').find('td:first').text());
            $.ajax({
                type: "POST",
                async: false,
                url: "/WebService_Equipment.asmx/Rented",
                data: JSON.stringify({
                    EquipmentID: $('tr.selected').find('td:first').text(),
                    StartDate: sd,
                    EndDate: ed,
                    EmployeeID: $('#HiddenField3').val(),
                    EquipmentName: $('#EquipmentName').text()
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    getEvent($('tr.selected').find('td:first').text());
                    GetDetails($('tr.selected').find('td:first').text());
                }
            });
        }
        function getEvent(Eqid) {

            $.ajax({
                type: "POST",
                async: false,
                url: "/WebService_Equipment.asmx/GetEvent",
                data: JSON.stringify({
                    EquipmentID: Eqid,
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var events = [];
                    $(data.d).each(function () {
                        events.push(
                            {
                                title: $(this)[0].DepartmentName + '-' + $(this)[0].Name,
                                start: $(this)[0].StartDate,
                                end: $(this)[0].EndDate,
                            });
                    });
                    console.log(events);
                    $('#calendar').fullCalendar('removeEvents');
                    $('#calendar').fullCalendar('addEventSource', events);
                    $('#calendar').fullCalendar('refetchEvents');
                }
            });
        }
    </script>
</asp:Content>

