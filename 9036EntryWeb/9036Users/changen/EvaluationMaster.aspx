<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
     protected void Button1_Click(object sender, EventArgs e)
    {
        int id = int.Parse(Request.QueryString["id"].ToString());
        string com = comment.InnerText;
        DateTime d = DateTime.Now;
        int saleid = 1;
        string droplevel = DropDownList1.SelectedItem.Value;
        Evaluation evaluations = new Evaluation()
        {
            Content=com,
            CusID=id.ToString(),
            EvaDate=d,
            SaleID=saleid,
            level=droplevel
            
        };
        Entry9036Entities db = new Entry9036Entities();
        db.Evaluations.Add(evaluations);
        db.SaveChanges();
        Response.Redirect("~/ChangEn/SalelistMaster.aspx");
        //if (!Page.IsPostBack && Request.QueryString["id"] != null)
        //{


        //}
    }


    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/SalelistMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="container">
        
            <h1 style="font-family:Microsoft JhengHei;" class="text-center"><b>拜訪記錄</b></h1>
            <div>
                <div class="">
                    <br />
                    <%--<label class="" >購買意願程度:  </label>--%>
                    <asp:Label Font-Size="Medium" Font-Bold="True" for="DropDownList1" ID="Label1" runat="server" Text="Label">購買意願程度:</asp:Label>
                    <asp:DropDownList CssClass="form-control" ID="DropDownList1" runat="server">
                        <asp:ListItem Value="0">請選擇</asp:ListItem>
                        <asp:ListItem>意願高</asp:ListItem>
                        <asp:ListItem>一般</asp:ListItem>
                        <asp:ListItem>沒有意願</asp:ListItem>
                    </asp:DropDownList>
                    <br />
                    <%--<label for="comment">拜訪記事:</label>--%>
                    <asp:Label Font-Size="Medium" Font-Bold="True" for="comment" ID="Label2" runat="server" Text="Label">拜訪記事:</asp:Label>
                    <textarea  class="form-control" rows="5" id="comment" runat="server"></textarea><br />
                    <asp:Button CssClass="btn  btn-facebook" ID="Button1" runat="server" Text="送出" OnClick="Button1_Click" />
                    <asp:Button CssClass="btn  btn-gplus" ID="Button2" runat="server" Text="返回" OnClick="Button2_Click"/>
                </div>
            </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

