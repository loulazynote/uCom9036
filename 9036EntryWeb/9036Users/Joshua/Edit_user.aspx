<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["mode"] != null)
        {
            FormView1.DefaultMode = FormViewMode.Insert;
            lblMode.Text = "Insert";
        }
        if (!Page.IsPostBack && Request.QueryString["id"] != null)
        {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindListView(id);
        }
    }
    private void BindListView(int id)
    {
        SqlDataAdapter da = new SqlDataAdapter(
       "select * from Bulletin where  [Id] = @Id",
      WebConfigurationManager.ConnectionStrings
      ["Entry9036"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("Id", id);
        DataTable dt = new DataTable();
        da.Fill(dt);
        FormView1.DataSource = dt;
        FormView1.DataBind();
    }


    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {

    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        string id = e.Keys[0].ToString();
        string Title = e.NewValues[0].ToString();
        string Description = e.NewValues[1].ToString();
        string Category = e.NewValues[2].ToString();
        //string Category = DropDownList1.SelectedValue;

        SqlConnection cn = new SqlConnection(
    WebConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

        SqlCommand cmd = new SqlCommand(
            "UPDATE [Bulletin] SET [Title] = @Title, [Description] = @Description, [Category]=@Category WHERE [Id] = @Id", cn);

        cmd.Parameters.AddWithValue("Title", Title);
        cmd.Parameters.AddWithValue("Description", Description);
        cmd.Parameters.AddWithValue("Category", Category);
        cmd.Parameters.AddWithValue("Id", id);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
    }

    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");

        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style>
        .textStyle {
            border-radius: 5px;
            /*background-color:limegreen;*/
            color: white;
            display: inline-block;
            background-color: limegreen;
            padding: 5px;
        }

        .titleStyle {
            border-radius: 5px;
            background-color: darkred;
            color: white;
            display: ruby-text;
            padding: 5px;
        }
    </style>


</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="main">
        <h2>
            <asp:Label ID="lblMode" runat="server"></asp:Label></h2>
            <div class="titleStyle" style="width: 100%; text-align: center; font-size:larger">
                編輯公佈欄文章
            </div>
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="Id" DefaultMode="Edit" Width="100%" OnItemInserting="FormView1_ItemInserting" OnItemUpdating="FormView1_ItemUpdating" OnItemCommand="FormView1_ItemCommand" CellPadding="4" ForeColor="#333333">
            <EditItemTemplate>
                <%--                Id:
          <asp:Label ID="IdLabel1" runat="server" Text='<%# Eval("Id") %>' />--%>
                <br />
                <div class="textStyle">公告主題: </div>
                <asp:TextBox ID="TitleTextBox" runat="server" Text='<%# Bind("Title") %>' width="60%"/>
                <br />
                <br />
                <div class="textStyle">公告內容: </div>
                <%--<asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>' />--%>
                <CKEditor:CKEditorControl ID="CKEditorControl1" runat="server" Height="100%" Text='<%# Bind("Description") %>'></CKEditor:CKEditorControl>
                <%--<ckeditor:ckeditorcontrol id="CKEditorControl1" runat="server" width="600px"></ckeditor:ckeditorcontrol >--%>
                <br />
                <br />
                <div class="textStyle">公告分類: </div>

                <asp:DropDownList ID="DropDownList1" runat="server" SelectedValue='<%# Bind("Category") %>'>
                    <asp:ListItem Value="團康活動">團康活動</asp:ListItem>
                    <asp:ListItem Value="人事派令">人事派令</asp:ListItem>
                    <asp:ListItem Value="團購活動">團購活動</asp:ListItem>
                    <asp:ListItem Value="公司表單">公司表單</asp:ListItem>
                    <asp:ListItem Value="其他">其他</asp:ListItem>
                </asp:DropDownList>
                <br />
                <br />
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" class="btn btn-primary btn-search">
                更新完成<i class="fas fa-wrench"></i>
                </asp:LinkButton>
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" class="btn btn-primary btn-danger">
                取消編輯<i class="fas fa-times-circle"></i>   
                </asp:LinkButton>
            </EditItemTemplate>
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />


        </asp:FormView>
    </div>
</asp:Content>
