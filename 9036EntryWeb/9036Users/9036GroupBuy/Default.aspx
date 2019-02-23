<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Script.Services" %>

<script runat="server">


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            groupbuylocal.WebService ww = new groupbuylocal.WebService();
            ww.Update();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                #region MyRegion
                DataSet ds = new DataSet();
                SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM groupList INNER JOIN Employees ON Employees.EmployeeID = groupList.EmployeeID where deadline > getdate() order by groupId Desc", con);
                cm.Fill(ds);
                GridView1.DataSource = ds;
                GridView1.DataBind();
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    System.Web.UI.WebControls.Label textbox = (System.Web.UI.WebControls.Label)GridView1.Rows[i].Cells[4].FindControl("Label1");
                    if (textbox.Text == "未成團" || textbox.Text == "已結標")
                    {
                        HyperLink b = ((HyperLink)GridView1.Rows[i].Cells[5].FindControl("HyperLink1"));
                        b.Visible = false;
                    }
                    if (textbox.Text == "已成團")
                    {
                        textbox.ForeColor = Color.Red;
                        textbox.Font.Bold = true;
                        textbox.BackColor = Color.Yellow;
                    }
                }
                #endregion
            };
        };
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        HiddenField1.Value = "false";
        DataTable data = new DataTable();
        string Type = DropDownList1.SelectedValue;
        string qs = TextBox1.Text;
        string queryString = "";
        queryString = "SELECT * FROM groupList INNER JOIN Employees ON Employees.EmployeeID = groupList.EmployeeID WHERE " + Type + " like N'%' + @SEARCH + '%' order by groupId Desc";

        if (!string.IsNullOrEmpty(qs))
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                DataSet aa = new DataSet();
                SqlDataAdapter cm = new SqlDataAdapter(queryString, con);
                cm.SelectCommand.Parameters.AddWithValue("@SEARCH", qs);

                cm.Fill(aa);
                GridView1.DataSource = aa;
                GridView1.DataBind();
                groupbuylocal.WebService ww = new groupbuylocal.WebService();
                ww.Update();

                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    System.Web.UI.WebControls.Label textbox = (System.Web.UI.WebControls.Label)GridView1.Rows[i].Cells[4].FindControl("Label1");
                    if (textbox.Text == "未成團" || textbox.Text == "已結標")
                    {
                        HyperLink b = ((HyperLink)GridView1.Rows[i].Cells[5].FindControl("HyperLink1"));
                        b.Visible = false;
                    }
                    if (textbox.Text == "已成團")
                    {
                        textbox.ForeColor = Color.Red;
                        textbox.Font.Bold = true;
                        textbox.BackColor = Color.Yellow;
                    }
                }

                if (GridView1.Rows.Count == 0)
                {
                    HiddenField1.Value = "true";
                }
            };
        }
        else
        {
            HiddenField1.Value = "true";
        }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        getData(); //取資料  
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            System.Web.UI.WebControls.Label textbox = (System.Web.UI.WebControls.Label)GridView1.Rows[i].Cells[4].FindControl("Label1");
            if (textbox.Text == "未成團" || textbox.Text == "已結標")
            {
                HyperLink b = ((HyperLink)GridView1.Rows[i].Cells[5].FindControl("HyperLink1"));
                b.Visible = false;
            }
            if (textbox.Text == "已成團")
            {
                textbox.ForeColor = Color.Red;
                textbox.Font.Bold = true;
                textbox.BackColor = Color.Yellow;
            }
        }

    }
    public void getData()
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            DataSet ds = new DataSet();
            SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM groupList INNER JOIN Employees ON Employees.EmployeeID = groupList.EmployeeID where deadline > getdate()  order by groupId Desc", con);
            cm.Fill(ds, "Data");
            GridView1.DataSource = ds.Tables["Data"];
            GridView1.DataBind();
            groupbuylocal.WebService ww = new groupbuylocal.WebService();
            ww.Update();

        }
    }


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="Stylesheet" type="text/css" />
    <style>
        div {
            font-family: Times New Roman,'微軟正黑體';
            font-size: 18px;
        }

        .mycenter {
            text-align: center;
        }

        .aa {
            font-size: 16px;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>

        $(function () {
            //$("#Button_1").click(function () {
            if ($("#ContentPlaceHolder1_HiddenField1").val() == "true") {
                swal({
                    title: '找不到資料!',
                    type: 'error',
                    confirmButtonText: 'OK'
                });
                //});
            }

        });
    </script>
    <div class="col-lg-12 ">
        <asp:Label runat="server" CssClass="h1" Text="團單總覽"></asp:Label>
        <br />
        <br />

        <div class="col-lg-6">
            <ul class="nav nav-pills nav-pills-success">
                <li class="active"><a href="Default.aspx">去跟團</a></li>
                <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
                <li class="active"><a href="grouplist.aspx">團單管理</a></li>
                <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
                <li class="active"><a href="Chart.aspx">圖表生成</a></li>

            </ul>
            <br />
            <asp:HiddenField ID="HiddenField1" runat="server" Value="false" />
        </div>
        <div class="col-lg-6 form-inline">
            <div id="aaa" class="form-group col-lg-12" style="vertical-align: top">
                <asp:DropDownList CssClass="dropdown col-lg-offset-5 aa" ID="DropDownList1" runat="server">
                    <asp:ListItem Value="groupList.ProductName" Text="產品名稱"></asp:ListItem>
                    <asp:ListItem Value="Employees.Name" Text="開團者姓名"></asp:ListItem>
                </asp:DropDownList>
                <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:Button ID="Button1" runat="server" Text="搜尋" CssClass="btn btn-danger " OnClick="Button1_Click" />
                <br />
                <br />
            </div>
        </div>
    </div>
    <hr />
    <div id="divAll" class="col-lg-12 ">
        <asp:GridView ID="GridView1" runat="server" CssClass="table" OnPageIndexChanging="GridView1_PageIndexChanging" PageSize="5" AllowPaging="True" AutoGenerateColumns="False" HeaderStyle-CssClass="bg-info" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" FooterStyle-Wrap="True" EditRowStyle-VerticalAlign="Middle" EditRowStyle-HorizontalAlign="NotSet" PagerStyle-HorizontalAlign="Center" PagerStyle-VerticalAlign="Middle" RowStyle-VerticalAlign="Middle" PagerStyle-CssClass="h3" PagerSettings-PreviousPageText="上一頁" PagerSettings-LastPageText="最後一頁" PagerSettings-NextPageText="下一頁" PagerSettings-FirstPageText="第一頁" PagerSettings-Mode="Numeric" AllowCustomPaging="False" EnableSortingAndPagingCallbacks="False">
            <Columns>
                <asp:ImageField DataImageUrlField="ImgUrl" ControlStyle-CssClass="img-rounded" HeaderStyle-CssClass="col-lg-2" FooterStyle-VerticalAlign="NotSet" FooterStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" DataImageUrlFormatString='..\Images\{0}'>
                    <ControlStyle CssClass="img-rounded" Width="100%"></ControlStyle>

                    <FooterStyle HorizontalAlign="Center"></FooterStyle>

                    <HeaderStyle CssClass="col-lg-1 mycenter"></HeaderStyle>

                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                </asp:ImageField>
                <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="NotSet" SortExpression="groupId">
                    <HeaderTemplate>標題</HeaderTemplate>
                    <ItemTemplate>
                        <asp:HyperLink runat="server" NavigateUrl='<%# "Products.aspx?id="+Eval("groupId") %>' Text='<%#"#"+Eval("groupId")+ Eval("ProductName") %>'></asp:HyperLink>
                    </ItemTemplate>
                    <HeaderStyle CssClass="col-lg-3 mycenter" HorizontalAlign="NotSet" VerticalAlign="Middle" />
                </asp:TemplateField>
                <asp:BoundField DataField="DeadLine" HeaderText="截標時間" SortExpression="DeadTime" ItemStyle-BorderStyle="NotSet" ItemStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:yyyy/MM/dd}">
                    <HeaderStyle CssClass="col-lg-2 mycenter"></HeaderStyle>

                    <ItemStyle VerticalAlign="Middle"></ItemStyle>
                </asp:BoundField>

                <asp:BoundField DataField="Name" HeaderText="開團者" SortExpression="Name" HeaderStyle-CssClass="col-lg-1">
                    <HeaderStyle CssClass="col-lg-2 mycenter"></HeaderStyle>
                </asp:BoundField>
                <asp:BoundField DataField="Price" HeaderText="價格" SortExpression="Price" HeaderStyle-CssClass="col-lg-1">
                    <HeaderStyle CssClass="col-lg-1 mycenter"></HeaderStyle>
                </asp:BoundField>

                <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="NotSet" ItemStyle-HorizontalAlign="Center" SortExpression="State">
                    <HeaderTemplate>團單狀態</HeaderTemplate>
                    <ItemTemplate>
                        <div id="aa">
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("State") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="col-lg-2 mycenter" HorizontalAlign="NotSet" VerticalAlign="Middle" />
                </asp:TemplateField>

                <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="NotSet" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:HyperLink CssClass="btn btn-danger " ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("GroupId", "shopping.aspx?Mode=Insert&groupid={0}") %>' Text="我要跟團"></asp:HyperLink>
                    </ItemTemplate>
                    <HeaderStyle CssClass="col-lg-2 mycenter" HorizontalAlign="NotSet" VerticalAlign="Middle" />
                </asp:TemplateField>
            </Columns>

            <HeaderStyle CssClass="bg-info mycenter"></HeaderStyle>

        </asp:GridView>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ContentPlaceHolder1_TextBox1").autocomplete({
                source: function (request, response) {
                    var a = $("#ContentPlaceHolder1_DropDownList1").val();
                    $.ajax({
                        url: "/9036GroupBuy/WebService.asmx/GetNames",
                        //data: "{ 'prefixText': '" + request.term + "' }",
                        data: "{ 'prefixText': '" + request.term + "','dds': '" + a + "' }",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return { value: item }
                            }))
                        },
                    });
                },
                minLength: 1
            });
        });

        //$(document).load(function () {
        //    $.ajax({
        //        url: "/9036GroupBuy/WebService.asmx/Update",
        //        type: "POST",
        //    });
        //});
    </script>

</asp:Content>

