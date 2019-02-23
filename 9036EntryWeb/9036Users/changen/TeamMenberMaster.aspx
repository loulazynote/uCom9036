<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            Chart();
            BindGridView();

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
    private void BindGridView()
    {
        var db = new Entry9036Entities();


        var cus = from t in db.Sales
                  join o in db.Orderinformations on t.SaleID equals o.SaleID
                  
                  select new { t.SaleID, t.SaleName, o.OrderAmount, t.Email };
        var cus1 = from c in cus
                   group c by c.SaleID;
        var cus2 = cus1.Select(cl => new MyOrder
        {
            SaleID = cl.FirstOrDefault().SaleID,
            OrderCounts = cl.Count().ToString(),
            SaleName = cl.FirstOrDefault().SaleName,
            OrderAmount = cl.Sum(c => c.OrderAmount),
            Email = cl.FirstOrDefault().Email
        }).ToList();
        GridView1.DataSource = cus2.ToList();
        GridView1.DataBind();
    }
    private void Chart()
    {
        var db = new Entry9036Entities();
        var cus = from t in db.Sales
                  join o in db.Orderinformations on t.SaleID equals o.SaleID
                  where t.SaleID > 0
                  select new { t.SaleID, t.SaleName, o.OrderAmount };
        var cus1 = from c in cus
                   group c by c.SaleID;
        var cus2 = cus1.Select(cl => new MyOrder
        {
            SaleName = cl.FirstOrDefault().SaleName,
            OrderAmount = cl.Sum(c => c.OrderAmount),
        }).ToList();

        var SaleName = cus2.Select(p => p.SaleName).ToArray();
        var OrderAmount = cus2.Select(p => p.OrderAmount).ToArray();

        HiddenField1.Value = string.Join(",", SaleName);
        HiddenField2.Value = string.Join(",", OrderAmount);
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "email")
        {
            int i = Convert.ToInt32(e.CommandArgument);
            string key = GridView1.Rows[i].Cells[4].Text.ToString();

            Response.Redirect("~/ChangEn/SentEmailMaster.aspx?email=" + key);
        }
        if (e.CommandName == "orderlist")
        {
            int i = Convert.ToInt32(e.CommandArgument);
            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());

            Response.Redirect("~/ChangEn/TeamMenberListMaster.aspx?id=" + key);
        }
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Response.Redirect("~/ChangEn/SalelistMaster.aspx");
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
    }


    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/FullCalendarAdminMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">

        <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>業務員業績總表</B></h1>

        <asp:GridView Font-Size="Medium" CssClass="table table-bordered table-hover" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="SaleID" OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="SaleID" HeaderText="業務ID" ReadOnly="True" SortExpression="SaleID" />
                <asp:BoundField DataField="SaleName" HeaderText="業務姓名" SortExpression="SaleName" />
                <asp:BoundField DataField="OrderCounts" HeaderText="達成訂單筆數" SortExpression="OrderCounts" />
                <asp:BoundField DataField="OrderAmount" HeaderText="訂單金額" SortExpression="OrderAmount" />
                <asp:BoundField DataField="Email" HeaderText="E-Mail" SortExpression="Email" />

                <asp:ButtonField  CommandName="orderlist" Text="業績詳情">
                    <ControlStyle CssClass="btn btn-primary"></ControlStyle>
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:ButtonField>
                <asp:ButtonField  CommandName="email" Text="發送信件">
                    <ControlStyle CssClass="btn btn-primary"></ControlStyle>
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:ButtonField>
            </Columns>
            <HeaderStyle BackColor="#333333" />
        </asp:GridView>
        <div class="btn-group">
        
        <%--<asp:Button CssClass="btn btn-twitter" ID="Button2" runat="server" Text="查看組員行程表" OnClick="Button2_Click" />--%>
            </div>
        <div style="width: 100%;">
            <canvas id="myChart"></canvas>
        </div>
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <asp:HiddenField ID="HiddenField2" runat="server" />


    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="scripts/Chart.min.js"></script>

    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>


    <script>
        $(document).ready(function () {
            $('#ContentPlaceHolder1_GridView1').DataTable({
                "searching": false,
                "language": {
                    "lengthMenu": "顯示 _MENU_ 筆資料",
                    "oPaginate": {
                        "sPrevious": "上一頁",
                        "sNext": "下一頁",
                    },
                    "info": "目前顯示第 _PAGE_  頁",

                },
                "columnDefs": [
                    { "orderable": false, "targets": 6 }, { "orderable": false, "targets": 5 }
                ]
            });
            var ctx = document.getElementById("myChart");
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: document.getElementById("ContentPlaceHolder1_HiddenField1").value.split(","),
                    datasets: [{
                        label: '業績總額',
                        data: document.getElementById("ContentPlaceHolder1_HiddenField2").value.split(","),
                        borderWidth: 1,
                        backgroundColor: 'lightblue'
                    }]
                },
                options: {
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            }
                        }]
                    }
                }
            });
        });


    </script>
</asp:Content>

