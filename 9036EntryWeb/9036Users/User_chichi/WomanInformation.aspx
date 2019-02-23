<%-- Bootstrap 結合 jQuery 的append方法 --%>

<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title></title>
    <link rel="stylesheet" href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            font-family: "微軟正黑體";
            font-size: 28px;
            line-height: 36px;
            background-image: url("../images/backgroundImage/9.jpg")
        }

        #myTable {
            margin: 0px auto; /*table 至中*/
        }

        .my_th {
            background-color: #666;
        }

        .each_tr {
            /*background-color: #ccc;*/
        }
    </style>
</head>
<body>
    <%--<div class="container">--%>
    <form id="form1" runat="server">
        <%--<input type="button" id="btn" value="submit" />--%>

        <div style="width: 75%;" id="myTable">
            <table class="table table-striped" id="DataTable" >
                <thead>
                    <tr class="my_th">
                        <th>序號</th>
                        <th>相片</th>
                        <th>名稱</th>

                        <th>身高(cm)</th>
                        <th>生日</th>
                        <th>興趣</th>
                        <th>明細</th>

                    </tr>
                </thead>
                <tbody id="mytBody">
                </tbody>
            </table>
        </div>

        <div id="qq">
        </div>
    </form>
    <%--</div>--%>

    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
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
                url: "WebService.asmx/QueryWomanInfo",
                //url: "WebService.asmx/HelloWorld",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {


                        var tr1 = $(`<tr class="each_tr">                                          
                                             <td>${$(this)[0].WId}</td>
                                             <td><img src="/User_chichi/EmployeePhoto.aspx?id=${$(this)[0].WId}" alt="" height='150' width='210' /></td>
                                            <td>${$(this)[0].name}</td>
                                           
                                            <td>${$(this)[0].height}</td>
                                            <td>${$(this)[0].birth}</td>
                                            <td>${$(this)[0].hobby}</td>
                                            <td><a href='Details.aspx?id=${$(this)[0].WId}' class='btn btn-danger btn-lg '>明細</a></td>
                                           
                                        </tr>`);

                        $("#mytBody").append(tr1);
                    });
                }
            });

            $(".each_tr").css("background-color", "#eee");

            //套DataTables並中文化
            $("#DataTable").DataTable(
                {
                    "sPaginationType": "full_numbers",
                    "oLanguage": {
                        "sUrl": "/User_chichi/Scripts/dataTables.Chinese.traditional.txt"
                    }
                });

        });



    </script>
</body>
</html>
