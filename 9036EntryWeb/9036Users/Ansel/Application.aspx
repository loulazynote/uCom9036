<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>




<script runat="server">

    SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
    DataSet ds = new DataSet();


    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            using (cn)
            {

                //SqlDataAdapter da = new SqlDataAdapter("Select Name from Employees", cn);
                //da.Fill(ds, "Employees");

            }
        }
    }

    protected void confirmBtn_Click(object sender, EventArgs e)
    {

        SqlCommand cmd = new SqlCommand("insert into  Conference values (" +
            "@Topic," +
            "@StartTime," +
            "@EndTime," +
            "@CreatedTime," +
            "@Host," +
            "@Recorder," +
            "@Participant," +
            "@Creator," +
            "@Content," +
            "@Application," +
            "@FileName)", cn);

        cmd.Parameters.AddWithValue("@Topic", topicTxt.Text);
        cmd.Parameters.AddWithValue("@StartTime", startTimeTxt.Text);
        cmd.Parameters.AddWithValue("@EndTime", endTimeTxt.Text);
        cmd.Parameters.AddWithValue("@CreatedTime", DateTime.Now);
        cmd.Parameters.AddWithValue("@Host", string.Empty);
        cmd.Parameters.AddWithValue("@Recorder", string.Empty);
        cmd.Parameters.AddWithValue("@Participant", string.Empty);
        cmd.Parameters.AddWithValue("@Creator", Session["UID"].ToString());
        cmd.Parameters.AddWithValue("@Content", contentTxt.Text);
        cmd.Parameters.AddWithValue("@Application", "未審核");
        string fileName = FileUploadHasFile(FileUpload1, FileUpload2, FileUpload3);
        cmd.Parameters.AddWithValue("@FileName", fileName);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        FileUploadHasFile(FileUpload1, FileUpload2, FileUpload3);



        //show sweet alert
        Response.Redirect("~/Ansel/ApplicationStatus.aspx");
    }


    protected string FileUploadHasFile(FileUpload fileUpload, FileUpload fileUpload2, FileUpload fileUpload3)
    {

        if (fileUpload.HasFile)
        {
            string uploadPath = "~/Ansel/Upload/" + fileUpload.FileName;
            fileUpload.SaveAs(Server.MapPath(uploadPath));
        }
        if (fileUpload2.HasFile)
        {
            string uploadPath = "~/Ansel/Upload/" + fileUpload2.FileName;
            fileUpload.SaveAs(Server.MapPath(uploadPath));
        }
        if (fileUpload3.HasFile)
        {
            string uploadPath = "~/Ansel/Upload/" + fileUpload3.FileName;
            fileUpload.SaveAs(Server.MapPath(uploadPath));
        }

        string result = fileUpload.FileName + "," + fileUpload2.FileName + "," + fileUpload3.FileName;
        return result;

    }


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Ansel/Content/jquery.datetimepicker.css" rel="stylesheet" />
    <link href="/Ansel/Content/sweetalert2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.0/jquery.validate.min.js"></script>
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
                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="" />
                <asp:FileUpload ID="FileUpload2" runat="server" CssClass="" />
                <asp:FileUpload ID="FileUpload3" runat="server" CssClass="" />
            </div>
        </div>
        <br />
        <br />
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
                <asp:Button ID="Button3" runat="server" CssClass="btn btn-danger btn-block" Text="取消" OnClientClick="return false"/>
            </div>
            <div class="col-sm-3">
                <%--<asp:Button ID="Button2" runat="server" CssClass="btn btn-default btn-block" Text="重新填寫" OnClick="Button2_Click" />--%>
                <input type="reset" value="重新填寫" class="btn btn-default btn-block" />
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

                    //CheckBoxList1: { minlength: 1 }

                },

                messages: {
                    ctl00$ContentPlaceHolder1$topicTxt: "請填寫主題",
                    ctl00$ContentPlaceHolder1$startTimeTxt: "請選擇開始時間",
                    ctl00$ContentPlaceHolder1$endTimeTxt: "請選擇結束時間",

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

