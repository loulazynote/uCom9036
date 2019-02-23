<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>




<script runat="server">

    SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);

    DataSet ds = new DataSet();


    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack && Request.QueryString["id"] != null)
        {
            int id = int.Parse(Request.QueryString["id"].ToString());
            //Response.Write(id);

            SqlDataAdapter da = new SqlDataAdapter("Select Name from Employees", cn);
            da.Fill(ds, "Employees");
            hostDropDwonList.DataSource = ds;
            hostDropDwonList.DataMember = "Employees";
            hostDropDwonList.DataTextField = "Name";
            hostDropDwonList.DataValueField = "Name";
            hostDropDwonList.DataBind();

            recorderDropDownList.DataSource = ds;
            recorderDropDownList.DataMember = "Employees";
            recorderDropDownList.DataTextField = "Name";
            recorderDropDownList.DataValueField = "Name";
            recorderDropDownList.DataBind();

            participantsCheckBoxList.DataSource = ds;
            participantsCheckBoxList.DataMember = "Employees";
            participantsCheckBoxList.DataTextField = "Name";
            participantsCheckBoxList.DataValueField = "Name";
            participantsCheckBoxList.DataBind();

            EditConference(id);
            //using (cn)
            //{



            //}





        }
    }

    private void EditConference(int id)
    {

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        SqlDataAdapter da = new SqlDataAdapter("SELECT c.Id, Topic, StartTime, EndTime, CreatedTime, Host, Recorder, Participant, Creator, Content, FileName FROM Conference AS c LEFT JOIN Employees  AS e ON c.Creator = e.Name  where (c.Id = @ID) ORDER BY CreatedTime DESC", cn);

        //"SELECT c.Id, c.Topic, c.StartTime, c.EndTime, c.CreatedTime, c.Host, c.Recorder, c.Participant, c.Creator, c.Content, e.Name FROM Conference AS c LEFT JOIN Employees AS e ON c.Creator = e.Name where (c.Id = @Id) ORDER BY c.CreatedTime DESC"

        da.SelectCommand.Parameters.AddWithValue("ID", id);
        DataTable dt = new DataTable();
        da.Fill(dt);
        DataSet ds = new DataSet();
        ds.Tables.Add(dt);
        topicTxt.Text = dt.Rows[0]["Topic"]?.ToString();
        startTimeTxt.Text = dt.Rows[0]["StartTime"]?.ToString();
        endTimeTxt.Text = dt.Rows[0]["EndTime"]?.ToString();

        hostDropDwonList.SelectedValue = dt.Rows[0]["Host"]?.ToString();
        recorderDropDownList.SelectedValue = dt.Rows[0]["Recorder"]?.ToString();
        participantsCheckBoxList.SelectedValue = dt.Rows[0]["Participant"]?.ToString();

        string participant = dt.Rows[0]["Participant"]?.ToString();

        List<string> pt = participant.Split(',').ToList();

        foreach (ListItem item in participantsCheckBoxList.Items)
        {
            if (pt.Contains(item.Value))
            {
                item.Selected = true;
            }
        }


        contentTxt.Text = dt.Rows[0]["Content"]?.ToString();

        string fileName = dt.Rows[0]["FileName"]?.ToString();

        string[] file = fileName.Split(',');

        if (file.Length >= 1)
        {
            fileUpload1Lbl.Text = file[0];
        }

        if (file.Length >= 2)
        {
            fileUpload2Lbl.Text = file[1];
        }

        if (file.Length >= 3)
        {
            fileUpload3Lbl.Text = file[2];
        }







        //string parti = "";
        //foreach (ListItem item in participantsCheckBoxList.Items)
        //{
        //    if (item.Selected == true)
        //    {
        //        parti += item.Value + ",";
        //    }
        //}


        //DataRow[] rows = ds.Tables["Conference"].Select(id.ToString(), "id desc");

        //Response.Write(string.Format("{0}", rows[id]["Topic"]));


        //var query = from t in dt.AsEnumerable()
        //            select new Conference()
        //            {
        //                Topic = t["Topic"].ToString(),
        //                StartTime = Convert.ToDateTime(t["StartTime"]),
        //                CreatTime = Convert.ToDateTime(t["CreatedTime"]),
        //                Creator = t["Name"].ToString(),

        //            };

        //return query.ToList();

        //topicTxt.Text = dt.Rows[1].ToString();






        //StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT c.Id, c.Topic, c.StartTime, c.EndTime, c.CreatedTime,c.Host, c.Recorder, c.Participant, c.Creator, c.Content, e.Name FROM Conference as c LEFT JOIN Employees as e  ON c.Creator = e.Name where (c.Id = 50) ORDER BY c.CreatedTime DESC");

        //Dictionary<string, string> dic = new Dictionary<string, string>();
        ////dic.Add("Id", id.ToString());//123 = value
        //var table = SelectToDataTable(sb, dic);

        //topicTxt.Text = table.Rows[0]["Topic"].ToString();
    }

    //public DataTable SelectToDataTable(StringBuilder sb, Dictionary<string, string> dic)
    //{
    //    DataTable dataTable = new DataTable();
    //    using (SqlCommand cmdQuery = new SqlCommand(sb.ToString(), cn))
    //    {
    //        if (dic.Count > 0)
    //        {
    //            foreach (var item in dic)
    //            {
    //                cmdQuery.Parameters.AddWithValue("@" + item.Key.ToString(), item.Value.ToString());
    //            }
    //        }

    //        cn.Open();
    //        SqlDataReader reader = cmdQuery.ExecuteReader();
    //        try
    //        {
    //            dataTable.Load(reader);
    //        }
    //        catch (Exception sqlException)
    //        {
    //            throw sqlException;
    //        }
    //        finally
    //        {
    //            reader.Close();
    //        }
    //        cn.Close();
    //        return dataTable;
    //    }
    //}






    protected void confirmBtn_Click(object sender, EventArgs e)
    {
        int id = int.Parse(Request.QueryString["id"].ToString());
        SqlCommand cmd = new SqlCommand("UPDATE Conference set " +
            "Topic = @Topic, " +
            "StartTime = @StartTime," +
            "EndTime = @EndTime," +
            "CreatedTime = @CreatedTime," +
            "Host= @Host," +
            "Recorder = @Recorder," +
            "Participant = @Participant," +
            "Creator = @Creator," +
            "Content = @Content," +
            "Application = @Application," +
            "FileName = @FileName where (Id = @Id)", cn);

        cmd.Parameters.AddWithValue("@Id", id);
        cmd.Parameters.AddWithValue("@Topic", topicTxt.Text);
        cmd.Parameters.AddWithValue("@StartTime", DateTime.Parse(startTimeTxt.Text));
        cmd.Parameters.AddWithValue("@EndTime", DateTime.Parse(endTimeTxt.Text));
        cmd.Parameters.AddWithValue("@CreatedTime", DateTime.Now);
        cmd.Parameters.AddWithValue("@Host", hostDropDwonList.SelectedValue);
        cmd.Parameters.AddWithValue("@Recorder", recorderDropDownList.SelectedValue);


        //存ID字串
        string parti = "";
        foreach (ListItem item in participantsCheckBoxList.Items)
        {
            if (item.Selected == true)
            {
                parti += item.Value + ",";
            }
        }
        cmd.Parameters.AddWithValue("@Participant", parti);


        cmd.Parameters.AddWithValue("@Creator", Session["UID"].ToString());
        cmd.Parameters.AddWithValue("@Content", contentTxt.Text);
        cmd.Parameters.AddWithValue("@Application", "審核成功");

        string fileName = FileUploadHasFile(FileUpload1, fileUpload1Lbl);
        string fileName2 = FileUploadHasFile(FileUpload2, fileUpload2Lbl);
        string fileName3 = FileUploadHasFile(FileUpload3, fileUpload3Lbl);


        cmd.Parameters.AddWithValue("@FileName", fileName + fileName2 + fileName3);




        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();


        new MailAlert().SendMail("redm30721@gmail.com", "開會更改通知", "請盡速詳閱");

        //show sweet alert
        Response.Redirect("~/Ansel/Default.aspx");

    }


    //string uploadPath = string.Empty;

    //   if (fileUpload.HasFile)
    //   {
    //       uploadPath = "~/Ansel/Upload/" + fileUpload.FileName;
    //       fileUpload.SaveAs(Server.MapPath(uploadPath));
    //   }
    //   else
    //   {
    //       uploadPath = fileUpload1Lbl.Text;
    //   }
    //   if (fileUpload2.HasFile)
    //   {
    //       uploadPath + "," + fileUpload2.FileName;
    //       fileUpload.SaveAs(Server.MapPath(uploadPath));
    //   }
    //   else
    //   {
    //       uploadPath = fileUpload1Lb2.Text;
    //   }
    //   if (fileUpload3.HasFile)
    //   {
    //       uploadPath + "," + fileUpload3.FileName;
    //       fileUpload.SaveAs(Server.MapPath(uploadPath));
    //   }
    //   else
    //   {
    //       uploadPath = fileUpload1Lb3.Text;
    //   }


    protected string FileUploadHasFile(FileUpload fileUpload,Label lbl)
    {
        string uploadPath = string.Empty;
        string name = string.Empty;

        if (fileUpload.HasFile)
        {
            name = fileUpload.FileName;
            uploadPath = "~/Ansel/Upload/" + name;
            fileUpload.SaveAs(Server.MapPath(uploadPath));
        }
        else
        {

            if (lbl.Text != string.Empty)
            {
                name = lbl.Text;
                uploadPath = "~/Ansel/Upload/" + name;
                fileUpload.SaveAs(Server.MapPath(uploadPath));
            }


        }


        string result = name + ",";
        return result;

    }

    //protected int FileUpload_DB(string inputFileName)
    //{
    //    //同一次會議存同一欄
    //    SqlCommand cmd = new SqlCommand("insert into  FileUpload(FileName)values (@FileName)", cn);
    //    cmd.Parameters.AddWithValue("@FileName", inputFileName);
    //    int i = 0;

    //    cn.Open();
    //    i = cmd.ExecuteNonQuery();
    //    cn.Close();

    //    return i;
    //}

    //public class Conference
    //{
    //    public int Id { get; set; }
    //    public string Topic { get; set; }
    //    public DateTime StartTime { get; set; }
    //    public DateTime EndTime { get; set; }
    //    public DateTime CreatTime { get; set; }
    //    public string Host { get; set; }
    //    public string Recorder { get; set; }
    //    public string Participant { get; set; }
    //    public string Creator { get; set; }
    //    public string Content { get; set; }
    //    public int Application { get; set; }

    //}


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Ansel/Content/jquery.datetimepicker.css" rel="stylesheet" />
    <link href="/Ansel/Content/sweetalert2.min.css" rel="stylesheet" />
    <script src="../vendor/jquery-validation/jquery.validate.min.js"></script>
    <script src="/Ansel/Scripts/jquery.datetimepicker.full.min.js"></script>
    <script src="/Ansel/Scripts/sweetalert2.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="container">
        <div class="form-group">
            <asp:Label ID="topicLbl" runat="server" CssClass="col-md-2 control-label" Text="會議主題:" AssociatedControlID="topicTxt"></asp:Label>
            <div class="col-md-10">
                <asp:TextBox ID="topicTxt" runat="server" AutoComplete="off" CssClass="form-control" Width="362px"></asp:TextBox>
            </div>
        </div>
        <div class="form-group">
            <%--  <asp:Label ID="conferenceTimeLbl" runat="server" CssClass="col-md-2 control-label" Text="會議時間:"></asp:Label>
        <br />
        <br />
        <br />--%>
            <asp:Label ID="startTimeLbl" runat="server" CssClass="col-md-2 control-label" Text="開始時間:"></asp:Label>
            <div class="col-md-10">
                <asp:TextBox ID="startTimeTxt" runat="server" AutoComplete="off" CssClass="col-md-6 form-control"></asp:TextBox>
            </div>
            <br />
            <br />
            <br />
            <asp:Label ID="endTimeLbl" runat="server" CssClass="col-md-2 control-label" Text="結束時間:"></asp:Label>
            <div class="col-md-10">
                <asp:TextBox ID="endTimeTxt" runat="server" AutoComplete="off" CssClass="col-md-6 form-control"></asp:TextBox>
            </div>
        </div>
        <div class="form-gruop">
            <asp:Label ID="hostLbl" runat="server" CssClass="col-md-2 control-label" Text="主席:" AssociatedControlID="hostDropDwonList"></asp:Label>
            <div class="col-md-10">
                <asp:DropDownList ID="hostDropDwonList" AppendDataBoundItems="true" CssClass="form-control" runat="server">
                    <asp:ListItem Value="0">請選擇</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <br />
        <br />
        <br />
        <div class="form-gruop">
            <asp:Label ID="recorderLbl" runat="server" CssClass="col-md-2 control-label" Text="紀錄:" AssociatedControlID="recorderDropDownList"></asp:Label>
            <div class="col-md-10">
                <asp:DropDownList ID="recorderDropDownList" AppendDataBoundItems="true" CssClass="form-control" runat="server">
                    <asp:ListItem Value="0">請選擇</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <br />
        <br />
        <br />
        <div class="form-gruop" id="checkboxList_DIV ">
            <asp:Label ID="participantsLbl" runat="server" CssClass="col-md-2 control-label" Text="會議參與者:" AssociatedControlID="participantsCheckBoxList"></asp:Label>
            <div class="col-md-10">
                <asp:CheckBoxList ID="participantsCheckBoxList" runat="server" CssClass="checkbox-primary" RepeatDirection="Horizontal"></asp:CheckBoxList>
                <label for="CheckBoxList1" class="error"></label>
            </div>
        </div>
        <br />
        <br />
        <br />
        <div class="form-gruop">
            <asp:Label ID="contentLbl" runat="server" CssClass="col-md-2 control-label" Text="會議內容:" AssociatedControlID="contentTxt"></asp:Label>
            <div class="col-md-10">
                <asp:TextBox ID="contentTxt" runat="server" CssClass="form-bordered" TextMode="MultiLine" Height="68px" Width="354px"></asp:TextBox>
            </div>
        </div>
        <%--讀取資料庫--%><%--驗證控制項--%>
        <br />
        <br />
        <br />
        <br />
        <br />
        <div class="form-gruop">
            <asp:Label ID="fileUploadLbl" CssClass="col-md-2 control-label" runat="server" Text="附件:"></asp:Label>
            <div class="col-md-10">
                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="" /><asp:Label ID="fileUpload1Lbl" runat="server" Text=""></asp:Label>
                <asp:FileUpload ID="FileUpload2" runat="server" CssClass="" /><asp:Label ID="fileUpload2Lbl" runat="server" Text=""></asp:Label>
                <asp:FileUpload ID="FileUpload3" runat="server" CssClass="" /><asp:Label ID="fileUpload3Lbl" runat="server" Text=""></asp:Label>
            </div>
        </div>
        <br />
        <br />
        <br />
        <br />
        <br />

        <%--Sweet Alert 寫入資料庫 Email通知--%>
        <div class="form-gruop">
            <div class="col-sm-3">
                <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary btn-block" Text="確定" OnClick="confirmBtn_Click" />
            </div>
            <div class="col-sm-3">
                <asp:Button ID="Button3" runat="server" CssClass="btn btn-danger btn-block" Text="取消" OnClientClick="return false" />
            </div>
        </div>
        <br />
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <script>

        //$.validator.addMethod('selectNone',
        //    function (value, element) {
        //        return this.optional(element) || (value != 0);
        //    });



        $(document).ready(function () {

            //jQuery.validator.setDefaults({
            //    debug: true,
            //    success: "valid"
            //});

            //$("input[type='checkbox']").attr("name", "CheckBoxList1");

            //form表單
            $("#form1").validate({
                rules: {
                    //要對name
                    ctl00$ContentPlaceHolder1$topicTxt: "required",
                    ctl00$ContentPlaceHolder1$startTimeTxt: "required",
                    ctl00$ContentPlaceHolder1$endTimeTxt: "required",
                    //ctl00$ContentPlaceHolder1$hostDropDwonList: { selectNone: true },
                    //ctl00$ContentPlaceHolder1$recorderDropDownList: { selectNone: true },
                    //CheckBoxList1: { minlength: 1 }

                },

                messages: {
                    ctl00$ContentPlaceHolder1$topicTxt: "請填寫主題",
                    ctl00$ContentPlaceHolder1$startTimeTxt: "請選擇開始時間",
                    ctl00$ContentPlaceHolder1$endTimeTxt: "請選擇結束時間",
                    //ctl00$ContentPlaceHolder1$hostDropDwonList: "請選擇主席",
                    //ctl00$ContentPlaceHolder1$recorderDropDownList: "請選擇紀錄",
                    //CheckBoxList1: { minlength: "請選擇參與人員" }
                }

            });


            $.datetimepicker.setLocale('zh-TW');
            $('#ContentPlaceHolder1_startTimeTxt').datetimepicker({
                allowTimes: [
                    '09:00', '09:30', '10:00', '10:30', '11:00',
                    '11:30', '12:00', '12:30', '13:00', '13:30',
                    '14:00', '14:30', '15:00', '15:30', '16:00',
                    '16:30', '17:00', '17:30', '18:00'
                ],
            });
            $('#ContentPlaceHolder1_endTimeTxt').datetimepicker({
                allowTimes: [
                    '09:00', '09:30', '10:00', '10:30', '11:00',
                    '11:30', '12:00', '12:30', '13:00', '13:30',
                    '14:00', '14:30', '15:00', '15:30', '16:00',
                    '16:30', '17:00', '17:30', '18:00'
                ],
            });


            $('#ContentPlaceHolder1_startTimeTxt').datetimepicker({
                onShow: function (ct) {
                    this.setOptions({
                        minDate: 0,
                        maxDate: $('#ContentPlaceHolder1_endTimeTxt').val() ? $('#ContentPlaceHolder1_endTimeTxt').val() : false,

                    })
                },
            });

            $('#ContentPlaceHolder1_endTimeTxt').datetimepicker({
                onShow: function (ct) {
                    this.setOptions({

                        minDate: $('#ContentPlaceHolder1_startTimeTxt').val() ? $('#ContentPlaceHolder1_startTimeTxt').val() : false
                    })
                },
            });


            //sweet alert
            $("#ContentPlaceHolder1_Button3").click(function () {
                swal({
                    title: '確認?',
                    text: "確定取消?",
                    type: 'question',
                    showCancelButton: true,
                }).then(
                    function () {
                        swal('確定!', '即將返回會議首頁', 'success').then(function () {
                            //javaScript換頁
                            window.location.href = "/Ansel/Default.aspx";
                        })
                    },
                    function (dismiss) {
                        if (dismiss === 'cancel') {
                            swal('取消', '你可以繼續編輯', 'warning')
                        }

                    });

            });

        });

                // page is now ready, initialize the calendar...

    </script>
</asp:Content>

