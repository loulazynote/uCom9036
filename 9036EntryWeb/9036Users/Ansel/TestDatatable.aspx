<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../vendor/jquery/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css" />
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
</head>
<body>
    <table id="table_id" class="display">
        <thead>
            <tr>
                <th>Column 1</th>
                <th>Column 2</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Row 1 Data 1</td>
                <td>Row 1 Data 2</td>
            </tr>
            <tr>
                <td>Row 2 Data 1</td>
                <td>Row 2 Data 2</td>
            </tr>
        </tbody>
    </table>

    <script>
        $(document).ready(function () {

            $.ajax({
                type: "POST",
                async: false,
                url: "http://localhost:17089/Ansel/WebService.asmx/GetConferenceInfo",
                data: null,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    
                    $('#table_id').DataTable({

                        columns: [
                            { data: 'Topic' },
                            { data: 'StartTime' },
                            { data: 'CreatedTime' },
                            { data: 'Creator' }
                           
                        ]

                    });
                }
            })

        });
        
    </script>

</body>
</html>
