<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Tanner_Edit" %>

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
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="EmployeeID" DataSourceID="SqlDataSource1" DefaultMode="Edit" OnItemCommand="FormView1_ItemCommand" OnItemUpdating="FormView1_ItemUpdating" OnItemDeleting="FormView1_ItemDeleting">
            <EditItemTemplate>
                <div class="table-responsive">
                    <div class="text-center">
                        <p class="h3">編輯資料</p>
                    </div>
                    <table class="table">
                        <tr>
                            <td>帳號 ：</td>
                            <td>
                                <asp:Label CssClass="form-control" ID="EmployeeIDLabel1" runat="server" Text='<%# Eval("EmployeeID") %>' />
                            </td>
                            <td style="width: 25px">
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="EmployeeIDLabel1" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>--%>
                            </td>
                        </tr>
                        <tr>
                            <td>密碼 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="PasswordTextBox" runat="server" Text='<%# Bind("Password") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="PasswordTextBox" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <%--                        <tr>
                            <td>Confirm Password:</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" Text="" TextMode="Password" />
                            </td>
                            <td>
                                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="*" ValidationGroup="InsertBook" ControlToValidate="TextBox1" ControlToCompare="PasswordTextBox" ForeColor="Red" Font-Bold="True" Display="Dynamic"></asp:CompareValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox1" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>--%>
                        <tr>
                            <td>部門名稱 ：</td>
                            <td>
                                <asp:DropDownList CssClass="form-control" ID="DropDownList1" runat="server" SelectedValue='<%# Bind("DepartmentID") %>' DataSourceID="SqlDataSource3" DataTextField="DepartmentName" DataValueField="DepartmentID" AppendDataBoundItems="True">
                                    <asp:ListItem Selected="True" Value="-1">------------請選擇------------</asp:ListItem>
                                </asp:DropDownList>
                                <%--<asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("DepartmentID") %>' />--%>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="DropDownList1" ValidationGroup="InsertBook" ForeColor="Red" InitialValue="-1"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>職務 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="PositionTextBox" runat="server" Text='<%# Bind("Position") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="PositionTextBox" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>權限 ：</td>
                            <td>
                                <asp:DropDownList CssClass="form-control" ID="DropDownList_Role" runat="server" SelectedValue='<%# Bind("RoleID") %>' DataSourceID="SqlDataSource2" DataTextField="RoleName" DataValueField="RoleID" AppendDataBoundItems="True">
                                    <asp:ListItem Value="-1">------------請選擇------------</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="DropDownList_Role" ValidationGroup="InsertBook" ForeColor="Red" InitialValue="-1"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>身分證字號 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" Text='<%# Bind("identifier") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox3" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>姓名 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="NameTextBox" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>性別 ：</td>
                            <td>
                                <asp:DropDownList CssClass="form-control" ID="DropDownList_Gender" runat="server" SelectedValue='<%# Bind("Gender") %>'>
                                    <asp:ListItem Value="-1">------------請選擇------------</asp:ListItem>
                                    <asp:ListItem Value="Male">男</asp:ListItem>
                                    <asp:ListItem Value="FeMale">女</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="DropDownList_Gender" ValidationGroup="InsertBook" ForeColor="Red" InitialValue="-1"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>出生日期 ：</td>
                            <td>
                                <div class="input-group date" data-provide="datepicker" data-date-format="yyyy/mm/dd" style="width: 100%">
                                    <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" Text='<%# Bind("DateOfBirth","{0:yyyy/MM/dd}") %>' placeholder="yyyy/mm/dd" />
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-th"></span>
                                    </div>
                                    <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("DateOfBirth","{0:yyyy/MM/dd}") %>' />

                                </div>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox4" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>手機號碼 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" Text='<%# Bind("MobilePhoneNumber") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox5" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>分機號碼 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox6" runat="server" Text='<%# Bind("ExtensionNumber") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox6" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Email ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox7" runat="server" Text='<%# Bind("Email") %>' />
                            </td>
                            <td>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ValidationGroup="InsertBook" ControlToValidate="TextBox7" ValidateRequestMode="Inherit" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ForeColor="Red"></asp:RegularExpressionValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox7" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>地址 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox8" runat="server" Text='<%# Bind("Address") %>' />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox8" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>照片 ：</td>
                            <td>
                                <asp:Image ID="Image1" runat="server" Height="150" Width="120" />
                                <asp:FileUpload CssClass="form-control" ID="FileUpload1" runat="server" accept=".png,.jpg,.jpeg,.gif,.bmp" />
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>自我介紹 ：</td>
                            <td>
                                <asp:TextBox CssClass="form-control" ID="TextBox9" runat="server" Text='<%# Bind("Introduction") %>' ClientIDMode="Inherit" AutoPostBack="False" TextMode="MultiLine" />
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox9" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>到職日 ：</td>
                            <td>
                                <div class="input-group date" data-provide="datepicker" data-date-format="yyyy/mm/dd" style="width: 100%">
                                    <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("DutyDate","{0:yyyy/MM/dd}") %>' />
                                    <asp:TextBox CssClass="form-control" ID="TextBox10" runat="server" Text='<%# Bind("DutyDate","{0:yyyy/MM/dd}") %>' placeholder="yyyy/mm/dd" />
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-th"></span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ErrorMessage="*" Display="Dynamic" Font-Bold="True" ControlToValidate="TextBox10" ValidationGroup="InsertBook" ForeColor="Red"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn-group col-md-12" role="group" aria-label="Basic example">
                                    <asp:LinkButton CssClass="btn btn-success col-md-4" ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="更新" ValidationGroup="InsertBook" />
                                    <asp:LinkButton CssClass="btn btn-danger col-md-4" ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="刪除" OnClientClick="return confirm('確定要刪除嗎?');" />
                                    <asp:LinkButton CssClass="btn btn-warning col-md-4" ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </EditItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Entry9036 %>" SelectCommand="SELECT * FROM [Employees] WHERE ([EmployeeID] = @EmployeeID)">
            <SelectParameters>
                <asp:SessionParameter Name="EmployeeID" SessionField="EmployeeID" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:Entry9036 %>' SelectCommand="SELECT * FROM [Departments]"></asp:SqlDataSource>
        <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:Entry9036 %>' SelectCommand="SELECT * FROM [Roles]"></asp:SqlDataSource>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="scripts/bootstrap-filestyle.min.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $(function () {
            $(":file").filestyle({ buttonText: "" });
            $("#ContentPlaceHolder1_FormView1_TextBox4").datepicker();
            $("#ContentPlaceHolder1_FormView1_TextBox10").datepicker();
            $("#ContentPlaceHolder1_FormView1_TextBox4").datepicker("option", "dateFormat", "yy-mm-dd");
            $("#ContentPlaceHolder1_FormView1_TextBox10").datepicker("option", "dateFormat", "yy-mm-dd");
            var a = $("#ContentPlaceHolder1_FormView1_TextBox4").val().split('-');
            $("#ContentPlaceHolder1_FormView1_TextBox4").datepicker("setDate", new Date(a[0], a[1], a[2]));
            a = $("#ContentPlaceHolder1_FormView1_TextBox10").val().split('-');
            $("#ContentPlaceHolder1_FormView1_TextBox10").datepicker("setDate", new Date(a[0], a[1], a[2]));
        });
    </script>
</asp:Content>
