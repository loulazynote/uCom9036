<%@ Page Language="C#" %>

<%--fancyBox--%>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];

            //HiddenField1.Value = human.Id.ToString();

            TextBox1.Text = HiddenField1.Value+9999;

            SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
            SqlCommand cmd = new SqlCommand("select pwd,name,height,hobby,email  from SignUp where Id=@Id; ", cn);

            cn.Open();
            cmd.Parameters.AddWithValue("@Id", human.Id);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    //Response.Write(dr[0].ToString());
                    //Response.Write(dr[1].ToString());
                    //Response.Write(dr[2].ToString());
                    //Response.Write(dr[3].ToString());
                    //Response.Write(dr[4].ToString());
                    //Response.Write(dr[5].ToString());
                    TextBox1.Text = dr[0].ToString();
                    TextBox2.Text = dr[1].ToString();
                    TextBox3.Text = dr[2].ToString();
                    TextBox4.Text = dr[3].ToString();
                    TextBox5.Text = dr[4].ToString();
                   

                }
            }

            dr.Close();
            cn.Close();

        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-color: #CCEEFF;
        }

        .aa {
            background-color: #CCEEFF;
        }

        div input {
            margin-top: 10px;
        }

        #Submit1 {
            margin-left: 100px;
        }

        #information {
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" action="UpdateOnesInformation.aspx">
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <div id="information" style="background-color: #009FCC">
            <h3>修改基本資料</h3>
            密碼：<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox><br />
            姓名：<asp:TextBox ID="TextBox2" runat="server"></asp:TextBox><br />
            身高：<asp:TextBox ID="TextBox3" runat="server"></asp:TextBox><br />
            興趣：<asp:TextBox ID="TextBox4" runat="server"></asp:TextBox><br />
            電郵：<asp:TextBox ID="TextBox5" runat="server"></asp:TextBox><br />
           
            <input id="Submit1" type="submit" value="提交資訊" class="btn btn-danger" />
        </div>
    </form>

    <script src="Scripts/jquery-3.1.1.js"></script>
    <%-- <script src="https://code.jquery.com/jquery-1.12.4.js"></script>--%>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>
    <script>
        $(function () {
            $("#TextBox4").datepicker({
                changeYear: true, // 年份下拉選單
                yearRange: "1950:2019"
            });
        });
    </script>
</body>
</html>
