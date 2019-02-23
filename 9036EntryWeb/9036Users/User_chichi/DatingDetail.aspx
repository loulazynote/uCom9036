<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            HiddenField2.Value = human.Id.ToString();
        }



        string PlaceId = null;
        if (Request.QueryString["id"] != null)
        {
            PlaceId = Request.QueryString["id"];
            HiddenField1.Value = PlaceId;
        }
    }

    //返回上一頁
    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/DatingPlace.aspx");
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width" name="viewport" />
    <title></title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <style>
        body {
            background-color: #CCDDFF; /*淡紫色*/
        }

        #btnBack, #btnEmail {
           border-radius: 5px;
            margin-left: 50px;
            margin-top: 10px;
            background-color: #222;
            color: white;
        }

       
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <asp:HiddenField ID="HiddenField2" runat="server" />
        <div>
            <h1>約會地點</h1>
            <div style="width: 75%;">
                <table class="table table-striped">
                    <thead>
                        <tr class="warning">
                        </tr>
                    </thead>
                    <tbody id="mytBody">
                    </tbody>
                </table>
            </div>
        </div>
        <asp:Button ID="btnBack" runat="server" Text="返回約會地點選項" OnClick="btnBack_Click"  />
        <input id="btnEmail" type="button" value="寄送邀請" />
         <div id="result"></div>
    </form>
    <script src="Scripts/jquery-3.1.1.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script>
        $(function () {
            var UserId = $("#HiddenField2").val();
            var PlaceId = $("#HiddenField1").val();
            var name = null;
            var description = null;

            
           
            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryCertainDatingPlace",
                data: JSON.stringify({
                    Id: PlaceId
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {
                        name = $(this)[0].name;
                        description = $(this)[0].description;
                        var table = $(` 
                                        <tr class="success"><td width="90">照片</td><td> <img src="DatingPlacePhoto.aspx?id=${$(this)[0].PlaceId}" height="300" width="400" alt="" /></td></tr>
                                        <tr class="success"><td width="90">地點</td><td>${$(this)[0].name}</td></tr>
                                        <tr class="success"><td width="90">描述</td><td>${$(this)[0].description}</td></tr>
                                       
                                        `);
                        $("#mytBody").append(table);
                    });
                }
            });

            console.log(UserId);
            console.log(PlaceId);
            console.log(name);
            console.log(description);

            $("#btnEmail").click(function () {
                console.log("qq");
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/ModifyGaleTable",
                    data: JSON.stringify({
                        UserId: UserId,
                        PlaceId: PlaceId,
                        place: name,
                        description: description
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        console.log("kk");
                        $("#result").html(data.d); 
                    }
                });

                window.location = 'SendEmailToWoman.aspx';//寄信給女生

            });
        });
    </script>
</body>
</html>
