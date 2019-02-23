<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"].ToString();
        TextBox1.Text = id;
      
        
        TextBox2.Text = Session["UID"].ToString();
    
    }

</script>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

<!-- include jquery -->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.js"></script>

<!-- include libs stylesheets -->
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.css" />
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.5/umd/popper.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.js"></script>

<!-- include summernote -->
<link href="../Summernote/dist/summernote-bs4.css" rel="stylesheet" />
<script type="text/javascript" src="../Summernote/dist/summernote-bs4.js"></script>
<link href="../Summernote/example/example.css" rel="stylesheet" />
<script type="text/javascript">
    $(document).ready(function () {
        $('.click2edit').summernote({

            height: 300,
            width: 1300,
            tabsize: 2
        });

    });
    function UploadWindow()
{
    var aa = document.getElementById("TextBox1").value;
    //alert(aa);
    window.open("UploadfilmEdit.aspx?id=" + aa, "_blank", "width=400,height=400");


    
}

</script>
<style>
    body{
        background-color:rgb(236, 237, 240);
    }
</style>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Summernote - Bootstrap 4</title>

</head>
<body>
    <div style="display:none"><span id="head"></span></div>
    Title :&nbsp;<input type="text" id="title" value="" class="form-control" style="width: 500px"/><br />
     <form id="form1" runat="server">
        <div style="display:none;">
    Author :&nbsp;<asp:TextBox ID="TextBox2" class="form-control" style="width: 300px" runat="server"></asp:TextBox><br />
        <%--<input type="text" id="author" value="" class="form-control" style="width: 200px" runat="server"/>--%>
</div>
    

   <label>Group :</label>
    <br />
    <select id="drop" class="browser-default custom-select" style="width: 500px">
    </select>
    
        <div style="display: none">
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        </div>
    </form>

    <br />
    <div id="hey"></div>
    <br />
    <button onclick="UploadWindow()" class="btn btn-primary">附檔</button>
    &nbsp;<input type="button" id="btn1" value="預覽" class="btn btn-primary"/>
    &nbsp;<input type="button" id="btn" value="上傳" class="btn btn-primary"/>

    
    <div id="ho"></div>

    <script>



        $(function () {

            $("#btn1").click(function () {
                var markup = $('#hey').summernote('code');
                $('#hey').summernote('destroy');
                $('#hey').summernote({
                    focus: true, height: 300, width: 1300,
                    tabsize: 2
                });
                $("#ho").empty();
                var firstDivContent = document.getElementById('hey');
                var secondDivContent = document.getElementById('ho');
                secondDivContent.innerHTML = firstDivContent.innerHTML;
            });//預覽按鈕
            $("#drop").empty();//清除dropdownlist
            $.ajax({
                type: "POST",
                async: false,
                url: "../WebService.asmx/select",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data);
                    var xAry = new Array();
                    $(data.d).each(function () {
                        xAry.push(this);
                    })
                    for (var i = 0; i < data.d.length; i++) {
                        $("#drop").append("<option>" + xAry[i] + "</option>");
                    }
                }
            })//生成dropdownlist
            var id = TextBox1.value;
            $.ajax({
                type: "POST",
                async: false,
                url: "../WebService.asmx/select1",
                data: JSON.stringify({
                    keyword: id,
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {

                    //alert(data.d);
                    var secondDivContent = document.getElementById('hey');
                    secondDivContent.innerHTML = data.d;
                    $('#hey').summernote({
                        focus: true, height: 300, width: 1300,
                        tabsize: 2
                    });
                    var header = document.getElementById('head');
                    header.innerHTML = id;

                    //for (var i = 0; i < data.d.length; i++) {
                    //    $("#drop").append("<option>" + xAry[i] + "</option>");
                    //}

                }
            })//抓內文
            $.ajax({
                type: "POST",
                async: false,
                url: "../WebService.asmx/select2",
                data: JSON.stringify({
                    keyword: id,
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data.d);                 
                    var title = document.getElementById('title');
                    title.value = data.d;

                }
            })//抓主題
            $.ajax({
                type: "POST",
                async: false,
                url: "../WebService.asmx/select3",
                data: JSON.stringify({
                    keyword: id,
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    //alert(data.d);                 
                    var title = document.getElementById('author');
                    author.value = data.d;

                }
            })//抓作者

            $.ajax({
                    type: "POST",
                    async: false,
                    url: "../WebService.asmx/select4",
                    data: JSON.stringify({
                        keyword: id,
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        document.getElementById("drop").value = data.d;


                    }
                })//抓作者


            $("#btn").click(function () {
                var markup = $('#hey').summernote('code');
                $('#hey').summernote('destroy');
                $('#hey').summernote({
                    focus: true, height: 300, width: 1300,
                    tabsize: 2
                });
                $("#ho").empty();
                var firstDivContent = document.getElementById('hey');
                var secondDivContent = document.getElementById('ho');
                secondDivContent.innerHTML = firstDivContent.innerHTML;
                var id = TextBox1.value;
                var content = firstDivContent.innerHTML;
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "../WebService.asmx/UpSavethediv3",
                    data: JSON.stringify({
                        keyword: id,
                        content: content,
                        title: $("#title").val(),
                        author: $("#TextBox2").val(),
                        categoryName: $("#drop").val(),

                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function () {

                        //alert($("#title").val());
                        //window.top.location.href = "@List.aspx";
                        window.location.href = "UploadUserimg.aspx?Title="+$("#title").val();
                    }
                });
            });//上傳

        });



    </script>
</body>
</html>

