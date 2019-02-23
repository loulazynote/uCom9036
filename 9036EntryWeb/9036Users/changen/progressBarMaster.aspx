<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        int id = int.Parse(Request.QueryString["id"].ToString());
        var db = new Entry9036Entities();
        var query = from t in db.Customers
                    where t.SaleID == id
                    select new Progress { CusName = t.CusName, Development = t.Development };
        List<Progress> list = new List<Progress>(query);
        List<Progress> newlist = new List<Progress>();
        foreach (var item in list)
        {
            if (item.Development == "新客戶")
            {
                item.Step1 = "active";
                item.Step2 = "disabled";
                item.Step3 = "disabled";
                item.Step4 = "disabled";
            }
            else if (item.Development == "接洽中")
            {
                item.Step1 = "complete";
                item.Step2 = "active";
                item.Step3 = "disabled";
                item.Step4 = "disabled";
            }
            else if (item.Development == "已提案待回覆")
            {
                item.Step1 = "complete";
                item.Step2 = "complete";
                item.Step3 = "active";
                item.Step4 = "disabled";
            }
            else if (item.Development == "已開發")
            {
                item.Step1 = "complete";
                item.Step2 = "complete";
                item.Step3 = "complete";
                item.Step4 = "active";
            }
            newlist.Add(item);

        }
        //DbFunctions.AddDays＝幫結束日期+1
        Repeater1.DataSource = newlist.ToList();
        Repeater1.DataBind();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="Content/Bar.css" rel="stylesheet" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>客戶開發狀況</B></h1><br/>
     <asp:Repeater ID="Repeater1" runat="server">
        
         
            <ItemTemplate>
                <div class="container">
                    <table id="GridView1" class="table table-hover table-bordered img-rounded">
                <thead >
                    <tr class="btn-facebook">
                        <td><h3 style="font-family:Microsoft JhengHei;" class="text-center"><%# Eval("CusName")%></h3></td>
                    </tr>
                </thead>
                <tbody >
                    <tr  class="warning">
                        <td><div class="row bs-wizard" style="border-bottom: 0;">
                
                <div class="col-xs-3 bs-wizard-step <%# Eval("Step1")%>">
                    <div class="text-center bs-wizard-stepnum">新客戶</div>
                    <div class="progress">
                        <div class="progress-bar"></div>
                    </div>
                    <a href="#" class="bs-wizard-dot"></a>
                    <div class="bs-wizard-info text-center"></div>
                </div>

                <div class="col-xs-3 bs-wizard-step <%# Eval("Step2")%>"">
                    <!-- complete -->
                    <div class="text-center bs-wizard-stepnum">接洽中</div>
                    <div class="progress">
                        <div class="progress-bar"></div>
                    </div>
                    <a href="#" class="bs-wizard-dot"></a>
                    <div class="bs-wizard-info text-center"></div>
                </div>

                <div class="col-xs-3 bs-wizard-step <%# Eval("Step3")%>">
                    <!-- complete -->
                    <div class="text-center bs-wizard-stepnum">已提案待回覆</div>
                    <div class="progress">
                        <div class="progress-bar"></div>
                    </div>
                    <a href="#" class="bs-wizard-dot"></a>
                    <div class="bs-wizard-info text-center"></div>
                </div>

                <div class="col-xs-3 bs-wizard-step <%# Eval("Step4")%>">
                    <!-- active -->
                    <div class="text-center bs-wizard-stepnum">已開發</div>
                    <div class="progress">
                        <div class="progress-bar"></div>
                    </div>
                    <a href="#" class="bs-wizard-dot"></a>
                    <div class="bs-wizard-info text-center"></div>
                </div>
            </div></td>             
                    </tr>
                </tbody>
            </table>
                    
            
 </div>
                </ItemTemplate>

        

        </asp:Repeater>
    <div class="container">
    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-block btn-twitter " PostBackUrl="~/ChangEn/SalelistMaster.aspx" Text="返回"></asp:LinkButton>
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

