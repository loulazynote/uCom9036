<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    
    protected void Button1_Click(object sender, EventArgs e)
    {
        var db = new Entry9036Entities();
        string cusname = TextBox1.Text;
        string cusphone = TextBox2.Text;
        string email = TextBox3.Text;
        Customer r = new Customer();
        r.CusName = cusname;
        r.Phone = cusphone;
        r.Email = email;
        db.Customers.Add(r);
        db.SaveChanges();//產生SQL

        Response.Redirect("~/ChangEn/NewCusAdminMaster.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="scripts/sweet/sweetalert2.css" rel="stylesheet" />
    <link href="stylesheets/MyStyleSheet.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <div class="container">
       
            <h1 style="font-family:Microsoft JhengHei;" class="text-center"><B>新增客戶</B></h1>
            <br />
            <div class="form-group">
                <asp:Label Font-Size="Medium" Font-Bold="True" ID="Label1" runat="server" Text="Label">客戶姓名:</asp:Label>
                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="不可為空白" ForeColor="#FF5050"></asp:RequiredFieldValidator>
                
            <div class="form-group">
                
                <asp:Label Font-Size="Medium" Font-Bold="True" ID="Label2" runat="server" Text="Label">手機:</asp:Label>
                <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server"></asp:TextBox>

            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="不可為空白" ForeColor="#FF5050"></asp:RequiredFieldValidator>
                
            <div class="form-group">
                <asp:Label Font-Size="Medium" Font-Bold="True" ID="Label3" runat="server" Text="Label">E-Mail:</asp:Label>
                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBox3" ErrorMessage="不可為空白" ForeColor="#FF5050"></asp:RequiredFieldValidator>
                <br />
            <asp:Button CssClass="btn btn-facebook" ID="Button1" runat="server" Text="新增" OnClick="Button1_Click" />
            <%--<asp:Button CssClass="btn btn-danger" ID="Button2" runat="server" Text="返回" CommandName="cancel" OnClick="Button2_Click" />--%>
            <input id="Button2" type="button" value="返回" class="btn btn-gplus" />
      
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">

    <script>
        
 
            $(function () {

                $("#Button2").click(function () {
                    swal({
                        title: '確認?',
                        text: "停止新增，返回上一頁",
                        type: 'warning',
                        showCancelButton: true,
                    }).then(
                        function () {
                            swal('即將返回上一頁!', '', 'success').then(function () {
                                window.location.href = "NewCusAdminMaster.aspx";
                            })
                        },
                        function (dismiss) {
                            if (dismiss === 'cancel') {
                                swal('已取消', '請繼續新增資料', 'success')
                            }

                        });

                });
            });
           
    </script>
</asp:Content>

