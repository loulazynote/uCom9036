<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int id = int.Parse(e.Keys[0].ToString());
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand(
            "DELETE FROM [Forum] WHERE [Id] = @Id", cn);
        cmd.Parameters.AddWithValue("Id", id);
        SqlCommand cmd1 = new SqlCommand(
            "DELETE FROM [comment] WHERE [Titleid] = @Id", cn);
        cmd1.Parameters.AddWithValue("Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cmd1.ExecuteNonQuery();
        cn.Close();
        Response.Redirect(Request.Url.AbsoluteUri);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        function Openwin() {
            myu = document.getElementById('cid').value;
            var res = myu.split(" ");
            if (res.length = 1)
                window.open("search.aspx?Id=" + res, "_blank");
            else {
                var str1 = res[0];
                var str2 = res[1];
                window.open("search.aspx?Id=" + str1 + "&Id2=" + str2, "_blank");
            }
        }
    </script>
    <style>
        .greenBorder {
            /*border: 1px solid green;*/
        }
        /* just borders to see it */
        .center123 {
            margin: auto;
            width: 60%;
            /*border: 3px solid green;*/
            padding: 10px;
        }

        .center1234 {
            margin: auto;
            width: 58%;
            /*border: 3px solid green;*/
            padding: 10px;
        }

        tr {
            font-size: medium
        }
        .table-hover > tbody > tr:hover {
            background-color: lightblue;
            /*background-color: yellow;*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource3">

            <ItemTemplate>
                <td runat="server" style="">
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("CategoryName", "~/Yoyo/Showgroup.aspx?CategoryName={0}") %>'><%# Eval("CategoryName") %></asp:HyperLink>
                    <%--<asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />--%>
                    <br />
                </td>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" border="0" style="">
                    <tr id="itemPlaceholderContainer" runat="server">
                        <td id="itemPlaceholder" runat="server"></td>
                    </tr>
                </table>
                <div style="">
                </div>
            </LayoutTemplate>

        </asp:ListView>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT DISTINCT [CategoryName] FROM [Forum]"></asp:SqlDataSource>
    </div>
    <div style="float: right;" class="form-inline"><input type="text" placeholder="Search" id="cid" class="form-control" style="width:200px;height:30px"/>&nbsp;<i class="fas fa-search text-white ml-3" aria-hidden="true"></i><div style="display:none;"><asp:Button ID="Button1" runat="server" Text="搜尋" OnClientClick="Openwin();return false;" /></div></div>
    <div style="float: right">
        &nbsp;<asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Yoyo/Insert.aspx"><img src="img/24.gif" style="height:29px;width:95px" onmouseover='this.src = "img/26.gif"' onmouseout='this.src = "img/24.gif"'/></asp:HyperLink>&nbsp;
    </div>
    <div class="greenBorder" style="display: table; width: 100%; height: 400px; #position: relative; overflow: hidden;">
        <div style="#position: absolute; #top: 50%; display: table-cell; vertical-align: middle;">
            <div class="center123" style="#position: relative; #top: -50%">
                
                    <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" DataSourceID="SqlDataSource1">
                    <EmptyDataTemplate>
                        <table runat="server" style="">
                            <tr>
                                <td>No data was returned.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                    <ItemTemplate>
                        <tr style="text-align: center">
                            <td>
                                <a href='Edit.aspx?id=<%#Eval("Id")%>&title=<%#Eval("Title")%>'>編輯</a>
                                <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" />
                            </td>
                            
                            <td>
                                <%--<asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Title") %>' />--%>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# string.Format("~/Yoyo/ShowTitle.aspx?Id={0}&Title={1}", Eval("Id"), Eval("Title")) %>'><%# Eval("Title") %></asp:HyperLink>
                            </td>
                            <td>
                                <asp:Label ID="AgeLabel" runat="server" Text='<%# Eval("DateTime") %>' />
                            </td>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("Author") %>' />
                            </td>
                            <td>
                                <asp:Label ID="EmployeeIDLabel" runat="server" Text='<%# Eval("commentcount") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                     <table id="Table1" runat="server" class=" table table-bordered table-hover table-responsive-md btn-table">
                                        <tr runat="server" style="">
                                            <th runat="server"></th>
                                            <th runat="server" style="text-align: center; width: 300px">標題</th>
                                                        <th runat="server" style="text-align: center; width: 200px">討論發起時間</th>
                                                        <th runat="server" style="text-align: center; width: 100px">作者</th>
                                                        <th runat="server" style="text-align: center; width: 100px">回覆</th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="text-align: center">
                                    <asp:DataPager ID="DataPager1" runat="server" PageSize="10">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Link" ShowLastPageButton="false"
                               FirstPageText="&#171;" ShowNextPageButton="false"   ShowFirstPageButton="true"  ShowPreviousPageButton="False" />
                      <asp:NumericPagerField ButtonType="Link" ButtonCount="5"  />
                       <asp:NextPreviousPagerField ButtonType="Link" ShowLastPageButton="True" LastPageText="&#187;" ShowNextPageButton="false" ShowFirstPageButton="false"  ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                </asp:ListView>
                    
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT [Id], [Title], [DateTime], [Author], [Content], [commentcount] FROM [Forum]  where ((Title like '%' + @SEARCH + '%') OR (Content like '%' + @SEARCH + '%'))">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="SEARCH" QueryStringField="Id" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

