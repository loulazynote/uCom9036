<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<script runat="server">

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

    <%--<input type="button" id="btn" value="submit" />--%>

    <div class="row">
        <div class="col-sm-12 text-center text-primary ">
            <h1>未審核假單</h1>
        </div>
    </div>
    <%--class="mb-xs mt-xs mr-xs btn btn-primary"--%>
    <%-- <a class=" mb-xs mt-xs mr-xs btn btn-lg btn btn-primary " href="../Manger.aspx">返回上頁</a>--%>

    <div style="width: 100%;" class="row col-sm-12 text-center">

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
                    <table class="table table-bordered mb-none table-hover" id="table1">
                        <thead>
                            <tr class="dark">
                                <td>勾選</td>
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
                                <td>編輯</td>
                            </tr>
                        </thead>
                        <tbody id="mytBody">
                        </tbody>
                    </table>
                </div>
                <%--::after--%>
            </div>
        </section>

        <input type="hidden" id="btnHid" />
        <input type="button" id="btnPass" value="通過" onclick="" class="mb-xs mt-xs mr-xs btn btn-primary" />
        <input type="button" id="btnNo" value="不通過" class="mb-xs mt-xs mr-xs btn btn-danger" />
        <hr />

        <div class="row">
            <div class="col-sm-12 text-center text-success">
                <h1><small>審核</small>通過假單</h1>
            </div>
        </div>
        <div class="panel-body">
            <div class="table-resopnsive">
                <table class="table table-bordered mb-none table-hover " id="table2">
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
                    <tbody id="mytBody1">
                    </tbody>
                </table>
            </div>
        </div>
        <hr />
        <div class="row">
            <div class="col-sm-12 text-center text-danger">
                <h1><small>審核</small>不通過假單</h1>
            </div>
        </div>


        <div class="panel-body">
            <div class="table-resopnsive">
                <table class="table table-bordered mb-none table-hover " id="table3">
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
                    <tbody id="mytBody2">
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    <%--彈跳視窗modal--%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title text text-info">回覆訊息</h4>
                </div>
                <div class="modal-body">
                    <p>
                        回覆內容 :
                        <%--                            <input id="Text1" type="text" style="width:50%;line-height:70px;text-align:start;" />--%>
                        <textarea id="Text1" class="form-control"></textarea>
                    </p>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-danger" data-dismiss="modal">返回</button>
                    <input type="button" id="btnsumbit" data-dismiss="modal" class="btn btn-success" onclick="myArrayEdit()" value="確定修改" />
                    <%--裡面加了data-dismiss="modal" 自動關閉--%>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <link href="Scripts/sweetalert2.min.css" rel="stylesheet" />

    <script src="Scripts/sweetalert2.min.js"></script>

    <script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

    <script>
        //針對aa跟mybody 創兩個參數給他
        function myfunction(status, mybody) {
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryEmployess",
                data: JSON.stringify({
                    aa: status
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    $(data.d).each(function () {
                        if (status == "未審核") {  //生成表格 對條件"未審核" 第一個表格

                            var tr1 = $(`<tr class="info">
                                            <td><input data-id="${$(this)[0].Id}" class="bb" type="checkbox" /></td>
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
                                            <td><input class="btn btn-warning" type="Button" id="btnEdit" value="回復備註" onclick='myfun2(${$(this)[0].Id},"${$(this)[0].Replay}")'/></td>
                                        </tr>`);
                            //"${$(this)[0].Replay}" 轉型成字串
                        }
                        else {

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
                        }
                        $("#" + mybody).append(tr1);
                    });
                }
            });
        }


        //創一個通過的方法
        function myArrayPass() {  //通過陣列 判斷是否有勾選  
            var ary = new Array();
            $(".bb").each(function () {
                if ($(this).is(":checked") == true)
                    ary.push($(this).attr("data-id")
                    );
                /*console.log(ary);*/  //測試結果
            });

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/UpdateEmployess",
                data: JSON.stringify({
                    aa: ary.toString()  //轉換成字串 
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

                        $("#" + mybody).append(tr1);
                    });
                }
            });
        }

        //不通過
        function myArrayDelete() {  //通過陣列 判斷是否有勾選 
            var ary = new Array();
            $(".bb").each(function () {
                if ($(this).is(":checked") == true)
                    ary.push($(this).attr("data-id"));
                /*console.log(ary);*/  //測試結果
            });



            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/DeleteEmployess",
                data: JSON.stringify({
                    aa: ary.toString()  //轉換成字串 
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

                        $("#" + mybody).append(tr1);
                    });
                }
            });
        }



        function myArrayEdit() {  //編輯修改 
            var ary = new Array();
            ary.push($('#btnHid').val()),
                ary.push($('#Text1').val());
            //alert(ary);    //test
            //console.log(ary);

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/EditEmployess",
                data: JSON.stringify({
                    cc: ary.toString()  //轉換成字串 
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {   //伺服器如果是 void回傳值 就不用在跑下面程式
                    //$("#myModal").modal("hide");
                    //$(data.d).each(function () {

                    //    var tr1 = $(`<tr class="info">

                    //                        <td>${$(this)[0].Id}</td>
                    //                        <td>${$(this)[0].EmpId}</td>
                    //                        <td>${$(this)[0].Starttime}</td>
                    //                        <td>${$(this)[0].Overtime}</td>
                    //                        <td>${$(this)[0].Event}</td>
                    //                        <td>${$(this)[0].Hour}</td>
                    //                        <td>${$(this)[0].Result}</td>
                    //                        <td>${$(this)[0].Content}</td>
                    //                        <td>${$(this)[0].Replay}</td>
                    //                        <td>${$(this)[0].Nowdate}</td>
                    //                        <td>${$(this)[0].Department}</td>

                    //                    </tr>`);

                    //    $("#" + mybody).append(tr1);
                    //});
                }
            });
        }


        //彈跳視窗 modal
        function myfun2(myId, myReplay) {
            $('#btnHid').val(myId);
            $('#Text1').val(myReplay);

            //$("#btnEdit").click(function () {
            //    //$("#myModal").modal();
            $("#myModal").modal("show");
            //});

            //$("#butclose").click(function () {

            //    alert("Hello..." + $("#Text1").val());
            //    $("#myModal").modal("hide");

            //});

        }




        $(function () {


            //$("#btn").click(function () {
            //$("#mytable").empty();
            myfunction("未審核", "mytBody");
            
            myfunction("通過", "mytBody1");
           

            myfunction("不通過", "mytBody2");
           
            //});

            //通過
            $("#btnPass").click(function () {
                if ($('.bb').is(":checked") == true) {
                    myArrayPass();
                    $('table tbody').empty();

                    myfunction("未審核", "mytBody");

                    myfunction("通過", "mytBody1");

                    myfunction("不通過", "mytBody2");


                }
                else {

                    swal(
                        '錯誤',
                        '左方請先勾選通過假單!', 'error'
                    );

                }
            });
            //不通過
            $("#btnNo").click(function () {
                if ($('.bb').is(":checked") == true) {
                    myArrayDelete();
                    $('table tbody').empty();


                    myfunction("未審核", "mytBody");

                    myfunction("通過", "mytBody1");

                    myfunction("不通過", "mytBody2");

                }
                else {

                    swal(
                        '錯誤',
                        '左方請先勾選不通過假單!', 'error'
                    );

                }
            });
            //編輯修改
            $("#btnsumbit").click(function () {
                myfun2();
                $('table tbody').empty();

                myfunction("未審核", "mytBody");

                myfunction("通過", "mytBody1");

                myfunction("不通過", "mytBody2");


            });

        

        //測試
        //$("#btnEdit").click(function () {
        ////    //$("#myModal").modal();
        //    $("#myModal").modal("show");
        //});

        //$("#butclose").click(function () {

        //    alert("Hello..." + $("#Text1").val());
        //    $("#myModal").modal("hide");

        //});

       
            $('#table1').DataTable({
            "sPaginationType": "full_numbers",
            "oLanguage": {
                "sUrl": "../NewPP/script/dataTables.Chinese.traditional.txt"
            }
            });
                     $('#table2').DataTable({
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sUrl": "../NewPP/script/dataTables.Chinese.traditional.txt"
                }
            });
                     $('#table3').DataTable({
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sUrl": "../NewPP/script/dataTables.Chinese.traditional.txt"
                }
            });

        });

    </script>

</asp:Content>

