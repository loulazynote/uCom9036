<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Button1_Click(object sender, EventArgs e)
    {
        localhost.WebService ws = new localhost.WebService();

        DateTime s = DateTime.Parse(datepicker.Text);
        DateTime en = DateTime.Parse(datepicker2.Text);
        string content = "客戶姓名:" + TextBox1.Text + "\r\n"  + comment.InnerText;
        //int id = Convert.ToInt32(DropDownList1.SelectedItem.Value);業務id
        int id = 1;

        string colord = ws.GetColor();
        Fullevent schedules = new Fullevent()
        {
            SaleID = id,
            title = content,
            color = colord,
            start = s,
            end = en


        };
        Entry9036Entities db = new Entry9036Entities();
        db.Fullevents.Add(schedules);
        db.SaveChanges();
        Response.Redirect("~/ChangEn/FullCalendarMaster.aspx");


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="Content/bootstrap.css" rel="stylesheet" />--%>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link rel="stylesheet" href="/resources/demos/style.css" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">


        <h1 style="font-family:Microsoft JhengHei;" class="text-center"><b>行程安排</b></h1>
        <br />

        <div class="form-group">

            <asp:Label for="DropDownList1" ID="Label1" runat="server" Text="Label" Font-Size="Medium" Font-Bold="True">客戶姓名:</asp:Label>
            <asp:TextBox CssClass="form-control " ID="TextBox1" runat="server" TextMode="DateTime"></asp:TextBox>
            <%-- <asp:DropDownList CssClass="form-control" ID="DropDownList1" runat="server">
                    <asp:ListItem Value="0">請選擇</asp:ListItem>
                    <asp:ListItem Value="1">Ben</asp:ListItem>
                    <asp:ListItem Value="2">Sally</asp:ListItem>
                    <asp:ListItem Value="3">Kelly</asp:ListItem>
                    <asp:ListItem Value="4">Danny</asp:ListItem>
                    <asp:ListItem Value="5">Johnson</asp:ListItem>
                </asp:DropDownList>--%>
        </div>


        <div class="form-group">
            <asp:Label for="datepicker" ID="Label2" runat="server" Text="Label" Font-Size="Medium" Font-Bold="True">行程開始:</asp:Label>
            <asp:TextBox CssClass="form-control " ID="datepicker" runat="server" TextMode="DateTime"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label for="datepicker2" ID="Label3" runat="server" Text="Label" Font-Size="Medium" Font-Bold="True">行程結束:</asp:Label>
            <asp:TextBox CssClass="form-control" ID="datepicker2" runat="server" TextMode="DateTime"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Label for="comment" ID="Label4" runat="server" Text="Label" Font-Size="Medium" Font-Bold="True">行程安排:</asp:Label>
            <textarea class="form-control" rows="5" id="comment" runat="server"></textarea>
        </div>
        <br />
        <asp:Button CssClass="btn btn-facebook btn-group-justified" ID="Button1" runat="server" Text="送出" OnClick="Button1_Click" />



    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="i18n/datepicker-zh-TW.js"></script>
    <script>
        $(function () {
            $.datepicker.regional['zh-TW'] = {
                clearText: '清除', clearStatus: '清除已選日期',
                closeText: '關閉', closeStatus: '取消選擇',
                prevText: '<上一月', prevStatus: '顯示上個月',
                nextText: '下一月>', nextStatus: '顯示下個月',
                currentText: '今天', currentStatus: '顯示本月',
                monthNames: ['一月', '二月', '三月', '四月', '五月', '六月',
                    '七月', '八月', '九月', '十月', '十一月', '十二月'],
                monthNamesShort: ['一', '二', '三', '四', '五', '六',
                    '七', '八', '九', '十', '十一', '十二'],
                monthStatus: '選擇月份', yearStatus: '選擇年份',
                weekHeader: '周', weekStatus: '',
                dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
                dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
                dayNamesMin: ['日', '一', '二', '三', '四', '五', '六'],
                dayStatus: '設定每周第一天', dateStatus: '選擇 m月 d日, DD',
                dateFormat: 'yy-mm-dd', firstDay: 1,
                initStatus: '請選擇日期', isRTL: false
            };
            $("#ContentPlaceHolder1_datepicker").datepicker();
            $("#ContentPlaceHolder1_datepicker2").datepicker();
            $.datepicker.setDefaults($.datepicker.regional['zh-TW']);
        });
    </script>
</asp:Content>

