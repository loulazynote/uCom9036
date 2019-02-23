<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string barQuery = "";
        string stepQuery = "";
        if (Request.QueryString["Mode"] == "user")
        {
            barQuery = "select count(State) as cc , [State] from groupList Where EmployeeID=@EmployeeID group by [State] ";
            stepQuery = "SELECT groupId,ProductName,[State] FROM groupList  Where EmployeeID=@EmployeeID Order by groupId DESC";
            Label1.Text = "個人圖表生成";
        }
        else
        {
            barQuery = "select count(State) as cc , [State] from groupList group by [State] ";
            stepQuery = "SELECT groupId,ProductName,[State] FROM groupList Order by groupId DESC";
        }

        String EmployeeID = Session["ID"].ToString();
        DataTable data = new DataTable();
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            DataSet ds = new DataSet();
            ds.Clear();
            SqlDataAdapter cm = new SqlDataAdapter(stepQuery, con);
            cm.SelectCommand.Parameters.AddWithValue("@EmployeeID", EmployeeID);
            cm.Fill(ds);
            con.Open();
            SqlDataReader dr = cm.SelectCommand.ExecuteReader();
            ProgressList A = new ProgressList();
            List<ProgressList> list = new List<ProgressList>();
            List<ProgressList> newlist = new List<ProgressList>();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    ProgressList alist = new ProgressList { State = dr.GetSqlString(2).ToString(), ProductName = dr.GetSqlString(1).ToString(), groupId = dr.GetSqlInt32(0).ToString() };
                    list.Add(alist);
                }
            };

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
                newlist.Add(item);
            }
            Repeater1.DataSource = newlist.ToList();
            Repeater1.DataBind();
            con.Close();
            SqlDataAdapter da = new SqlDataAdapter(barQuery, con);
            da.SelectCommand.Parameters.AddWithValue("@EmployeeID", EmployeeID);

            DataTable dt = new DataTable();
            da.Fill(dt);
            var StateAry = dt.AsEnumerable().Select(r => r["State"].ToString()).ToArray();
            var CountAry = dt.AsEnumerable().Select(r => r["cc"].ToString()).ToArray();
            HiddenField3.Value = string.Join(",", StateAry);
            HiddenField4.Value = string.Join(",", CountAry);
        }
    }

    protected void radio1_CheckedChanged(object sender, EventArgs e)
    {
        if (radio1.Checked == true)
        {
            HiddenField1.Value = "true";
        }
        else
        {
            HiddenField1.Value = "false";
        }

    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DropDownList1.SelectedValue == "total")
        {
            Response.Redirect("Chart.aspx");
        }
        else if (DropDownList1.SelectedValue == "user")
        {
            Response.Redirect("Chart.aspx?Mode=user");
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="Stylesheet" type="text/css" />
    <script src="../scripts/Chart.js"></script>
    <script src="../scripts/utils.js"></script>
    <link href="../Content/Bar.css" rel="stylesheet" />

    <style>
        div {
            font-family: Times New Roman,'微軟正黑體';
            font-size: 18px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>

        $(function () {
            if ($("#ContentPlaceHolder1_HiddenField1").val() == "true") {
                document.getElementById("div1").style.display = "none";
                document.getElementById("div2").style.display = "block";

            } else {
                document.getElementById("div2").style.display = "none";
                document.getElementById("div1").style.display = "block";
            }
        });

    </script>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12 container">
        <asp:Label ID="Label1" runat="server" CssClass="h1" Text="總體圖表生成"></asp:Label>
        <br />
        <br />
        <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12  form-horizontal">
            <div class="col-lg-7 form-group">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12">
                    <ul class="nav nav-pills nav-pills-success col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12">
                        <li class="active"><a href="Default.aspx">去跟團</a></li>
                        <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
                        <li class="active"><a href="grouplist.aspx">團單管理</a></li>
                        <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
                        <li class="active"><a href="Chart.aspx">圖表生成</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-5 form-group">
            </div>
            <br />
            <br />
        </div>
        <div class="col-lg-12 h4">
            <div class="col-lg-12">
                <asp:Label ID="Label3" runat="server" Text="選擇範圍："　CssClass="h4">

                </asp:Label>
                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="h4" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                    <asp:ListItem>請選擇</asp:ListItem>
                    <asp:ListItem Value="total">總體團單圖表</asp:ListItem>
                    <asp:ListItem Value="user">個人團單圖表</asp:ListItem>
                </asp:DropDownList>

            </div>

            <div class="col-lg-12 radio radio-primary radio-inline">
                                <asp:Label ID="Label4" runat="server" Text="選擇模式："　CssClass="h4"></asp:Label>

                <asp:RadioButton ID="radio1" runat="server" CssClass="radio radio-primary radio-inline" GroupName="color" Text="開團商品狀態" OnCheckedChanged="radio1_CheckedChanged" Checked="true" AutoPostBack="True" />
                <asp:RadioButton ID="radio2" CssClass="radio radio-primary radio-inline" runat="server" GroupName="color" Text="開團商品狀態統計長條圖" OnCheckedChanged="radio1_CheckedChanged" AutoPostBack="True" />
            </div>

        </div>

        <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12 div2" id="div1">
            <asp:HiddenField ID="HiddenField3" runat="server" />
            <asp:HiddenField ID="HiddenField4" runat="server" />
            <asp:HiddenField ID="HiddenField1" runat="server" Value="true" />

            <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12 div2">
                <canvas id="myChart" class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12 div1"></canvas>
            </div>

        </div>

        <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12 div1" id="div2">
            <br />
            <br />
            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div class="col-lg-12">
                        <asp:Label ID="Label2" runat="server" Text='<%#"#"+Eval("groupId")+"  "+ Eval("ProductName")%>'></asp:Label>
                    </div>
                    <div class="col-lg-12">
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
                    </div>
                </ItemTemplate>

            </asp:Repeater>
        </div>

    </div>
    <script>
        var ctx = document.getElementById("myChart");
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: document.getElementById("ContentPlaceHolder1_HiddenField3").value.split(","),
                datasets: [{
                    label: '團單數量',
                    data: document.getElementById("ContentPlaceHolder1_HiddenField4").value.split(","),
                    borderWidth: 3,
                    backgroundColor: ['rgba(255, 99, 132, 0.5)', 'rgba(255, 221, 98, 0.5)', 'rgba(169, 255, 98, 0.5)', 'rgba(98, 223, 255, 0.5)'],
                    borderColor: ['rgba(255, 99, 132, 1)', 'rgba(255, 221, 98, 1)', 'rgba(169, 255, 98, 1)', 'rgba(98, 223, 255, 1)'],
                }]
            },
            options: {
                title: {
                    display: true,
                    text: '開團商品狀態',
                    fontSize: 24,
                    fontStyle: 'bold',
                    fontFamily: "'Times New Roman','微軟正黑體'",

                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true,
                            stepSize: 1,
                            fontSize: 20,
                        }
                    }],
                    xAxes: [{
                        ticks: {
                            beginAtZero: true,
                            fontSize: 20,
                            fontFamily: "'Times New Roman','微軟正黑體'"
                        }
                    }],

                }
            }
        });
    </script>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

