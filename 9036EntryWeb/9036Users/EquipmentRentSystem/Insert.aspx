<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Insert.aspx.cs" Inherits="EquipmentRentSystem_Insert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .table tbody tr td {
            vertical-align: middle;
        }

        .justify {
            text-align: justify;
            text-justify: inter-ideograph;
        }

        table {
            margin-left: auto;
            margin-right: auto;
        }

        body, button, input, select, textarea, h1, h2, h3, h4, h5, h6 {
            font-family: Microsoft YaHei,'宋体', Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif;
        }

        .bootstrap-filestyle {
            width: 100%
        }
        /*select {
            text-align-last: center;
            text-align: center;
            -ms-text-align-last: center;
            -moz-text-align-last: center;
        }*/
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="#">器材租借管理系統</a>
                </div>
                <ul class="nav navbar-nav">
                    <li>
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/EquipmentRentSystem/Index.aspx">首頁</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/EquipmentRentSystem/ShowLogs.aspx">租借紀錄查詢</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/EquipmentRentSystem/EditEvent.aspx">管理租借紀錄</asp:HyperLink></li>
                    <li class="active">
                        <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/EquipmentRentSystem/Insert.aspx">新增器材</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/EquipmentRentSystem/Condition.aspx">報銷器材</asp:HyperLink></li>
                </ul>
            </div>
        </nav>
    </div>
    <div class="row text-right">
        <asp:Button ID="Button1" runat="server" Text="Fill" CssClass="btn btn-default" OnClick="Button1_Click" />
    </div>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="EmployeeID" DefaultMode="Insert" OnItemCommand="FormView1_ItemCommand" OnItemInserting="FormView1_ItemInserting" DataSourceID="SqlDataSource1">
        <InsertItemTemplate>
            <div class="text-center">
                <p class="h3">新增器材</p>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <tr>
                        <td>器材類別 ：</td>
                        <td>
                            <asp:DropDownList CssClass="form-control" ID="DropDownList0" runat="server" SelectedValue='<%# Bind("EquipmentTypeID") %>' DataSourceID="SqlDataSource2" DataTextField="EquipmentTypeName" DataValueField="EquipmentTypeID" AppendDataBoundItems="True">
                                <asp:ListItem Selected="True" Value="-1">-----------------------請選擇-----------------------</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>器材名稱 ：</td>
                        <td>
                            <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" Text='<%# Bind("EquipmentName") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td>器材描述 ：</td>
                        <td>
                            <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" Text='<%# Bind("EquipmentDescription") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td>使用年限 ：</td>
                        <td>
                            <div class="col-xs-5">
                                <asp:DropDownList CssClass="form-control" ID="DropDownList1" runat="server">
                                    <asp:ListItem Selected="True" Value="-1">--請選擇--</asp:ListItem>
                                    <asp:ListItem Value="0">00</asp:ListItem>
                                    <asp:ListItem Value="1">01</asp:ListItem>
                                    <asp:ListItem Value="2">02</asp:ListItem>
                                    <asp:ListItem Value="3">03</asp:ListItem>
                                    <asp:ListItem Value="4">04</asp:ListItem>
                                    <asp:ListItem Value="5">05</asp:ListItem>
                                    <asp:ListItem Value="6">06</asp:ListItem>
                                    <asp:ListItem Value="7">07</asp:ListItem>
                                    <asp:ListItem Value="8">08</asp:ListItem>
                                    <asp:ListItem Value="9">09</asp:ListItem>
                                    <asp:ListItem Value="10">10</asp:ListItem>
                                    <asp:ListItem Value="11">11</asp:ListItem>
                                    <asp:ListItem Value="12">12</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-xs-1">
                                <h5>年</h5>
                            </div>
                            <div class="col-xs-5">
                                <asp:DropDownList CssClass="form-control" ID="DropDownList2" runat="server">
                                    <asp:ListItem Selected="True" Value="-1">--請選擇--</asp:ListItem>
                                    <asp:ListItem Value="0">00</asp:ListItem>
                                    <asp:ListItem Value="1">01</asp:ListItem>
                                    <asp:ListItem Value="2">02</asp:ListItem>
                                    <asp:ListItem Value="3">03</asp:ListItem>
                                    <asp:ListItem Value="4">04</asp:ListItem>
                                    <asp:ListItem Value="5">05</asp:ListItem>
                                    <asp:ListItem Value="6">06</asp:ListItem>
                                    <asp:ListItem Value="7">07</asp:ListItem>
                                    <asp:ListItem Value="8">08</asp:ListItem>
                                    <asp:ListItem Value="9">09</asp:ListItem>
                                    <asp:ListItem Value="10">10</asp:ListItem>
                                    <asp:ListItem Value="11">11</asp:ListItem>
                                    <asp:ListItem Value="12">12</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-xs-1">
                                <h5>月</h5>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>照片 ：</td>
                        <td>
                            <%--<asp:Image ID="Image1" runat="server" Height="150" Width="120"/>--%>
                            <asp:FileUpload CssClass="form-control" ID="FileUpload1" runat="server" accept=".png,.jpg,.jpeg,.gif,.bmp" />
                        </td>
                    </tr>
                    <tr>
                        <td>數量 ：</td>
                        <td>
                            <asp:TextBox CssClass="form-control" ID="Quantity_TextBox" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="btn-group col-md-12" role="group" aria-label="Basic example">
                                <asp:LinkButton CssClass="btn btn-success col-md-6" ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="新增" ValidationGroup="InsertBook" />
                                <asp:LinkButton CssClass="btn btn-warning col-md-6" ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消" />
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </InsertItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT * FROM [Equipments]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT * FROM [EquipmentType]" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="../Tanner/scripts/bootstrap-filestyle.min.js"></script>

    <script>
        $(function () {
            $(":file").filestyle({ buttonText: "" });
        });
    </script>
</asp:Content>

