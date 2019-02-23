<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<script runat="server">


    //設定表格模式
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["Mode"] == "Insert")
        {
            FormView1.DefaultMode = FormViewMode.Insert;
        }
        if (!Page.IsPostBack && Request.QueryString["id"] != null)
        {

            string EmpId = Request.QueryString["id"].ToString();
            BindFormView(EmpId);
        }
    }
    //id判斷進入者
    private void BindFormView(string EmpId)
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT [Id], [EmpId], [Starttime], [Overtime], [Event], [Hour], [Content], [Department] FROM [AllEmployess] where Id=@Id",
            ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("Id", EmpId);
        DataTable dt = new DataTable();
        da.Fill(dt);
        FormView1.DataSource = dt;
        FormView1.DataBind();

    }

    //cancel設定
    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/NewPP/Employess.aspx");
        }
    }

    //新增
    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        int id = (int)e.Keys[0];
        ////Response.Write(id); //點擊測試
        //int Empid = (int)e.NewValues[0];
        //System.DateTime Stardate = (DateTime)e.NewValues[0];
        DateTime Starttime = DateTime.Parse(e.NewValues[0].ToString());
        DateTime Overttime = DateTime.Parse(e.NewValues[1].ToString());
        string Event = e.NewValues[2].ToString();
        int Hour = int.Parse(e.NewValues[3].ToString());
        string Content = e.NewValues[4].ToString();

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand("UPDATE AllEmployess SET Starttime=@Startime, Overtime=@Overtime,Event=@Event,Hour=@Hour,Content=@Content WHERE(Id=@Id)", cn);
        cmd.Parameters.AddWithValue("Id", id);

        cmd.Parameters.AddWithValue("Startime", Starttime);
        cmd.Parameters.AddWithValue("Overtime", Overttime);
        cmd.Parameters.AddWithValue("Event", Event);
        cmd.Parameters.AddWithValue("Hour", Hour);
        cmd.Parameters.AddWithValue("Content", Content);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/NewPP/Employess.aspx");

        /*Response.Write(StartDate); */ //先測試

    }

    //申請價單
    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        //int Id = int.Parse(e.Values[0].ToString());
        string EmpId = "王小明";
        DateTime Startime = DateTime.Parse(e.Values[0].ToString());
        DateTime Overtime = DateTime.Parse(e.Values[1].ToString());
        string Event = e.Values[2].ToString();
        int Hour = int.Parse(e.Values[3].ToString());
        string Content = e.Values[4].ToString();
        string Department = "業務部";
        string Nowdate = System.DateTime.Now.ToString();
        string Result = "未審核";

        //Response.Write(Result);
        //測試
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        SqlCommand cmd = new SqlCommand("INSERT INTO AllEmployess(EmpId,Starttime,Overtime,Event,Hour,Result,Content,Nowdate,Department) VALUES(@EmpId,@Starttime,@Overtime,@Event,@Hour,@Result,@Content,@Nowdate,@Department)", cn);
        cmd.Parameters.AddWithValue("EmpId", EmpId);
        cmd.Parameters.AddWithValue("Starttime", Startime);
        cmd.Parameters.AddWithValue("Overtime", Overtime);
        cmd.Parameters.AddWithValue("Event", Event);
        cmd.Parameters.AddWithValue("Hour", Hour);
        cmd.Parameters.AddWithValue("Result", Result);
        cmd.Parameters.AddWithValue("Content", Content);
        cmd.Parameters.AddWithValue("Department", Department);
        cmd.Parameters.AddWithValue("Nowdate", Nowdate);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/NewPP/Employess.aspx");

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.css" rel="stylesheet" />
    <style>
        table {
            margin-left: auto;
            margin-right: auto;
        }
        .auto-style1 {
            height: 59px;
        }
    </style>
</asp:Content>






<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="id" DefaultMode="Edit" OnItemCommand="FormView1_ItemCommand" OnItemUpdating="FormView1_ItemUpdating" OnItemInserting="FormView1_ItemInserting">
            <EditItemTemplate>
                 <div class="page-header text-center">
                    <p class="h1" style="color: white">編輯假單</p>
                </div>
                <div class="table">
                    
                        <%-- style="border: 1px solid; border-radius: 20px; background-color: azure; box-shadow: 5px 5px 10px rgba(0,0,0,0.8);--%>
                        <table class="table" style="width: 500px;">
                            <tr>
                                <td>假單編號 ：</td>
                                <div>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Id") %>' />
                                    </td>

                                </div>
                            </tr>
                            <tr>
                                <td>員工名稱 ：</td>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("EmpId") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td>開始時間 ：</td>
                                <td>
                                    <div class="form-group">
                                        <div class='input-group date' id='datetimepicker1'>
                                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Starttime") %>' />
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>結束時間 ：</td>
                                <td>
                                    <div class='input-group date' id='datetimepicker2'>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Overtime") %>' />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>假單 ：</td>
                                <td>
                                    <asp:DropDownList ID="DropDownList4" runat="server" SelectedValue='<%# Bind("Event") %>'>
                                        <asp:ListItem>事假</asp:ListItem>
                                        <asp:ListItem>病假</asp:ListItem>
                                        <asp:ListItem>年假</asp:ListItem>
                                        <asp:ListItem>出差</asp:ListItem>
                                        <asp:ListItem>會議</asp:ListItem>
                                        <asp:ListItem>其他</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>時數 ：</td>
                                <div class="row">
                                    <td>
                                        <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Hour") %>' />
                                    </td>
                                </div>
                            </tr>
                            <tr>
                                <td>備註內容 ：</td>

                                <td>

                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Content") %>' />
                                </td>

                            </tr>
                            <tr>
                                <td>部門 ：</td>
                                <td>

                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("Department") %>' />
                                </td>

                            </tr>
                    
                    
                        <tr>
                            <td colspan="2" style="width: 400px; height: 250px;">
                                <div class="btn-group col-md-12" role="group" aria-label="Basic example">
                                    <asp:Button CssClass=" btn btn-success" ID="Button1" runat="server" CausesValidation="True" CommandName="Update" Text="確認修改" />
                                    <asp:Button CssClass="btn btn-danger" ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel" Text="返回" />
                                </div>
                            </td>
                        </tr>
                   
                    </table>
                </div>
            </EditItemTemplate>
            <%--=================================================================================================================--%>
            <InsertItemTemplate>
                 <div class="page-header text-center">
                    <p class="h1" style="color: white">新增假單</p>
                </div>
                <div class="table">
                    
                        <%-- style="border: 1px solid; border-radius: 20px; background-color: azure; box-shadow: 5px 5px 10px rgba(0,0,0,0.8);--%>
                        <table class="table" style="width: 500px;">
                            <tr>
                                <td>假單編號 ：</td>
                                <div>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Id") %>' />
                                    </td>

                                </div>
                            </tr>
                            <tr>
                                <td>員工名稱 ：</td>
                                <td>
                                    <asp:Label ID="Label4" runat="server" Text='王小明' />
                                    <%--<asp:Label ID="Label4" runat="server" Text='<%# Eval("EmpId") %>' />--%>
                                </td>
                            </tr>
                            <tr>
                                <td>開始時間 ：</td>
                                <td>
                                    <div class="form-group">
                                        <div class='input-group date' id='datetimepicker1'>
                                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Starttime") %>' />
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>結束時間 ：</td>
                                <td>
                                    <div class='input-group date' id='datetimepicker2'>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Overtime") %>' />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="auto-style1">假單 ：</td>
                                <td class="auto-style1">
                                    <asp:DropDownList ID="DropDownList4" runat="server" SelectedValue='<%# Bind("Event") %>'>
                                        <asp:ListItem>事假</asp:ListItem>
                                        <asp:ListItem>病假</asp:ListItem>
                                        <asp:ListItem>年假</asp:ListItem>
                                        <asp:ListItem>出差</asp:ListItem>
                                        <asp:ListItem>會議</asp:ListItem>
                                        <asp:ListItem>其他</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>時數 ：</td>
                                <div class="row">
                                    <td>
                                        <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Hour") %>' />
                                    </td>
                                </div>
                            </tr>
                            <tr>
                                <td>備註內容 ：</td>

                                <td>

                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Content") %>' />
                                </td>

                            </tr>
                            <tr>
                                <td>部門 ：</td>
                                <td>

                                    <asp:Label ID="Label3" runat="server" Text='業務部' />
                                   <%-- <asp:Label ID="Label5" runat="server" Text='<%# Eval("Department") %>' />--%>
                                </td>

                            </tr>
                    
                    
                        <tr>
                            <td colspan="2" style="width: 400px; height: 250px;">
                                <div class="btn-group col-md-12" role="group" aria-label="Basic example">
                                    <asp:Button CssClass=" btn btn-success" ID="Button1" runat="server" CausesValidation="True" CommandName="Insert" Text="確認新增" />
                                    <asp:Button CssClass="btn btn-danger" ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel" Text="返回" />
                                </div>
                            </td>
                        </tr>
                    
                    </table>
                </div>
            </InsertItemTemplate>
            <ItemTemplate>
                假單編號:
                    <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                <br />
                員工名稱:
                    <asp:Label ID="EmpIdLabel" runat="server" Text='<%# Bind("EmpId") %>' />
                <br />
                開始時間:
                    <asp:Label ID="StarttimeLabel" runat="server" Text='<%# Bind("Starttime") %>' />
                <br />
                結束時間:
                    <asp:Label ID="OvertimeLabel" runat="server" Text='<%# Bind("Overtime") %>' />
                <br />
                假單:
                    <asp:Label ID="EventLabel" runat="server" Text='<%# Bind("Event") %>' />
                <br />
                時數:
                    <asp:Label ID="HourLabel" runat="server" Text='<%# Bind("Hour") %>' />
                <br />
                備註原因:
                    <asp:Label ID="ContentLabel" runat="server" Text='<%# Bind("Content") %>' />
                <br />
                部門:
                    <asp:Label ID="DepartmentLabel" runat="server" Text='<%# Bind("Department") %>' />
                <br />

            </ItemTemplate>
        </asp:FormView>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <script src="script/moment.min.js"></script>
    <script src="script/zh-tw.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>
    <%--日期選法--%>
    <script type="text/javascript">
        $(function () {
            $('#datetimepicker1').datetimepicker();
            $('#datetimepicker2').datetimepicker({
                useCurrent: false,
                locale: moment.locale('zh-tw')
            });
            $("#datetimepicker1").on("dp.change", function (e) {
                $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
            });
            $("#datetimepicker2").on("dp.change", function (e) {
                $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
            });

        });
    </script>

</asp:Content>
