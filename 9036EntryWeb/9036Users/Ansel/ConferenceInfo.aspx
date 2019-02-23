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
        SqlDataAdapter da = new SqlDataAdapter("SELECT Id, Topic, StartTime, EndTime, CreatedTime, Host, Recorder, Participant, Creator, Content,FileName FROM Conference LEFT JOIN Employees ON Creator = Name where (Id = @Id) ORDER BY CreatedTime DESC", cn);

        da.SelectCommand.Parameters.AddWithValue("ID", id);
        DataTable dt = new DataTable();
        da.Fill(dt);

        

        FormView1.DataSource = dt;
        FormView1.DataBind();

    }

    protected void returnBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Ansel/Default.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    
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
                        <asp:Label ID="hostTxt" runat="server" CssClass="col-md-4 control-label" Text="主席:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox7" runat="server" CssClass="form-control" ReadOnly="True"  Text='<%# Bind("Host") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="creatorTxt" runat="server" CssClass="col-md-4 control-label" Text="紀錄:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox8" runat="server" CssClass="form-control" ReadOnly="True"  Text='<%# Bind("Recorder") %>' Width="250px"></asp:TextBox>
                        </div>
                    </div>
                    </br>
                    </br>
                    <div class="form-group">
                        <asp:Label ID="partiTxt" runat="server" CssClass="col-md-4 control-label" Text="參與者:"></asp:Label>
                        <div class="col-md-8">
                            <asp:TextBox ID="TextBox9" runat="server" CssClass="form-control" ReadOnly="True" Text='<%# Bind("Participant") %>' Width="250px"></asp:TextBox>
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

    <asp:Button ID="returnBtn" runat="server" Text="返回" OnClick="returnBtn_Click" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

