<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GemBox.Spreadsheet" %>



<script runat="server">

    SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindGridView();
        }


        int Level = (int)Session["Level"];
        if (Level == 3)
        {

            GridView1.Columns[1].Visible = false;
            createBtn.Visible = false;

        }
        else
        {
            applyBtn.Visible = false;
        }
    }

    private void BindGridView()
    {


        SqlDataAdapter da = new SqlDataAdapter("SELECT c.Id, c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name where c.Application=N'審核成功' ORDER BY c.CreatedTime DESC", cn);
        DataTable dt = new DataTable();
        da.Fill(dt);
        GridView1.DataSource = dt;
        GridView1.DataBind();



        //Response.Write(dt.Rows[0]["RegionDescription"]);

        //LINQ to DataSet
        //var result = from t in dt.AsEnumerable()
        //             where (int)t["RegionID"] == 2
        //             select t;

        //foreach (var item in result)
        //{
        //    Response.Write(item["RegionDescription"]);
        //}
    }


    protected void createBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Ansel/NewConference.aspx");
    }


    protected void applyBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Ansel/Application.aspx");
    }

    protected void GrideView1_ItemDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //Response.Write(e.Keys[0].ToString());
        int id = (int)e.Keys[0];

        SqlCommand cmd = new SqlCommand("DELETE FROM Conference WHERE (Id = @Id)", cn);
        cmd.Parameters.AddWithValue("@Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/Ansel/Default.aspx");
    }


    //protected void deleteBtn_Click(object sender, EventArgs e)
    //{

    //    //SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Roles"].ConnectionString);

    //    //SqlCommand cmd = new SqlCommand("DELETE FROM Conference where @Topic=topic)", cn);
    //    //SqlDataAdapter da = new SqlDataAdapter();
    //    //da.DeleteCommand = cmd;
    //    //DataSet ds= new DataSet();

    //    ////SqlDataAdapter da = new SqlDataAdapter("DELETE FROM Conference where @Topic=topic)", cn);

    //    ////DataTable dt = new DataTable();
    //    ////da.Fill(dt);


    //    //cn.Open();
    //    //cmd.ExecuteNonQuery();
    //    //cn.Close();

    //}



    protected void editBtn_Click(object sender, EventArgs e)
    {
        Button btn = sender as Button;
        int id = int.Parse(btn.CommandArgument);
        Response.Redirect("~/Ansel/EditConference.aspx?id=" + id);
    }

    protected void selectBtn_Click1(object sender, EventArgs e)
    {
        Button btn = sender as Button;
        int id = int.Parse(btn.CommandArgument);
        Response.Redirect("~/Ansel/ConferenceInfo.aspx?id=" + id);
    }

    protected void excel_Click(object sender, EventArgs e)
    {
        SpreadsheetInfo.SetLicense("Free-LIMITED-KEY");

        SqlDataAdapter da = new SqlDataAdapter(
       "SELECT c.Id, c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name where c.Application=N'審核成功' ORDER BY c.CreatedTime DESC", cn);
        DataTable dt = new DataTable("MyTable");
        da.Fill(dt);


        SpreadsheetInfo.SetLicense("FREE-LIMITED-KEY");
        ExcelFile xlsx = new ExcelFile();
        ExcelWorksheet mySheet = xlsx.Worksheets.Add("sheet1");
        mySheet.InsertDataTable(dt,
           new InsertDataTableOptions()
           {
               StartColumn = 0,
               StartRow = 0,
               ColumnHeaders = true
           });
        //xlsx.Save(Server./*MapPath*/(@"Ansel\Output\Conference.xlsx"));
        xlsx.Save(Server.MapPath(@"~/Ansel/Output/Conference.xlsx"));
        Response.Redirect("~/Ansel/Output/Conference.xlsx");
    }


    protected void returnBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Ansel/Default.aspx");
    }
</script>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Ansel/Content/jsgrid.min.css" rel="stylesheet" />
    <link href="/Ansel/Content/jsgrid-theme.min.css" rel="stylesheet" />
    <script src="/Ansel/Scripts/jsgrid.min.js"></script>
    <link href="/Ansel/Content/jquery.datetimepicker.css" rel="stylesheet" />
    <script src="/Ansel/Scripts/jquery.datetimepicker.full.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <%--admin--%>
        &nbsp;
        <asp:Button ID="createBtn" runat="server" Text="新增會議" OnClick="createBtn_Click" />
        <%--employee--%>
        <asp:Button ID="applyBtn" runat="server" Text="申請會議" OnClick="applyBtn_Click" />
        <asp:Button ID="excel" runat="server" Text="檔案匯出" OnClick="excel_Click" />
        <asp:TextBox ID="queryTime" runat="server" AutoComplete="off"></asp:TextBox><asp:Button ID="queryTimeBtn" runat="server" Text="會議查詢" OnClientClick="return false" />
        <asp:Button ID="returnBtn" runat="server" Text="返回" OnClick="returnBtn_Click" />
        <br />
        <br />
        <br />
        <%--1.已建立會議Table--%>
        <%--2.管理者編輯.刪除--%>

        <div id="tablePlaceParent" class="tablePlaceParent">
            <div id="tablePlace" class="tablePlace"></div>
        </div>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" CssClass="table table-hover table-striped" GridLines="None"
            AutoGenerateColumns="False" AllowPaging="True" OnRowDeleting="GrideView1_ItemDeleting" DataKeyNames="Id">
            <%--DataSourceID="SqlDataSource1"--%>
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="selectBtn" runat="server" Text="詳細資料" CommandArgument='<%# Eval("Id") %>' OnClick="selectBtn_Click1" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="editBtn" runat="server" Text="編輯" CommandArgument='<%# Eval("Id") %>' OnClick="editBtn_Click" />
                        <asp:Button ID="deleteBtn" runat="server" Text="刪除" CommandName="Delete" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Id" Visible="False" />
                <asp:BoundField DataField="Topic" HeaderText="主題" SortExpression="Topic" />
                <asp:BoundField DataField="StartTime" HeaderText="開會時間" SortExpression="StartTime" />
                <asp:BoundField DataField="CreatedTime" HeaderText="建立時間" SortExpression="CreatedTime" />
                <asp:BoundField DataField="Name" HeaderText="建立者" SortExpression="Name" />
            </Columns>
        </asp:GridView>



        <%-- <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Roles %>" SelectCommand="SELECT c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name ORDER BY c.CreatedTime DESC"></asp:SqlDataSource>--%>
    </div>

    <%--<div id="jsGrid"></div>--%>







    <script>

        //$(document).ready(function () {
        //    $('#tablePlace').DataTable();
        //});


        $('#ContentPlaceHolder1_queryTime').datetimepicker();


        $(function () {

            $("#ContentPlaceHolder1_queryTimeBtn").click(function () {

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "/Ansel/WebService.asmx/QueryConference",
                    data: JSON.stringify({
                        keyword: $("#ContentPlaceHolder1_queryTime").val()
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {


                        $('#tablePlaceParent').show();
                        $('#ContentPlaceHolder1_GridView1').hide();
                        //清除上次查詢資料 避免重複顯示
                        $("#tablePlace").empty();

                        //$("#tablePlace").remove();
                        //$("#tablePlaceParent").append("<div id=tablePlace></div>");

                        //組table資料  表頭??
                        var htmlStr = "<table><tr><td >主題</td><td>開會時間</td><td>建立時間</td><td>建立者</td></tr>";
                        if ($(data.d).length == 0) {
                            htmlStr += "<tr><td>找不到資料</td><td>---</td><tr>";
                        }
                        $(data.d).each(function () {

                            htmlStr += "<tr><td>" + $(this)[0].Topic + "</td><td>" + $(this)[0].StartTime + "</td><td>" + $(this)[0].CreatedTime + "</td><td>" + $(this)[0].Creator + "</td></tr>";
                        });
                        htmlStr += "</table>";

                        $("#tablePlace").append(htmlStr);
                        $("tr:first > td").addClass("headerTitle");

                    },
                    error: function () {
                        alert("查無資料");
                    }

                });

            });
        });
    </script>

    <style>
        .tablePlaceParent {
            display: none;
            /*border: 1px solid black;
        border-collapse: collapse;
        width: 200px;*/
            border: 2px solid black;
            border-collapse: collapse;
            width: 100%;
        }

            .tablePlaceParent td {
                border: 2px solid gray;
                height: 40px;
                width: 400px;
                text-align: left;
            }

        .headerTitle {
            background-color: lightgray;
            text-align: center;
        }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>




