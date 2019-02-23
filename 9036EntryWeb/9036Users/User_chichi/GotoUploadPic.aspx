<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string MId = null;

        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            MId = human.Id.ToString();
        }

        Response.Redirect($"~/User_chichi/UploadImageDB.aspx?id={MId}");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
