<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>W3.CSS</title>

    
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css" />
    <link href="https://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css" />

    <link href="aaa/dist/jquery.roadmap.min.css" rel="stylesheet" type="text/css" />
    <script src="aaa/dist/jquery.roadmap.min.js"></script>
    <script src="Scripts/utils.js"></script>
    <script src="aaa/dist/jquery.roadmap.js" type="text/javascript"></script>
    <style>


        .titleStyle {
            border-radius: 5px;
            background-color: black;
            color: white;
            display: ruby-text;
            padding: 5px;
        }


        .dateTT {
            background-color: #CCDDFF; /*淡紫色*/
            font-family: "微軟正黑體";
            font-size: 25px;
            text-align: center;
            /*border-bottom: 0px;*/
        }

        .contentTT {
            background-color: #CCDDFF; /*淡紫色*/
            font-family: "微軟正黑體";
            font-size: 20px;
            text-align: left;
            /*border-width:medium;
			border-color: blue;*/
        }

        .table-hover > tbody > tr:hover > td,
        .table-hover > tbody > tr:hover > th {
            background-color: lightblue;
        }

        .aa {
            text-align: center;
        }


        /*tr:hover {background-color:lightblue;}*/
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<%--    <form id="form1" runat="server">--%>

        <a href="#" class="titleStyle">發文者</a>
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        <input id="button1" type="button" value="搜尋" />
        <input type="button" value="匯出" id="btnPrint" />

<%--        <div id="result1">
        </div>
        <div id="result2">
        </div>--%>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <div id="my-timeline">
        </div>

        <script type="text/javascript">

				$("#btnPrint").on("click", function () {
				console.log("fFFFF")
				var divContents = $("#my-timeline").html();
				var printWindow = window.open('', '', 'height=400,width=800');
				printWindow.document.write('<html><head><title>DIV Contents</title>');
				printWindow.document.write('</head><body >');
				printWindow.document.write(divContents);
				printWindow.document.write('</body></html>');
				printWindow.document.close();
				printWindow.print();
			});

			$(document).ready(function () {

			});

        </script>
        <script type="text/javascript">

			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', 'UA-36251023-1']);
			_gaq.push(['_setDomainName', 'jqueryscript.net']);
			_gaq.push(['_trackPageview']);

			(function () {
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();


			$(function () {
				$("#button1").click(clickHandler);
			});
			function clickHandler() {

				$.ajax({
					type: "POST",
					url: "WebService.asmx/GetTimeLine",
					contentType: "application/x-www-form-urlencoded",
					data: "announcer=" + $("#ContentPlaceHolder1_TextBox1").val(),
					success: function (data) {
						var dataToJson = xmlToJson(data)
						//var object = JSON.parse( $(data).find("string").text() );
						console.log(dataToJson)
						getTimeLine(dataToJson)
					}
				});

			};

			function getTimeLine(dataToJson) {
				let n = dataToJson.ArrayOfTimeline.timeline.length || 1
				console.log(n)
				var events = []

				if (n == 1) {
					events = [
						{
							date: dataToJson.ArrayOfTimeline.timeline.Date['#text'].slice(0, 10),
							content: "Title: " + dataToJson.ArrayOfTimeline.timeline.Title['#text'] + "<br>" + "發文分類: " + dataToJson.ArrayOfTimeline.timeline.Category['#text'] + '<input id="Button1" type="button" value="button" />'
						},
					];
				}

				else {
					for (var i = 0; i < n; i++) {



						events[i] = {
							date: "<div class='dateTT'>"
								+ "公告日期: "
								+ dataToJson.ArrayOfTimeline.timeline[i].Date['#text'].slice(0, 10)
								+ "</div>"
								+ "<br>",
							//"<table border='1'>"+
							//  "<tr>"+
							//	"<th>公告日</th>"
							//	+"<td>" + dataToJson.ArrayOfTimeline.timeline[i].Date['#text'].slice(0, 10) + "</td>"+
							//  "</tr></table>",

							content: /*"<div class='contentTT'>"*/
								//+ "標題: "
								//+ dataToJson.ArrayOfTimeline.timeline[i].Title['#text']
								//+ "<br>"
								//+ "公告分類:"
								//+ dataToJson.ArrayOfTimeline.timeline[i].Category['#text']
								//+ "<br>"
								//+ "</div>"
								//+ '<input id="btnDelete" type="button" value="刪除貼文" onclick="DeleteEvent(' + dataToJson.ArrayOfTimeline.timeline[i].Id['#text'] + ')"/>'
								//+ '<input id="btnUpdate" type="button" value="編輯貼文" onclick=UpdateEvent(' + dataToJson.ArrayOfTimeline.timeline[i].Id['#text'] + ')"/>'


								//"<table class='w3-table-all w3-hoverable'>" +
								//class=" table table-bordered table-hover table-responsive-md btn-table"
								"<table class='table table-bordered table-hover'>" +
								"<tr>" +
								"<th>標題</th>"
								+ "<td>" + dataToJson.ArrayOfTimeline.timeline[i].Title['#text'] + "</td>" +
								"</tr><tr>"
								+ "<th>分類</th>" +
								"<td class='aa'>" + dataToJson.ArrayOfTimeline.timeline[i].Category['#text'] + "</td>" +
								"</tr>" +
								"</table>"
								+ '<input id="btnDelete" class="sweetalert" type="button" value="刪除貼文" onclick="DeleteEvent(' + dataToJson.ArrayOfTimeline.timeline[i].Id['#text'] + ')"/>'


						}
					}
				}

				$('#my-timeline').roadmap(events, {
					eventsPerSlide: n,
					slide: 1,
					prevArrow: '<i class="material-icons">keyboard_arrow_left</i>',
					nextArrow: '<i class="material-icons">keyboard_arrow_right</i>'
				});


				return events;

			}



			function DeleteEvent(Id) {

				console.log(Id) //OK

				//$("#btnDelete").click(clickHandler2);

				$.ajax({
					type: "GET",
					url: "WebService.asmx/DeleteArticle",
					contentType: "application/x-www-form-urlencoded",
					//data: "announcer=" + $("#TextBox1").val(),
					data: "Id=" + Id,
					success: function (data) {
					}
                });

                    swal({
                    title: '確認?',
                    text: "檔案即將被刪除!",
                    type: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '刪除',
                    cancelButtonText: '取消'
                });
                clickHandler();




				//window.location = 'TimeLine_MP.aspx';//reset頁面

			}

			function UpdateEvent(Id) {

				console.log(Id) //OK

				//$("#btnDelete").click(clickHandler2);

				$.ajax({
					type: "GET",
					url: "WebService.asmx/",
					contentType: "application/x-www-form-urlencoded",
					//data: "announcer=" + $("#TextBox1").val(),
					data: "Id=" + Id,
					success: function (data) {
					}
				});
				window.location = 'TimeLine_withDB.aspx';//reset頁面

			}

			// Changes XML to JSON
			function xmlToJson(xml) {

				// Create the return object
				var obj = {};

				if (xml.nodeType == 1) { // element
					// do attributes
					if (xml.attributes.length > 0) {
						obj["@attributes"] = {};
						for (var j = 0; j < xml.attributes.length; j++) {
							var attribute = xml.attributes.item(j);
							obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
						}
					}
				} else if (xml.nodeType == 3) { // text
					obj = xml.nodeValue;
				}

				// do children
				if (xml.hasChildNodes()) {
					for (var i = 0; i < xml.childNodes.length; i++) {
						var item = xml.childNodes.item(i);
						var nodeName = item.nodeName;
						if (typeof (obj[nodeName]) == "undefined") {
							obj[nodeName] = xmlToJson(item);
						} else {
							if (typeof (obj[nodeName].push) == "undefined") {
								var old = obj[nodeName];
								obj[nodeName] = [];
								obj[nodeName].push(old);
							}
							obj[nodeName].push(xmlToJson(item));
						}
					}
				}
				return obj;
			};


        </script>


<%--    </form>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

