<%--檢視男女邀約情況--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>



<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            //HiddenField1.Value = human.Id.ToString();
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%-- <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />--%>
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

        #btnCollectInfo {
            border-radius: 5px;
            margin-left: 500px;
            margin-top: 10px;
            /*background-color: #222;
            color: white;*/
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <asp:HiddenField ID="HiddenField1" runat="server" />
    <h1>約會狀況</h1>
    <div style="width: 100%;" id="myTable">
        <table class="table mb-none" id="DataTable">
            <thead>
                <tr class="btn-dark">
                    <th>流水號</th>
                    <th>男方Id</th>
                    <th>男方照片</th>
                    <th>女方照片</th>
                    <th>女方Id</th>
                    <th>約會地點</th>
                    <th>狀態</th>
                </tr>
            </thead>
            <tbody id="mytBody">
            </tbody>
        </table>
    </div>

    <input id="btnCollectInfo" type="button" value="匯集數據" class="btn btn-primary btn-lg" />
    <div id="result">
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

  <%--  <script src="../Scripts/jquery-3.1.1.js"></script>
    <script src="../Scripts/bootstrap.js"></script>--%>
    <script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    <script>
        $(function () {
            var sex = $("#HiddenField1").val();
            console.log(sex);

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryDatingResult",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {

                        var tr1 = $(`<tr class="">                                          
                                             <td>${$(this)[0].Id}</td>                                         
                                            <td>${$(this)[0].MId}</td>
                                            <td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].MId}" alt="" height='90' width='120' class='img-circle'/></td>
                                            <td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].WId}" alt="" height='90' width='120' class='img-circle'/></td>
                                            <td>${$(this)[0].WId}</td>                                                                                
                                            <td>${$(this)[0].place}</td>
                                            <td>${$(this)[0].status}</td>                                         
                                        </tr>`);

                        $("#mytBody").append(tr1);
                    });
                }
            });

            //套DataTables並中文化
            $("#DataTable").DataTable(
                {
                    "sPaginationType": "full_numbers",
                    "oLanguage": {
                        "sUrl": "/admin_chichi/Scripts/dataTables.Chinese.traditional.txt"
                    }
                });



            //收集數據
            $("#btnCollectInfo").click(function () {
                swal({
                    title: '確認?',
                    text: "彙整數據!",
                    type: 'warning',
                    showCancelButton: true,
                }).then(
                    function () {
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "WebService.asmx/ProduceStatistics", //製作統計圖
                            data: JSON.stringify({

                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                console.log("kk");
                                $("#result").html(data.d);
                            }
                        });

                        swal('完成!', '數據已彙整', 'success')
                    },
                    function (dismiss) {
                        if (dismiss === 'cancel') {
                            swal('取消', '數據未彙整', 'error')
                        }
                    });



                //window.location = "../Default.aspx";
            });
        });
    </script>
</asp:Content>
