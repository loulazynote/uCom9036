<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server"> 


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (ViewState["SortExpression"] == null)
                ViewState["SortExpression"] = string.Empty;
            BindListView();
        }
    }

    private void BindListView()
    {
        SqlDataAdapter da = new SqlDataAdapter(
       "select * from Bulletin order by TopPost DESC", WebConfigurationManager.ConnectionStrings
      ["Entry9036"].ConnectionString);


        DataTable dt = new DataTable();
        da.Fill(dt);
        ListView1.DataSource = dt;
        //  ListView1.DataBind();

        ListView1.DataSource = GetAllBulletin(ViewState["SortExpression"].ToString());
        ListView1.DataBind();
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        //Response.Write(e.Keys[0].ToString());
        int id = (int)e.Keys[0];
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM Bulletin WHERE (Id = @Id)", cn);
        cmd.Parameters.AddWithValue("@Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
    }

    protected void ListView1_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
        }
    }

    protected void ListView1_ItemUpdating1(object sender, ListViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];

        string title = e.NewValues[0].ToString();
        string description = e.NewValues[1].ToString();
        string category = e.NewValues[2].ToString();


        SqlConnection cn = new SqlConnection(
    WebConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

        SqlCommand cmd = new SqlCommand(
            "UPDATE [Bulletin] SET [Title] = @Title, [Description] = @Description, [Category] = @Category WHERE [Id] = @Id", cn);

        cmd.Parameters.AddWithValue("@Id", id);
        cmd.Parameters.AddWithValue("Title", title);
        cmd.Parameters.AddWithValue("Description", description);
        cmd.Parameters.AddWithValue("Category", category);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
    }

    protected void ListView1_ItemEditing(object sender, ListViewEditEventArgs e)
    {

    }

    protected void AddTitle_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Edit_yoyo_MP.aspx");
    }



    protected void Search_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/SearchBulletin_MP.aspx");
    }
    //paging
    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //set current page startindex, max rows and rebind to false
        DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

        //rebind List View
        BindListView();
    }

    protected void lvProducts_Sorting(object sender, ListViewSortEventArgs e)
    {
        string direction = string.Empty;
        if (ViewState["SortDirection"] != null)
            direction = ViewState["SortDirection"].ToString();

        if (direction == "ASC")
            direction = "DESC";
        else
            direction = "ASC";

        ViewState["SortDirection"] = direction;

        ViewState["SortExpression"] = String.Format("{0} {1}", e.SortExpression, direction);

        BindListView();

    }


    public List<Bulletin> GetAllBulletin(string orderBy)
    {
        Entry9036Entities db = new Entry9036Entities();

        if (orderBy == null)
        {
            return db.Bulletins.ToList();
        }

        switch (orderBy)
        {
            case "Category":
            case "Category ASC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenBy(p => p.Category).ToList();
            case "Category DESC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenByDescending(p => p.Category).ToList();
            case "View":
            case "View ASC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenBy(p => p.View).ToList();
            case "View DESC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenByDescending(p => p.View).ToList();
            case "Date":
            case "Date ASC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenBy(p => p.Date).ToList();
            case "Date DESC":
                return db.Bulletins.OrderByDescending(p => p.TopPost).ThenByDescending(p => p.Date).ToList();
            default:
                return db.Bulletins.OrderByDescending(p => p.TopPost).ToList();
        }
    }



</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <%--<link href="Content/bootstrap.css" rel="stylesheet" />--%>
    <%--<link href="Content/MyStyles.css" rel="stylesheet" />--%>
    <script src="Chart.js"></script>
    <script src="utils.js"></script>
    <style>
        .titleStyle {
            border-radius: 5px;
            background-color: darkred;
            color: white;
            display: ruby-text;
            padding: 5px;
        }

        .rrr {
            /*font-family: "微軟正黑體";*/
            /*color: white;*/
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

    <div class="col-md-2">
    </div>
    <div class="col-md-8 title">
        公佈欄主頁
    </div>
    <div class="col-md-2">
    </div>

    <br />
    <br />

    <div id="form1" runat="server">
        <div>
            <br />


            <%--<div style="width: 10%; text-align: center">--%>
                <asp:LinkButton ID="LinkButton2" runat="server" OnClick="Search_Click" class="btn btn-success btn-search">
                查詢公告<i class="fas fa-search"></i>
                </asp:LinkButton>
                <asp:LinkButton ID="btnsearch" runat="server" OnClick="AddTitle_Click" class="btn btn-primary btn-search">
                新增公告<i class="fas fa-plus-circle"></i>
                </asp:LinkButton>
            <%--</div>--%>
            <br />

            <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" OnItemCommand="ListView1_ItemCommand" OnItemUpdating="ListView1_ItemUpdating1" OnItemEditing="ListView1_ItemEditing" OnPagePropertiesChanging="ListView1_PagePropertiesChanging" OnSorting="lvProducts_Sorting">

<%--                <EditItemTemplate>
                    <tr style="background-color: #999999;">
                        <td>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                            <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                        </td>
                        <td>
                            <asp:TextBox ID="TitleTextBox" runat="server" Text='<%# Bind("Title") %>' />
                        </td>
                        <td>
                            <asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>' />
                        </td>
                        <td>
                            <asp:TextBox ID="CategoryTextBox" runat="server" Text='<%# Bind("Category") %>' />
                        </td>
                    </tr>
                </EditItemTemplate>--%>
                <ItemTemplate>
                    <tr>
                        <td>
                            <%--<a href='Edit.aspx?id=<%#Eval("Id")%>'></a>--%>
                            <a class="fas fa-pen" href='Edit.aspx?id=<%#Eval("Id")%>'></a>
                            <%--<asp:ImageButton ID="imgBtnEdit" CommandName="Edit" ToolTip="Edit a record." CommandArgument='<%#Eval("Id") %>' runat="server" ImageUrl="edit.png" />--%>
                            <%--<asp:ImageButton ID="ImageButton1" CommandName="Edit" ToolTip="Edit a record." CommandArgument='<%#Eval("Id") %>' runat="server" ImageUrl="edit.png" PostBackUrl='Bulletin_MasterPage.aspx?id=<%#Eval("Id")%>'/>--%>
                            <asp:ImageButton ToolTip="Delete a record." OnClientClick="javascript:return confirm('Are you sure to delete record?')" CommandName="Delete" ID="imgBtnDelete" CommandArgument='<%#Eval("Id") %>' runat="server" ImageUrl="images/delete.png"></asp:ImageButton>
                        
                        </td>
                        <td>
                            <asp:HyperLink ID="HyperLink1" runat="server" ForeColor='<%#(Eval("TopPost").ToString()=="1"?System.Drawing.Color.Red:System.Drawing.ColorTranslator.FromHtml("#284775")) %>' NavigateUrl='<%# Eval("Id", "~/Joshua/ShowTitle_MP.aspx?Id={0}") %>'>
                                <%#Eval("TopPost").ToString()=="1"?"[★置頂] ":""%><%# Eval("Title") %>
                            </asp:HyperLink>
                        </td>
                        <td>
                            <asp:Label ID="CategoryLabel" runat="server" Text='<%# Eval("Category") %>' />
                        </td>
                        <td>
                            <asp:Label ID="ViewLabel" runat="server" Text='<%# Eval("View") %>' />
                        </td>
                        <td>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Eval("Date") %>' />
                        </td>

                        <td>

                            <asp:HyperLink download runat="server" ID="HyperLink2" NavigateUrl='<%# Eval("FileName", "/Upload/{0}") %>'>
                                <%#Eval("FileName") != null ? "<i class='fas fa-paperclip'></i>下載" : "" %>
                            </asp:HyperLink>
                        </td>
                    </tr>
                </ItemTemplate>
                <LayoutTemplate>
                    <%--<div class="col-sm-2"></div>--%>
                    <%--<div class="col-sm-12 categories row">--%>
                        <table runat="server">
                            <tr runat="server">

                                <td runat="server">
                                    <%--<table id="itemPlaceholderContainer" runat="server" border="1" style="background-color: #FFFFFF; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px; font-family: Verdana, Arial, Helvetica, sans-serif;">--%>
                                    <table id="Table1" runat="server" class=" table table-bordered table-hover table-responsive-md btn-table" style="width:200%">
                                        <tr runat="server" style="background-color: #5D7B9D; color: #ffffff;">
                                            <th runat="server"></th>
                                            <th style="width:1000px" runat="server"><i class="fas fa-book"></i>公告主題</th>
                                            <%--<th class="col-lg-4 rrr" runat="server" bgcolor="#CCEEFF">--%>
                                            <th style="width:400px" class="rrr" runat="server" bgcolor="#CCEEFF">
                                                <asp:LinkButton runat="server" ID="btnSortByCategory" CommandName="Sort" CommandArgument="Category">
                                                <i class="fas fa-university"></i>公告分類
                                                </asp:LinkButton>
                                            </th>
                                            <th style="width:400px" class="rrr" runat="server" bgcolor="#CCEEFF">
                                                <asp:LinkButton runat="server" ID="btnSortByView" CommandName="Sort" CommandArgument="View">
                                                <i class="fas fa-burn"></i>人氣
                                                </asp:LinkButton>
                                            </th>
                                            <th style="width:500px" class="rrr" runat="server" bgcolor="#CCEEFF">
                                                <asp:LinkButton runat="server" ID="btnSortByDate" CommandName="Sort" CommandArgument="Date">
                                                <i class="fas fa-table"></i></i>公告日期
                                                </asp:LinkButton>
                                            </th>
                                            <th style="width:500px" runat="server"><i class='fas fa-paperclip'>附檔</th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="text-align: center; background-color: #5D7B9D; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000"></td>
                            </tr>
                        </table>

                    <%--</div>--%>
                    <%--<div class="col-sm-2"></div>--%>

                </LayoutTemplate>
                <SelectedItemTemplate>
                    <tr style="background-color: #E2DED6; font-weight: bold; color: #333333;">
                        <td>
                            <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
                            <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                        </td>
                        <td>
                            <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                            <%--<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%#"ShowProduct.aspx?Id="&Eval("Id") %>'Text='<%# Eval("Id") %>'></asp:HyperLink>--%>
                            
                        </td>
                        <td>
                            <%--<asp:Label ID="TitleLabel" runat="server" Text='<%# Eval("Title") %>' />--%>
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("Id", "~/Joshua/ShowTitle.aspx?Id={0}") %>'><%# Eval("Title") %></asp:HyperLink>
                        </td>
                        <td>
                            <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Eval("Description") %>' />
                        </td>
                        <td>
                            <asp:Label ID="CategoryLabel" runat="server" Text='<%# Eval("Category") %>' />
                        </td>
                        <td>
                            <asp:Label ID="ViewLabel" runat="server" Text='<%# Eval("View") %>' />
                        </td>
                        <td>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Eval("Date") %>' />
                        </td>
                    </tr>
                </SelectedItemTemplate>
            </asp:ListView>
        </div>
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <asp:DataPager ID="DataPager1" runat="server" PageSize="8" PagedControlID="ListView1">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" PreviousPageText="上一頁" NextPageText="下一頁" FirstPageText="第一頁" LastPageText="最終頁"/>
                </Fields>
            </asp:DataPager>
        </div>
        <div class="col-lg-4"></div>

    </div>


    <br />
    <br />
    <br />
    <input type="button" id="btn" value="熱門公告" />
    <input type="button" id="btn1" value="公告分類數" />
    <div style="width: 75%;">
        <canvas id="myChart"></canvas>
    </div>

    <script>
        $(function () {

            $("#btn").click(function () {
                $.ajax({
                    type: "POST",
                    //async: false,
                    url: "WebService.asmx/QueryProducts1",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        var xAry = new Array();
                        var yAry = new Array();

                        $(data.d).each(function () {

                            xAry.push($(this)[0].Title);
                            yAry.push($(this)[0].View);

                        });

                        var ctx = document.getElementById("myChart");
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: xAry,
                                datasets: [{
                                    label: '點閱數',
                                    data: yAry,
                                    borderWidth: 1,
                                    backgroundColor: GetRandomColors(22)
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
                    }
                });
            });
            $("#btn1").click(function () {
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/QueryProducts3",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        var xAry = new Array();
                        var yAry = new Array();

                        $(data.d).each(function () {

                            xAry.push($(this)[0].Category);
                            yAry.push($(this)[0].Total);

                        });

                        var ctx = document.getElementById("myChart");
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: xAry,
                                datasets: [{
                                    label: '回覆數',
                                    data: yAry,
                                    borderWidth: 1,
                                    backgroundColor: GetRandomColors(22)
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
                    }
                });
            });



        });



    </script>





</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

