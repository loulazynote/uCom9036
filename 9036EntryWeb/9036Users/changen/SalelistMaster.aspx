<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="GemBox.Spreadsheet" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
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
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string deve = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "Development"));
            if (deve == "新客戶")
            {
                e.Row.Cells[4].ForeColor = System.Drawing.Color.Red;

            }
        }

    }
    private void BindGridView()
    {
        var db = new Entry9036Entities();
        //var employees = db.Customers;
        var cus = from t in db.Customers
                  where t.SaleID == 1
                  select t;
        GridView1.DataSource = cus.ToList();
        GridView1.DataBind();
    }


    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "add")
        {
            int? n = null;
            int i = Convert.ToInt32(e.CommandArgument);
            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());
            Entry9036Entities db = new Entry9036Entities();
            var r = (from t in db.Customers
                     where t.CusId == key
                     select t).First();
            r.SaleID = 0;
            r.Development = "已開發";
            db.SaveChanges();
            Response.Redirect("~/ChangEn/SalelistMaster.aspx");
        }
        if (e.CommandName == "evaluation")
        {
            int i = Convert.ToInt32(e.CommandArgument);
            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());

            Response.Redirect("~/ChangEn/EvaluationMaster.aspx?id=" + key);
        }
        if (e.CommandName == "readevaluation")
        {
            int i = Convert.ToInt32(e.CommandArgument);
            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());


            Response.Redirect("~/ChangEn/CusEvaluationMasterSale.aspx?id=" + key);
        }
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Response.Redirect("~/ChangEn/SalelistMaster.aspx");
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Customer WHERE (SaleID = 1)", cn);
        DataTable dt = new DataTable("MyTable");
        da.Fill(dt);
        SpreadsheetInfo.SetLicense("FREE-LIMITED-KEY");
        ExcelFile xlsx = new ExcelFile();
        ExcelWorksheet mySheet = xlsx.Worksheets.Add("sheet1");
        mySheet.InsertDataTable(dt,
           new InsertDataTableOptions()
           {
               StartColumn = 2,
               StartRow = 2,
               ColumnHeaders = true
           });
        xlsx.Save(Response, "客戶清單.xlsx");
        //xlsx.Save(Server.MapPath(@"Output\test3.xlsx"));
        //Response.Redirect("~/TestDowload.aspx?filename=Output/test3.xlsx");


    }

    //protected void Button2_Click(object sender, EventArgs e)
    //{
    //    int id = 1;

    //    Response.Redirect("~/ChangEn/FullCalendarMaster.aspx?id=" + id);
    //}
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        BindGridView();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];


        Entry9036Entities db = new Entry9036Entities();
        var cus = (from t in db.Customers
                   where t.CusId == id
                   select t
                        ).First();
        var a = GridView1.Rows[e.RowIndex].Cells[4].FindControl("DropDownList1") as DropDownList;
        string development = a.SelectedValue;
        cus.Development = development;


        db.SaveChanges();
        Response.Redirect("~/ChangEn/SalelistMaster.aspx");
    }

    protected void Button3_Click(object sender, EventArgs e)
    {
        int id = 1;

        Response.Redirect("~/ChangEn/progressBarMaster.aspx?id=" + id);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <link href="scripts/sweetalert2.css" rel="stylesheet" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">

        <h1 style="font-family: Microsoft JhengHei;" class="text-center"><b>我的目標客戶</b></h1>

        <asp:GridView Font-Size="Medium" CssClass="table table-hover table-bordered" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="CusId" OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand" Width="100%" OnRowUpdating="GridView1_RowUpdating" OnRowEditing="GridView1_RowEditing" OnRowCancelingEdit="GridView1_RowCancelingEdit">
            <Columns>
                <asp:BoundField DataField="CusId" HeaderText="客戶ID" ReadOnly="True" SortExpression="CusId">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="CusName" HeaderText="客戶姓名" SortExpression="CusName" ReadOnly="True">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Phone" HeaderText="手機" SortExpression="Phone" ReadOnly="True">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" ReadOnly="True">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="客戶狀態" SortExpression="Development">
                    <EditItemTemplate>
                        <asp:DropDownList ID="DropDownList1" runat="server">
                            <asp:ListItem Value="0">請選擇</asp:ListItem>
                            <asp:ListItem>接洽中</asp:ListItem>
                            <asp:ListItem>已提案待回覆</asp:ListItem>
                            <asp:ListItem>已開發</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Development") %>'></asp:Label>
                    </ItemTemplate>
                    <ControlStyle Width="120px" />
                    <ItemStyle Wrap="False" />
                </asp:TemplateField>
                <asp:ButtonField ControlStyle-CssClass="btn btn-primary" CommandName="add" Text="移至總名單">
                    <ControlStyle CssClass="btn btn-danger"></ControlStyle>
                    <ItemStyle Wrap="False" HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:ButtonField>
                <asp:ButtonField ControlStyle-CssClass="btn btn-primary" CommandName="evaluation" Text="填寫拜訪內容">
                    <ControlStyle CssClass="btn btn-primary"></ControlStyle>
                    <ItemStyle Wrap="False" HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:ButtonField>
                <asp:ButtonField ButtonType="Button" CommandName="readevaluation" Text="查看記錄" ControlStyle-CssClass="btn btn-primary" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Bottom" ItemStyle-Wrap="False" >

<ControlStyle CssClass="btn btn-primary"></ControlStyle>

<ItemStyle HorizontalAlign="Center" VerticalAlign="Bottom" Wrap="False"></ItemStyle>
                </asp:ButtonField>

                <asp:CommandField ShowEditButton="True" ButtonType="Button" CancelText="返回" EditText="編輯" UpdateText="更新">
                    <ControlStyle CssClass="btn btn-info" />
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:CommandField>
            </Columns>
            <HeaderStyle BackColor="#333333" />
        </asp:GridView>
        <div class="btn-group">

            <asp:Button CssClass="btn btn-facebook" ID="Button1" runat="server" OnClick="Button1_Click" Text="輸出此頁面至Excel" OnClientClick="return false" /><%--OnClientClick="return false"--%>
            <%--<asp:Button CssClass="btn btn-twitter" ID="Button2" runat="server" Text="查看我的行程表" OnClick="Button2_Click" />--%>
            <asp:Button CssClass="btn btn-gplus" ID="Button3" runat="server" OnClick="Button3_Click" Text="客戶進度表" />
        </div>







    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
    <script src="scripts/sweetalert2.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#ContentPlaceHolder1_GridView1').DataTable({
                "searching": false,
                "bStateSave": true,//不跳回第一頁
                "language": {
                    "lengthMenu": "顯示 _MENU_ 筆資料",
                    "sSearch": "搜尋:",


                    "oPaginate": {
                        "sPrevious": "上一頁",
                        "sNext": "下一頁",
                    },
                    "info": "目前顯示第 _PAGE_  頁",

                },
                "columnDefs": [
                    { "orderable": false, "targets": 6 }, { "orderable": false, "targets": 5 }, { "orderable": false, "targets": 7 }, { "orderable": false, "targets":8 }                ]
            });
            $("#ContentPlaceHolder1_Button1").click(function () {
                swal({
                    title: '確認?',
                    text: "下載目標客戶清單",
                    type: 'warning',
                    showCancelButton: true,
                }).then(

                    function () {
                        $("#__EVENTTARGET").val("ctl00$ContentPlaceHolder1$Button1");
                        $("#form1").submit();
                    });
            });

        });

    </script>
</asp:Content>

