<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="EditEvent.aspx.cs" Inherits="EquipmentRentSystem_EditEvent" %>

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
                    <li>
                        <asp:hyperlink id="HyperLink1" runat="server" navigateurl="~/EquipmentRentSystem/Index.aspx">首頁</asp:hyperlink>
                    </li>
                    <li>
                        <asp:hyperlink id="HyperLink2" runat="server" navigateurl="~/EquipmentRentSystem/ShowLogs.aspx">租借紀錄查詢</asp:hyperlink>
                    </li>
                    <li class="active">
                        <asp:hyperlink id="HyperLink3" runat="server" navigateurl="~/EquipmentRentSystem/EditEvent.aspx">租借紀錄管理</asp:hyperlink>
                    </li>
                    <li>
                        <asp:hyperlink id="HyperLink4" runat="server" navigateurl="~/EquipmentRentSystem/Insert.aspx">新增器材</asp:hyperlink>
                    </li>
                    <li>
                        <asp:hyperlink id="HyperLink5" runat="server" navigateurl="~/EquipmentRentSystem/Condition.aspx">報銷器材</asp:hyperlink>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
    <div>
        <asp:dropdownlist id="DropDownList1" runat="server" datasourceid="SqlDataSource1" datatextfield="EquipmentTypeName" datavaluefield="EquipmentTypeID" appenddatabounditems="True">
            <asp:ListItem Value="0">--器材類別--</asp:ListItem>
        </asp:dropdownlist>
        <asp:sqldatasource id="SqlDataSource1" runat="server" connectionstring="<%$ ConnectionStrings:Entry9036 %>" selectcommand="SELECT * FROM [EquipmentType]"></asp:sqldatasource>
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
    <%--datepicker--%>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.js"></script>
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
                    GetDetails($(this).children('td').eq(0).text());
                    getEvent($(this).children('td').eq(0).text());
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
                contentHeight: 500,
                selectable: false,
                editable: true,
                eventDurationEditable: true,
                eventResize: function (event, delta, revertFunc, jsEvent, ui, view) {
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "/WebService_Equipment.asmx/ChangeDate",
                        data: JSON.stringify({
                            sd: event.start,
                            ed: event.end,
                            logid: event.className[0]
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {

                        }
                    });

                },
                eventClick: function (calEvent, jsEvent, view) {
                    var id = calEvent.className[0];
                    console.log(id)
                    swal({
                        title: 'Are you sure?',
                        html: 'Event: ' + calEvent.title + '</br>' + 'StartDate: ' + calEvent.start.format() + '</br>EndDate:' + calEvent.end.format(),
                        type: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, delete it!'
                    }).then(function () {
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "/WebService_Equipment.asmx/DeleteLogs",
                            data: JSON.stringify({
                                logid: id
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                swal(
                                    'Deleted!',
                                    'Your Record has been deleted.',
                                    'success'
                                );
                                getEvent($('tr.selected').find('td:first').text());
                            }
                        });
                    }, function () {

                    });


                }

                //select: function (startDate, endDate) {
                //    confirm('selected ' + startDate.format() + ' to ' + endDate.format());
                //    Rent(startDate.format(), endDate.format());
                //}
            })
        }
        function Rent(sd, ed) {
            $.ajax({
                type: "POST",
                async: false,
                url: "/WebService_Equipment.asmx/Rented",
                data: JSON.stringify({
                    EquipmentID: $('tr.selected').find('td:first').text(),
                    StartDate: sd,
                    EndDate: ed,
                    EmployeeID: 'handi83111'
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
                                className: $(this)[0].EventID + ""
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

