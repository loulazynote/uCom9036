<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="Chart.js"></script>
    <script src="utils.js"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
    <input type="button" id="btn" value="熱門文章" />
    <input type="button" id="btn1" value="員工發言數" />
    <div style="width: 75%;">
        <canvas id="myChart"></canvas>
    </div>

    <script>
        $(function () {

            $("#btn").click(function () {
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/QueryProducts1",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        var xAry = new Array();
                        var yAry = new Array();

                        $(data.d).each(function () {

                            xAry.push($(this)[0].ProductName);
                            yAry.push($(this)[0].UnitPrice);

                        });

                        var ctx = document.getElementById("myChart");
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: xAry,
                                datasets: [{
                                    label: '回覆數',
                                    data: yAry,
                                    borderWidth: 1,
                                    backgroundColor: GetRandomColors(22)
                                }]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                        ticks: {
                                            beginAtZero: true
                                        }
                                    }]
                                }
                            }
                        });
                    }
                });
            });
            $("#btn1").click(function () {
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "WebService.asmx/QueryProducts3",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {

                        var xAry = new Array();
                        var yAry = new Array();

                        $(data.d).each(function () {

                            xAry.push($(this)[0].ProductName);
                            yAry.push($(this)[0].UnitPrice);

                        });

                        var ctx = document.getElementById("myChart");
                        var myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: xAry,
                                datasets: [{
                                    label: '回覆數',
                                    data: yAry,
                                    borderWidth: 1,
                                    backgroundColor: GetRandomColors(22)
                                }]
                            },
                            options: {
                                scales: {
                                    yAxes: [{
                                        ticks: {
                                            beginAtZero: true
                                        }
                                    }]
                                }
                            }



                        });
                    }
                });
            });

        });



    </script>




</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>

