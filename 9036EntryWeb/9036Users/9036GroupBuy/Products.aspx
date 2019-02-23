<%@ Page Title="商品介紹" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Script.Services" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            int id = int.Parse(Request.QueryString["id"]);
            DataTable data = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                DataSet ds = new DataSet();
                ds.Clear();
                SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM groupList WHERE (groupList.groupId = @id)", con);
                cm.SelectCommand.Parameters.AddWithValue("@id", id);
                cm.Fill(ds);
                con.Open();
                SqlDataReader dr = cm.SelectCommand.ExecuteReader();
                dr.Read();
                FormView1.DataSource = ds;
                FormView1.DataBind();
                string miltext = dr["groupDesc"].ToString();
                miltext = miltext.Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
                Label Desclabel = ((Label)FormView1.FindControl("Label1"));
                Desclabel.Text = miltext.ToString();

                Label textbox = (Label)FormView1.FindControl("StateLabel");

                if (textbox.Text.Contains("已結標"))
                {
                    textbox.ForeColor = Color.Red;
                    textbox.Font.Bold = true;
                    textbox.BackColor = Color.Yellow;
                }
                else if (textbox.Text.Contains("已成團"))
                {
                    textbox.ForeColor = Color.Red;
                    textbox.Font.Bold = true;
                    textbox.BackColor = ColorTranslator.FromHtml(""); ;
                }
                else
                {
                    textbox.BackColor = ColorTranslator.FromHtml("");
                    textbox.ForeColor = ColorTranslator.FromHtml("#777");
                }

                #region MyRegion
                HiddenField statehf = (HiddenField)FormView1.FindControl("HiddenField1");
                string a = statehf.Value.ToString();
                Progress1 alist = new Progress1 { State = a };
                List<Progress1> list = new List<Progress1>() { alist };
                foreach (var item in list)
                {
                    if (item.State == "未成團")
                    {
                        item.Step1 = "active";
                        item.Step2 = "disabled";
                        item.Step3 = "disabled";
                        item.Step4 = "disabled";
                    }
                    else if (item.State == "開團中")
                    {
                        item.Step1 = "complete";
                        item.Step2 = "active";
                        item.Step3 = "disabled";
                        item.Step4 = "disabled";
                    }
                    else if (item.State == "已成團")
                    {
                        item.Step1 = "complete";
                        item.Step2 = "complete";
                        item.Step3 = "active";
                        item.Step4 = "disabled";
                    }
                    else if (item.State == "已結標")
                    {
                        item.Step1 = "complete";
                        item.Step2 = "complete";
                        item.Step3 = "complete";
                        item.Step4 = "active";
                    }
                }


                FormView2.DataSource = list.ToList();
                FormView2.DataBind();
                #endregion
            };


        }
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Bar.css" rel="stylesheet" />

    <style>
        div {
            font-family: '微軟正黑體';
            font-size: 18px;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <br />
    <div class="col-lg-12 ">
        <div class="col-lg-6">
            <ul class="nav nav-pills nav-pills-success">
                <li class="active"><a href="Default.aspx">去跟團</a></li> 
                <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
                <li class="active"><a href="grouplist.aspx">團單管理</a></li>
                <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
                      
                <li class="active"><a href="Chart.aspx">圖表生成</a></li>
            </ul>
            <br />

        </div>
        <div class="col-lg-6 form-inline">
        </div>
    </div>
    <hr />    
    <div class="col-lg-12  col-xs-12 col-md-12">
        <asp:FormView runat="server" ID="FormView2" CssClass="col-lg-12  col-xs-12 col-md-12">
            <ItemTemplate>
                <div class="row bs-wizard" style="border-bottom: 0;">
                    <div class="col-xs-3  col-md-3  col-lg-3 bs-wizard-step <%# Eval("Step1")%>">
                        <div class="text-center bs-wizard-stepnum">未成團</div>
                        <div class="progress">
                            <div class="progress-bar"></div>
                        </div>
                        <a href="#" class="bs-wizard-dot"></a>
                        <div class="bs-wizard-info text-center"></div>
                    </div>

                    <div class="col-xs-3  col-md-3  col-lg-3 bs-wizard-step <%# Eval("Step2")%>">
                        <!-- complete -->
                        <div class="text-center bs-wizard-stepnum">開團中</div>
                        <div class="progress">
                            <div class="progress-bar"></div>
                        </div>
                        <a href="#" class="bs-wizard-dot"></a>
                        <div class="bs-wizard-info text-center"></div>
                    </div>

                    <div class="col-xs-3  col-md-3  col-lg-3 bs-wizard-step <%# Eval("Step3")%>">
                        <!-- complete -->
                        <div class="text-center bs-wizard-stepnum">已成團</div>
                        <div class="progress">
                            <div class="progress-bar"></div>
                        </div>
                        <a href="#" class="bs-wizard-dot"></a>
                        <div class="bs-wizard-info text-center"></div>
                    </div>

                    <div class="col-xs-3  col-md-3  col-lg-3 bs-wizard-step <%# Eval("Step4")%>">
                        <!-- active -->
                        <div class="text-center bs-wizard-stepnum">已結標</div>
                        <div class="progress">
                            <div class="progress-bar"></div>
                        </div>
                        <a href="#" class="bs-wizard-dot"></a>
                        <div class="bs-wizard-info text-center"></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>
        

    </div>

    <div class="col-lg-12">
       <br />        
        <br /> 
        <asp:FormView ID="FormView1" runat="server" CellPadding="4" CssClass="col-lg-12">

            <ItemTemplate>
                <div class="container col-lg-12">
                    <div class="col-lg-3">
                        <asp:Image ID="Image1" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="img-rounded" Width="100%" />
                    </div>
                    <div class="col-lg-9 ">
                        <div class="col-lg-12">
                            <asp:Label ID="IdLabel" runat="server" Text='<%# "團單編號#"+Eval("groupId")+"　"+Eval("ProductName") %>' Font-Bold="True" CssClass="h1" />
                        </div>
                        <div class="col-lg-12">
                            <br />
                            <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("State")%>' />
                            <asp:Label ID="StateLabel" runat="server" Text='<%# Eval("State")+" ~ "+Eval("DeadLine","{0:yyyy / MM / dd}")%>' Font-Bold="True" CssClass="h2 title" />
                            <br />
                            <br />
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("groupDesc") %>' Font-Size="16" CssClass="title text-dark" />
                            <br />
                            <br />
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("Url") %>' Text="店家網址" CssClass="h3 text-primary"></asp:HyperLink>
                            <br />
                            <br />
                            <asp:HyperLink CssClass="btn btn-danger" ID="HyperLink2" runat="server" NavigateUrl='<%# Eval("GroupId", "shopping.aspx?Mode=Insert&groupid={0}") %>' Text="我要跟團"></asp:HyperLink>

                        </div>

                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

