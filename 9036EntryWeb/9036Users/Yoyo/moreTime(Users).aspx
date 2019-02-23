<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<script runat="server">    
    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int id = int.Parse(e.Keys[0].ToString());
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);

        SqlCommand cmd = new SqlCommand(
            "DELETE FROM [Forum] WHERE [Id] = @Id", cn);

        cmd.Parameters.AddWithValue("Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
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
                window.open("search(Users).aspx?Id=" + res, "_blank");
            else {
                var str1 = res[0];
                var str2 = res[1];
                window.open("search(Users).aspx?Id=" + str1 + "&Id2=" + str2, "_blank");
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

        .table-hover > tbody > tr:hover > td:hover {
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
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("CategoryName", "~/Yoyo/Showgroup(Users).aspx?CategoryName={0}") %>'><%# Eval("CategoryName") %></asp:HyperLink>
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
    <div style="float: right;" class="form-inline">
        <input type="text" placeholder="Search" id="cid" class="form-control" style="width: 200px; height: 30px" />&nbsp;<i class="fas fa-search text-white ml-3" aria-hidden="true"></i><div style="display: none;">
            <asp:Button ID="Button1" runat="server" Text="搜尋" OnClientClick="Openwin();return false;" /></div>
    </div>
    <div style="float: right">
        &nbsp;<asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Yoyo/Insert.aspx"><img src="img/24.gif" style="height:29px;width:95px" onmouseover='this.src = "img/26.gif"' onmouseout='this.src = "img/24.gif"'/></asp:HyperLink>&nbsp;
    </div>
    <div class="greenBorder" style="display: table; width: 100%; height: 400px; #position: relative; overflow: hidden;">
        <div style="#position: absolute; #top: 50%; display: table-cell; vertical-align: middle;">
            <div class="center123" style="#position: relative; #top: -50%">

                <asp:ListView ID="ListView3" runat="server" DataSourceID="SqlDataSource1" GroupItemCount="3">

                    <GroupTemplate>
                        <tr id="itemPlaceholderContainer" runat="server">
                            <td id="itemPlaceholder" runat="server"></td>
                        </tr>
                    </GroupTemplate>

                    <ItemTemplate >
                        <td runat="server" style="text-align: center">
                            <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# string.Format("~/Yoyo/ShowTitle(Users).aspx?Id={0}&Title={1}", Eval("Id"), Eval("Title")) %>'>
                                <asp:Image ID="Image2" runat="server" ImageUrl='<%# string.Format("~/Yoyo/Upload/Userimg.aspx?Id={0}&Title={1}", Eval("Id"), Eval("Title")) %>' Width="256px" Height="196px" /></asp:HyperLink>
                            <br />
                            <asp:HyperLink ID="HyperLink1" runat="server" Width="256px" NavigateUrl='<%# string.Format("~/Yoyo/ShowTitle(Users).aspx?Id={0}&Title={1}", Eval("Id"), Eval("Title")) %>'><%# Eval("Title") %></asp:HyperLink>

                            <br />
                        </td>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                    <table id="Table1" runat="server" class=" table table-bordered table-hover table-responsive-md btn-table">
                                        <tr id="groupPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="text-align: center">
                                    <asp:DataPager ID="DataPager1" runat="server" PageSize="9">
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
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT * FROM [Forum] ORDER BY [DateTime] DESC"></asp:SqlDataSource>



            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

