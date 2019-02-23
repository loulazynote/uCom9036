<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        TextBox1.Text = Session["UID"].ToString();
    }

</script>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

<!-- include jquery -->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.js"></script>
<link href="../../vendor/sweetalert2/sweetalert2.min.css" rel="stylesheet" />
<script src="../../scripts/sweetalert2.min.js"></script>
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
    function UploadWindow() {
        var aa = document.getElementById("title").value;
        //alert(aa);
        window.open("Uploadfilm.aspx?title=" + aa, "_blank", "width=400,height=400");
    }
</script>
<style>
    body {
        background-color: rgb(236, 237, 240);
    }
</style>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Summernote - Bootstrap 4</title>
</head>
<body>
    Title :&nbsp;<input type="text" id="title" value="" class="form-control" style="width: 500px" /><br />
    <form id="form1" runat="server">
        <div style="display: none;">
            Author :&nbsp;<asp:TextBox ID="TextBox1" class="form-control" Style="width: 300px" runat="server"></asp:TextBox><br />
            <%--<input type="text" id="author" value="" class="form-control" style="width: 200px" runat="server"/>--%>
        </div>
    </form>
    <label>Group :</label>
    <br />
    <select id="drop" class="browser-default custom-select" style="width: 500px">
    </select>

    <br />

    <br />
    <div class="click2edit" id="ha"></div>
    <br />
    <button onclick="UploadWindow()" class="btn btn-primary">附檔</button>&nbsp;
    
    <button onclick="myFunction()" class="btn btn-primary">預覽</button>
    &nbsp;
    <button id="btn" class="btn btn-primary">上傳</button>
    &nbsp;
    <button id="btn2" class="btn btn-danger">取消</button>
    <div id="hey"></div>
    <script>




        function myFunction() {
            var markup = $('.click2edit').summernote('code');
            $('.click2edit').summernote('destroy');
            $('.click2edit').summernote({
                focus: true, height: 300, width: 1300,
                tabsize: 2
            });
            var firstDivContent = document.getElementById('ha');
            var secondDivContent = document.getElementById('hey');
            secondDivContent.innerHTML = "<h1>" + $("#title").val() + "</h1><hr/>" + firstDivContent.innerHTML;
        }

        $(function () {


            $("#drop").empty();
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
            })




            $("#btn").click(function () {

                var markup = $('.click2edit').summernote('code');
                $('.click2edit').summernote('destroy');
                $('.click2edit').summernote({
                    focus: true, height: 300, width: 1300,
                    tabsize: 2
                });

                var firstDivContent = document.getElementById('ha');

                var content = firstDivContent.innerHTML;


                $.ajax({
                    type: "POST",
                    async: false,
                    url: "../WebService.asmx/Savethediv4",
                    data: JSON.stringify({

                        content: content,
                        title: $("#title").val(),
                        author: $("#TextBox1").val(),
                        categoryName: $("#drop").val(),

                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function () {

                        window.location.href = "UploadUserimg.aspx?Title=" + $("#title").val();
                        //window.top.location.href = "@List.aspx";
                        //return false;
                    }
                });
            });


            $("#btn2").click(function () {
                swal({
                    title: "警告",
                    text: "確定要離開?",
                    type: "warning"
                }).then(function () {
                    // Redirect the user
                    window.top.location.href = "../List(admin).aspx";
                })

            });

        });



    </script>
</body>
</html>

