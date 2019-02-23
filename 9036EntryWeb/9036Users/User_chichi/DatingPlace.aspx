<%--3 level Navigation bar--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title></title>
    <link href="/User_chichi/Content/bootstrap.css" rel="stylesheet" />

    <link href="/User_chichi/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" />
    <style>
        /*div{
            border:1px solid;
        }*/
        body {
            padding-top: 50px;
            /*background-image: url("images/backgroundImage/2.jpg");*/
            background:aliceblue;
            font-size:24px;
        }

         #myJumbotron{
            background-color:#999;
            color:aliceblue;
        }

        .carousel .item img {
            width: 100%;
            margin: auto;
        }

        .dropdown-submenu {
            position: relative;
        }

            .dropdown-submenu > .dropdown-menu {
                top: 0;
                left: 100%;
                margin-top: -6px;
                margin-left: -1px;
                -webkit-border-radius: 0 6px 6px 6px;
                -moz-border-radius: 0 6px 6px;
                border-radius: 0 6px 6px 6px;
            }

            .dropdown-submenu:hover > .dropdown-menu {
                display: block;
            }

            .dropdown-submenu > a:after {
                display: block;
                content: " ";
                float: right;
                width: 0;
                height: 0;
                border-color: transparent;
                border-style: solid;
                border-width: 5px 0 5px 5px;
                border-left-color: #ccc;
                margin-top: 5px;
                margin-right: -10px;
            }

            .dropdown-submenu:hover > a:after {
                border-left-color: #fff;
            }

            .dropdown-submenu.pull-left {
                float: none;
            }

                .dropdown-submenu.pull-left > .dropdown-menu {
                    left: -100%;
                    margin-left: 10px;
                    -webkit-border-radius: 6px 0 6px 6px;
                    -moz-border-radius: 6px 0 6px 6px;
                    border-radius: 6px 0 6px 6px;
                }
    </style>
</head>
<body>

    

   
    <!--jumbotron-->
    <div class="container">
        <div class="jumbotron" id="myJumbotron">
            <h1>請男性用戶選取約會地點</h1>
            <%--<p>Youtube Test</p>--%>
            <a href="/User_chichi/Default_mine.aspx" class="btn btn-primary btn-lg">首頁</a>
        </div>
    </div>

    <!--content-->
    <div class="container-fluid">

        <div class="row text-center" id="divx">
        </div>

    </div>

    <%-- fancyBox--%>
    <%--<a id="fancyBox1" href="FormFrom_FancyBox.aspx"><img src="images/cat1.jpg" width="400" height="300"/></a>--%>

    <script src="/User_chichi/Scripts/jquery-3.1.1.js"></script>
    <script src="/User_chichi/Scripts/bootstrap.js"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
    <script src="/User_chichi/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script src="/User_chichi/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>


    <script>
        $(function () {

            $.ajax({
                type: "POST",
                async: false,
                url: "WebService.asmx/QueryDatingPlace",
                data: JSON.stringify({}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    console.log(data.d);
                    //alert("bb");
                    $(data.d).each(function () {


                        var divx = $(` <div class="col-xs-6 col-sm-4 col-md-3 ">
                                        <div class="media">
                                            <a href="DatingDetail_Detailview.aspx?id=${$(this)[0].PlaceId}" class="pull-left">
                                                <img src="DatingPlacePhoto.aspx?id=${$(this)[0].PlaceId}" height="150" width="210" class="media-object" />
                                            </a>
                                             <div class="media-body">
                                                <h4 class="media-heading"><font color="red">${$(this)[0].name}</font></h4>
                                                <p>
                                                    ${$(this)[0].description.substr(0, 20)}... 
                                                 </p>
                                            </div>
                                         </div>
                                     </div>`);

                        $(".media").css("margin-bottom", "100px");


                        $("#divx").append(divx);
                    });
                }
            });

            //$("a#fancyBox1").fancybox();


        });

    </script>


</body>
</html>
