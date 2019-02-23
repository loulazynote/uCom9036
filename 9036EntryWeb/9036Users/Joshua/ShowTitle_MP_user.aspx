<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Web.ModelBinding" %>
<%@ Import Namespace="System.Data.Entity.Core.EntityClient" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            int id = int.Parse(Request.QueryString["id"]);
            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
            cn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Bulletin SET [View] = [View]+1 WHERE (id=@Id)", cn);
            cmd.Parameters.AddWithValue("@Id", id);
            cmd.ExecuteNonQuery();
            cn.Close();
        }

    }

    protected void Return_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
    }





</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <style type="text/css">
        #adminedit > div > div.row > table th {
            background-color: #F7F7F7;
            color: #333;
            font-weight: bold;
        }

        #adminedit > div > div.row > table th, table td {
            padding: 5px;
            border-color: #ccc;
        }

        #adminedit > div > div.row {
            padding-left: 0;
            margin: 20px 0;
            border-radius: 4px;
        }

            #adminedit > div > div.row > table > tbody > tr > td {
                display: inline;
            }

                #adminedit > div > div.row > table > tbody > tr > td > a, #adminedit > div > div.row > table > tbody > tr > td > span {
                    position: relative;
                    float: left;
                    padding: 8px 12px;
                    line-height: 1.42857143;
                    text-decoration: none;
                    color: #009BEE;
                    background-color: #ffffff;
                    border: 1px solid #dddddd;
                    margin-left: -1px;
                }

                #adminedit > div > div.row > table > tbody > tr > td > span {
                    position: relative;
                    float: left;
                    padding: 8px 12px;
                    line-height: 1.42857143;
                    text-decoration: none;
                    margin-left: -1px;
                    z-index: 2;
                    color: #fff;
                    background-color: #5bc0de;
                    border-color: #dddddd;
                    cursor: default;
                }

                #adminedit > div > div.row > table > tbody > tr > td:first-child > a, #adminedit > div > div.row > table > tbody > tr > td:first-child > span {
                    margin-left: 0;
                    border-bottom-left-radius: 4px;
                    border-top-left-radius: 4px;
                }

                #adminedit > div > div.row > table > tbody > tr > td:last-child > a, #adminedit > div > div.row > table > tbody > tr > td:last-child > span {
                    border-bottom-right-radius: 4px;
                    border-top-right-radius: 4px;
                }

                #adminedit > div > div.row > table > tbody > tr > td > a:hover, #adminedit > div > div.row > table > tbody > tr > td > span:hover, #adminedit > div > div.row > table > tbody > tr > td > a:focus, #adminedit > div > div.row > table > tbody > tr > td > span:focus {
                    color: #d58512;
                    background-color: #eeeeee;
                    border-color: #dddddd;
                }

        .textStyle {
            border-radius: 5px;
            background-color: darkred;
            color: white;
            display: inline-block;
        }
           
        .titleStyle{
          border-radius:5px;
            background-color:darkred;
            color:white;
            display:ruby-text;
            padding: 5px;
        }


 



        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="row">
        <div class="col-md-2">
        </div>
        <div class="col-md-8">
                        <div class="titleStyle" style="width: 100%; text-align: center; font-size:larger">
                公佈欄文章
            </div>
            <asp:FormView ID="FormView1" runat="server" BackColor="#ffffff" BorderColor="#8b0000 " BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" DataKeyNames="Id" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Both" >
                <ItemTemplate>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="textStyle">公告主題: </div>
                            <asp:Label ID="TitleLabel" runat="server" Text='<%# Bind("Title") %>' />
                            <hr />
                            <div class="textStyle">公告內容: </div>
                            <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Bind("Description") %>' />
                            <br />
                            <hr />
                            <div class="textStyle">發佈單位: </div>
                            <asp:Label ID="CategoryLabel" runat="server" Text='<%# Bind("Category") %>' />
                            <br />                            
                            <div class="textStyle">發文者: </div>
                            <asp:Label ID="ViewLabel" runat="server" Text='<%# Bind("Announcer") %>' />
                            <br />
                            <div class="textStyle">發文時間: </div>
                            <asp:Label ID="DateIDLabel" runat="server" Text='<%# Bind("Date") %>' />
                </ItemTemplate>
                <%--<PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />--%>
                <PagerStyle CssClass="pagination-ys" />
                <PagerSettings Visible="true" NextPageText="Next" PreviousPageText="Previous" Mode="Numeric"
                    PageButtonCount="10" Position="Bottom" />
            </asp:FormView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT * FROM [Bulletin] WHERE ([Id] = @Id)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <br />
            <asp:LinkButton ID="LinkButton1" runat="server" Text="返回公佈欄" OnClick="Return_Click" class="btn btn-primary btn-search">
            </asp:LinkButton>
<%--            <asp:LinkButton ID="LinkButton2" runat="server" OnClick="Top_Click" class="btn btn-primary btn-danger">
            設為置頂<i class="fas fa-arrow-to-top"></i>
            </asp:LinkButton>
            <asp:LinkButton ID="LinkButton3" runat="server" OnClick="CancelTop_Click" class="btn btn-warning">
                取消置頂
            </asp:LinkButton>--%>
        </div>
        <div class="col-md-2">
        </div>

    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

