<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server"> 


    protected void Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
    }

     protected void aa(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/TimeLine_MP_user.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />


    <%--    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link rel="stylesheet" href="/resources/demos/style.css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>--%>


    <%--<link href="Content/bootstrap.css" rel="stylesheet" />--%>

    <style>
        .textStyle {
            border-radius: 5px;
            background-color: saddlebrown;
            color: white;
            display: ruby-text;
            padding: 5px;
        }

        .table-hover > tbody > tr:hover {
            background-color: lightblue;
            /*background-color: yellow;*/
        }

        .title {
            background-color: #CCDDFF; /*淡紫色*/
            font-family: "微軟正黑體";
            font-size: 25px;
            text-align: center;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<script src="Scripts/jquery-1.9.1.js"></script>--%>

    <div class="col-md-2">
    </div>
    <div class="col-md-8 title">
        多條件查詢
    </div>
    <div class="col-md-2">
    </div>
    <br />
    <br />
    <br />


    <div class="row">
        <div class="col-md-2">
        </div>
        <div class="col-md-8">
            <form class="form-horizontal" id="Search">

                <div class="form-group">
                    <label class="col-md-12 control-label" for="account">
                        <a href="#" class="textStyle">標題</a>
                    </label>
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="account" id="title" placeholder="請輸入關鍵字" />
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-12 control-label" for="account">
                        <a href="#" class="textStyle">內文</a>
                    </label>
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="account" id="description" placeholder="請輸入關鍵字" />
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-12 control-label" for="nationality">
                        <a href="#" class="textStyle">發佈單位</a>
                    </label>
                    <div class="col-md-4">
                        <select name="nationality" id="category" class="form-control">
                            <option>請選擇發佈單位</option>
                            <option>團康活動</option>
                            <option>部門公告</option>
                            <option>人事派令</option>
                            <option>公司表單</option>
                            <option>團購活動</option>
                            <option></option>
                        </select>
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-12 control-label" for="nationality">
                        <a href="#" class="textStyle">公告日期區間</a>
                    </label>
                    <div class="col-md-4">
                        <input type="text" class="datepicker form-control" id="date1" placeholder="選擇起始日期" onchange="getDate(event)" />
                    </div>
                    <div class="col-md-4">
                        <input type="text" class="datepicker form-control" id="date2" placeholder="選擇結束日期" onchange="getDate(event)" />
                    </div>
                    <div class="col-md-4">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-4">
                        <button class="btn btn-success btn-search" type="reset" onclick="aa()">
                            查詢<i class="fas fa-search"></i>
                        </button>
                        <asp:LinkButton ID="LinkButton1" runat="server" OnClick="Back_Click" class="btn btn-warning">
                            返回主頁<i class="fas fa-undo-alt"></i>
                        </asp:LinkButton>

                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
                <hr />
                <div class="form-group">
                    <div class="col-md-4">
                        <asp:LinkButton ID="LinkButton2" runat="server" OnClick="aa" class="btn btn-success btn-search">
                            時間軸查詢
                        </asp:LinkButton>
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>

            </form>
        </div>
        <div class="col-md-2">
        </div>

    </div>





</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">


    <script>    
        function aa(e) {
            // e.preventDefault();
            console.log(e);

            var str = "";
            var title = document.getElementById('title').value;
            var description = document.getElementById('description').value;
            var category = document.getElementById('category').value;

            var date1 = document.getElementById('date1').value;
            var date2 = document.getElementById('date2').value;

            //var category = $('#category').value;
            console.log(date1);
            console.log(date2);
            if (title != "") {
                str += "title=" + title + "&";
            }
            if (description != "") {
                str += "description=" + description + "&";
            }
            if (date1 != "") {
                str += "date1=" + date1 + "&";
            }
            if (date2 != "") {
                str += "date2=" + date2 + "&";
            }
            if (category != "請選擇發佈單位") {
                str += "category=" + category + "&";
            }
            str = str.substring(0, str.lastIndexOf('&'));
            if (str != "") {
                window.location.href = "../Joshua/SearchBulletin2_MP_user.aspx?" + str;
            }

        }


        $(function () {
            $(".datepicker").datepicker();

        });

        function getDate(e) {
            //console.log(e, e.target.value)
            var a = e.target.value
            //console.log(a)
            var b = a.split("/")
            var c = b[2] + b[0] + b[1]
            var d = []
            d[0] = b[2]
            d[1] = b[0]
            d[2] = b[1]
            console.log(d)
            d[1] = Number(d[1])
            d[2] = Number(d[2])
            var ddd = d.join("/")
            //console.log(ddd)
            e.target.value = ddd
        }


    </script>


</asp:Content>

