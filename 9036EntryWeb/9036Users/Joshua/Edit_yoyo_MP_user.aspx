<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<script runat="server">



    protected void Update_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
    }

    protected void UpLoad_Click(object sender, EventArgs e)
    {
        string FileName = FileUpload1.FileName;
        if (FileUpload1.HasFile)
        {
            string uploadPath = "~/Joshua/Upload/" + FileUpload1.FileName;
            //string fileName = FileUpload1.FileName;

            FileUpload1.SaveAs(Server.MapPath(uploadPath));

            Label1.Text = "上傳成功!!";
            Image1.Visible = true;
            Image1.ImageUrl = uploadPath;

            //Label1.Text = CKEditorControl1.Text;
            DateTime Date = DateTime.Now;
            string Title = TitleTextBox.Text;
            string Category = DropDownList1.SelectedValue;
            int View = 0;
            int TopPost = 0;
            FileName = FileUpload1.FileName;

            SqlConnection cn = new SqlConnection(
        WebConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

            SqlCommand cmd = new SqlCommand(
                "INSERT INTO [Bulletin] ([Title], [Date],[Description],[Category],[View],[TopPost],[FileName]) VALUES ( @Title, @Date, @Description, @Category, @View, @TopPost, @FileName)", cn);

            cmd.Parameters.AddWithValue("Title", Title);
            cmd.Parameters.AddWithValue("Date", Date);
            cmd.Parameters.AddWithValue("Description", CKEditorControl1.Text);
            cmd.Parameters.AddWithValue("Category", Category);
            cmd.Parameters.AddWithValue("View", View);
            cmd.Parameters.AddWithValue("TopPost", TopPost);
            cmd.Parameters.AddWithValue("FileName", FileName);
            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();
        }
        else
        {
            Label1.Text = "請選擇要上傳的檔案!!";
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

    <div id="form1" runat="server">
        <div class="titleStyle" style="width: 48%; text-align: center; font-size: larger">
            新增公佈欄文章
        </div>

        <div>
            <br />
            <div class="textStyle">公告主題: </div>
            <asp:TextBox ID="TitleTextBox" runat="server"></asp:TextBox>
            <br />
            <br />
            <div class="textStyle">公告內容: </div>
            <CKEditor:CKEditorControl ID="CKEditorControl1" runat="server" Width="600px"></CKEditor:CKEditorControl>
        </div>
        <br />
        <div class="textStyle">公告分類: </div>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" Category="Department" DataValueField="Category">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT DISTINCT [Category] FROM [Bulletin]"></asp:SqlDataSource>
        <br />
        <br />
        <div class="textStyle">上傳檔案: </div>
        <br />
        <br />
        <div>
            <asp:FileUpload ID="FileUpload1" runat="server" />
            <asp:Button ID="Button3" runat="server" OnClick="UpLoad_Click" Text="上傳" />
            <br />
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
            <asp:Image ID="Image1" runat="server" Visible="False" />
        </div>
        <br />
<%--<div class="textStyle">設為置頂: </div>
        <asp:CheckBox ID="CheckBox1" runat="server"/>--%>

        
        <asp:LinkButton ID="Button1" runat="server" OnClick="Update_Click" class="btn btn-primary btn-search">
        新增完成<i class="fas fa-check-circle"></i>
        </asp:LinkButton>
        <asp:LinkButton ID="Button2" runat="server" OnClick="Button2_Click" class="btn btn-primary btn-danger">
        取消編輯<i class="fas fa-times-circle"></i>
        </asp:LinkButton>

    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

