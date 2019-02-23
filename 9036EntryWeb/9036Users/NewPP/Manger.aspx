<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%-- 這邊先加上--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GemBox.Spreadsheet" %>
<%--<!DOCTYPE html>--%>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)   //如代表第一次到這網站
        {
            BindListView();
        }

    }

    protected void BindListView()
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Result], [Content], [Replay], [Nowdate], [Department] FROM [AllEmployess] WHERE [EmpId]=N'林小威'",
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        ListView1.DataSource = dt;
        ListView1.DataBind();
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        //ClientScript.RegisterStartupScript(this.GetType(), "DeleteButton", "alertem()", true);

        //Response.Write(e.Keys[0].ToString());  //測試 是否有抓到id=key[0]
        int id = (int)e.Keys[0];
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM AllEmployess WHERE(Id=@Id)", cn);
        cmd.Parameters.AddWithValue("@Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/NewPP/Manger.aspx");


    }

    protected void But1_Click(object sender, EventArgs e) //列印輸出事件
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM [AllEmployess] WHERE [EmpId]=N'林小威' ",
        ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        DataTable dt = new DataTable("MyTable");
        da.Fill(dt);


        SpreadsheetInfo.SetLicense("FREE-LIMITED-KEY");
        ExcelFile xlsx = new ExcelFile();
        ExcelWorksheet mySheet = xlsx.Worksheets.Add("sheet1");
        mySheet.InsertDataTable(dt,
           new InsertDataTableOptions()
           {
               StartColumn = 2,
               StartRow = 2,
               ColumnHeaders = true
           });
        xlsx.Save(Server.MapPath(@"Output\lin.xlsx"));
        Response.Redirect("~/NewPP/Output/lin.xlsx");
    }


    protected void ListView1_ItemDataBound(object sender, ListViewItemEventArgs e)
    {


        //e.Item.FindControl
        //System.Data.DataRowView aa = (System.Data.DataRowView)e.Item.DataItem;
        //Response.Write("aa" + aa.Row.ItemArray[1]);

        //Label LB = (Label)e.Item.FindControl("ResultLabel");
        //Response.Write("aa" + LB.Text+"<br/>");
        //Button bt = (Button)e.Item.FindControl("DeleteButton");
        //Response.Write("aa" + bt.Text + "<br/>");
        Label LB = (Label)e.Item.FindControl("ResultLabel");
        //string LB1 = LB.ToString();

        //Button BT = (Button)e.Item.FindControl("DeleteButton");

        if (LB.Text.ToString() != "未審核")
        {
            Button BT = (Button)e.Item.FindControl("DeleteButton");
            HyperLink HL = (HyperLink)e.Item.FindControl("HyperLink1");
            HL.Visible = false;
            BT.Visible = false;
        }


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style>
        text {
            font-family: '微軟正黑體';
        }

        th {
            text-align: center;
        }

        td {
            text-align: center;
        }

        .table-hover > tbody > tr:hover > td,
        .table-hover > tbody > tr:hover > th {
            background-color: lightblue;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <br />
    <br />
    <asp:Label ID="Label1" runat="server" Text="職員名:"></asp:Label>
    <asp:Label ID="Label2" runat="server" Text="林小威"></asp:Label>
    <br />
    <asp:Label ID="Label3" runat="server" Text="部門:"></asp:Label>
    <asp:Label ID="Label4" runat="server" Text="業務部"></asp:Label>


    <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" OnItemDataBound="ListView1_ItemDataBound">

        <ItemTemplate>

            <tr style="background-color: #FFFFFF; color: #333333; border-collapse: collapse;">

                <td>
                    <asp:Label CssClass="p-lg" ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                </td>

                <td>
                    <asp:Label CssClass="" ID="EmpIdLabel" runat="server" Text='<%# Eval("EmpId") %>' />
                </td>
                <td>
                    <asp:Label ID="StarttimeLabel" runat="server" Text='<%# Eval("Starttime") %>' />
                </td>
                <td>
                    <asp:Label ID="OvertimeLabel" runat="server" Text='<%# Eval("Overtime") %>' />
                </td>
                <td>
                    <asp:Label ID="EventLabel" runat="server" Text='<%# Eval("Event") %>' />
                </td>
                <td>
                    <asp:Label ID="HourLabel" runat="server" Text='<%# Eval("Hour") %>' />
                </td>
                <td>
                    <asp:Label ID="ResultLabel" runat="server" Text='<%# Eval("Result") %>' />
                </td>
                <td>
                    <asp:Label ID="ContentLabel" runat="server" Text='<%# Eval("Content") %>' />
                </td>
                <td>
                    <asp:Label ID="ReplayLabel" runat="server" Text='<%# Eval("Replay") %>' />
                </td>
                <td>
                    <asp:Label ID="NowdateLabel" runat="server" Text='<%# Eval("Nowdate") %>' />
                </td>
                <td>
                    <asp:Label ID="DepartmentLabel" runat="server" Text='<%# Eval("Department") %>' />
                </td>
                <td>
                    <asp:Button class="btn btn-danger" ID="DeleteButton" runat="server" OnClientClick="return confirm('確定刪除嗎?');" CommandName="Delete" Text="刪除" />
                    <asp:HyperLink class="btn btn-success" ID="HyperLink1" NavigateUrl='<%# Eval("Id","MangerEdit.aspx?id={0}") %>' runat="server">修改</asp:HyperLink>
                    <%-- <a ID="Edit" href="EmpEdit.aspx?id=<%# Eval("Id") %>">Edit</a>--%>
                </td>
            </tr>



        </ItemTemplate>
        <LayoutTemplate>


            <table runat="server">
                <tr runat="server">
                    <td runat="server">
                        <table class="table table-bordered table-hover" id="itemPlaceholderContainer" runat="server">
                            <tr runat="server" style="background-color: rgba(153, 153, 153, 0.72); color: #333333; height: 40px;">
                                <th runat="server">假單編號</th>
                                <th runat="server">員工名稱</th>
                                <th runat="server">開始時間</th>
                                <th runat="server">結束時間</th>
                                <th runat="server">假單</th>
                                <th runat="server">時數</th>
                                <th runat="server">審核</th>
                                <th runat="server">備註原因</th>
                                <th runat="server">回覆備註</th>
                                <th runat="server">申請時間</th>
                                <th runat="server">部門</th>
                                <th runat="server">編輯</th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr runat="server">
                    <td runat="server" style="text-align: center; background-color: #5D7B9D; font-family: Verdana, Arial, Helvetica, sans-serif; color: #FFFFFF"></td>
                </tr>
            </table>


        </LayoutTemplate>
    </asp:ListView>
    <a class="mb-xs mt-xs mr-xs btn btn-lg btn btn-info" href="MangerEdit.aspx?Mode=Insert">申請假單</a>
    <asp:Button ID="But1" runat="server" Text="EXCEL 輸出" CssClass="col-sm-1.5 text-center btn btn-success" OnClientClick="alert('EXCEL輸出完成');" OnClick="But1_Click" />
    <%--<a class=" mb-xs mt-xs mr-xs btn btn-lg btn btn-primary " href="../ReView.aspx"><i class="fa fa-book"></i>審核頁面</a>--%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

 <%--   <script>
        $(function () {
            $("#ContentPlaceHolder1_But1").click(function () {
                swal(
                    '錯誤',
                    '左方請先勾選不通過假單!',
                    'success'
                );
            });
        });



    </script>--%>
</asp:Content>


