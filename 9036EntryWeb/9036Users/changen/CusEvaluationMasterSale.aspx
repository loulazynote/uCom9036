<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int id = int.Parse(Request.QueryString["id"].ToString());
        var db = new Entry9036Entities();
        var query = from t in db.Sales
                    join o in db.Evaluations on t.SaleID equals o.SaleID
                    where o.CusID == id.ToString()
                    orderby o.EvaDate descending
                    select new { t.SaleName, o.Content, o.EvaDate, o.level };
        Repeater1.DataSource = query.ToList();
        Repeater1.DataBind();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <h1 class="text-center" style="font-family: Microsoft JhengHei;"><b>客戶拜訪紀錄</b></h1><br/>
        <asp:Repeater ID="Repeater1" runat="server">
            <HeaderTemplate>
                <div id="accordion">
            </HeaderTemplate>
            <ItemTemplate>
                <h3 class="<%# Eval("SaleName")%>">業務姓名:<%# Eval("SaleName")%></h3>
                <div>

                    <b>購買意願:</b><%# Eval("level")%><br /><p>
                        <b>拜訪記事:</b><%# Eval("Content")%></p>
                    <b>評價日期:</b><%# Eval("EvaDate")%><br /></div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
        <br />

        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-block btn-twitter " PostBackUrl="~/ChangEn/SalelistMaster.aspx" Text="返回"></asp:LinkButton>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $(function () {
            $("#accordion").accordion();
        });
    </script>
</asp:Content>

