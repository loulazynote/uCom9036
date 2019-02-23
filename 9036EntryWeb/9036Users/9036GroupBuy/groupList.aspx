<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindListView();
            int l = ListView1.Items.Count();
            for (int i = 0; i < l; i++)
            {
                System.Web.UI.WebControls.Label StateLabel = ((System.Web.UI.WebControls.Label)ListView1.Items[i].FindControl("StateLabel"));
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
    }
    private void BindListView()
    {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            String UID = Session["ID"].ToString();
            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM [groupList] INNER JOIN Employees ON groupList.EmployeeID = Employees.EmployeeID WHERE groupList.EmployeeID = @UID  order by groupId Desc", con);
            da.SelectCommand.Parameters.AddWithValue("@UID", UID);
            DataSet ds = new DataSet();
            da.Fill(ds);
            ListView1.DataSource = ds;
            ListView1.DataBind();
            //con.Open();
            //SqlDataReader dr = da.SelectCommand.ExecuteReader();
            //List<string> mix = new List<string>();
            //if (dr.HasRows)
            //{
            //    while (dr.Read())
            //    {
            //        mix.Add(dr["groupDesc"].ToString());
            //    }
            //};
            //string[] miltext = mix.ToArray();
            //int l = miltext.Length;
            //for (int i = 0; i < l; i++)
            //{
            //    miltext[i] = miltext[i].Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
            //    Label Desclabel = ((Label)ListView1.Items[i].FindControl("Desclabel"));
            //    Desclabel.Text = miltext[i];
            //}
            groupbuylocal.WebService ww = new groupbuylocal.WebService();
            ww.Update();

        }
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int id = (int)e.Keys[0];
        groupbuylocal.WebService ws = new groupbuylocal.WebService();
        ws.deletea(id.ToString());
        Response.Redirect("~/9036GroupBuy/groupList.aspx");
    }


    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //set current page startindex, max rows and rebind to false
        DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        //DataPager2.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

        //rebind List View
        BindListView();
        int l = ListView1.Items.Count();
        for (int i = 0; i < l; i++)
        {
            System.Web.UI.WebControls.Label StateLabel = ((System.Web.UI.WebControls.Label)ListView1.Items[i].FindControl("StateLabel"));
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
        string a = "SELECT groupList.EmployeeID AS 開團者,Id AS 訂單編號, [Name] AS 客戶姓名,Email, groupList.groupId AS 團單編號,ProductName AS 商品名稱,Price AS 商品價格,Amount AS 訂購數量,Amount* Price AS 訂單總額,groupList.[State] AS 團單狀態,DeadLine AS 截止日期 FROM  [Order] INNER JOIN Employees ON [Order].EmpName = Employees.EmployeeID INNER JOIN groupList ON groupList.groupId = [Order].groupId WHERE groupList.EmployeeID=@EmployeeID  order by groupList.groupId Desc";
        string title = "訂單總明細" + DateTime.Now.ToString("yyyyMMddHHmm");
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
    <!--引用jQuery-->
    <script src="https://code.jquery.com/jquery-3.2.1.min.js" type="text/javascript"></script>
    <!--引用SweetAlert2.js-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.0.0/sweetalert2.all.js"></script>

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
                html: "按下確定後所有團單的訂單明細將會匯出",
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
        <asp:Label runat="server" CssClass="h1" Text="團單管理"></asp:Label>
        <br />
        <br />
        <asp:HiddenField ID="HiddenField1" runat="server" Value="false" />
        <asp:HiddenField ID="HiddenField2" runat="server" />

        <div class="col-lg-6">
            <ul class="nav nav-pills nav-pills-success">
                <li class="active"><a href="Default.aspx">去跟團</a></li>
                <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
                <li class="active"><a href="grouplist.aspx">團單管理</a></li>
                <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
                <li class="active"><a href="Chart.aspx">圖表生成</a></li>

            </ul>
            <br />
        </div>
        <div class="col-lg-4 ">
            <asp:HiddenField ID="ExcelHiddenField" runat="server" />
            <%--            <asp:DataPager ID="DataPager2" runat="server" PageSize="4" PagedControlID="ListView1">
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
            </asp:DataPager>--%>
        </div>
        <div class="col-lg-2" style="text-align: right">
            <asp:Button ID="ExcelButton" runat="server" Text="匯出Excel" OnClick="ExcelButton_Click" OnClientClick="return false" CssClass="btn btn-primary h4" />
        </div>
    </div>
    <div class="col-lg-12">

        <asp:ListView ID="ListView1" runat="server" DataKeyNames="groupId" OnItemDeleting="ListView1_ItemDeleting" OnPagePropertiesChanging="ListView1_PagePropertiesChanging">
            <AlternatingItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                        <br />
                        <br />
                        <a class="btn btn-danger" href="groupEdit.aspx?id=<%# Eval("groupId") %>">編輯</a>
                        <br />
                        <br />
                        <a class="btn btn-info" href="groupOrder.aspx?id=<%# Eval("groupId") %>">明細</a>

                    </td>
                    <td>
                        <asp:Label ID="groupIdLabel" runat="server" Text='<%# Eval("groupId") %>' />
                    </td>
                    <td>
                        <asp:Image ID="ProudctImg" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="image img-rounded" Width="90%" />
                    </td>
                    <td>
                        <asp:HyperLink runat="server" NavigateUrl='<%# "Products.aspx?id="+Eval("groupId") %>' Text='<%# Eval("ProductName") %>'></asp:HyperLink>
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>' />
                    </td>
                    <td>
                        <asp:Label ID="SuccessLabel" runat="server" Text='<%# Eval("Limit") %>' />
                    </td>
                    <td>
                        <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DescLabel" runat="server" Text='<%# Eval("GroupDesc") %>' />
                    </td>

                </tr>
            </AlternatingItemTemplate>
            <EmptyDataTemplate>
                <table runat="server">
                    <tr>
                        <td>未創立團購商品</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                        <br />
                        <br />
                        <a class="btn btn-danger" href="groupEdit.aspx?id=<%# Eval("groupId") %>">編輯</a>
                        <br />
                        <br />
                        <a class="btn btn-info" href="groupOrder.aspx?id=<%# Eval("groupId") %>">明細</a>
                    </td>
                    <td>
                        <asp:Label ID="groupIdLabel" runat="server" Text='<%# Eval("groupId") %>' />
                    </td>
                    <td>
                        <asp:Image ID="ProudctImg" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="image img-rounded" Width="90%" />
                    </td>
                    <td>
                        <asp:HyperLink runat="server" NavigateUrl='<%# "Products.aspx?id="+Eval("groupId") %>' Text='<%# Eval("ProductName") %>'></asp:HyperLink>
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>'></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="SuccessLabel" runat="server" Text='<%# Eval("Limit") %>' />
                    </td>
                    <td>
                        <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DescLabel" runat="server" Text='<%# Eval("GroupDesc") %>' />
                    </td>

                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="table">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                                <tr runat="server">
                                    <th class="col-lg-1 bg-primary" runat="server"></th>
                                    <th class="col-lg-1 bg-primary" runat="server">團單編號</th>
                                    <th class="col-lg-2 bg-primary" runat="server">圖片</th>
                                    <th class="col-lg-2 bg-primary" runat="server">商品名稱</th>
                                    <th class="col-lg-1 bg-primary" runat="server">販售價格</th>
                                    <th class="col-lg-1 bg-primary" runat="server">截止日期</th>
                                    <th class="col-lg-1 bg-primary" runat="server">最低份數</th>
                                    <th class="col-lg-1 bg-primary" runat="server">團單狀態</th>
                                    <th class="col-lg-2 bg-primary" runat="server">團單描述</th>


                                </tr>
                                <tr id="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server" style=""></td>
                    </tr>
                </table>
            </LayoutTemplate>
            <SelectedItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                    </td>
                    <td>
                        <asp:Label ID="groupIdLabel" runat="server" Text='<%# Eval("groupId") %>' />
                    </td>
                    <td>
                        <asp:Label ID="NameLabel" runat="server" Text='<%# Eval("ProductName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("DeadLine","{0:yyyy/MM/dd}") %>'></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="SuccessLabel" runat="server" Text='<%# Eval("Limit") %>' />
                    </td>
                    <td>
                        <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DescLabel" runat="server" Text='<%# Eval("GroupDesc") %>' />
                    </td>
                    <td>
                        <asp:Image ID="ProudctImg" runat="server" ImageUrl='<%# Eval("ImgUrl") %>' CssClass="image img-rounded" Width="100%" />
                    </td>
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
        <div class="col-lg-12 ">
            <div class="col-lg-5"></div>
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

