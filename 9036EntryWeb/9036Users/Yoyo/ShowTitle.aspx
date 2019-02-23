<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string id = Request.QueryString["id"].ToString();
            BindListView1(id);
            TextBox3.Text = id;
            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
            SqlCommand cmd = new SqlCommand(
                "SELECT Head FROM Forum WHERE [Id] = @Id", cn);
            cmd.Parameters.AddWithValue("Id", id);
            cn.Open();
            string value = cmd.ExecuteScalar().ToString();
            cn.Close();
            if (value == "" || value == "false")
            {
                this.DIV2.Style.Value = "display:none";
            }
            else
            {
                this.DIV1.Style.Value = "display:none";
            }
             TextBox2.Text = Session["UID"].ToString();
        }
    }
    private void BindListView1(string id)
    {
        SqlDataAdapter da = new SqlDataAdapter(
       "select * from comment where  ([Titleid] = @Id) AND ([ToWho]=@Id) ", ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("Id", id);
        DataTable dt = new DataTable();
        da.Fill(dt);
        ListView1.DataSource = dt;
        ListView1.DataBind();

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        //int id = int.Parse(TextBox1.Text);
        string Username = TextBox2.Text;//登入者
        string comment = TextBox1.Text;//回覆
        string datetime = System.DateTime.Now.ToString();
        int titleid = int.Parse(Request.QueryString["id"].ToString());
        //string author = UserName;


        //string name = e.Values[1].ToString();
        //int age = int.Parse(e.Values[2].ToString());

        SqlConnection cn = new SqlConnection(
    ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);



        SqlCommand cmd = new SqlCommand(
            "INSERT INTO [comment] ([Titleid],[DateTime], [UserName], [Comment], [ToWho], [ReplyDateTime]) VALUES (@Titleid, @datetime, @UserName, @Comment, @ToWho, @ReplyDateTime)", cn);

        cmd.Parameters.AddWithValue("UserName", Username);
        cmd.Parameters.AddWithValue("Titleid", titleid);
        cmd.Parameters.AddWithValue("datetime", datetime);
        cmd.Parameters.AddWithValue("Comment", comment);
        cmd.Parameters.AddWithValue("ToWho", titleid);
        cmd.Parameters.AddWithValue("ReplyDateTime", datetime);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        Countcomment(titleid);
    }
    private void Countcomment(int titleid)
    {
        SqlConnection cn1 = new SqlConnection(
    ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd1 = new SqlCommand(
            "SELECT COUNT (Titleid) FROM [comment] WHERE (Titleid=@titleid)", cn1);
        cmd1.Parameters.AddWithValue("titleid", titleid);
        cn1.Open();
        int op = int.Parse(cmd1.ExecuteScalar().ToString());
        SqlCommand cmd2 = new SqlCommand(
            "UPDATE [Forum] SET [commentcount] = @Title WHERE [Id] = @id", cn1);
        cmd2.Parameters.AddWithValue("id", titleid);
        cmd2.Parameters.AddWithValue("Title", op);
        cmd2.ExecuteNonQuery();
        cn1.Close();

        Response.Redirect("~/Yoyo/ShowTitle.aspx?id=" + titleid);

    }
    protected void btnReplyParent_Click(object sender, CommandEventArgs e)
    {
        var control = (Control)sender;
        var container = control.NamingContainer;
        var textBox = container.FindControl("textCommentReplyParent") as TextBox;//回應內容
        var textBoxtowho = container.FindControl("textUserNameReplyParent") as TextBox;//ToWho存取用
        var textBoxtocomment = container.FindControl("textUserNameReplyParentComment") as TextBox;//針對哪一篇評論回應存取用(改成針對哪一篇評論的時間)
        int title = int.Parse(Request.QueryString["id"].ToString());//文章id存取用

        if (textBox != null)
        {
            var lineID = e.CommandArgument;
            var text = textBox.Text;//回應內容
            var towho = textBoxtowho.Text;//ToWho存取用
            var tocomment = textBoxtocomment.Text;//針對哪一篇評論回應存取用


            //Response.Write(towho);
            //Response.Write(text);

            string Username = Session["UID"].ToString();//登入者

            string datetime = System.DateTime.Now.ToString();


            SqlConnection cn = new SqlConnection(
        ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);

            SqlCommand cmd = new SqlCommand(
                "INSERT INTO [comment] ([Titleid], [UserName], [DateTime], [ToWho], [Comment], [ReplyDateTime]) VALUES (@Titleid, @UserName, @datetime, @ToWho, @Comment, @tocomment)", cn);

            cmd.Parameters.AddWithValue("UserName", Username);
            cmd.Parameters.AddWithValue("Titleid", title);
            cmd.Parameters.AddWithValue("datetime", datetime);
            cmd.Parameters.AddWithValue("ToWho", towho);
            cmd.Parameters.AddWithValue("Comment", text);
            cmd.Parameters.AddWithValue("tocomment", tocomment);//改時間
            cn.Open();
            cmd.ExecuteNonQuery();
            cn.Close();




        }

        Countcomment(title);

    }
    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int title = int.Parse(Request.QueryString["id"].ToString());//文章id存取用
        string id = e.Keys[0].ToString();
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand(
            "DELETE FROM [comment] WHERE [DateTime] = @Id", cn);
        cmd.Parameters.AddWithValue("Id", id);
        SqlCommand cmd1 = new SqlCommand(
            "DELETE FROM [comment] WHERE [ReplyDateTime] = @Id", cn);
        cmd1.Parameters.AddWithValue("Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cmd1.ExecuteNonQuery();
        cn.Close();        
        Countcomment(title);
        
    }
    protected void ListView2_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int title = int.Parse(Request.QueryString["id"].ToString());//文章id存取用
        string id = e.Keys[0].ToString();
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand(
            "DELETE FROM [comment] WHERE [DateTime] = @Id", cn);
        cmd.Parameters.AddWithValue("Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Countcomment(title);
    }
    protected void DownloadFile(object sender, EventArgs e)
    {
        string GUID = (sender as LinkButton).CommandArgument;
        byte[] bytes;
        string fileName, contentType;
        string constr = ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select * from Document where GUID=@GUID";
                cmd.Parameters.AddWithValue("@GUID", GUID);
                cmd.Connection = con;
                con.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    sdr.Read();
                    bytes = (byte[])sdr["Data"];
                    contentType = sdr["CONTENT_TYPE"].ToString();
                    fileName = sdr["FILE_NAME"].ToString();
                }
            }
        }

        Response.Clear();
        Response.Buffer = true;
        Response.Charset = "";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = contentType;
        Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
        Response.BinaryWrite(bytes);
        Response.Flush();
        Response.End();
    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"].ToString();
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand(
            "UPDATE [Forum] SET [Head] = @Head WHERE [Id] = @Id", cn);
        cmd.Parameters.AddWithValue("Id", id);
        cmd.Parameters.AddWithValue("Head", "false");
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/Yoyo/ShowTitle.aspx?id=" + id);
    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"].ToString();
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString);
        SqlCommand cmd = new SqlCommand(
            "UPDATE [Forum] SET [Head] = @Head WHERE [Id] = @Id", cn);
        cmd.Parameters.AddWithValue("Id", id);
        cmd.Parameters.AddWithValue("Head", "true");
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect("~/Yoyo/ShowTitle.aspx?id=" + id);
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        function Openwin() {
            myu = document.getElementById('cid').value;
            var res = myu.split(" ");
            if (res.length = 1)
                window.open("search.aspx?Id=" + res, "_blank");
            else {
                var str1 = res[0];
                var str2 = res[1];
                window.open("search.aspx?Id=" + str1 + "&Id2=" + str2, "_blank");
            }
        }        
    </script>
    <style>
        .greenBorder {
            /*border: 1px solid green;*/
        }
        /* just borders to see it */
        .center123 {
            margin: auto;
            width: 65%;
            /*border: 3px solid green;*/
            padding: 10px;
        }

        .center1234 {
            margin: auto;
            width: 58%;
            /*border: 3px solid green;*/
            padding: 10px;
        }

        tr {
            font-size: medium
        }
        

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource3">
            <ItemTemplate>
                <td runat="server" style="">
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("CategoryName", "~/Yoyo/Showgroup.aspx?CategoryName={0}") %>'><%# Eval("CategoryName") %></asp:HyperLink>
                    <%--<asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />--%>
                    <br />
                </td>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" border="0" style="">
                    <tr id="itemPlaceholderContainer" runat="server">
                        <td id="itemPlaceholder" runat="server"></td>
                    </tr>
                </table>
                <div style="">
                </div>
            </LayoutTemplate>
        </asp:ListView>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT DISTINCT [CategoryName] FROM [Forum]"></asp:SqlDataSource>
    </div>
    <div style="float: right;" class="form-inline"><input type="text" placeholder="Search" id="cid" class="form-control" style="width:200px;height:30px"/>&nbsp;<i class="fas fa-search text-white ml-3" aria-hidden="true"></i><div style="display:none;"><asp:Button ID="Button2" runat="server" Text="搜尋" OnClientClick="Openwin();return false;" /></div></div>
    <div style="float: right">
        &nbsp;<asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Yoyo/Insert.aspx"><img src="img/24.gif" style="height:29px;width:95px" onmouseover='this.src = "img/26.gif"' onmouseout='this.src = "img/24.gif"'/></asp:HyperLink>&nbsp;
    </div>
    <div class="greenBorder" style="display: table; width: 100%; height: 400px; #position: relative; overflow: hidden;">
        <div style="#position: absolute; #top: 50%; display: table-cell; vertical-align: middle;">
            <div class="center123" style="#position: relative; #top: -50%">
                <div id="DIV1" runat="server" style="float: right; background-color: pink;">                    
                    <asp:Button ID="Button4" runat="server" Text="放置首頁當封面" OnClick="Button4_Click" />
                </div>
                <div id="DIV2" runat="server" style="float: right; background-color: pink;">
                    <asp:Button ID="Button3" runat="server" Text="取消首頁當封面" OnClick="Button3_Click" />
                </div>
                <!--貼文-->
                <div style="display: none;">
                    <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
                </div>

                <asp:FormView ID="FormView1" runat="server" DataKeyNames="Id" DataSourceID="SqlDataSource1">
                    <ItemTemplate>
                        <%--Id:
                    <asp:Label ID="ProductIDLabel" runat="server" Text='<%# Eval("Id") %>' />
                        <br />--%>
                        <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Bind("Title") %>' Font-Size="X-Large" />
                        <hr />
                        類別 :
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("CategoryName") %>' />
                        <br />
                        發文時間:
                    <asp:Label ID="SupplierIDLabel" runat="server" Text='<%# Bind("DateTime") %>' />
                        <br />
                        作者:
                    <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Bind("Author") %>' />
                        <br />
                        <br />
                        <asp:Label ID="QuantityPerUnitLabel" runat="server" Text='<%# Bind("Content") %>' />
                        <br />
                    </ItemTemplate>
                    <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                    <RowStyle  />
                </asp:FormView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT [Id], [Title], [DateTime], [Author], [Content],[CategoryName] FROM [Forum] WHERE ([Id] = @Id)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:ListView ID="ListView3" runat="server" DataSourceID="SqlDataSource9" DataKeyNames="GUID">
                    <ItemTemplate>
                        <tr style="">
                            <td>
                                <asp:Label ID="FILE_NAMELabel" runat="server" Text='<%# Eval("FILE_NAME") %>' />
                            </td>
                            <td>
                                
                            </td>
                            <td>
                                <asp:LinkButton ID="lnkDownload" runat="server" Text="Download" OnClick="DownloadFile"
                                    CommandArgument='<%# Eval("GUID") %>'></asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="">
                                        <tr runat="server" style="">
                                            <th runat="server"></th>
                                            <th runat="server"></th>
                                            <th runat="server"></th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style=""></td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                </asp:ListView>
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT [GUID], [FILE_NAME], [SIZE] FROM [Document] WHERE ([CONTENT_TYPE] = @CONTENT_TYPE)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="CONTENT_TYPE" QueryStringField="id" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="center123">
                <!--評論-->
                <div style="display:none;">
            <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox></div>                
                <br />
                Comment:
                <asp:TextBox ID="TextBox1" runat="server" Height="100px" Width="381px" TextMode="MultiLine" class="form-control"></asp:TextBox>
                 <br />   
                <asp:Button ID="Button1" runat="server" Text="comment" OnClick="Button1_Click" class="btn btn-info"/>
                <asp:ListView ID="ListView1" runat="server" DataKeyNames="DateTime" OnItemDeleting="ListView1_ItemDeleting">
                    <ItemTemplate>
                        <table style="width: 500px">
                            <tr style="">
                                <td>
                                    <%--<a href='Edit.aspx?id=<%#Eval("EmployeeID")%>'>Edit</a>--%>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
                                    <br />
                                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl='<%# Eval("UserName", "~/Yoyo/Upload/EmployeePhoto.aspx?Name={0}") %>' Width="50px" Height="50px" />
                                    <asp:Label ID="EmployeeIDLabel" runat="server" Text='<%# Eval("UserName") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Comment") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%-- <asp:Button ID="Button2" runat="server" Text="Reply" OnClick="Button2_Click" />--%>
                                    <button type="button" class="btn btn-info" onclick='document.getElementById("divReply<%# Eval("Comment") %>").style.display = "block"'>Reply</button>
                                    <button type="button" class="btn btn-info" onclick='document.getElementById("divReply<%# Eval("Comment") %>").style.display = "none"'>Cancel</button>
                                    <div id='divReply<%# Eval("Comment") %>' style="display: none; margin-top: 5px;">
                                        <asp:TextBox ID="textCommentReplyParent" runat="server" Width="300px" TextMode="MultiLine"></asp:TextBox>
                                        <div style="display: none;">
                                            <asp:TextBox ID="textUserNameReplyParent" runat="server" Width="30px" Text='<%# Eval("UserName") %>'></asp:TextBox><%--ToWho--%>
                                            <asp:TextBox ID="textUserNameReplyParentComment" runat="server" Width="30px" Text='<%# Eval("DateTime") %>'></asp:TextBox><%--DateTime--%>
                                        </div>
                                        <br />
                                        <asp:Button class="btn btn-info" ID="btnReplyParent" runat="server" Text="Reply" OnCommand="btnReplyParent_Click" />
                                    </div>
                                    <br />
                                    <asp:ListView ID="ListView2" runat="server" DataKeyNames="DateTime" DataSourceID="SqlDataSource1" OnItemDeleting="ListView2_ItemDeleting">
                                        <ItemTemplate>
                                            <table>
                                                <tr>
                                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
                                                </tr>
                                                <tr style="">
                                                    <td>
                                                        <div style="width: 50px;"></div>
                                                    </td>
                                                    <td>
                                                        <br />
                                                        <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl='<%# Eval("UserName", "~/Yoyo/Upload/EmployeePhoto.aspx?Name={0}") %>' Width="50px" Height="50px" />
                                                        <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("UserName") %>' />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div style="width: 50px;"></div>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ReplyLabel" runat="server" Text='<%# Eval("Comment") %>' />
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="DateTimeLabel" runat="server" Text='<%# Eval("DateTime") %>' />
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:ListView>
                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT * FROM [comment] WHERE (([Titleid] = @Id) AND ([ToWho] = @ToWho) AND ([ReplyDateTime] = @DateTime))">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="textUserNameReplyParent" Name="ToWho" PropertyName="Text" Type="String" />
                                            <asp:ControlParameter ControlID="textUserNameReplyParentComment" Name="DateTime" PropertyName="Text" Type="String" />
                                            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <hr />
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

