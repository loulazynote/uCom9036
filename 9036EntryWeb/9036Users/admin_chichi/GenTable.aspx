<%-- Bootstrap 結合 jQuery 的append方法 --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>



<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <%--<meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />--%>
    <title></title>
    <link rel="stylesheet" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
    <style>
        body {
            /*background-color: #CCDDFF;*/ /*淡紫色*/
            font-family: "微軟正黑體";
            font-size: 16px;
        }

        #myTable {
            margin: 0px auto; /*table 至中*/
        }

        #btnGaleShapley {
            margin-left: 100px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--<div class="container">--%>

    <%--<input type="button" id="btn" value="submit" />--%>

    <div style="width: 100%;" id="myTable" class="text-center">
        <table class="table mb-none" id="DataTable">
            <thead>
                <tr class="dark">
                    <th class="text-center">序號</th>
                    <th class="text-center">相片</th>
                    <th class="text-center">名稱</th>
                    <th class="text-center">性別</th>
                    <th class="text-center">身高(cm)</th>
                    <th class="text-center">生日</th>
                    <th class="text-center">興趣</th>
                    <th class="text-center">明細</th>
                    <th class="text-center">刪除</th>
                </tr>
            </thead>
            <tbody id="mytBody">
            </tbody>
        </table>
        <input id="btnGaleShapley" type="button" value="執行配對程序" class="btn btn-gplus btn-lg" />
    </div>
    <%--</div>--%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <script>
        $(function () {

            //var td1 = $("<td>").html("...").attr("class" , "abc");
            //var td1 = $("<td>...</td>")
            //$("#qq").append(td1);




            //$("#btn").click(function () {
            //$("#mytable").empty();
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryPerson",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {

                        //1
                        //var td1 = $(`<td>${$(this)[0].Id}</td>`);
                        //var td2 = $(`<td>${$(this)[0].name}</td>`);
                        //var td3 = $(`<td>${$(this)[0].sex}</td>`);
                        //var td4 = $(`<td>${$(this)[0].birth}</td>`);
                        //var tr1 = $("<tr class='success'></tr>");
                        //$(tr1).append(td1).append(td2).append(td3).append(td4);
                        //$("#mytBody").append(tr1);

                        //2
                        var tr1 = $(`<tr class="">                                          
                                             <td>${$(this)[0].Id}</td>
                                             <td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].Id}" alt="" height='50' width='50' /></td>
                                            <td>${$(this)[0].name}</td>
                                            <td>${$(this)[0].sex}</td>
                                            <td>${$(this)[0].height}</td>
                                            <td>${$(this)[0].birth}</td>
                                            <td>${$(this)[0].hobby}</td>
                                            <td><a href='DetailsForManager.aspx?id=${$(this)[0].Id}' class='btn btn-primary btn-lg'>明細</a></td>
                                            <td><input id="${$(this)[0].Id}"  type="button" value="刪除" class="btn btn-danger btn-lg btnDel" /></td>
                                        </tr>`);

                        $("#mytBody").append(tr1);
                    });
                }
            });
            //});

            //套DataTables並中文化
            $("#DataTable").DataTable(
                {
                    "sPaginationType": "full_numbers",
                    "oLanguage": {
                        "sUrl": "/admin_chichi/Scripts/dataTables.Chinese.traditional.txt"
                    }
                });

            //刪除操作
            $(".btnDel").click(function () {

                console.log($(this).attr('id'));
                var userId = $(this).attr('id');

                swal({
                    title: '確認?',
                    text: "檔案即將被刪除!",
                    type: 'warning',
                    showCancelButton: true,
                    //timer:3000
                }).then(
                    function () {
                        //swal('完成!', '執行', 'success');
                        swal({
                            //title: 'Auto close alert!',
                            //text: 'I will close in 3 seconds.',
                            imageUrl: '/admin_chichi/images/check.png',
                            imageWidth: 200,
                            imageHeight: 200,
                            animation: false,
                            timer: 30000
                        }).then(
                            function () {
                                $.ajax({
                                    type: "POST",
                                    async: false,
                                    url: "WebService.asmx/DeletePerson",
                                    data: JSON.stringify({
                                        Id: userId
                                    }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {

                                    }
                                });                                
                                window.location = "Default.aspx";
                            },
                            // handling the promise rejection
                            function (dismiss) {
                                 $.ajax({
                                    type: "POST",
                                    async: false,
                                    url: "WebService.asmx/DeletePerson",
                                    data: JSON.stringify({
                                        Id: userId
                                    }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {

                                    }
                                });                                
                                window.location = "Default.aspx";
                                if (dismiss === 'timer') {
                                    console.log('I was closed by the timer')
                                }
                            }
                        )


                    },
                    function (dismiss) {
                        if (dismiss === 'cancel') {
                            swal('取消', '未執行', 'error')
                        }
                    });

            });

            $("#btnGaleShapley").click(function () {

                swal({
                    title: '確認?',
                    text: "執行演算!",
                    type: 'warning',
                    showCancelButton: true,
                }).then(
                    function () {
                        //swal('完成!', '執行', 'success');
                        swal({
                            title: 'Auto close alert!',
                            text: 'I will close in 3 seconds.',
                            imageUrl: '/admin_chichi/images/running.gif',
                            imageWidth: 400,
                            imageHeight: 200,
                            animation: false,
                            timer: 3000
                        }).then(
                            function () { window.location = "GaleShapley.aspx"; },
                            // handling the promise rejection
                            function (dismiss) {
                                window.location = "GaleShapley.aspx";//導向演算
                                if (dismiss === 'timer') {
                                    console.log('I was closed by the timer')
                                }
                            }
                        )


                    },
                    function (dismiss) {
                        if (dismiss === 'cancel') {
                            swal('取消', '未執行', 'error')
                        }
                    });


            });

        });



    </script>
</asp:Content>

