<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowDetails.aspx.cs" Inherits="Tanner_ShowDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .table tbody tr td {
            vertical-align: middle;
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
        /*.select {
            text-align-last: center;
            text-align: center;
            -ms-text-align-last: center;
            -moz-text-align-last: center;
        }*/
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="EmployeeID" OnItemCommand="FormView1_ItemCommand">
            <ItemTemplate>
                <div class="table-responsive">
                    <div class="text-center">
                        <p class="h3">詳細資料</p>
                    </div>
                    <table class="table">
                        <tr>
                            <td>帳號 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="EmployeeIDLabel1" runat="server" Text='<%# Eval("EmployeeID") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>密碼 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="PasswordTextBox" runat="server" Text='<%# Bind("Password") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>部門名稱 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox1" runat="server" Text='<%# Bind("DepartmentName") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>職務 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="PositionTextBox" runat="server" Text='<%# Bind("Position") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>權限 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="Role" runat="server" Text='<%# Bind("RoleName") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>身分證字號 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox3" runat="server" Text='<%# Bind("identifier") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>姓名 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>性別 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="Label1" runat="server" Text='<%# Bind("Gender") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>出生日期 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox4" runat="server" Text='<%# Bind("DateOfBirth","{0:yyyy/MM/dd}") %>' placeholder="yyyy/mm/dd" />
                            </td>
                        </tr>
                        <tr>
                            <td>手機號碼 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox5" runat="server" Text='<%# Bind("MobilePhoneNumber") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>分機號碼 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox6" runat="server" Text='<%# Bind("ExtensionNumber") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>Email ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox7" runat="server" Text='<%# Bind("Email") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>地址 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox8" runat="server" Text='<%# Bind("Address") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>照片 ：</td>
                            <td>
                                <asp:Image ID="Image1" runat="server" Height="150" Width="120" />
                            </td>
                        </tr>
                        <tr>
                            <td>自我介紹 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox9" runat="server" Text='<%# Bind("Introduction") %>' TextMode="MultiLine" ReadOnly="True" Wrap="True" Width="250" Height="170" />
                            </td>
                        </tr>
                        <tr>
                            <td>到職日 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="TextBox10" runat="server" Text='<%# Bind("DutyDate","{0:yyyy/MM/dd}") %>' placeholder="yyyy/mm/dd" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn-group col-md-12" role="group" aria-label="Basic example">
                                    <asp:LinkButton CssClass="btn btn-danger col-md-12" ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="返回" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </ItemTemplate>
        </asp:FormView>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT Employees.EmployeeID, Employees.Password, Employees.DepartmentID, Employees.Position, Employees.RoleID, Employees.identifier, Employees.Name, Employees.Gender, Employees.DateOfBirth, Employees.MobilePhoneNumber, Employees.ExtensionNumber, Employees.Email, Employees.Address, Employees.ProfilePicture, Employees.Introduction, Employees.DutyDate, Employees.State, Departments.DepartmentName, Roles.RoleName FROM Employees INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID INNER JOIN Roles ON Employees.RoleID = Roles.RoleID WHERE (Employees.EmployeeID = @EmployeeID)">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="" Name="EmployeeID" SessionField="EmployeeID" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>

