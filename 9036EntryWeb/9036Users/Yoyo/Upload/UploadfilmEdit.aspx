<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Configuration" %>
<!DOCTYPE html>

<script runat="server"> 
    protected void Upload(object sender, EventArgs e)
    {
        foreach (HttpPostedFile postedFile in FileUpload1.PostedFiles)
        {
            string filename = Path.GetFileName(postedFile.FileName);
            string contentType = postedFile.ContentType;
            using (Stream fs = postedFile.InputStream)
            {
                using (BinaryReader br = new BinaryReader(fs))
                {
                    byte[] bytes = br.ReadBytes((Int32)fs.Length);
                    string constr = ConfigurationManager.ConnectionStrings["Yoyo"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constr))
                    {
                        string query = "insert into Document values (@CONTENT_TYPE,@FILE_NAME,@DATA,@SIZE,@MNT_USER,@MNT_DT)";
                        using (SqlCommand cmd = new SqlCommand(query))
                        {
                            string title = Request.QueryString["id"].ToString();
                            cmd.Connection = con;
                            cmd.Parameters.AddWithValue("@CONTENT_TYPE", title);
                            cmd.Parameters.AddWithValue("@FILE_NAME", filename);
                            cmd.Parameters.Add("@SIZE", SqlDbType.Decimal);
                            cmd.Parameters["@SIZE"].Value = Convert.ToDecimal(bytes.Length / 1024);
                            cmd.Parameters.AddWithValue("@MNT_USER", "try");
                            cmd.Parameters.AddWithValue("@MNT_DT", DateTime.Now);
                            cmd.Parameters.AddWithValue("@DATA", bytes);
                            con.Open();
                            cmd.ExecuteNonQuery();
                            con.Close();
                        }
                    }
                }
            }
        }
        Response.Redirect(Request.Url.AbsoluteUri);
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
        int id = int.Parse(e.Keys[0].ToString());
        SqlConnection cn = new SqlConnection(WebConfigurationManager.ConnectionStrings
      ["Yoyo"].ConnectionString);

        SqlCommand cmd = new SqlCommand(
            "DELETE FROM [Document] WHERE [GUID] = @Id", cn);

        cmd.Parameters.AddWithValue("Id", id);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        Response.Redirect(Request.Url.AbsoluteUri);
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div><asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" />
            <asp:Button ID="Button1" runat="server" Text="Upload" OnClick="Upload" Height="22px" />
        </div>
        <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="GUID" OnItemDeleting="ListView1_ItemDeleting">
            <ItemTemplate>
                <tr style="">
                    <td>
                        <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
                    </td>
                    <td>
                        <asp:Label ID="FILE_NAMELabel" runat="server" Text='<%# Eval("FILE_NAME") %>' />
                    </td>
                    <td>
                        <asp:Label ID="SIZELabel" runat="server" Text='<%# Eval("SIZE") %>' />
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
                                    <th runat="server">FILE_NAME</th>
                                    <th runat="server">SIZE</th>
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Yoyo %>" SelectCommand="SELECT [GUID], [FILE_NAME], [SIZE] FROM [Document] WHERE ([CONTENT_TYPE] = @CONTENT_TYPE)">
            <SelectParameters>
                <asp:QueryStringParameter Name="CONTENT_TYPE" QueryStringField="id" Type="String" />                
            </SelectParameters>
        </asp:SqlDataSource>


        


    </form>
</body>
</html>
