<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Group.aspx.cs" Inherits="Louis_Group" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.js"></script>
    <link href="/stylesheets/theme-custom.css" rel="stylesheet" />
    <style>
        .lightbox {
            width: 100% !important;
        }

        .ck-editor__editable {
            min-height: 200px;
        }

        .content_box {
            border: 1px dotted #4F4F4F;
            padding: 5px;
            margin: 5px;
            font-size: 15px;
            line-height: 150%;
            color: #353535;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
            width: 350px;
            display: block;
            font-size: 12px;
        }

        .grid-item {
            width: 20%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:LinkButton runat="server" ID="LinkButton1" class="btn btn-primary" data-toggle="modal" data-target="#lightbox-form">發表貼文</asp:LinkButton>
    <div id="lightbox-form" class="modal fade lightbox" hidden="hidden">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <asp:Label ID="Label1" runat="server" class="modal-title" Text=""></asp:Label>
                </div>
                <div class="modal-body">
                    <textarea id="editor" name="editor"></textarea>
                </div>
                <div class="modal-footer">
                    <asp:Button runat="server" class="btn btn-secondary" data-dismiss="modal" Text="取消" />
                    <asp:Button runat="server" ID="submit" class="btn btn-primary" Text="送出" OnClick="button_Click" />
                </div>
            </div>
        </div>
    </div>
    <div class='row box'>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="Repeater1_ItemDataBound">
                    <ItemTemplate>
                        <div class="content_box col-xs-12 col-sm-6 col-md-4">
                            <div class="panel panel-info">
                                <h3 class="panel-heading"><small class="text-muted">發表者：</small><%# Eval("name")%></h3>
                                <p><em><%# Eval("content")%></em></p>
                                <div class="input-group">
                                    <a href="#" class="pressid input-group-addon btn btn-danger"><i data-groupid="<%# Eval("ID")%>" class="far fa-hand-rock"><%# Eval("press")%></i></a>
                                    <input id="sub" class="sub_on form-control btn btn-warning" data-groupid="<%# Eval("ID")%>" type="button" value="On" />
                                </div>
                                <small class="text-muted"><%# Eval("time")%></small>
                            </div>
                            <asp:Repeater ID="Repeater2" runat="server">
                                <ItemTemplate>
                                    <div class="input-group">
                                        <h5 class="input-group-addon" id="sizing-addon2"><%# Eval("Name")%>
                                        </h5>
                                        <p class="form-control">
                                            <%# Eval("message1")%>
                                            <%--<small class="text-muted"><%# Eval("Datetime")%></small>--%>
                                        </p>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="submit" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <asp:HiddenField ID="HiddenField1" runat="server" />
    <asp:HiddenField ID="HiddenField2" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script src="//cdn.ckeditor.com/4.11.2/standard/ckeditor.js"></script>
    <script>
        $(function () {
            //瀑布流
            $('.box').masonry({
                itemSelector: '.content_box',
            });
        });
        //按讚功能
        var clk = 0;
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_pageLoaded(EndRequestHandler);
        function EndRequestHandler() {
            $(".pressid>i").click(function () {
                var count = $(this)[0];
                var Id = $(this).attr("data-groupid");

                switch (clk) {
                    case 0:
                        clk += 1;
                        $(this).attr("class", "fas fa-hand-rock");
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "/WebService.asmx/AddQuery",
                            data: JSON.stringify({
                                id: Id
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                $.ajax({
                                    type: "POST",
                                    async: false,
                                    url: "/WebService.asmx/ShowPress",
                                    data: JSON.stringify({
                                        id: Id
                                    }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {
                                        count.innerText = data.d;
                                    }
                                });
                            }
                        });
                        break;
                    default:
                        clk -= 1;
                        $(this).attr("class", "far fa-hand-rock");
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "/WebService.asmx/SubQuery",
                            data: JSON.stringify({
                                id: Id
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                $.ajax({
                                    type: "POST",
                                    async: false,
                                    url: "/WebService.asmx/ShowPress",
                                    data: JSON.stringify({
                                        id: Id
                                    }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {
                                        count.innerText = data.d;
                                    }
                                });
                            }
                        });
                        break;
                }
            });

        }

        //編輯器
        CKEDITOR.replace('editor');
        //編輯器取值
        $("#<%=submit.ClientID%>").click(function () {
            var content = CKEDITOR.instances.editor.getData();
            $("#<%=HiddenField1.ClientID%>").val(function getContent() {
                return content;
            })
        })

        //留言按鈕
        $(".sub_on").click(function () {
            var Id = $(this).attr("data-groupid");
            swal({
                input: 'textarea',
                inputPlaceholder: '你想說什麼呢？',
                confirmButtonText: "丟",
                showCancelButton: true,
                cancelButtonText: "掰",
                animation: true,
            }).then(
                function (result) {
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "/WebService.asmx/ShowMsg",
                        data: JSON.stringify({
                            id: Id, Msg: result
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            window.location.href = "/Louis/Group.aspx";
                        }
                    });
                });
        });
    </script>
</asp:Content>