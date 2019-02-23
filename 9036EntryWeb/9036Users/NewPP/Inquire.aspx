<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!Page.IsPostBack == true)
        //{

        //}
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

 <style>
        /*body{
       font-family:'微軟正黑體';
       
        }*/
        
         
       
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="row">
        <div class="col-sm-12 text-center text-primary">
            <p class="lead">
            <span class="word-rotate highlight active form-control">
                <span class="word-rotate-items"style="font-size:x-large;">
                    <span >9036員工系統</span>
                    <span >搜尋頁面</span>
                    <span >假務系統</span>
                    </span>
            </span>
            </p>
        </div>
    </div>




    <input type="text" id="keyword" value="" placeholder="請輸入名稱" />
    <input type="button" id="btn1" value="搜尋/全員" class="mb-xs mt-xs mr-xs fa fa-search btn btn-warning "  />

    <%--<button id="btn1">
        Search <span class="glyphicon glyphicon-search"></span>
    </button>--%>







    <div style="width: 100%;">
        <table class="table table-striped">
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

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <script src="Scripts/jquery-3.3.1.min.js"></script>
   <%-- <script src="Scripts/bootstrap.min.js"></script>--%>
    <script>

        //收尋功能
        $(function () {
            $("#btn1").click(function () {

                //$("#mytBody").empty();   
                $('table tbody').empty();

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/SelectProducts",
                    data: JSON.stringify({

                        keyword: $("#keyword").val()
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
            });
        });

    </script>
</asp:Content>

