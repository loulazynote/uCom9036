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
                  where t.Development == null
                  select t;
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
        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
    }

    //protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    //{
    //    int id = (int)e.Keys[0];
    //    string name = e.NewValues[0].ToString();
    //    string email = e.NewValues[1].ToString();



    //    Entry9036Entities db = new Entry9036Entities();
    //    var customer = (from t in db.Customers
    //                    where t.CusId == id
    //                    select t
    //                    ).First();
    //    customer.CusName = name;
    //    customer.Email = email;

    //    db.SaveChanges();
    //}


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
        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
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
        //if (e.CommandName == "add")
        //{
        //    int i = Convert.ToInt32(e.CommandArgument);
        //    int key = int.Parse(GridView1.DataKeys[i].Value.ToString());

        //    Entry9036Entities db = new Entry9036Entities();
        //var r = (from t in db.Customers
        //         where t.CusId == key
        //         select t).First();
        //r.SaleID = Convert.ToInt32(DropDownList2.SelectedItem.Value);

        //r.Development = "新客戶";
        //db.SaveChanges();
        //Response.Redirect("~/AdminList.aspx");
        //}

    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow item in this.GridView1.Rows)//取出有打勾的..id
        {
            CheckBox ckb = item.FindControl("CheckBox1") as CheckBox;

            if (ckb.Checked)
            {
                int id = Convert.ToInt32(item.Cells[1].Text);
                Entry9036Entities db = new Entry9036Entities();
                var r = (from t in db.Customers
                         where t.CusId == id
                         select t).First();
                r.SaleID = Convert.ToInt32(DropDownList2.SelectedItem.Value);

                r.Development = "新客戶";
                db.SaveChanges();

            }
        }
        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <link href="scripts/icheck-1.x/skins/all.css" rel="stylesheet" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="container">
            <div >
                <h1 style="font-family:Microsoft JhengHei;" class="text-center black"><B>新客戶名單</B></h1>
                <asp:GridView CssClass="table table-bordered table-hover" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="CusId" OnRowDataBound="GridView1_RowDataBound" OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCommand="GridView1_RowCommand" OnRowCancelingEdit="GridView1_RowCancelingEdit" Font-Size="Medium" >
                    <Columns>
                        <asp:TemplateField ShowHeader="False" HeaderText="請選擇" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:CheckBox ID="CheckBox1" runat="server"  />
                            </ItemTemplate>

                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />

<ItemStyle HorizontalAlign="Center" VerticalAlign="Top"></ItemStyle>

                        </asp:TemplateField>

                        <asp:BoundField DataField="CusId" HeaderText="客戶編號" ReadOnly="True" SortExpression="CusId" >
                        <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        <ItemStyle HorizontalAlign="Justify" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CusName" HeaderText="客戶姓名" SortExpression="CusName" >
                        </asp:BoundField>
                        <asp:BoundField DataField="Phone" HeaderText="手機" SortExpression="Phone" >
                        </asp:BoundField>
                        <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" >
                        </asp:BoundField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" OnClientClick="return confirm('確定刪除此客戶?')" CausesValidation="false" CommandName="Delete" Text="刪除"></asp:LinkButton>
                            </ItemTemplate>
                            <ControlStyle CssClass="btn btn-danger" />
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"  />
                        </asp:TemplateField>
                        <asp:CommandField ControlStyle-CssClass="btn " ShowEditButton="True" CancelText="返回" EditText="編輯" UpdateText="更新" HeaderStyle-VerticalAlign="NotSet" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" >
                            <ControlStyle CssClass="btn btn-primary"></ControlStyle>

<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                        </asp:CommandField>

                    </Columns>
                    <HeaderStyle BackColor="#333333" />
                </asp:GridView>
                <div class="form-group">
                <asp:Label CssClass="control-label" ID="Label1" runat="server" Text="Label" Font-Size="Larger" Font-Underline="False" Font-Bold="True">將此客戶分配給:</asp:Label>
                <asp:DropDownList CssClass="" ID="DropDownList2" runat="server">
                    <asp:ListItem Value="null">請選擇</asp:ListItem>
                    <asp:ListItem Value="1">Ben</asp:ListItem>
                    <asp:ListItem Value="2">Sally</asp:ListItem>
                    <asp:ListItem Value="3">Kelly</asp:ListItem>
                    <asp:ListItem Value="4">Danny</asp:ListItem>
                    <asp:ListItem Value="5">Johnson</asp:ListItem>
                </asp:DropDownList>
                <asp:Button CssClass="btn btn-facebook " ID="Button1" runat="server" Text="送出" OnClick="Button1_Click" Width="90px"  />
                    
                    
                    </div>
                <br />
                <br />
                
            </div>

        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
    <script src="scripts/icheck-1.x/icheck.min.js"></script>
     <script>
        $(document).ready(function () {
            
            $('#ContentPlaceHolder1_GridView1').DataTable({
                "searching": false,
                "language": {
                    "lengthMenu": "顯示 _MENU_ 筆資料",
                    "info": "目前顯示第 _PAGE_  頁",
                     "sSearch": "搜尋:",
                    
                    
                    "oPaginate": {
                        "sPrevious": "上一頁",
                        "sNext": "下一頁",
                    },
                },
                "columnDefs": [
                    { "orderable": false, "targets": 6 } ,{ "orderable": false, "targets": 5 }
                ]
            });
             $('input').iCheck({
                checkboxClass: 'icheckbox_square-green',
                radioClass: 'iradio_square-green',
                increaseArea: '20%' // optional
            });
        });

    </script>
</asp:Content>

