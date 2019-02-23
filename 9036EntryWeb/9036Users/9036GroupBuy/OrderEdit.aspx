<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

            int qs = 0;
            if (Request.QueryString["id"] != null)
            {
                int id = int.Parse(Request.QueryString["id"]);
                qs = int.Parse(Request.QueryString["groupid"]);

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
                {
                    String UID = Session["ID"].ToString();
                    DataSet ds = new DataSet();
                    ds.Clear();
                    SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM [Order] INNER JOIN [groupList] ON groupList.groupId = [Order].groupId WHERE dbo.[Order].id = @id AND groupList.EmployeeID = @UID", con);
                    cm.SelectCommand.Parameters.AddWithValue("@id", id);
                    cm.SelectCommand.Parameters.AddWithValue("@UID", UID);
                    cm.Fill(ds);
                    FormView1.DataSource = ds;
                    FormView1.DataBind();

                };
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
                {
                    DataSet ds = new DataSet();
                    SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM [Order] INNER JOIN [Employees] ON Employees.EmployeeID = [Order].EmpName WHERE dbo.[Order].id = @id", con);
                    cm.SelectCommand.Parameters.AddWithValue("@id", id);
                    cm.Fill(ds);
                    FormView3.DataSource = ds;
                    FormView3.DataBind();
                };
            }
            else
            {
                if (Request.QueryString["Mode"] == "Insert")
                {
                    qs = int.Parse(Request.QueryString["groupid"]);
                    FormView1.DefaultMode = FormViewMode.Insert;
                    Label5.Text = "新增訂單";
                };
            }

                Label name = ((Label)FormView1.FindControl("Label8"));
                Label hidename = ((Label)FormView3.FindControl("Label7"));

                name.Text = hidename.Text;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                DataSet ds = new DataSet();
                ds.Clear();
                SqlDataAdapter ms = new SqlDataAdapter("SELECT * FROM [groupList] WHERE ([groupList].groupId = @id)", con);
                ms.SelectCommand.Parameters.AddWithValue("@id", qs);
                ms.Fill(ds);
                con.Open();
                SqlDataReader dr = ms.SelectCommand.ExecuteReader();
                dr.Read();
                string miltext = dr["groupDesc"].ToString();
                miltext = miltext.Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
                FormView2.DataSource = ds;
                FormView2.DataBind();
                Label Desclabel = ((Label)FormView2.FindControl("groupDescLabel"));
                Desclabel.Text = miltext.ToString();


            };

        };
    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];
        int Amount = int.Parse(e.NewValues[0].ToString());
        string OrderDesc = e.NewValues[1].ToString();
        DataTable dt = new DataTable();
        string queryString = "";
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            queryString = "UPDATE [order] SET OrderDesc=@OrderDesc,Amount=@Amount WHERE Id=@orderId";
            SqlDataAdapter da = new SqlDataAdapter(queryString, con);
            da.SelectCommand.Parameters.AddWithValue("@orderId", id);
            da.SelectCommand.Parameters.AddWithValue("@Amount", Amount);
            da.SelectCommand.Parameters.AddWithValue("@OrderDesc", OrderDesc);
            da.Fill(dt);
            FormView1.DataSource = dt;
            FormView1.DataBind();
            int groupid = int.Parse(Request.QueryString["groupid"]);

            Response.Redirect("~/9036GroupBuy/groupOrder.aspx?id=" + groupid.ToString());
        };
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        int groupId = int.Parse(Request.QueryString["groupId"]);
        String EmpName = Session["ID"].ToString();
        int Amount = int.Parse(e.Values[0].ToString());
        string OrderDesc = e.Values[1].ToString();
        DataTable dt = new DataTable();
        SqlDataAdapter da = new SqlDataAdapter("INSERT INTO [Order]([EmpName],[groupID],[Amount],[OrderDesc]) VALUES (@EmpName, @groupID, @Amount, @OrderDesc)", ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        da.SelectCommand.Parameters.AddWithValue("@groupId", groupId);
        da.SelectCommand.Parameters.AddWithValue("@EmpName", EmpName);
        da.SelectCommand.Parameters.AddWithValue("@Amount", Amount);
        da.SelectCommand.Parameters.AddWithValue("@OrderDesc", OrderDesc);
        da.Fill(dt);
        FormView1.DataSource = dt;
        FormView1.DataBind();
        int groupid = int.Parse(Request.QueryString["groupid"]);

        Response.Redirect("~/9036GroupBuy/groupOrder.aspx?id=" + groupid.ToString());
    }

    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName.ToLower() == "cancel")
        {
            int groupid = int.Parse(Request.QueryString["groupid"]);

            Response.Redirect("~/9036GroupBuy/groupOrder.aspx?id=" + groupid.ToString());
        }
        else if (e.CommandName.ToLower() == "insertcancel")
        {
            int groupid = int.Parse(Request.QueryString["groupid"]);

            Response.Redirect("~/9036GroupBuy/groupOrder.aspx?id=" + groupid.ToString());
        }

    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        div {
            font-family: Times New Roman,'微軟正黑體';
            font-size: 18px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-lg-12">
        <asp:Label ID="Label5" runat="server" Text="  編輯訂單" CssClass="h1"></asp:Label>
        <br />
        <br />
    </div>

    <div class="col-lg-12 ">
        <ul class="nav nav-pills nav-pills-success">
            <li class="active"><a href="Default.aspx">去跟團</a></li>
            <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
            <li class="active"><a href="grouplist.aspx">團單管理</a></li>
            <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>

            <li class="active"><a href="Chart.aspx">圖表生成</a></li>
        </ul>
        <br />
        <br />
    </div>

    <div class="col-lg-12">
        <asp:FormView ID="FormView3" runat="server" Visible="False">
            <ItemTemplate>
                <asp:Label ID="Label7" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
            </ItemTemplate>
        </asp:FormView>
        <div class="col-lg-4">
            <asp:FormView CssClass="col-lg-12" ID="FormView2" runat="server">
                <ItemTemplate>
                    <asp:Image ID="ProudctImg" runat="server" CssClass="image img-rounded" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' Height="50%" /><br />

                    <br />

                    <asp:Table ID="Table2" runat="server">
                        <asp:TableRow VerticalAlign="Top">
                            <asp:TableHeaderCell>訂購商品</asp:TableHeaderCell>
                            <asp:TableCell>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("ProductName") %>'></asp:Label>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow VerticalAlign="Top">
                            <asp:TableCell>售價</asp:TableCell>
                            <asp:TableCell>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("Price")+"元" %>'></asp:Label>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow VerticalAlign="Top">
                            <asp:TableCell>商品介紹　</asp:TableCell>
                            <asp:TableCell>
                                <asp:Label ID="groupDescLabel" runat="server" Text='<%# Eval("GroupDesc") %>'></asp:Label>
                            </asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow VerticalAlign="Top"></asp:TableRow>

                        <asp:TableRow VerticalAlign="Top">
                            <asp:TableCell>截止日期</asp:TableCell>
                            <asp:TableCell>
                                <asp:Label ID="DeadLineLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>'></asp:Label></td>
                            </asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>

                </ItemTemplate>
            </asp:FormView>
        </div>
        <div class="col-lg-8">
            <asp:FormView CssClass="col-lg-12" ID="FormView1" runat="server" DataKeyNames="Id" DefaultMode="Edit" GridLines="None" OnItemUpdating="FormView1_ItemUpdating" OnItemInserting="FormView1_ItemInserting" OnItemCommand="FormView1_ItemCommand" CellPadding="-1">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" CssClass="h1" Text="編輯訂單"></asp:Label>
                    <br />

                    <asp:Label ID="groupIdLable" runat="server" CssClass="h1" Text='<%#  "團單編號#"+Eval("groupId")+Eval("ProductName") %>' />

                    <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                        <tr id="itemPlaceholder" runat="server">
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂單編號</th>
                            <td>
                                <asp:Label ID="Label6" runat="server" Text='<%#Eval("Id") %>' />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂購者</th>
                            <td>
                                <asp:Label ID="Label8" runat="server" Text="" />
                            </td>
                        </tr>

                        <tr runat="server">
                            <th runat="server">訂購商品</th>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text='<%#Eval("ProductName") %>' />
                            </td>
                        </tr>

                        <tr runat="server">
                            <th runat="server">販售價格</th>
                            <td>
                                <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price")+"元"%>' />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂購數量</th>
                            <td>
                                <asp:TextBox ID="AmountTextBox" runat="server" CssClass="rounded col-lg-1" Text='<%# Bind("Amount") %>' TextMode="Number"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th runat="server">補充資料</th>
                            <td>
                                <asp:TextBox ID="DescTextBox" runat="server" Text='<%# Bind("OrderDesc") %>' TextMode="MultiLine" Height="200px" CssClass="col-lg-6"></asp:TextBox>

                                <div class="col-lg-offset-3 col-lg-9">
                                    <br />
                                    <asp:LinkButton ID="UpdateButton" CssClass="btn-primary  btn rounded" runat="server" CausesValidation="True" CommandName="Update" Text="更新資料" OnClientClick='return confirm("確認更新?")' />
                                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" CssClass="btn btn-primary" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消編輯" OnClientClick='return confirm("確認取消?")' />
                                </div>

                            </td>
                        </tr>
                    </table>
                    <br />

                </ItemTemplate>

                <EditItemTemplate>


                    <asp:Label ID="groupIdLable" runat="server" CssClass="h1" Text='<%#  "團單編號#"+Eval("groupId")+Eval("ProductName") %>' />

                    <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                        <tr id="itemPlaceholder" runat="server">
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂單編號</th>
                            <td>
                                <asp:Label ID="Label6" runat="server" Text='<%#Request.QueryString["id"].ToString()%>' />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂購者</th>
                            <td>
                                <asp:Label ID="Label8" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂購商品</th>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text='<%#Eval("ProductName") %>' />
                            </td>
                        </tr>

                        <tr runat="server">
                            <th runat="server">販售價格</th>
                            <td>
                                <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price")+"元"%>' />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">訂購數量</th>
                            <td>
                                <asp:TextBox ID="AmountTextBox" runat="server" CssClass="rounded col-lg-1" Text='<%# Bind("Amount") %>' TextMode="Number"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th runat="server">補充資料</th>
                            <td>
                                <asp:TextBox ID="DescTextBox" runat="server" Text='<%# Bind("OrderDesc") %>' TextMode="MultiLine" Height="200px" CssClass="col-lg-6"></asp:TextBox>

                                <div class="col-lg-offset-3 col-lg-9">
                                    <br />
                                    <asp:LinkButton ID="UpdateButton" CssClass="btn-primary  btn rounded" runat="server" CausesValidation="True" CommandName="Update" Text="更新資料" OnClientClick='return confirm("確認更新?")' />
                                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" CssClass="btn btn-primary" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消編輯" OnClientClick='return confirm("確認取消?")' />
                                </div>

                            </td>
                        </tr>
                    </table>
                    <br />

                </EditItemTemplate>
                <InsertItemTemplate>
                    <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                        <tr id="itemPlaceholder" runat="server">
                        </tr>

                        <tr runat="server">
                            <th runat="server">訂購數量</th>
                            <td>
                                <asp:TextBox ID="AmountTextBox" runat="server" CssClass="rounded col-lg-1" Text='<%# Bind("Amount") %>' TextMode="Number"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th runat="server">補充資料</th>
                            <td>
                                <asp:TextBox ID="DescTextBox" runat="server" Text='<%# Bind("OrderDesc") %>' TextMode="MultiLine" Height="200px" CssClass="col-lg-6"></asp:TextBox>

                                <div class="col-lg-offset-3 col-lg-9">
                                    <br />
                                    <asp:LinkButton ID="InsertButton" CssClass="btn-primary  btn rounded" runat="server" CausesValidation="True" CommandName="Insert" Text="新增訂單" OnClientClick='return confirm("確認新增?")' />
                                    &nbsp;<asp:LinkButton ID="InsertCancelButton" CssClass="btn btn-primary" runat="server" CausesValidation="False" CommandName="insertcancel" Text="取消編輯" OnClientClick='return confirm("確認取消?")' />
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br />
                </InsertItemTemplate>
            </asp:FormView>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>




