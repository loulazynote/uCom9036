<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Label2.Visible = false;

            BindListView();
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
                Table dt = (Table)FormView1.FindControl("dt");
                Button ExcelButton = (Button)FormView1.FindControl("ExcelButton");
                Button SentButton = (Button)FormView1.FindControl("SentButton");
                Label label = (Label)FormView1.FindControl("lab");
                if (Label2.Visible == true)
                {
                    dt.Visible = false;
                    ExcelButton.Visible = false;
                    SentButton.Visible = false;
                    label.Visible = false;
                }
                else
                {
                    dt.Visible = true;
                    ExcelButton.Visible = true;
                    SentButton.Visible = true;
                    label.Visible = true;

                };

                string miltext = dr["groupDesc"].ToString();
                miltext = miltext.Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
                Label Desclabel = ((Label)FormView1.FindControl("Label1"));
                Desclabel.Text = miltext.ToString();

                Label textbox = (Label)FormView1.FindControl("DescriptionLabel");

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
                HiddenField statehf = (HiddenField)FormView1.FindControl("HiddenField2");
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
        };
    }
    private void BindListView()
    {
        if (Request.QueryString["id"] != null)
        {
            int id = int.Parse(Request.QueryString["id"]);
            DataTable data = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                DataSet ds = new DataSet();
                ds.Clear();
                SqlDataAdapter cm = new SqlDataAdapter("SELECT*,Amount*Price AS Total FROM  [Order] INNER JOIN Employees ON [Order].EmpName = Employees.EmployeeID INNER JOIN groupList ON groupList.groupId = [Order].groupId  WHERE (dbo.groupList.groupId = @id )", con);
                cm.SelectCommand.Parameters.AddWithValue("@id", id);
                cm.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ListView1.DataSource = ds.Tables[0];
                    ListView1.DataBind();
                }
                else
                {
                    Label2.Visible = true;

                };


            }
        };
    }
    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int OrderId = (int)e.Keys[0];
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlCommand cmd = new SqlCommand("DELETE FROM [Order] WHERE Id = @OrderId", cn);
        cmd.Parameters.AddWithValue("@OrderId", OrderId);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        int groupid = int.Parse(Request.QueryString["id"]);

        Response.Redirect("~/9036GroupBuy/groupOrder.aspx?id=" + groupid.ToString());
    }


    protected void SentButton_Click(object sender, EventArgs e)
    {
        ExcelHiddenField.Value = "false";
        MailHiddenField.Value = "false";
        TextBox SubjectLabel = (TextBox)FormView1.FindControl("Subject");
        TextBox BodyLabel = (TextBox)FormView1.FindControl("Body");
        Label TitleLabel = (Label)FormView1.FindControl("IdLabel");
        string title = "團購系統通知";
        string Subjecta = SubjectLabel.Text + "_" + TitleLabel.Text;
        string Body = BodyLabel.Text;
        string miltext = Body;
        miltext = miltext.Replace(System.Environment.NewLine, "<br>").Replace(" ", "&nbsp;");
        List<string> MailList = new List<string>();

        for (int i = 0; i < ListView1.Items.Count; i++)
        {
            //List<string> MailList, string Subject, string Body--%>
            Label EMail = ((Label)ListView1.Items[i].FindControl("DeadLabel"));
            HtmlInputCheckBox CheckBox1 = ((HtmlInputCheckBox)ListView1.Items[i].FindControl("CheckBox1"));
            //Label CheckBox1 = ((Label)ListView1.Items[i].FindControl("DeadLabel"));

            if (CheckBox1.Checked == true)
                MailList.Add(EMail.Text);
        };
        string[] MailArray = MailList.ToArray();
        if (MailArray.Length > 0)
        {
            if (miltext != null && Subjecta != null)
            {
                groupbuylocal.WebService ws = new groupbuylocal.WebService();
                string dalert = ws.email(title, MailArray, Subjecta, miltext);
                string usermail = Session["Mail"].ToString();

                string[] aaa = new string[] { usermail };

                string titlecc = "團購系統通知";
                string Subjectcc = "寄件副本" + Subjecta;
                groupbuylocal.WebService wwws = new groupbuylocal.WebService();
                string succ = wwws.email(titlecc, aaa, Subjectcc, miltext);
                MailHiddenField.Value = succ;
                //string js = @"swal('寄送成功', 'E-mail寄送成功可至郵箱查看寄件副本', 'success');";
                //ClientScript.RegisterStartupScript(Page.GetType(), Guid.NewGuid().ToString(), js, true);
            }
            else
            {
                MailHiddenField.Value = "fail";

            }
        }
        else
        {
            MailHiddenField.Value = "fail";

        }


    }

    protected void ExcelButton_Click(object sender, EventArgs e)
    {
        ExcelHiddenField.Value = "false";
        MailHiddenField.Value = "false";

        string qs = "SELECT Id AS 訂單編號,Name AS 客戶姓名,Amount AS 訂購數量,Amount*Price AS 訂單總額,Email FROM  [Order] INNER JOIN Employees ON [Order].EmpName = Employees.EmployeeID INNER JOIN groupList ON groupList.groupId = [Order].groupId  WHERE dbo.groupList.groupId = @groupId ";
        HiddenField TitleLabel = (HiddenField)FormView1.FindControl("HiddenField1");
        string title = "訂單明細" + TitleLabel.Value + "_" + DateTime.Now.ToString("yyyyMMddHHmm");
        string EmployeeId = "";
        int id = int.Parse(Request.QueryString["id"].ToString());
        groupbuylocal.WebService ws = new groupbuylocal.WebService();
        string dalert = ws.download(EmployeeId, id, title, qs);
        Response.Redirect(dalert);

        if (dalert == null)
        {
            ExcelHiddenField.Value = "fail";
        }
    }

    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //set current page startindex, max rows and rebind to false
        DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        DataPager2.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

        //rebind List View
        BindListView();
        Label textbox = (Label)FormView1.FindControl("DescriptionLabel");

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

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        TextBox SubjectLabel = (TextBox)FormView1.FindControl("Subject");
        TextBox BodyLabel = (TextBox)FormView1.FindControl("Body");
        SubjectLabel.Text = "【取貨通知】";
        BodyLabel.Text = "您好！\r\n您團購的商品已於" + DateTime.Now.ToString("yyyy/MM/dd") + "到貨，\r\n請於" + DateTime.Now.AddDays(7).ToString("yyyy/MM/dd") + "前至業務部，\r\n向Tom領取貨品。\r\n謝謝您的合作!";


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!--引用jQuery-->
    <script src="https://code.jquery.com/jquery-3.2.1.min.js" type="text/javascript"></script>
    <!--引用SweetAlert2.js-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.0.0/sweetalert2.all.js"></script>
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
        function checkall1() {
            var check1 = document.getElementById("checkall");
            //var check2 = document.getElementsByName("CH1");

            //for (var i = 0; i < check2.length; i++) {
            //    check2[i].checked = check1.checked;
            //};
            $(".allall").each(function () {

                //if ($(this).attr("name").indexOf("CheckBox1") > 0) {
                this.checked = check1.checked;
                //}

            });
        }



    </script>
    <script>
        $(function () {
            $("#ContentPlaceHolder1_FormView1_SentButton").click(function () {
                myConfirm();
            });
            $("#ContentPlaceHolder1_FormView1_ExcelButton").click(function () {
                myConfirm2();

            });
        });

        function myConfirm() {

            let btnName = $("input#ContentPlaceHolder1_FormView1_SentButton").attr("name");
            //confirm dialog範例
            swal({
                title: "確定寄出？",
                html: "按下確定後E-mail將會送出",
                type: "question",
                showCancelButton: true//顯示取消按鈕
            }).then(function () {
                __doPostBack(btnName, "");
            },
            );//end then 
        }//end function myConfirm()

        function myConfirm2() {

            let btnName = $("input#ContentPlaceHolder1_FormView1_ExcelButton").attr("name");
            //confirm dialog範例
            swal({
                title: "確定匯出？",
                html: "按下確定後訂單明細將會匯出",
                type: "question",
                showCancelButton: true//顯示取消按鈕
            }).then(function () {
                __doPostBack(btnName, "");
            },
            );//end then 
        }//end function myConfirm()



        $(function () {
            //$("#Button_1").click(function () {

            if ($("#ContentPlaceHolder1_MailHiddenField").val() == "true") {
                swal({
                    title: '寄送成功!',
                    type: 'success',
                    confirmButtonText: 'OK'
                });
                //});
            } else if ($("#ContentPlaceHolder1_MailHiddenField").val() == "fail") {
                swal({
                    title: '寄送失敗!',
                    type: 'error',
                    confirmButtonText: 'OK'
                });
            };

        });

        $(function () {
            //$("#Button_1").click(function () {
            if ($("#ContentPlaceHolder1_ExcelHiddenField").val() == "true") {
                swal({
                    title: '匯出成功!',
                    type: 'success',
                    confirmButtonText: 'OK'
                });
                //});
            } else if ($("#ContentPlaceHolder1_ExcelHiddenField").val() == "fail") {
                swal({
                    title: '匯出失敗!',
                    type: 'error',
                    confirmButtonText: 'OK'
                });
            }
        });

    </script>

    <asp:Label ID="Label4" runat="server" Text="團購訂單明細管理" CssClass="h1"></asp:Label>

    <div class="col-lg-12 ">
        <br />
        <div class="col-lg-8 ">
            <ul class="nav nav-pills nav-pills-success ">
                <li class="active"><a href="Default.aspx">去跟團</a></li>
                <li class="active"><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
                <li class="active"><a href="grouplist.aspx">團單管理</a></li>
                <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
                <li class="active"><a href="Chart.aspx">圖表生成</a></li>
            </ul>
        </div>
        <div class="col-lg-4">
        </div>
    </div>
    <div class="col-lg-12">

        <asp:FormView ID="FormView2" runat="server" CssClass="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12">
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

        <asp:FormView ID="FormView1" runat="server" CellPadding="4" CssClass="col-lg-12">

            <ItemTemplate>
                <div class="col-lg-12">
                    <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# "No"+Eval("groupId") %>' />
                    <asp:Label ID="IdLabel" runat="server" Text='<%# "#"+Eval("groupId")+Eval("ProductName")  %>' Font-Bold="True" CssClass="h1 " />
                    <asp:Label ID="TitleLabel" runat="server" Text="訂單資料" Font-Bold="True" CssClass=" h1" />
                    <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Eval("State")%>' Font-Bold="True" CssClass="h1 title text-danger" />
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("Url") %>' CssClass="text-bold h1  text-primary" Text="店家網址"></asp:HyperLink>
                    <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("State")%>' />
                    <br />
                    <br />
                    <br />
                </div>
                <div>
                    <div class="col-lg-4">
                        <div class="col-lg-offset-2 col-lg-8 col-lg-offset-2">
                            <asp:Image ID="Image1" runat="server" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' CssClass="img-rounded" Width="300px" />
                        </div>
                    </div>
                    <div class="col-lg-7 ">
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("groupDesc") %>' Font-Size="16" CssClass="title text-dark" />
                        <br />

                        <div class="col-lg-12 form order hid" id="myDiv" runat="server">
                            <asp:Label runat="server" CssClass="h2" Text="寄送E-mail" ID="lab"></asp:Label>

                            <asp:Table ID="dt" runat="server" CssClass="table table-hover">
                                <asp:TableRow>
                                    <asp:TableHeaderCell>
                                        <asp:Label ID="SubjectLabel" runat="server" Text='E-Mail主旨' Font-Size="16" CssClass="title text-dark" />
                                    </asp:TableHeaderCell>
                                    <asp:TableCell>
                                        <asp:TextBox ID="Subject" runat="server" CssClass="form-control"></asp:TextBox>
                                    </asp:TableCell>
                                </asp:TableRow>
                                <asp:TableRow>
                                    <asp:TableHeaderCell>
                                        <asp:Label ID="BodyTextBox1" runat="server" Text='E-Mail內容' Font-Size="16" CssClass="title text-dark" />
                                    </asp:TableHeaderCell>
                                    <asp:TableCell>
                                        <asp:TextBox ID="Body" Height="109px" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>
                            <div class="col-lg-offset-8">
                                <asp:Button ID="Button1" runat="server" Text="Demo" CssClass="btn btn-warning h4" OnClick="Button1_Click" />
                                <asp:Button ID="ExcelButton" runat="server" Text="匯出Excel" OnClick="ExcelButton_Click" CssClass="btn btn-primary h4" OnClientClick="return false" />
                                <asp:Button ID="SentButton" runat="server" CssClass="btn btn-info h4" Text="發送" OnClick="SentButton_Click" OnClientClick="return false" />
                            </div>
                        </div>

                    </div>
                </div>
                <div class="col-lg-1"></div>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <br />
        <br />
        <asp:HiddenField ID="ExcelHiddenField" runat="server" Value="false" />
        <asp:HiddenField ID="MailHiddenField" runat="server" Value="false" />
        <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>

    </div>
    <div class="col-lg-12">
        <br />
        <br />
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <asp:Label ID="Label2" runat="server" Text="尚未有人跟團" CssClass="text-bold text-danger h1 hidla" Visible="false"></asp:Label>
        </div>
        <div class="col-lg-4"></div>
    </div>
    <div class="col-lg-12">
        <br />

        <div class="col-lg-12 ">
            <div class="col-lg-4"></div>
            <div class="col-lg-4 ">
                <div class="col-lg-12" style="text-align: center">

                    <asp:DataPager ID="DataPager2" runat="server" PageSize="5" PagedControlID="ListView1">
                        <Fields>
                            <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger" ButtonType="Button" FirstPageText="第一頁" PreviousPageText="上一頁" ShowFirstPageButton="True" ShowPreviousPageButton="true" ShowLastPageButton="false" ShowNextPageButton="false" />

                            <asp:NumericPagerField
                                PreviousPageText="&lt; Prev"
                                NextPageText="Next &gt;"
                                ButtonCount="10"
                                NextPreviousButtonCssClass="PrevNext h3"
                                CurrentPageLabelCssClass="CurrentPage h3"
                                NumericButtonCssClass="PageNumber h3" />
                            <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger" ButtonType="Button" LastPageText="最後一頁" NextPageText="下一頁" ShowFirstPageButton="false" ShowPreviousPageButton="false" ShowLastPageButton="true" ShowNextPageButton="true" />

                        </Fields>
                    </asp:DataPager>
                </div>
            </div>
            <div class="col-lg-4"></div>
        </div>

        <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting" OnPagePropertiesChanging="ListView1_PagePropertiesChanging">
            <AlternatingItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />
                        <asp:HyperLink ID="Link" class="btn btn-danger" runat="server" NavigateUrl='<%# "OrderEdit.aspx?id="+Eval("Id")+"&groupid="+Eval("groupId")%>'>編輯</asp:HyperLink>
                    </td>

                    <td>
                        <div class="col-lg-12">
                            <div class="col-lg-1">
                                <input type="checkbox" id="CheckBox1" runat="server" class="checkbox allall" name="CH1" />
                            </div>
                            <div class="">
                                <asp:Label ID="groupIdLabel" runat="server" CssClass="" Text='<%# Eval("Id") %>' />
                            </div>
                        </div>
                    </td>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text='<%#　Eval("Name") %>' />
                    </td>
                    <td>
                        <asp:Label ID="AmountLabel" runat="server" Text='<%# Eval("Amount") %>' />
                    </td>
                    <td>
                        <asp:Label ID="TotalLabel" runat="server" Text='<%# Eval("Total") %>' />
                    </td>
                    <td>
                        <div class="checkbox">
                            <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("Email") %>' />

                        </div>
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("OrderDesc") %>' />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <EmptyDataTemplate>
                <table runat="server">
                    <tr>
                        <td>No data was returned.</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <ItemTemplate>
                <td>
                    <asp:Button ID="DeleteButton" runat="server" CommandName="Delete" Text="刪除" CssClass="btn btn-warning" OnClientClick='return confirm("確認刪除?")' />

                    <asp:HyperLink ID="Link" class="btn btn-danger" runat="server" NavigateUrl='<%# "OrderEdit.aspx?id="+Eval("Id")+"&groupid="+Eval("groupId")%>'>編輯</asp:HyperLink>
                </td>

                <td>
                    <div class="col-lg-12">
                        <div class="col-lg-1">
                            <input type="checkbox" id="CheckBox1" runat="server" class="checkbox allall" name="CH1" />
                        </div>
                        <div class="">
                            <asp:Label ID="groupIdLabel" runat="server" CssClass="" Text='<%# Eval("Id") %>' />
                        </div>
                    </div>
                </td>
                <td>
                    <asp:Label ID="Label3" runat="server" Text='<%#　Eval("Name") %>' />
                </td>
                <td>
                    <asp:Label ID="AmountLabel" runat="server" Text='<%# Eval("Amount") %>' />
                </td>
                <td>
                    <asp:Label ID="TotalLabel" runat="server" Text='<%# Eval("Total") %>' />
                </td>
                <td>
                    <div class="checkbox">
                        <asp:Label ID="DeadLabel" runat="server" Text='<%# Eval("Email") %>' />
                    </div>
                </td>
                <td>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("OrderDesc") %>' />
                </td>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="table ">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                                <tr runat="server">
                                    <th class="col-lg-1 bg-secondary" runat="server"></th>
                                    <th class="col-lg-1 bg-secondary" runat="server">

                                        <input type="checkbox" id="checkall" onclick="checkall1()" />訂單編號
                                     
                                    </th>
                                    <th class="col-lg-1 bg-secondary" runat="server">
                                        <div class="checkbox">
                                            <asp:CheckBox ID="CheckBox4" runat="server" Visible="false" />
                                            訂購者                                                                       
                                        </div>
                                    </th>
                                    <th class="col-lg-1 bg-secondary" runat="server">
                                        <div class="checkbox">
                                            <asp:CheckBox ID="CheckBox3" runat="server" Visible="false" />
                                            訂購數量                                                                       
                                        </div>
                                    </th>
                                    <th class="col-lg-1 bg-secondary" runat="server">
                                        <div class="checkbox">
                                            <asp:CheckBox ID="CheckBox2" runat="server" Visible="false" />
                                            訂單小計                                                                       
                                        </div>
                                    </th>
                                    <th class="col-lg-3 bg-secondary" runat="server">
                                        <div class="checkbox">
                                            <input type="checkbox" id="check" hidden="hidden" />E-mail
                                        </div>
                                    </th>
                                    <th class="col-lg-2 bg-secondary" runat="server">
                                        <div class="checkbox">
                                            <asp:CheckBox ID="CheckBox6" runat="server" Visible="false" />
                                            補充資料                                                                       
                                        </div>
                                    </th>
                                </tr>
                                <tr id="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server"></td>
                    </tr>
                </table>
            </LayoutTemplate>

        </asp:ListView>
        <div class="col-lg-12 ">
            <div class="col-lg-4"></div>
            <div class="col-lg-4 ">
                <div class="col-lg-12" style="text-align: center">

                    <asp:DataPager ID="DataPager1" runat="server" PageSize="5" PagedControlID="ListView1">
                        <Fields>
                            <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger" ButtonType="Button" FirstPageText="第一頁" PreviousPageText="上一頁" ShowFirstPageButton="True" ShowPreviousPageButton="true" ShowLastPageButton="false" ShowNextPageButton="false" />

                            <asp:NumericPagerField
                                PreviousPageText="&lt; Prev"
                                NextPageText="Next &gt;"
                                ButtonCount="10"
                                NextPreviousButtonCssClass="PrevNext h3"
                                CurrentPageLabelCssClass="CurrentPage h3"
                                NumericButtonCssClass="PageNumber h3" />
                            <asp:NextPreviousPagerField ButtonCssClass="btn btn-danger" ButtonType="Button" LastPageText="最後一頁" NextPageText="下一頁" ShowFirstPageButton="false" ShowPreviousPageButton="false" ShowLastPageButton="true" ShowNextPageButton="true" />

                        </Fields>
                    </asp:DataPager>
                </div>
            </div>
            <div class="col-lg-4"></div>
        </div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tb1").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "/9036GroupBuy/WebService.asmx/GetNames",
                        data: "{ 'prefixText': '" + request.term + "' }",
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return { value: item }
                            }))
                        },
                    });
                },
                minLength: 1
            });
        });

    </script>
</asp:Content>

