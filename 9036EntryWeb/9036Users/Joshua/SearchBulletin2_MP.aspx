<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server"> 

    string count = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
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
        ListView1.DataBind();


        //query string
        string title = Request.QueryString["title"];
        string description = Request.QueryString["description"];
        string category = Request.QueryString["category"];
        string date1 = Request.QueryString["date1"]; //"2018/7/2"
        string date2 = Request.QueryString["date2"]; //"2019/3/7"

        string sqlCondition = "";
        if (title != null)
        {
            sqlCondition += " AND title like N'%" + title + "%'"; //AND Title like N'%北%'
        }
        if (description != null)
        {
            sqlCondition += " AND description like N'%" + description + "%'";
        }
        if (category != null)
        {
            sqlCondition += " AND category like N'%" + category + "'";
        }
        if (date1 != null && date2 != null)
        {
            //and Convert(DateTime, Date) >= Convert(DateTime, '2018/9/1')
            //and Convert(DateTime, Date)<= Convert(DateTime, '2019/2/07')
            //order by TopPost DESC

            sqlCondition += " and Convert(DateTime, Date) >= Convert(DateTime,'" + date1 + "')";
            sqlCondition += " and Convert(DateTime, Date) <= Convert(DateTime,'" + date2 + "')";

            //sqlCondition += $" and Convert(DateTime, Date) >= Convert(DateTime, '{date1}')";
            //sqlCondition += $" and Convert(DateTime, Date) >= Convert(DateTime, '{date2}')";
            //sqlCondition += $" order by TopPost DESC";
        }



        var sqlString = "select * from Bulletin WHERE 1=1" + sqlCondition + " order by TopPost DESC";

        SqlDataAdapter da2 = new SqlDataAdapter(
sqlString, WebConfigurationManager.ConnectionStrings
["Entry9036"].ConnectionString);

        //Response.Write(sql);

        DataTable dt2 = new DataTable();
        da2.Fill(dt2);
        ListView1.DataSource = dt2;
        ListView1.DataBind();

        count = ListView1.Items.Count.ToString();
        //Response.Write(count);
        //SELECT COUNT(*) FROM Bulletin;
        //        SqlDataAdapter da3 = new SqlDataAdapter(
        //"SELECT COUNT(*) FROM Bulletin", WebConfigurationManager.ConnectionStrings
        //["Entry9036"].ConnectionString);


        //        DataTable dt3 = new DataTable();
        //        da3.Fill(dt3);

        //        ListView1.DataSource = dt3;
        //        ListView1.DataBind();


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
        //Response.Redirect("~/Edit_yoyo_MP.aspx");
    }


    protected void Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
    }

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


    protected void Back1_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
    }

    protected void Back2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/SearchBulletin_MP.aspx");
    }


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />


    <%--    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link rel="stylesheet" href="/resources/demos/style.css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>--%>


    <%--<link href="Content/bootstrap.css" rel="stylesheet" />--%>

    <style>
        .textStyle {
            border-radius: 5px;
            background-color: saddlebrown;
            color: white;
            display: ruby-text;
            padding: 5px;
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
    <%--<script src="Scripts/jquery-1.9.1.js"></script>--%>

    <div class="col-md-2">
    </div>
    <div class="col-md-8 title">
        查詢結果
    </div>
    <div class="col-md-2">
    </div>
    <br />
    <br />


    <div id="form1" runat="server">
        <div>
            <br />
            <%--<div style="width: 60%; text-align: center">--%>

                <asp:LinkButton ID="btnsearch" runat="server" OnClick="Back2_Click" class="btn btn-success">
                返回查詢頁<i class="fas fa-undo-alt"></i>
                </asp:LinkButton>
                <asp:LinkButton ID="LinkButton2" runat="server" OnClick="Back1_Click" class="btn btn-warning">
                返回主頁<i class="fas fa-undo-alt"></i>
                </asp:LinkButton>

            <%--</div>--%>
            <br />

            <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" OnItemCommand="ListView1_ItemCommand" OnItemUpdating="ListView1_ItemUpdating1" OnItemEditing="ListView1_ItemEditing" OnPagePropertiesChanging="ListView1_PagePropertiesChanging" OnSorting="lvProducts_Sorting">

                <EditItemTemplate>
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
                </EditItemTemplate>
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
                                <%#Eval("TopPost").ToString()=="1"?"[置頂] ":""%><%# Eval("Title") %>
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

                <EmptyDataTemplate>
              <table class="emptyTable">
                <tr>
                  <td>
                    <asp:Image ID="NoDataImage"
                      ImageUrl="~/Joshua/images/icon.png" 
                      runat="server"/>
                  </td>
                  <td style="text-align:center">
                            "查無此貼文,建議放寬查詢條件."
                  </td>
                </tr>
              </table>
          </EmptyDataTemplate>



            </asp:ListView>
        </div>
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <asp:DataPager ID="DataPager1" runat="server" PageSize="8" PagedControlID="ListView1">
                <Fields>
                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" />
                </Fields>
            </asp:DataPager>
        </div>
        <div class="col-lg-4"></div>

    </div>




</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">


    <script>    
        function aa(e) {
            // e.preventDefault();
            console.log(e);

            var str = "";
            var title = document.getElementById('title').value;
            var description = document.getElementById('description').value;
            var category = document.getElementById('category').value;

            var date1 = document.getElementById('date1').value;
            var date2 = document.getElementById('date2').value;

            //var category = $('#category').value;
            console.log(date1);
            console.log(date2);
            if (title != "") {
                str += "title=" + title + "&";
            }
            if (description != "") {
                str += "description=" + description + "&";
            }
            if (date1 != "") {
                str += "date1=" + date1 + "&";
            }
            if (date2 != "") {
                str += "date2=" + date2 + "&";
            }
            if (category != "請選擇發佈單位") {
                str += "category=" + category + "&";
            }
            str = str.substring(0, str.lastIndexOf('&'));
            if (str != "") {
                window.location.href = "/SearchBulletin_MP.aspx?" + str;
            }

        }


        $(function () {
            $(".datepicker").datepicker();

        });

        function getDate(e) {
            //console.log(e, e.target.value)
            var a = e.target.value
            //console.log(a)
            var b = a.split("/")
            var c = b[2] + b[0] + b[1]
            var d = []
            d[0] = b[2]
            d[1] = b[0]
            d[2] = b[1]
            console.log(d)
            d[1] = Number(d[1])
            d[2] = Number(d[2])
            var ddd = d.join("/")
            //console.log(ddd)
            e.target.value = ddd
        }


    </script>


</asp:Content>

