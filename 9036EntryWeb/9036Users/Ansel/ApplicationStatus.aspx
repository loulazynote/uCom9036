<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="GemBox.Spreadsheet" %>

<script runat="server">

    SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
    //int id = 0;

    protected void Page_Load(object sender, EventArgs e)
    {

        //id = int.Parse(Request.QueryString["id"].ToString());

        if (!Page.IsPostBack)
        {
            
            BindGridView();
        }


        int Level = (int)Session["Level"];
        if (Level == 3)
        {

            GridView1.Columns[1].Visible = false;
            //createBtn.Visible = false;

        }
        else
        {
            //applyBtn.Visible = false;
        }
    }

    private void BindGridView()
    {

        //SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Roles"].ConnectionString);
        SqlDataAdapter da = new SqlDataAdapter("SELECT c.Id, c.Topic, c.StartTime, c.CreatedTime, e.Name,c.Application FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name Where e.RoleId = 3 ORDER BY c.CreatedTime DESC",cn);
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



    //protected void createBtn_Click(object sender, EventArgs e)
    //{
    //    Response.Redirect("~/Ansel/NewConference.aspx");
    //}


    //protected void applyBtn_Click(object sender, EventArgs e)
    //{
    //    Response.Redirect("~/Ansel/Application.aspx");
    //}


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


    protected void selectBtn_Click1(object sender, EventArgs e)
    {
        Button btn = sender as Button;
        int id = int.Parse(btn.CommandArgument);
        Response.Redirect("~/Ansel/ConferenceInfoForApplication.aspx?id=" + id);
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        BindGridView();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];
        string application = e.NewValues[0].ToString();
        //int id = int.Parse(Request.QueryString["id"].ToString());
        //Response.Write(id);

        //string desc = e.NewValues[0].ToString();
        //Response.Write(desc);
        //ado.net update db
        SqlCommand cmd = new SqlCommand(
            "UPDATE  Conference SET Application = @Application WHERE (Id = @Id)", cn);
        cmd.Parameters.AddWithValue("Id", id);
        cmd.Parameters.AddWithValue("Application", application);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        Response.Redirect("~/Ansel/ApplicationStatus.aspx");
    }


    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Response.Redirect("~/Ansel/ApplicationStatus.aspx");
    }

    protected void excelBtn_Click(object sender, EventArgs e)
    {
        SpreadsheetInfo.SetLicense("Free-LIMITED-KEY");

        SqlDataAdapter da = new SqlDataAdapter(
       "SELECT c.Id, c.Topic, c.StartTime, c.CreatedTime, e.Name,c.Application FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name Where e.RoleId = 3 ORDER BY c.CreatedTime DESC", cn);
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
        xlsx.Save(Server.MapPath(@"~/Ansel/Output/ApplicationStatus.xlsx"));
        Response.Redirect("~/Ansel/Output/ApplicationStatus.xlsx");
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>

        &nbsp;

        <asp:Button ID="excelBtn" runat="server" Text="檔案匯出" OnClick="excelBtn_Click" />
        <br />
        <br />
        <%--1.已建立會議Table--%>
        <%--2.管理者編輯.刪除--%>
        <asp:GridView ID="GridView1" runat="server" CssClass="table table-hover table-striped" GridLines="None" 
    AutoGenerateColumns="False" DataKeyNames="Id" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit">
            <%--DataSourceID="SqlDataSource1"--%>
            <Columns>
                <%--<ItemTemplate>
                        <asp:CheckBox ID="Application" runat="server" Text="審核狀態" Checked='<%# Convert.ToBoolean(Eval("Application")) %>'/>
                </ItemTemplate>--%>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="selectBtn" runat="server" Text="詳細資料" CommandArgument='<%# Eval("Id") %>' OnClick="selectBtn_Click1"/>
                                          
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowEditButton="True" CancelText="取消" EditText="審核" UpdateText="確定"></asp:CommandField>
                <asp:BoundField DataField="Id" Visible="False" />
                <asp:BoundField DataField="Topic" HeaderText="主題" SortExpression="Topic" ReadOnly="True" />
                <asp:BoundField DataField="StartTime" HeaderText="開會時間" SortExpression="StartTime" ReadOnly="True" />  
                <asp:BoundField DataField="CreatedTime" HeaderText="建立時間" SortExpression="CreatedTime" ReadOnly="True" />
                <asp:BoundField DataField="Name" HeaderText="建立者" SortExpression="Name" ReadOnly="True" />
                <asp:TemplateField HeaderText="審核狀態" SortExpression="Application">
                    <EditItemTemplate>
                        <asp:DropDownList ID="DropDownList1" runat="server" SelectedValue='<%# Bind("Application") %>'>
                            <asp:ListItem>未審核</asp:ListItem>
                            <asp:ListItem>審核成功</asp:ListItem>
                            <asp:ListItem>審核失敗</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Application") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <br />
        &nbsp;
        <asp:Button ID="returnBtn" runat="server" Text="返回首頁" OnClick="returnBtn_Click" />
        
       <%-- <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Roles %>" SelectCommand="SELECT c.Topic, c.StartTime, c.CreatedTime, e.Name FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name ORDER BY c.CreatedTime DESC"></asp:SqlDataSource>--%>

    </div>

    <%--<div id="jsGrid"></div>--%>


    <%--jsGrid要秀在Ajax成功function裡--%>

    <%--<script>
        
        $.ajax({
            type: "POST",
            async: false,
            url: "/WebService.asmx/GetConferenceInfo",
            data: {},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {


                $("#jsGrid").jsGrid({
                    width: "100%",
                    height: "400px",

                    inserting: true,
                    editing: true,
                    sorting: true,
                    paging: true,

                    data: data.d,



                    fields: [
                        { name: "主題", type: "text", width: 100, validate: "required" },
                        { name: "開會時間", type: "text", width: 70 },
                        { name: "建立時間", type: "text", width: 70 },
                        { name: "建立者", type: "select", items: countries, valueField: "Id", textField: "Name", width: 50 },
                        //{ name: "Married", type: "checkbox", title: "Is Married", sorting: false },
                        { type: "control" }
                    ]


                });

            }
        });
    </script>--%>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>




