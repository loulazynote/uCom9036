<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
       

        if (!Page.IsPostBack && Request.QueryString["id"] != null)
        {
            int id = int.Parse(Request.QueryString["id"].ToString());
            //Response.Write(id);
            BindDetailsView(id);
        }

       
    }

    private void BindDetailsView(int id)
    {

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        //SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Topic, StartTime, CreatedTime, Creator, Content FROM Conference LEFT JOIN Employees ON Creator = Name where (Id = @Id) ORDER BY CreatedTime DESC", cn);
        SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Topic, StartTime, EndTime, CreatedTime, Creator, Content,FileName FROM Conference LEFT JOIN Employees ON Creator = Name where (Id = @Id) ORDER BY CreatedTime DESC", cn);
        da.SelectCommand.Parameters.AddWithValue("ID", id);
        DataTable dt = new DataTable();
        da.Fill(dt);

        //DetailsView1.DataSource = dt;
        //DetailsView1.DataBind();

        FormView1.DataSource = dt;
        FormView1.DataBind();

    }

    protected void returnBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Ansel/ApplicationStatus.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="form-group">
        <asp:DetailsView ID="DetailsView1" CssClass="table table-bordered table-striped table-hover" GridLines="Vertical"
            AutoGenerateColumns="False" DataKeyNames="Id" runat="server" Height="100px" Width="150px" AutoGenerateRows="False">
            <Fields>
                <asp:BoundField DataField="Id" Visible="False" />
                <asp:BoundField DataField="Topic" HeaderText="主題" SortExpression="Topic" />
                <asp:BoundField DataField="StartTime" HeaderText="開會時間" SortExpression="StartTime" />
                <asp:BoundField DataField="EndTime" HeaderText="結束時間" SortExpression="EndTime" />
                <asp:BoundField DataField="CreatedTime" HeaderText="建立時間" SortExpression="CreatedTime" />
                <asp:BoundField DataField="Creator" HeaderText="建立者" SortExpression="Creator" />
                <asp:BoundField DataField="Content" HeaderText="會議內容" SortExpression="Content" />
            </Fields>
        </asp:DetailsView>
        <div class="form-group">
            <asp:FormView ID="FormView1" runat="server" DataKeyNames="Id">
                <ItemTemplate>

                    <div class="form-group">
                        <asp:Label ID="topiclbl" runat="server" CssClass="col-md-4 control-label" Text="主題:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="Topic" runat="server" CssClass="form-control" Width="250px" Text='<%# Bind("Topic") %>' ReadOnly="True"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label1" runat="server" CssClass="col-md-4 control-label" Text="開會時間:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("StartTime") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label2" runat="server" CssClass="col-md-4 control-label" Text="結束時間:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("EndTime") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label3" runat="server" CssClass="col-md-4 control-label" Text="建立時間:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("CreatedTime") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label4" runat="server" CssClass="col-md-4 control-label" Text="建立者:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("Creator") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label5" runat="server" CssClass="col-md-4 control-label" Text="會議內容:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("Content") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="Label6" runat="server" CssClass="col-md-4 control-label" Text="附件:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("FileName") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                </ItemTemplate>
            </asp:FormView>
        </div>
    </div>
    <asp:Button ID="returnBtn" runat="server" Text="返回" OnClick="returnBtn_Click" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

