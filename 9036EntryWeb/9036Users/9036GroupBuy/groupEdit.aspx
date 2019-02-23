<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack && Request.QueryString["id"] != null)
        {
            if (FormView2.ViewStateMode.ToString() == "Edit")
            {

            }

            int id = int.Parse(Request.QueryString["id"]);
            DataTable data = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
            {
                DataSet ds = new DataSet();
                ds.Clear();
                SqlDataAdapter cm = new SqlDataAdapter("SELECT * FROM groupList WHERE (groupId = @id)", con);
                cm.SelectCommand.Parameters.AddWithValue("@id", id);
                cm.Fill(ds);
                FormView1.DataSource = ds;
                FormView1.DataBind();
            };
        };
        if (Request.QueryString["Mode"] == "Insert")
        {
            FormView1.DefaultMode = FormViewMode.Insert;
            FormView2.DefaultMode = FormViewMode.Insert;
        }
    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        Label dateNamelabel = ((Label)FormView1.FindControl("Label1"));
        int id = (int)e.Keys[0];
        string ProductName = e.NewValues[0].ToString();
        int Price = int.Parse(e.NewValues[1].ToString());
        string DeadLine = e.NewValues[2].ToString();
        string Url = e.NewValues[4].ToString();
        if (DeadLine == "")
        {
            DeadLine = dateNamelabel.Text;
        }
        else
        {
            DeadLine = e.NewValues[2].ToString();
        }
        int Limit = int.Parse(e.NewValues[3].ToString());
        string GroupDesc = e.NewValues[5].ToString();
        FileUpload myfile = new FileUpload();
        DataTable dt = new DataTable();
        string queryString = "";
        string mypath = Request.PhysicalApplicationPath + "\\images\\";
        string tempfileName = "";
        myfile = ((FileUpload)FormView1.FindControl("FileUpload2"));
        string fileName = myfile.FileName;
        //把formview的fileupload放入新的myfile裡
        System.Web.UI.WebControls.Image productImg = ((System.Web.UI.WebControls.Image)FormView1.FindControl("ProudctImg"));
        string pathToCheck = mypath + myfile.FileName;
        string ImgUrl = "";
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {
            if (myfile.HasFile)
            {
                if (myfile.PostedFile.ContentType == "image/pjpeg" | myfile.PostedFile.ContentType == "image/jpeg" | myfile.PostedFile.ContentType == "image/gif" | myfile.PostedFile.ContentType == "image/x-png")
                {
                    if (System.IO.File.Exists(pathToCheck))
                    {
                        int my_counter = 2;
                        while (System.IO.File.Exists(pathToCheck))
                        {
                            tempfileName = my_counter.ToString() + "_" + fileName;
                            pathToCheck = mypath + tempfileName;
                            my_counter = my_counter + 1;
                        }
                        fileName = tempfileName;
                    };
                    myfile.SaveAs(mypath + fileName);
                    productImg.ImageUrl = "../images/" + fileName;
                    ImgUrl = fileName;
                };
                queryString = "UPDATE [groupList] SET ImgUrl=@ImgUrl,Url=@Url, ProductName = @ProductName, Price=@Price,DeadLine=@DeadLine,Limit=@Limit,GroupDesc=@GroupDesc WHERE groupId=@groupId";
            }
            else
            {
                queryString = "UPDATE [groupList] SET Url=@Url, ProductName = @ProductName, Price=@Price,DeadLine=@DeadLine,Limit=@Limit,GroupDesc=@GroupDesc WHERE groupId=@groupId";
            }
            SqlDataAdapter da = new SqlDataAdapter(queryString, con);
            da.SelectCommand.Parameters.AddWithValue("@groupId", id);
            da.SelectCommand.Parameters.AddWithValue("@ProductName", ProductName);
            da.SelectCommand.Parameters.AddWithValue("@Price", Price);
            da.SelectCommand.Parameters.AddWithValue("@DeadLine", DeadLine);
            da.SelectCommand.Parameters.AddWithValue("@Limit", Limit);
            da.SelectCommand.Parameters.AddWithValue("@GroupDesc", GroupDesc);
            da.SelectCommand.Parameters.AddWithValue("@ImgUrl", fileName);
            da.SelectCommand.Parameters.AddWithValue("@Url", Url);
            da.Fill(dt);
            FormView1.DataSource = dt;
            FormView1.DataBind();
            Response.Redirect("groupList.aspx");
        };
    }
    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FileUpload myfile = new FileUpload();
        myfile = ((FileUpload)FormView1.FindControl("FileUpload1"));
        string fileName = myfile.FileName;
        DataTable dt = new DataTable();
        string mypath = Request.PhysicalApplicationPath + "\\images\\";
        string tempfileName = "";
        myfile = ((FileUpload)FormView1.FindControl("FileUpload1"));
        //把formview的fileupload放入新的myfile裡
        System.Web.UI.WebControls.Image productImg = ((System.Web.UI.WebControls.Image)FormView1.FindControl("Image1"));
        string pathToCheck = mypath + myfile.FileName;
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString))
        {

            if (myfile.HasFile)
            {
                #region DB變數
                string EmployeeID = Session["ID"].ToString();
                string ProductName = e.Values[0].ToString();
                int Price = int.Parse(e.Values[1].ToString());
                string DeadLine = e.Values[2].ToString();
                int Limit = int.Parse(e.Values[3].ToString());
                string GroupDesc = e.Values[4].ToString();
                string Url = e.Values[5].ToString();
                string ImgUrl = "";
                string State = "開團中";
                #endregion

                if (myfile.PostedFile.ContentType == "image/pjpeg" | myfile.PostedFile.ContentType == "image/jpeg" | myfile.PostedFile.ContentType == "image/gif" | myfile.PostedFile.ContentType == "image/x-png" | myfile.PostedFile.ContentType == "image/png")
                {
                    if (System.IO.File.Exists(pathToCheck))
                    {
                        int my_counter = 2;
                        while (System.IO.File.Exists(pathToCheck))
                        {
                            tempfileName = my_counter.ToString() + "_" + fileName;
                            pathToCheck = mypath + tempfileName;
                            my_counter = my_counter + 1;
                        }
                        fileName = tempfileName;
                    }
                    myfile.SaveAs(mypath + fileName);
                    productImg.ImageUrl = "../images/" + fileName;
                    ImgUrl = fileName;
                }

                SqlDataAdapter da = new SqlDataAdapter("INSERT INTO [groupList]([EmployeeID],[ProductName],[Price],[DeadLine],[Limit],[GroupDesc],[Url],[ImgUrl],[State]) VALUES (@EmployeeID, @ProductName, @Price, @DeadLine,  @Limit, @GroupDesc, @Url,@ImgUrl,@State)", ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
                da.SelectCommand.Parameters.AddWithValue("@EmployeeID", EmployeeID);
                da.SelectCommand.Parameters.AddWithValue("@ProductName", ProductName);
                da.SelectCommand.Parameters.AddWithValue("@Price", Price);
                da.SelectCommand.Parameters.AddWithValue("@DeadLine", DeadLine);
                da.SelectCommand.Parameters.AddWithValue("@Limit", Limit);
                da.SelectCommand.Parameters.AddWithValue("@GroupDesc", GroupDesc);
                da.SelectCommand.Parameters.AddWithValue("@State", State);
                da.SelectCommand.Parameters.AddWithValue("@Url", Url);
                da.SelectCommand.Parameters.AddWithValue("@ImgUrl", ImgUrl);

                da.Fill(dt);
                FormView1.DataSource = dt;
                FormView1.DataBind();
                Response.Redirect("groupList.aspx");
            }
        }
    }

    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName.ToLower() == "cancel")
            Response.Redirect("groupList.aspx");
    }



    protected void Button1_Click(object sender, EventArgs e)
    {
        TextBox productname = ((TextBox)FormView1.FindControl("TextBox2"));
        TextBox price = ((TextBox)FormView1.FindControl("TextBox3"));
        TextBox date = ((TextBox)FormView1.FindControl("TextBox4"));
        TextBox limit = ((TextBox)FormView1.FindControl("TextBox5"));
        TextBox desc = ((TextBox)FormView1.FindControl("TextBox6"));
        TextBox url = ((TextBox)FormView1.FindControl("UrlTextBox"));
        productname.Text = "【福味】小琉球 手工麻花捲 -椒鹽芥末";
        price.Text = "79";
        date.Text = "2019/03/01";
        limit.Text = "10";
        desc.Text = "★小琉球直送，遊客必買伴手禮\r\n★堅持傳統手工製作，口感絕佳\r\n★新鮮酥脆，每一口都充滿麵粉香\r\n★越嚼越有味，口味多達13種可選擇 ";
        url.Text = "https://24h.pchome.com.tw/prod/DBAR4F-A9009S1Z3?fq=/A/119693";
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        div {
            font-family: Times New Roman,'微軟正黑體';
            font-size: 18px;
        }
        button{
                        font-family: Times New Roman,'微軟正黑體';

        }
    </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>jQuery UI Datepicker - Default functionality</title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $(function () {
            $("#ContentPlaceHolder1_FormView1_datepicker").datepicker({ dateFormat: 'yy/mm/dd' });
        });
        $(function () {
            $("#ContentPlaceHolder1_FormView1_TextBox4").datepicker({ dateFormat: 'yy/mm/dd' });
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="col-lg-12">
        <asp:FormView ID="FormView2" runat="server" CssClass="col-lg-12">
            <ItemTemplate>
                <asp:Label runat="server" CssClass="h1" Text="編輯團單"></asp:Label>

            </ItemTemplate>
            <EditItemTemplate>
                <asp:Label runat="server" CssClass="h1" Text="編輯團單"></asp:Label>

            </EditItemTemplate>
            <InsertItemTemplate>
                <asp:Label ID="Label1" runat="server" Text="商品上架" CssClass="title h1"></asp:Label>
            </InsertItemTemplate>
        </asp:FormView>

    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xl-12 col-xs-12">
        <br />
        
        <ul class="nav nav-pills nav-pills-success col-md-12">
            <li class="active "><a href="Default.aspx">去跟團</a></li>
            <li class="active "><a href="groupEdit.aspx?Mode=Insert">開新團當團長</a></li>
            <li class="active"><a href="grouplist.aspx">團單管理</a></li>
            <li class="active"><a href="orderlist.aspx">跟團訂單明細</a></li>
            <li class="active"><a href="Chart.aspx">圖表生成</a></li>
        </ul>
        <br />

    </div>
    <div class="col-lg-12">
        <asp:FormView CssClass="col-lg-12" ID="FormView1" runat="server" DataKeyNames="groupId" DefaultMode="Edit" GridLines="None" OnItemUpdating="FormView1_ItemUpdating" OnItemInserting="FormView1_ItemInserting" OnItemCommand="FormView1_ItemCommand" CellPadding="-1">

            <EditItemTemplate>
                <br />

                <asp:Label ID="groupIdLable" runat="server" CssClass="h1" Text='<%#  "團單編號#"+Eval("groupId")+Eval("ProductName") %>' />
                <br />
                <br />
                <div class="col-lg-4">
                    <asp:Image ID="ProudctImg" runat="server" CssClass="image img-rounded" ImageUrl='<%#"../images/"+Eval("ImgUrl") %>' Width="100%" /><br />
                    <asp:FileUpload ID="FileUpload2" runat="server" /><br />
                </div>
                <div class="col-lg-8">
                    <table id="itemPlaceholderContainer" class="table table-hover" runat="server">
                        <tr id="itemPlaceholder" runat="server">
                        </tr>
                        <tr runat="server">
                            <th runat="server">商品名稱</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="ProductNameTextBox" runat="server" Text='<%# Bind("ProductName") %>' />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">販售價格</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="PriceTextBox" runat="server" Text='<%# Bind("Price") %>' TextMode="Number" ViewStateMode="Inherit" />
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">截止日期</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="datepicker" runat="server" Text='<%# Bind("DeadLine","{0:yyyy/MM/dd}") %>'></asp:TextBox>
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">成團條件(總數量)</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="SuccessTextBox" runat="server" Text='<%# Bind("Limit") %>' TextMode="Number"></asp:TextBox>
                            </td>
                        </tr>
                        <tr runat="server">
                            <th runat="server">店家網址</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="UrlTextBox" runat="server" Text='<%# Bind("Url") %>' TextMode="Url"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th runat="server">團單描述</th>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="DescTextBox" runat="server" Text='<%# Bind("GroupDesc") %>' TextMode="MultiLine" Height="200px"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
                <div class="col-lg-12">
                    <asp:LinkButton ID="UpdateButton" CssClass="btn-primary  btn rounded" runat="server" CausesValidation="True" CommandName="Update" Text="更新資料" OnClientClick='return confirm("確認更新?")' />
                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" CssClass="btn btn-primary" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消編輯" OnClientClick='return confirm("確認取消?")' />
                </div>

            </EditItemTemplate>
            <InsertItemTemplate>
                <div class="col-lg-12">

                    <br />
                    <br />
                    <div class="col-lg-1"></div>
                    <div class="col-lg-8">

                        <table id="Table1" class="table table-hover" runat="server">
                            <tr id="Tr1" runat="server">
                            </tr>
                            <tr runat="server">
                                <th runat="server">商品名稱</th>
                                <td>
                                    <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" Text='<%# Bind("ProductName") %>' />
                                </td>
                            </tr>
                            <tr runat="server">
                                <th runat="server">販售價格</th>
                                <td>
                                    <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" TextMode="Number" Text='<%# Bind("Price") %>' />
                                </td>
                            </tr>

                            <tr runat="server">
                                <th runat="server">截止日期</th>
                                <td>
                                    <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" Text='<%# Bind("DeadLine") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <tr runat="server">
                                <th runat="server">成團條件(總數量)</th>
                                <td>
                                    <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" TextMode="Number" Text='<%# Bind("Limit") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <th runat="server">團單描述</th>
                                <td>
                                    <asp:TextBox ID="TextBox6" runat="server" TextMode="MultiLine" CssClass="form-control" Height="200px" Text='<%# Bind("groupDesc") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <th runat="server">上傳圖片</th>
                                <td>
                                    <asp:Image ID="Image1" runat="server" CssClass="image img-rounded" Height="70%" />
                                    <asp:FileUpload ID="FileUpload1" runat="server"  Font-Names="'Times New Roman','微軟正黑體'"/>
                                </td>
                            </tr>
                            <tr>
                                <th runat="server">店家網址</th>
                                <td>
                                    <asp:TextBox CssClass="form-control" ID="UrlTextBox" runat="server" TextMode="Url" Text='<%# Bind("Url") %>'></asp:TextBox>

                                </td>
                            </tr>
                        </table>

                        <br />
                                                <asp:Button ID="Button1" runat="server" Text="Demo" OnClick="Button1_Click" CssClass="btn btn-warning"/>

                        <asp:LinkButton CssClass="btn btn-primary" ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="新增" OnClientClick='return confirm("確認新增?")' />
                        &nbsp;<asp:LinkButton CssClass="btn btn-primary" ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消" OnClientClick='return confirm("確認取消?")' />
                    </div>
                    <div class="col-lg-3"></div>

                </div>
            </InsertItemTemplate>
        </asp:FormView>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script>
        function readURL(input) {

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#ContentPlaceHolder1_FormView1_ProudctImg').attr('src', e.target.result);
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $("#ContentPlaceHolder1_FormView1_FileUpload2").change(function () {
            readURL(this);
        });

        function readURL2(input) {

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#ContentPlaceHolder1_FormView1_Image1').attr('src', e.target.result);
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        $("#ContentPlaceHolder1_FormView1_FileUpload1").change(function () {
            readURL2(this);
        });
    </script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ContentPlaceHolder1_FormView1_TextBox2").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "/9036GroupBuy/WebService.asmx/GetNames2",
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

