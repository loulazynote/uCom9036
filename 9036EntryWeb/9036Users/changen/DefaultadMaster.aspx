<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

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
    }
    private void BindGridView()
    {
        var db = new Entry9036Entities();
        //var employees = db.Customers;
        var cus = from t in db.Customers
                  join o in db.Sales on t.SaleID equals o.SaleID
                  select new { t.CusId, t.CusName, t.Phone, t.Email,o.SaleName};
        GridView1.DataSource = cus.ToList();
        GridView1.DataBind();
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = (int)e.Keys[0];

        var db = new Entry9036Entities();
        Customer r = (from t in db.Customers
                      where t.CusId == id
                      select t
                  ).SingleOrDefault();
        db.Customers.Remove(r);
        db.SaveChanges();
        Response.Redirect("~/ChangEn/DefaultadMaster.aspx");
    }




    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        BindGridView();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];
        string name = e.NewValues[0].ToString();
        string phone = e.NewValues[1].ToString();
        string email = e.NewValues[2].ToString();


        Entry9036Entities db = new Entry9036Entities();
        var cus = (from t in db.Customers
                   where t.CusId == id
                   select t
                        ).First();
        cus.CusName = name;
        cus.Phone = phone;
        cus.Email = email;

        db.SaveChanges();
        Response.Redirect("~/ChangEn/DefaultadMaster.aspx");
    }


    //protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "addcus")
    //    {int id =(int)e.
    //        Entry9036Entities db = new Entry9036Entities();


    //    }
    //}




    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "add")
        {
            int i = Convert.ToInt32(e.CommandArgument);

            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());
            Entry9036Entities db = new Entry9036Entities();
            var r = (from t in db.Customers
                     where t.CusId == key
                     select t).First();
            r.SaleID = 1;
            db.SaveChanges();
            Response.Redirect("~/ChangEn/DefaultadMaster.aspx");
        }
        if (e.CommandName == "evaluation")
        {
            int i = Convert.ToInt32(e.CommandArgument);
            int key = int.Parse(GridView1.DataKeys[i].Value.ToString());


            Response.Redirect("~/ChangEn/cusEvaluationMaster.aspx?id=" + key);
        }
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Response.Redirect("~/ChangEn/DefaultadMaster.aspx");
    }

    //protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
    //    GridView1.PageIndex = e.NewPageIndex;
    //    BindGridView();
    //}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">

        <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>公司客戶總清單</B></h1>
        <asp:GridView CssClass="table table-hover table-bordered" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="CusId" OnRowDataBound="GridView1_RowDataBound" OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCommand="GridView1_RowCommand" OnRowCancelingEdit="GridView1_RowCancelingEdit"  Font-Size="Medium">
            <Columns>
                <asp:BoundField DataField="CusId" HeaderText="客戶編號" ReadOnly="True" SortExpression="CusId" />
                <asp:BoundField DataField="CusName" HeaderText="客戶姓名" SortExpression="CusName" >
                <ControlStyle Width="70px" />
                </asp:BoundField>
                <asp:BoundField DataField="Phone" HeaderText="手機" SortExpression="Phone" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                 <asp:BoundField DataField="SaleName" HeaderText="負責業務姓名" SortExpression="SaleName" />
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" CommandName="Delete" OnClientClick="return confirm('確定刪除此客戶?')" Text="刪除"></asp:LinkButton>
                    </ItemTemplate>
                    <ControlStyle CssClass="btn btn-danger" />
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:TemplateField>
                <asp:CommandField ControlStyle-CssClass="btn btn-success" ShowEditButton="True" CancelText="返回" EditText="編輯" UpdateText="更新" ButtonType="Button">
                    <ControlStyle CssClass="btn btn-success"></ControlStyle>
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:CommandField>
            </Columns>

            <HeaderStyle BackColor="#333333"></HeaderStyle>
        </asp:GridView>
        <br />


    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>

    <script>
        $(document).ready(function () {
            $('#ContentPlaceHolder1_GridView1').DataTable({
                "searching": true,
                //"serverSide":true, 
                "bStateSave": true,//不跳回第一頁
                "columnDefs": [
                    { "orderable": false, "targets": 5 }, { "orderable": false, "targets": 6 }
                ],
                "language": {
                    "lengthMenu": "顯示 _MENU_ 筆資料",
                    "sSearch": "搜尋:",
                    
                    
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

