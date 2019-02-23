<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Condition.aspx.cs" Inherits="EquipmentRentSystem_Condition" %>

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
                    <li>
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/EquipmentRentSystem/ShowLogs.aspx">租借紀錄查詢</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/EquipmentRentSystem/EditEvent.aspx">管理租借紀錄</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/EquipmentRentSystem/Insert.aspx">新增器材</asp:HyperLink></li>
                    <li class="active">
                        <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/EquipmentRentSystem/Condition.aspx">報銷器材</asp:HyperLink></li>
                </ul>
            </div>
        </nav>
    </div>
    <input id="Button1" type="button" value="報銷器材" class="btn btn-danger"/>
    <table id="example" class="talbe row-border hover" style="width: 100%">
        <thead>
            <tr>
                <th>編號</th>
                <th>器材名稱</th>
                <th>器材類別</th>
                <th>器材資訊</th>
                <th>使用年限</th>
                <th>報銷原因</th>
                <th>報銷</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>編號</th>
                <th>器材名稱</th>
                <th>器材類別</th>
                <th>器材資訊</th>
                <th>使用年限</th>
                <th>報銷原因</th>
                <th>報銷</th>
            </tr>
        </tfoot>
    </table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.css" />
    <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/datatables.min.js"></script>
    <script>
        $(document).ready(function () {
            myfunction();
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
                }
            });
            $('#Button1').click(function () {
                swal({
                    title: '報銷原因',
                    input: 'text',
                    inputPlaceholder: "報銷原因",
                    showCancelButton: true,
                    confirmButtonText: '確定報銷',
                    cancelButtonText: "取消",
                    animation: true,
                }).then(function (result) {


                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "/WebService_Equipment.asmx/ChangeState",
                        data: JSON.stringify({
                            id: $('tr.selected').find('td:first').text(),
                            r: result
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            myfunction();
                        }
                    });

                    swal(
                        '報銷成功',
                        '',
                        'success'
                    );

                });
            });

        });

        function myfunction() {

            var arrayReturn = [];
            $.ajax({
                type: "POST",
                url: "/WebService_Equipment.asmx/GetEquipmentCondition",
                async: false,
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    console.log(data.d);
                    $(data.d).each(function () {
                        var Life = ($(this)[0].EquipmentLife).split(',');
                        arrayReturn.push(
                            [
                                $(this)[0].EquipmentID,
                                $(this)[0].EquipmentName,
                                $(this)[0].EquipmentTypeName,
                                $(this)[0].EquipmentDescription,
                                Life[0] + "年" + Life[1] + "月",
                                $(this)[0].Reason,
                                $(this)[0].State == 1 ? '<p style="display:none">1</p><input type="checkbox" disabled="disabled" checked value="1">' : '<p style="display:none">0</p><input type="checkbox" disabled="disabled">'
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

