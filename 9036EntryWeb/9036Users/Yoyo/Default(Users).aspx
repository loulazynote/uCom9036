<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<script runat="server"> 

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

<style>
    body {
        background-color: rgb(236, 237, 240);
    }
</style>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="UTF-8">
    <link rel="shortcut icon" type="image/x-icon" href="https://static.codepen.io/assets/favicon/favicon-8ea04875e70c4b0bb41da869e81236e54394d63638a1ef12fa558a4a835f1164.ico" />
    <link rel="mask-icon" type="" href="https://static.codepen.io/assets/favicon/logo-pin-f2d2b6d2c61838f7e76325261b7195c27224080bc099486ddd6dccb469b8e8e6.svg" color="#111" />
    <title>CodePen - Split 3D Carousel</title>
    <link href="https://fonts.googleapis.com/css?family=Oswald" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Merriweather:300:italic" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <style>
        html,
        body {
            height: 100%;
            padding: 0;
            margin: 0;
        }

        body {
            background-color: rgb(236, 237, 240);
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }

        .js-transitions-disabled * {
            transition: none !important;
        }

        .carousel {
            position: relative;
            height: 100%;
            overflow: hidden;
            -webkit-perspective: 50vw;
            perspective: 50vw;
            -webkit-perspective-origin: 50% 50%;
            perspective-origin: 50% 50%;
        }

        .carousel__control {
            position: absolute;
            height: 160px;
            width: 40px;
            background: #fff;
            right: 0;
            top: 0;
            bottom: 0;
            margin: auto;
            z-index: 1;
        }

            .carousel__control a {
                position: relative;
                display: block;
                width: 10-%;
                padding-top: 75%;
                box-sizing: border-box;
            }

                .carousel__control a:hover:before {
                    background-color: rgba(0,0,0,0.4);
                }

                .carousel__control a.active:before,
                .carousel__control a.active:hover:before {
                    background-color: rgba(0,0,0,0.6);
                }

                .carousel__control a:first-child {
                    margin-top: 15px;
                }

                .carousel__control a:before {
                    position: absolute;
                    top: 50%;
                    left: 0;
                    right: 0;
                    margin: auto;
                    border-radius: 50%;
                    padding-top: 25%;
                    width: 25%;
                    background: rgba(0,0,0,0.2);
                    content: '';
                    display: block;
                    margin-top: -12.5%;
                }

        .carousel__stage {
            position: absolute;
            top: 20px;
            bottom: 20px;
            left: 20px;
            right: 20px;
            margin: auto;
            -webkit-transform-style: preserve-3d;
            transform-style: preserve-3d;
            -webkit-transform: translateZ(calc(-50vh + 20px));
            transform: translateZ(calc(-50vh + 20px));
        }

        .spinner {
            position: absolute;
            width: calc(50vw - (20px));
            height: calc(100vh - 40px);
            top: 0;
            left: 0;
            right: auto;
            bottom: 0;
            margin: auto;
            -webkit-transform-style: preserve-3d;
            transform-style: preserve-3d;
            transition: -webkit-transform 1s;
            transition: transform 1s;
            transition: transform 1s, -webkit-transform 1s;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            -webkit-transform-origin: 50% 50%;
            transform-origin: 50% 50%;
            -webkit-transform: rotateX(0);
            transform: rotateX(0);
        }

        .js-spin-fwd .spinner {
            -webkit-transform: rotateX(-90deg);
            transform: rotateX(-90deg);
        }

        .js-spin-bwd .spinner {
            -webkit-transform: rotateX(90deg);
            transform: rotateX(90deg);
        }

        .js-spin-fwd .spinner--right {
            -webkit-transform: rotateX(90deg);
            transform: rotateX(90deg);
        }

        .js-spin-bwd .spinner--right {
            -webkit-transform: rotateX(-90deg);
            transform: rotateX(-90deg);
        }

        .spinner--right {
            right: 0;
            left: auto;
        }

        .spinner__face {
            display: none;
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

            .spinner__face.js-next {
                display: block;
                -webkit-transform: rotateX(90deg) translateZ(calc(50vh - 20px));
                transform: rotateX(90deg) translateZ(calc(50vh - 20px));
            }

        .spinner--right .spinner__face.js-next {
            -webkit-transform: rotateX(270deg) translateZ(calc(50vh - 20px));
            transform: rotateX(270deg) translateZ(calc(50vh - 20px));
        }

        .js-spin-bwd .spinner__face.js-next {
            -webkit-transform: rotateX(-90deg) translateZ(calc(50vh - 20px));
            transform: rotateX(-90deg) translateZ(calc(50vh - 20px));
        }

        .js-spin-bwd .spinner--right .spinner__face.js-next {
            -webkit-transform: rotateX(-270deg) translateZ(calc(50vh - 20px));
            transform: rotateX(-270deg) translateZ(calc(50vh - 20px));
        }

        .js-active {
            display: block;
            -webkit-transform: translateZ(calc(50vh - 20px));
            transform: translateZ(calc(50vh - 20px));
        }

        .content {
            position: absolute;
            width: 200%;
            height: 100%;
            left: 0;
        }

        .spinner--right .content {
            left: -100%;
        }

        .content__left {
            position: absolute;
            left: 0;
            top: 0;
            width: 50%;
            height: 100%;
        }

        .content__right {
            position: absolute;
            left: 0;
            top: 0;
            width: 50%;
            height: 100%;
        }

        .content__right {
            right: 0;
            left: auto;
        }

        .content__left {
            background-repeat: no-repeat;
            background-size: cover;
        }

            .content__left:after {
                position: absolute;
                display: block;
                content: "";
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.1);
            }

            .content__left h1 {
                position: absolute;
                top: 50%;
                margin-top: -3vw;
                text-align: center;
                font-family: oswald;
                font-size: 5vw;
                height: 10vw;
                opacity: 1;
                color: #fff;
                width: 100%;
                letter-spacing: 0.15em;
                line-height: 0.6;
            }

            .content__left span {
                font-size: 1vw;
                font-weight: 300;
                letter-spacing: 0.2em;
                opacity: 0.9;
                font-family: Merriweather;
            }

        .content__right {
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .content__right .content__main {
                position: absolute;
                font-family: Merriweather, serif;
                text-align: left;
                color: #fff;
                font-size: 1.3vw;
                padding: 0 8vw;
                line-height: 1.65;
                font-weight: 300;
                margin: 0;
                opacity: 0.8;
            }

                .content__right .content__main p:last-child {
                    text-transform: uppercase;
                    letter-spacing: 0.15em;
                    font-size: 0.85em;
                }

            .content__right .content__index {
                font-size: 30vh;
                position: absolute;
                right: -1vh;
                top: 35vh;
                opacity: 0.04;
                font-family: oswald;
                color: #fff;
            }

        [data-type="iceland"] .content__left {
            background-image: url("https://i.ibb.co/q0dBDPd/Picture2.png");
        }

        .spinner--right [data-type="iceland"] .content__left {
            background-image: none;
        }

        [data-type="china"] .content__left {
            background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/china.jpg");
        }

        .spinner--right [data-type="china"] .content__left {
            background-image: none;
        }

        [data-type="usa"] .content__left {
            background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/usa.jpg");
        }

        .spinner--right [data-type="usa"] .content__left {
            background-image: none;
        }

        [data-type="peru"] .content__left {
            background-image: url("https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/peru.jpg");
        }

        .spinner--right [data-type="peru"] .content__left {
            background-image: none;
        }

        .spinner--right {
            width: 70%
        }

        .spinner--left {
            width: 30%
        }
    </style>
    <script>
        window.console = window.console || function (t) { };
    </script>
    <script>
        if (document.location.search.match(/type=embed/gi)) {
            window.parent.postMessage("resize", "*");
        }
    </script>
</head>
<body>
    <div class="carousel" id="try">
        <div class="carousel__control">
        </div>
        <div class="carousel__stage">
            <div class="spinner spinner--left">

                <div class="spinner__face js-active" data-bg="#27323c">
                    <div class="content" data-type="iceland">
                        <div class="content__left">
                            <h1>ICELAND<br>
                                <span>EUROPE</span></h1>
                        </div>
                        <div class="content__right">
                            <div class="content__main">
                                
                            </div>
                            <h3 class="content__index">01</h3>
                        </div>
                    </div>
                </div>  


               








            </div>
        </div>
    </div>

    <form id="form1" runat="server">
        <!--  Poor man's preloader -->
        <div style="height: 0; width: 0; overflow: hidden">
            <img src="https://free.com.tw/blog/wp-content/uploads/2014/08/Placekitten480-g.jpg">
            <img src="https://free.com.tw/blog/wp-content/uploads/2014/08/Placekitten480-g.jpg"><img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/china.jpg"><img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/usa.jpg"><img src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/215059/iceland.jpg">
        </div>
        <script src="https://static.codepen.io/assets/common/stopExecutionOnTimeout-de7e2ef6bfefd24b79a3f68b414b87b8db5b08439cac3f1012092b2290c719cd.js"></script>

        <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js'></script>


        <script>
            var activeIndex = 0;
            var limit = 0;
            var disabled = false;
            var $stage = void 0;
            var $controls = void 0;
            var canvas = false;

            var SPIN_FORWARD_CLASS = 'js-spin-fwd';
            var SPIN_BACKWARD_CLASS = 'js-spin-bwd';
            var DISABLE_TRANSITIONS_CLASS = 'js-transitions-disabled';
            var SPIN_DUR = 1000;

            var appendControls = function appendControls() {
                for (var i = 0; i < limit; i++) {
                    $('.carousel__control').append('<a href="#" data-index="' + i + '"></a>');
                }
                var height = $('.carousel__control').children().last().outerHeight();

                $('.carousel__control').css('height', 30 + limit * height);
                $controls = $('.carousel__control').children();
                $controls.eq(activeIndex).addClass('active');
            };

            var setIndexes = function setIndexes() {
                $('.spinner').children().each(function (i, el) {
                    $(el).attr('data-index', i);
                    limit++;
                });
            };

            var duplicateSpinner = function duplicateSpinner() {
                var $el = $('.spinner').parent();
                var html = $('.spinner').parent().html();
                $el.append(html);
                $('.spinner').last().addClass('spinner--right');
                $('.spinner--right').removeClass('spinner--left');
            };

            var paintFaces = function paintFaces() {
                $('.spinner__face').each(function (i, el) {
                    var $el = $(el);
                    var color = $(el).attr('data-bg');
                    $el.children().css('backgroundImage', 'url(' + getBase64PixelByColor(color) + ')');
                });
            };

            var getBase64PixelByColor = function getBase64PixelByColor(hex) {
                if (!canvas) {
                    canvas = document.createElement('canvas');
                    canvas.height = 1;
                    canvas.width = 1;
                }
                if (canvas.getContext) {
                    var ctx = canvas.getContext('2d');
                    ctx.fillStyle = hex;
                    ctx.fillRect(0, 0, 1, 1);
                    return canvas.toDataURL();
                }
                return false;
            };

            var prepareDom = function prepareDom() {
                setIndexes();
                paintFaces();
                duplicateSpinner();
                appendControls();
            };

            var spin = function spin() {
                var inc = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 1;
                if (disabled) return;
                if (!inc) return;
                activeIndex += inc;
                disabled = true;

                if (activeIndex >= limit) {
                    activeIndex = 0;
                }

                if (activeIndex < 0) {
                    activeIndex = limit - 1;
                }

                var $activeEls = $('.spinner__face.js-active');
                var $nextEls = $('.spinner__face[data-index=' + activeIndex + ']');
                $nextEls.addClass('js-next');

                if (inc > 0) {
                    $stage.addClass(SPIN_FORWARD_CLASS);
                } else {
                    $stage.addClass(SPIN_BACKWARD_CLASS);
                }

                $controls.removeClass('active');
                $controls.eq(activeIndex).addClass('active');

                setTimeout(function () {
                    spinCallback(inc);
                }, SPIN_DUR, inc);
            };

            var spinCallback = function spinCallback(inc) {

                $('.js-active').removeClass('js-active');
                $('.js-next').removeClass('js-next').addClass('js-active');
                $stage.
                    addClass(DISABLE_TRANSITIONS_CLASS).
                    removeClass(SPIN_FORWARD_CLASS).
                    removeClass(SPIN_BACKWARD_CLASS);

                $('.js-active').each(function (i, el) {
                    var $el = $(el);
                    $el.prependTo($el.parent());
                });
                setTimeout(function () {
                    $stage.removeClass(DISABLE_TRANSITIONS_CLASS);
                    disabled = false;
                }, 100);

            };

            var attachListeners = function attachListeners() {

                document.onkeyup = function (e) {
                    switch (e.keyCode) {
                        case 38:
                            spin(-1);
                            break;
                        case 40:
                            spin(1);
                            break;
                    }

                };

                $controls.on('click', function (e) {
                    e.preventDefault();
                    if (disabled) return;
                    var $el = $(e.target);
                    var toIndex = parseInt($el.attr('data-index'), 10);
                    spin(toIndex - activeIndex);

                });
            };

            var assignEls = function assignEls() {
                $stage = $('.carousel__stage');
            };

            var init = function init() {
                assignEls();
                prepareDom();
                attachListeners();
            };


            $(function () {
                init();
            });
      //# sourceURL=pen.js
        </script>

        <script src="https://static.codepen.io/assets/editor/live/css_reload-5619dc0905a68b2e6298901de54f73cefe4e079f65a75406858d92924b4938bf.js"></script>

       
    </form>

   
    
    <script>



        $(function () {



            



                $("#try").empty();

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/QueryProducts2",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {



                        var cc = "<div class='carousel__control'></div><div class='carousel__stage' ><div class='spinner spinner--left'><div class='spinner__face js-active' data-bg='#27323c'><div class='content' data-type='iceland'><div class='content__left'></div><div class='content__right'><div class='content__main'><h1>恆逸9036班 微軟全方位網站程式設計師養成班</h1><h1>-導師周季賢</h1></div><h3 class='content__index'>01</h3></div></div></div>";

                        var hh = cc;
                        $(data.d).each(function () {

                            var dd = "<div class='spinner__face' data-bg='#19304a'><div class='content' >";
                            hh = hh + dd;

                            var aa = "Upload/Userimg.aspx?id=" + $(this)[0].ProductName;
                            var bb = "'" + aa + "'";
                            var ee = "<div class='content__left' style=";
                            hh = hh + ee;
                            var ff = '"background-image:';
                            hh = hh + ff;
                            var gg = "url(" + bb + "); ";
                            hh = hh + gg;
                            var uui = '"';
                            hh = hh + uui;

                            var uu1 = "ShowTitle(Users).aspx?Id=" + $(this)[0].ProductName;
                            var uu2 = "'" + uu1 + "'";
                            var uu3 = 'onclick="top.location.href=' + uu2+';';
                            
                            hh = hh + uu3;

                            var yy = '" > ';
                            hh = hh + yy;
                            //var ii = " </div > <div class='content__right' ><div class='content__main' >" + "<p>123</p>" + "<p>– Damian Harper</p></div><h3 class='content__index'>02</h3></div></div ></div > ";

                            var ii = " </div > <div class='content__right' ><div class='content__main' >" + "<p><h1>" + $(this)[0].UnitPrice + "</h1></p>" + "<p>– " + $(this)[0].Author + "</p></div><h3 class='content__index'>02</h3></div></div ></div > ";

                            hh = hh + ii;



                        });

                        hh = hh + "</div></div>";

                        $("#try").append(hh);
                    }
                });

                var activeIndex = 0;
                var limit = 0;
                var disabled = false;
                var $stage = void 0;
                var $controls = void 0;
                var canvas = false;

                var SPIN_FORWARD_CLASS = 'js-spin-fwd';
                var SPIN_BACKWARD_CLASS = 'js-spin-bwd';
                var DISABLE_TRANSITIONS_CLASS = 'js-transitions-disabled';
                var SPIN_DUR = 1000;

                var appendControls = function appendControls() {
                    for (var i = 0; i < limit; i++) {
                        $('.carousel__control').append('<a href="#" data-index="' + i + '"></a>');
                    }
                    var height = $('.carousel__control').children().last().outerHeight();

                    $('.carousel__control').css('height', 30 + limit * height);
                    $controls = $('.carousel__control').children();
                    $controls.eq(activeIndex).addClass('active');
                };

                var setIndexes = function setIndexes() {
                    $('.spinner').children().each(function (i, el) {
                        $(el).attr('data-index', i);
                        limit++;
                    });
                };

                var duplicateSpinner = function duplicateSpinner() {
                    var $el = $('.spinner').parent();
                    var html = $('.spinner').parent().html();
                    $el.append(html);
                    $('.spinner').last().addClass('spinner--right');
                    $('.spinner--right').removeClass('spinner--left');
                };

                var paintFaces = function paintFaces() {
                    $('.spinner__face').each(function (i, el) {
                        var $el = $(el);
                        var color = $(el).attr('data-bg');
                        $el.children().css('backgroundImage', 'url(' + getBase64PixelByColor(color) + ')');
                    });
                };

                var getBase64PixelByColor = function getBase64PixelByColor(hex) {
                    if (!canvas) {
                        canvas = document.createElement('canvas');
                        canvas.height = 1;
                        canvas.width = 1;
                    }
                    if (canvas.getContext) {
                        var ctx = canvas.getContext('2d');
                        ctx.fillStyle = hex;
                        ctx.fillRect(0, 0, 1, 1);
                        return canvas.toDataURL();
                    }
                    return false;
                };

                var prepareDom = function prepareDom() {
                    setIndexes();
                    paintFaces();
                    duplicateSpinner();
                    appendControls();
                };

                var spin = function spin() {
                    var inc = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 1;
                    if (disabled) return;
                    if (!inc) return;
                    activeIndex += inc;
                    disabled = true;

                    if (activeIndex >= limit) {
                        activeIndex = 0;
                    }

                    if (activeIndex < 0) {
                        activeIndex = limit - 1;
                    }

                    var $activeEls = $('.spinner__face.js-active');
                    var $nextEls = $('.spinner__face[data-index=' + activeIndex + ']');
                    $nextEls.addClass('js-next');

                    if (inc > 0) {
                        $stage.addClass(SPIN_FORWARD_CLASS);
                    } else {
                        $stage.addClass(SPIN_BACKWARD_CLASS);
                    }

                    $controls.removeClass('active');
                    $controls.eq(activeIndex).addClass('active');

                    setTimeout(function () {
                        spinCallback(inc);
                    }, SPIN_DUR, inc);
                };

                var spinCallback = function spinCallback(inc) {

                    $('.js-active').removeClass('js-active');
                    $('.js-next').removeClass('js-next').addClass('js-active');
                    $stage.
                        addClass(DISABLE_TRANSITIONS_CLASS).
                        removeClass(SPIN_FORWARD_CLASS).
                        removeClass(SPIN_BACKWARD_CLASS);

                    $('.js-active').each(function (i, el) {
                        var $el = $(el);
                        $el.prependTo($el.parent());
                    });
                    setTimeout(function () {
                        $stage.removeClass(DISABLE_TRANSITIONS_CLASS);
                        disabled = false;
                    }, 100);

                };

                var attachListeners = function attachListeners() {

                    document.onkeyup = function (e) {
                        switch (e.keyCode) {
                            case 38:
                                spin(-1);
                                break;
                            case 40:
                                spin(1);
                                break;
                        }

                    };

                    $controls.on('click', function (e) {
                        e.preventDefault();
                        if (disabled) return;
                        var $el = $(e.target);
                        var toIndex = parseInt($el.attr('data-index'), 10);
                        spin(toIndex - activeIndex);

                    });
                };

                var assignEls = function assignEls() {
                    $stage = $('.carousel__stage');
                };

                var init = function init() {
                    assignEls();
                    prepareDom();
                    attachListeners();
                };


                $(function () {
                    init();
                });
                //# sourceURL=pen.js




            
            

        });







    </script>
</body>
</html>

