<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data.Entity" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //int id = int.Parse(Request.QueryString["id"].ToString());
        int id = 1;
        var db = new Entry9036Entities();
        var query = from t in db.Fullevents
                    where t.SaleID == id
                    select new MyEvent { title = t.title, start = t.start.ToString(), color = t.color.ToString(), end = DbFunctions.AddDays(t.end, 1).ToString(), id = t.cusName };
        //DbFunctions.AddDays＝幫結束日期+1
        var result = query.ToList();
        HiddenField1.Value =
            new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);


    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ChangEn/ScheduleMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.8.1/fullcalendar.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.8.1/fullcalendar.print.css" rel="stylesheet" media="print" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <h1 style="font-family: Microsoft JhengHei;" class="text-center"><b>我的行程表</b></h1>
        <br />

        <asp:HiddenField ID="HiddenField1" runat="server" />

        <div class="container">

            <div id="example">
            </div>
            <div class="btn-group">
                <asp:Button CssClass="btn btn-gplus " ID="Button1" runat="server" Text="新增行程" OnClick="Button1_Click" />

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.0/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.8.1/fullcalendar.min.js"></script>
    <script src="scripts/fullcalendar-3.10.0/locale/zh-tw.js"></script>
    <script>
        $("#example").fullCalendar({
            // 參數設定[註1]

            nextDayThreshold: "00:00:00",




            header: { // 頂部排版
                left: "prev,next today", // 左邊放置上一頁、下一頁和今天
                center: "title", // 中間放置標題
                right: "month,basicWeek,basicDay"// 右邊放置月、周、天
            },


            events: JSON.parse(document.getElementById("ContentPlaceHolder1_HiddenField1").value)
        })


    </script>
</asp:Content>

