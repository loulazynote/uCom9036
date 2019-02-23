<%@ Page Title="" Language="C#" MasterPageFile="~/User_chichi/MasterPage_mine.master" %>
<%--首頁--%>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {


        if (Session["human"] != null)
        {
            Human human = (Human)Session["human"];
            labelUserId.Text = human.Id.ToString() + "," + human.Sex;
        }

        //if (Request.QueryString["userId"] != null)
        //{
        //    string id = Request.QueryString["userId"];
        //    labelUserId.Text = id;
        //}
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        #labelUserId{
            /*margin-top:110px;*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>

        <h1>9036Chichi 聯誼系統</h1>
         <!--Carousel-->
    <%--圖片輪播--%>
    <div id="carousel1" class="carousel slide" data-ride="carousel" data-interval="3000">
        <ul class="carousel-indicators">
            <li data-target="#carousel1" data-slide-to="0"></li>
            <li data-target="#carousel1" data-slide-to="1" class="active"></li>
            <li data-target="#carousel1" data-slide-to="2"></li>
            <li data-target="#carousel1" data-slide-to="3"></li>
        </ul>
        <div class="carousel-inner">
            <div class="item">
                <img src="../images/carousel/1.jpg" />
                <div class="carousel-caption">
                   <%-- <h1>Headling 1 </h1>
                    <p>Description 1</p>
                    <a href="55_Youtube.aspx">Youtube</a>--%>
                </div>
            </div>
            <div class="item active">
                <img src="../images/carousel/2.jpg" />
                <div class="carousel-caption">
                    <%--<h1>Headling 2 </h1>
                    <p>Description 2</p>--%>
                </div>
            </div>
            <div class="item">
                <img src="../images/carousel/3.jpg" />
                <div class="carousel-caption">
                  <%--  <h1>Headling 3 </h1>
                    <p>Description 3</p>--%>
                </div>
            </div>
            <div class="item">
                <img src="../images/carousel/4.jpg" />
                <div class="carousel-caption">
                   <%-- <h1>Headling 3 </h1>
                    <p>Description 3</p>--%>
                </div>
            </div>
        </div>
        <a class="left carousel-control" href="#carousel1" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="right carousel-control" href="#carousel1" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
    </div>
        <asp:Label ID="labelUserId" runat="server" Text=""></asp:Label>
    </div>
</asp:Content>

<%--<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>--%>

