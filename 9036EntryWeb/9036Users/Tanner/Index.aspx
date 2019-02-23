<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Tanner_Index" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        div {
            padding: 0;
            margin: 0;
        }

        .form-control {
            width: auto;
        }

        .table tbody tr td {
            vertical-align: middle;
        }

        body, button, input, select, textarea, h1, h2, h3, h4, h5, h6 {
            font-family: Microsoft YaHei,'宋体', Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif;
        }

        .table-striped > tbody > tr:nth-child(odd) {
            background-color: white;
        }

        .table-striped > tbody > tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        select {
            text-align-last: center;
            text-align: center;
            -ms-text-align-last: center;
            -moz-text-align-last: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField ID="HiddenField_DataSource" runat="server" />
    <div class="form-group row">
        <div class="col-xs-12 form-inline">
            <div class="col-xs-5" style="padding: 0">
                <asp:Button CssClass="btn btn-success " Style="width: 20%" ID="Button_Insert" runat="server" Text="新增" OnClick="Button_Insert_Click" />
                <asp:Button CssClass="btn btn-success " Style="width: 20%" ID="Button2" runat="server" Text="編輯" OnClick="Button2_Click" Visible="false"/>
            </div>
            <div class="col-xs-2">
                顯示
                <asp:DropDownList ID="DropDownList2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
                    <asp:ListItem>5</asp:ListItem>
                    <asp:ListItem Selected="True">10</asp:ListItem>
                    <asp:ListItem>15</asp:ListItem>
                    <asp:ListItem>20</asp:ListItem>
                    <asp:ListItem>50</asp:ListItem>
                    <asp:ListItem>75</asp:ListItem>
                    <asp:ListItem>100</asp:ListItem>
                </asp:DropDownList>
                筆資料
            </div>
            <div class="col-xs-5" style="padding: 0" align="right">
                <asp:DropDownList CssClass="form-control" ID="DropDownList1" runat="server" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="True">
                    <asp:ListItem Value="DepartmentID">部門名稱</asp:ListItem>
                    <asp:ListItem Value="Position">職務</asp:ListItem>
                    <asp:ListItem Value="Name">姓名</asp:ListItem>
                    <asp:ListItem Value="Gender">性別</asp:ListItem>
                    <asp:ListItem Value="DateOfBirth">生日</asp:ListItem>
                    <asp:ListItem Value="MobilePhoneNumber">手機號碼</asp:ListItem>
                    <asp:ListItem Value="ExtensionNumber">分機號碼</asp:ListItem>
                    <asp:ListItem Value="Email">電子信箱</asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList CssClass="form-control" ID="DropDownList_Department" runat="server" Visible="true" DataSourceID="SqlDataSource3" DataTextField="DepartmentName" DataValueField="DepartmentID">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" Visible="false" Style="height: 25px"></asp:TextBox>
                <asp:DropDownList CssClass="form-control" ID="DropDownList_Gender" runat="server" Visible="false">
                    <asp:ListItem Value="Male">男</asp:ListItem>
                    <asp:ListItem Value="FeMale">女</asp:ListItem>
                </asp:DropDownList>
                <asp:Button CssClass="btn btn-primary" ID="Button1" runat="server" Text="查詢" OnClick="Button1_Click" />
                <asp:Button CssClass="btn btn-danger" ID="Button_CanelQuery" Text="取消查詢" runat="server" OnClick="Button_CanelQuery_Click" />

            </div>

        </div>
    </div>
    <div>
        <asp:ListView ID="ListView1" runat="server" OnItemCommand="ListView1_ItemCommand" OnPagePropertiesChanging="ListView1_PagePropertiesChanging" OnSorting="ListView1_Sorting">
            <ItemTemplate>
                <tr>
                    <td>
                        <%--<asp:Button ID="DeleteButton" runat="server" CommandName="Delete" CommandArgument='<%#Eval("EmployeeID") %>' Text="Delete" OnClientClick="return confirm('確定要刪除嗎?');"/>--%>
                        <asp:Button CssClass="btn btn-basic" ID="ShowDetailsButton" runat="server" CommandName="ShowDetails" CommandArgument='<%#Eval("EmployeeID") %>' Text="詳細資料" />
                        <asp:Button CssClass="btn btn-basic" ID="EditButton" runat="server" CommandName="Edit" Text="編輯" CommandArgument='<%#Eval("EmployeeID") %>' />
                        <asp:HiddenField ID="HiddenField1" runat="server" Value='<%#Eval("EmployeeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="DepartmentIDLabel" runat="server" Text='<%# Eval("DepartmentID") %>' Visible="false" />
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("DepartmentName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PositionLabel" runat="server" Text='<%# Eval("Position") %>' />
                    </td>
                    <td>
                        <asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Name") %>' />
                    </td>
                    <td>
                        <asp:Image ID="Image1" runat="server" Heigh="60" Width="60" />
                    </td>
                    <td>
                        <asp:Label ID="GenderLabel" runat="server" Text='<%# Eval("Gender") %>' />
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("DateOfBirth","{0:yyyy-MM-dd}") %>' />
                    </td>
                    <td>
                        <asp:Label ID="MobilePhoneNumberLabel" runat="server" Text='<%# Eval("MobilePhoneNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ExtensionNumberLabel" runat="server" Text='<%# Eval("ExtensionNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EmailLabel" runat="server" Text='<%# Eval("Email") %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <div class="table-responsive">
                    <table class="table table-striped" id="itemPlaceholderContainer" runat="server" border="0" style="">
                        <tr runat="server" style="">
                            <th></th>
                            <th>
                                <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument="DepartmentName" CommandName="Sort">部門名稱</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton2" runat="server" CommandArgument="Position" CommandName="Sort">職務</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton3" runat="server" CommandArgument="Name" CommandName="Sort">姓名</asp:LinkButton>
                            </th>
                            <th>照片</th>
                            <th>
                                <asp:LinkButton ID="LinkButton4" runat="server" CommandArgument="Gender" CommandName="Sort">性別</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton5" runat="server" CommandArgument="DateOfBirth" CommandName="Sort">生日</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton6" runat="server" CommandArgument="MobilePhoneNumber" CommandName="Sort">手機號碼</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton7" runat="server" CommandArgument="ExtensionNumber" CommandName="Sort">分機號碼</asp:LinkButton>
                            </th>
                            <th>
                                <asp:LinkButton ID="LinkButton8" runat="server" CommandArgument="Email" CommandName="Sort">Email</asp:LinkButton>
                            </th>
                        </tr>
                        <tr id="itemPlaceholder">
                        </tr>
                    </table>
                </div>
            </LayoutTemplate>
        </asp:ListView>
    </div>
    <%--<div class="col-xs-2"></div>--%>
    <div class="col-xs-12" style="text-align: center">
        <asp:DataPager ID="lvDataPager1" runat="server" PagedControlID="ListView1" PageSize="10" class="btn-group pager-buttons">
            <Fields>
                <asp:NextPreviousPagerField ShowLastPageButton="False" ShowNextPageButton="False" ButtonType="Button" ButtonCssClass="btn" RenderNonBreakingSpacesBetweenControls="false" PreviousPageText="上一頁" />
                <asp:NumericPagerField ButtonType="Button" RenderNonBreakingSpacesBetweenControls="false" NumericButtonCssClass="btn" CurrentPageLabelCssClass="btn disabled" NextPreviousButtonCssClass="btn" />
                <asp:NextPreviousPagerField ShowFirstPageButton="False" ShowPreviousPageButton="False" ButtonType="Button" ButtonCssClass="btn" RenderNonBreakingSpacesBetweenControls="false" NextPageText="下一頁" />
            </Fields>
        </asp:DataPager>
    </div>
    <%--<div class="col-xs-2"></div>--%>

    <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:Entry9036 %>' SelectCommand="SELECT * FROM [Departments]"></asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

