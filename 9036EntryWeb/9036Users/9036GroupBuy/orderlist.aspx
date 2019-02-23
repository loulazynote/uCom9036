<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            String UID = Session["ID"].ToString();
            BindListView();
            groupbuylocal.WebService web = new groupbuylocal.WebService();
            int[] orderid = web.btnVisable(UID);
            for (int i = 0; i < ListView1.Items.Count; i++)
            {
                Button DeleteButton = ((Button)ListView1.Items[i].FindControl("DeleteButton"));
                HyperLink link = ((HyperLink)ListView1.Items[i].FindControl("Link"));
                DeleteButton.Visible = true;
                link.Visible = true;

            }
            for (int i = 0; i < orderid.Length; i++)
            {
                int aa = ListView1.Items.Count;
                for (int j = 0; j < aa; j++)
                {
                    Button DeleteButton = ((Button)ListView1.Items[j].FindControl("DeleteButton"));
                    Label groupIdLabel = ((Label)ListView1.Items[j].FindControl("groupIdLabel"));
                    HyperLink link = ((HyperLink)ListView1.Items[j].FindControl("Link"));
                    int a = int.Parse(groupIdLabel.Text);
                    if (orderid[i] == a)
                    {
                        link.Visible = false;
                        DeleteButton.Visible = false;
                    }
                }

            };
            int l = ListView1.Items.Count();
            for (int i = 0; i < l; i++)
            {
                Label StateLabel = ((Label)ListView1.Items[i].FindControl("StateLabel"));
                if (StateLabel.Text == "已結標")
                {
                    StateLabel.BackColor = Color.Yellow;
                    StateLabel.ForeColor = Color.Red;
                }
                else if (StateLabel.Text == "已成團")
                {
                    StateLabel.ForeColor = Color.Red;
                }
                else
                {
                    StateLabel.BackColor = ColorTranslator.FromHtml("");
                    StateLabel.ForeColor = ColorTranslator.FromHtml("#777");
                }
            };
        };
    }
    private void BindListView()
    {
        String UID = Session["ID"].ToString();
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT *, dbo.[Order].Amount*dbo.groupList.Price AS Total FROM groupList INNER JOIN Employees ON groupList.EmployeeID = Employees.EmployeeID INNER JOIN dbo.[Order] ON groupList.groupId = [Order].groupId  WHERE EmpName = @UID   order by Id Desc", con);
            da.SelectCommand.Parameters.AddWithValue("@UID", UID);
            DataSet ds = new DataSet();
            da.Fill(ds);
            ListView1.DataSource = ds.Tables[0];
            ListView1.DataBind();
            //con.Open();
            //SqlDataReader dr = da.SelectCommand.ExecuteReader();
            //List<string> mix = new List<string>();
            //if (dr.HasRows)
            //{
            //    while (dr.Read())
            //    {
            //        mix.Add(dr["OrderDesc"].ToString());
            //    };
            //};
            //string[] miltext = mix.ToArray();
            //for (int i = 0; i < miltext.Length; i++)
            //{
            //    miltext[i] = miltext[i].Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
            //    Label Desclabel = ((Label)ListView1.Items[i].FindControl("Desclabel"));
            //    Desclabel.Text = miltext[i];
            //};

            groupbuylocal.WebService ww = new groupbuylocal.WebService();
            ww.Update();

        }
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int id = (int)e.Keys[0];
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM [Order] WHERE Id = @groupId", cn);
        cmd.Parameters.AddWithValue("@groupId", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/9036GroupBuy/orderlist.aspx");
    }

    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //set current page startindex, max rows and rebind to false
        DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        //DataPager2.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        String UID = Session["ID"].ToString();

        //rebind List View
        BindListView();
        groupbuylocal.WebService web = new groupbuylocal.WebService();
        int[] orderid = web.btnVisable(UID);
        for (int i = 0; i < ListView1.Items.Count; i++)
        {
            Button DeleteButton = ((Button)ListView1.Items[i].FindControl("DeleteButton"));
            HyperLink link = ((HyperLink)ListView1.Items[i].FindControl("Link"));
            DeleteButton.Visible = true;
            link.Visible = true;

        }
        for (int i = 0; i < orderid.Length; i++)
        {
            int aa = ListView1.Items.Count;
            for (int j = 0; j < aa; j++)
            {
                Button DeleteButton = ((Button)ListView1.Items[j].FindControl("DeleteButton"));
                Label groupIdLabel = ((Label)ListView1.Items[j].FindControl("groupIdLabel"));
                HyperLink link = ((HyperLink)ListView1.Items[j].FindControl("Link"));
                int a = int.Parse(groupIdLabel.Text);
                if (orderid[i] == a)
                {
                    link.Visible = false;
                    DeleteButton.Visible = false;
                }
            }

        };
        int l = ListView1.Items.Count();
        for (int i = 0; i < l; i++)
        {
            Label StateLabel = ((Label)ListView1.Items[i].FindControl("StateLabel"));
            if (StateLabel.Text == "已結標")
            {
                StateLabel.BackColor = Color.Yellow;
                StateLabel.ForeColor = Color.Red;
            }
            else if (StateLabel.Text == "已成團")
            {
                StateLabel.ForeColor = Color.Red;
            }
            else
            {
                StateLabel.BackColor = ColorTranslator.FromHtml("");
                StateLabel.ForeColor = ColorTranslator.FromHtml("#777");
            }
        };

    }

    protected void ExcelButton_Click(object sender, EventArgs e)
    {
        ExcelHiddenField.Value = "false";

        int id = 0;
        string a = "SELECT Id AS 訂單編號, [Name] AS 開團者姓名,Email, groupList.groupId AS 團單編號,ProductName AS 商品名稱,Price AS 商品價格,Amount AS 訂購數量,Amount* Price AS 訂單總額,groupList.[State] AS 團單狀態,DeadLine AS 截止日期 FROM [Order] INNER JOIN  groupList INNER JOIN Employees ON groupList.EmployeeID = Employees.EmployeeID ON groupList.groupId = [Order].groupId WHERE EmpName=@EmployeeID";
        string title = "我的跟團訂單" + DateTime.Now.ToString("yyyyMMddHHmm");
        String UID = Session["ID"].ToString();
        groupbuylocal.WebService ws = new groupbuylocal.WebService();
        string dalert = ws.download(UID, id, title, a);
        Response.Redirect(dalert);
        if (dalert == null)
        {
            ExcelHiddenField.Value = "fail";
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
    <script>
        $(function () {
            $("#ContentPlaceHolder1_ExcelButton").click(function () {
                myConfirm2();
            });

        });




        function myConfirm2() {

            let btnName = $("input#ContentPlaceHolder1_ExcelButton").attr("name");
            //confirm dialog範例
            swal({
                title: "確定匯出？",
                html: "按下確定後您跟團的訂單明細將會匯出",
                type: "question",
                showCancelButton: true//顯示取消按鈕
            }).then(function () {
                __doPostBack(btnName, "");
            },
            );//end then 
        }//end function myConfirm()


        $(function () {
            //$("#Button_1").click(function () {
            if ($("#ContentPlaceHolder1_ExcelHiddenField").val() == "true") {
                swal({
                    title: '匯出成功!',
                    type: 'success',
                    confirmButtonText: 'OK'
                });
                //});
            } else if ($("#ContentPlaceHolder1_ExcelHiddenField").val() == "fail") {
                swal({
                    title: '匯出失敗!',
                    type: 'error',
                    confirmButtonText: 'OK'
                });
            }
        });

    </script>

    <div class="col-lg-12 ">
        <asp:Label runat="server" CssClass="h1" Text="跟團訂單明細"></asp:Label>
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
        </div>
        <div class="col-lg-4 ">
            <%--            <div class="col-lg-12" style="text-align: center">

            <asp:DataPager ID="DataPager2" runat="server" PageSize="4" PagedControlID="ListView1">
                <Fields>
                    <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger h4" ButtonType="Button" FirstPageText="第一頁" PreviousPageText="上一頁" ShowFirstPageButton="True" ShowPreviousPageButton="true" ShowLastPageButton="false" ShowNextPageButton="false" />
                    <asp:NumericPagerField
                        PreviousPageText="&lt; Prev"
                        NextPageText="Next &gt;"
                        ButtonCount="10"
                        NextPreviousButtonCssClass="PrevNext h3"
                        CurrentPageLabelCssClass="CurrentPage h3"
                        NumericButtonCssClass="PageNumber h3" />
                    <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger h4" ButtonType="Button" LastPageText="最後一頁" NextPageText="下一頁" ShowFirstPageButton="false" ShowPreviousPageButton="false" ShowLastPageButton="true" ShowNextPageButton="true" />

                </Fields>
            </asp:DataPager>

            </div>--%>
        </div>
        <div class="col-lg-2" style="text-align: right">
            <asp:Button ID="ExcelButton" runat="server" Text="匯出Excel" OnClick="ExcelButton_Click" CssClass="btn btn-primary h4" OnClientClick="return false" />
            <asp:HiddenField ID="ExcelHiddenField" runat="server" />
            <asp:HiddenField ID="MailHiddenField" runat="server" />
        </div>
    </div>

    <div class="col-lg-12">
        <br />
        <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" OnPagePropertiesChanging="ListView1_PagePropertiesChanging">
            <AlternatingItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                        <br />                        <br />
                        <asp:HyperLink ID="Link" class="btn btn-danger" runat="server" NavigateUrl='<%# "shopping.aspx?id="+Eval("Id")+"&groupid="+Eval("groupId")%>'>編輯</asp:HyperLink>

                    </td>
                    <td>
                        <asp:Label ID="groupIdLabel" runat="server" Text='<%# Eval("Id") %>' />
                    </td>
                    <td>
                        <asp:Image ID="ProudctImg" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="image img-rounded" Width="100%" />
                    </td>
                    <td>
                        <asp:HyperLink runat="server" NavigateUrl='<%# "Products.aspx?id="+Eval("groupId") %>' Text='<%# Eval("ProductName") %>'></asp:HyperLink><br />
                        <asp:Label ID="EmpLable" runat="server" Text='<%#　"開團者："+ Eval("Name") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="AmountLabel" runat="server" Text='<%# Eval("Amount") %>' />
                    </td>
                    <td>
                        <asp:Label ID="TotalLabel" runat="server" Text='<%# Eval("Total") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>' />
                    </td>
                    <td>
                        <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State") %>' />
                    </td>
                    <td>
                        <asp:Label ID="Desclabel" runat="server" Text='<%# Eval("OrderDesc") %>' />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <EmptyDataTemplate>
                <table runat="server">
                    <tr>
                        <td>尚未跟團</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <ItemTemplate>
                <td>
                    <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                    <br /><br />
                    <asp:HyperLink ID="Link" class="btn btn-danger" runat="server" NavigateUrl='<%# "shopping.aspx?id="+Eval("Id")+"&groupid="+Eval("groupId")%>'>編輯</asp:HyperLink>
                    

                </td>
                <td>
                    <asp:Label ID="groupIdLabel" runat="server" Text='<%# Eval("Id") %>' />
                </td>
                <td>
                    <asp:Image ID="ProudctImg" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="image img-rounded" Width="100%" />
                </td>
                <td>
                    <asp:HyperLink runat="server" NavigateUrl='<%# "Products.aspx?id="+Eval("groupId") %>' Text='<%# Eval("ProductName") %>'></asp:HyperLink><br />
                    <asp:Label ID="EmpLable" runat="server" Text='<%#　"開團者："+ Eval("Name") %>' />
                </td>
                <td>
                    <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                </td>
                <td>
                    <asp:Label ID="AmountLabel" runat="server" Text='<%# Eval("Amount") %>' />
                </td>
                <td>
                    <asp:Label ID="TotalLabel" runat="server" Text='<%# Eval("Total") %>' />
                </td>
                <td>
                    <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>' />
                </td>
                <td>
                    <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State") %>' />
                </td>
                <td>
                    <asp:Label ID="Desclabel" runat="server" Text='<%# Eval("OrderDesc") %>' />
                </td>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="table ">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                                <tr runat="server">
                                    <th class="col-lg-1 bg-warning" runat="server"></th>
                                    <th class="col-lg-1 bg-warning" runat="server">訂單編號</th>
                                    <th class="col-lg-1 bg-warning" runat="server">圖片</th>
                                    <th class="col-lg-2 bg-warning" runat="server">商品名稱</th>
                                    <th class="col-lg-1 bg-warning" runat="server">價格</th>
                                    <th class="col-lg-1 bg-warning" runat="server">訂購數量</th>
                                    <th class="col-lg-1 bg-warning" runat="server">訂單總額</th>
                                    <th class="col-lg-1 bg-warning" runat="server">截止日期</th>
                                    <th class="col-lg-1 bg-warning" runat="server">訂單狀態</th>
                                    <th class="col-lg-2 bg-warning" runat="server">補充資料</th>
                                </tr>
                                <tr id="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server"></td>
                    </tr>
                </table>
                <asp:Label ID="Label2" runat="server" CssClass="h1"></asp:Label>
            </LayoutTemplate>
        </asp:ListView>
        <div class="col-lg-12 ">

            <div class="col-lg-5">
            </div>
            <div class="col-lg-4 ">
                <asp:DataPager ID="DataPager1" runat="server" PageSize="4" PagedControlID="ListView1">
                    <Fields>
                        <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger h4" ButtonType="Button" FirstPageText="第一頁" PreviousPageText="上一頁" ShowFirstPageButton="True" ShowPreviousPageButton="true" ShowLastPageButton="false" ShowNextPageButton="false" />
                        <asp:NumericPagerField
                            PreviousPageText="&lt; Prev"
                            NextPageText="Next &gt;"
                            ButtonCount="10"
                            NextPreviousButtonCssClass="PrevNext h3"
                            CurrentPageLabelCssClass="CurrentPage h3"
                            NumericButtonCssClass="PageNumber h3" />
                        <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger h4" ButtonType="Button" LastPageText="最後一頁" NextPageText="下一頁" ShowFirstPageButton="false" ShowPreviousPageButton="false" ShowLastPageButton="true" ShowNextPageButton="true" />

                    </Fields>
                </asp:DataPager>
            </div>
            <div class="col-lg-3"></div>
        </div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tb1").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "/9036GroupBuy/WebService.asmx/GetNames",
                        data: "{ 'prefixText': '" + request.term + "' }",
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

    </script>
</asp:Content>



