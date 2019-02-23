<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            string id = Request.QueryString["id"].ToString();
            //int id = 1;
            this.txt1.Value = id.ToString();
        }

    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            //add the thead and tbody section programatically
            e.Row.TableSection = TableRowSection.TableHeader;
        }


    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/TeamMenberMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <style>
        tr {
        background-color:#333333;
        font-size:16px;
        }
    </style>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<asp:HiddenField ID="HiddenField1" runat="server" />--%>
    <input type="text" runat="server" id="txt1" name="txt1" value="" hidden="hidden" />
    <%--<input type="button" id="btn" value="submit" />--%>
    <div class="container">
        <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>業務訂單總覽</B></h1>
        <br />
        <table id="GridView1" class="table table-bordered table-hover">
            <thead>
                <tr id="head">
                    <td>業務ID</td>
                    <td>業務姓名</td>
                    <td>訂單金額</td>
                    <td>訂單編號</td>
                    <td>訂單日期</td>
                </tr>
            </thead>
            <tbody id="mytBody">
            </tbody>
        </table>
        <asp:Button CssClass="btn btn-twitter" ID="Button2" runat="server" Text="返回" OnClick="Button2_Click" />
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
    <script>
        $(document).ready(function () {
            //$("#btn").click(function () {
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/GetTeamList",
                data: JSON.stringify({
                    keyword: $("#ContentPlaceHolder1_txt1").val()
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    $(data.d).each(function () {

                        //1
                        //var td1 = $(`<td>${$(this)[0].ProductID}</td>`);
                        //var td2 = $(`<td>${$(this)[0].ProductName}</td>`);
                        //var td3 = $(`<td>${$(this)[0].UnitPrice}</td>`);
                        //var tr1 = $("<tr class='success'></tr>");
                        //$(tr1).append(td1).append(td2).append(td3);
                        //$("#mytBody").append(tr1);

                        //2
                        var tr1 = $(`<tr >
                                            <td>${$(this)[0].SaleID}</td>
                                            <td>${$(this)[0].SaleName}</td>
                                            <td>${$(this)[0].OrderAmount}</td>
                                             <td>${$(this)[0].OrderID}</td>
                                             <td>${$(this)[0].OrderDate}</td>
                                        </tr>`);

                        $("#mytBody").append(tr1);
                    });
                }
            });
            //});

            $('#GridView1').DataTable({
                "searching": false,
                "language": {
                    "lengthMenu": "顯示 _MENU_ 筆資料",
                    "oPaginate": {
                        "sPrevious": "上一頁",
                        "sNext": "下一頁",
                    },
                    "info": "目前顯示第 _PAGE_  頁",

                }

            });
        });

    </script>
</asp:Content>

