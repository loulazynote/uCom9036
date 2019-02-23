<%@ Application Language="C#" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

    protected void Application_AuthenticateRequest(object sender, EventArgs e)
    {
        if (Context.User != null)
        {
            //劃分權限
            string role = GetUserRoles();
            if (role != null)
            {
                Context.User = new GenericPrincipal(User.Identity, role.Split(char.Parse(",")));
            }
        }
    }


    private string GetUserRoles()
    {

        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Select roles From SignUp Where email=@email", cn);
        cmd.Parameters.AddWithValue("@email", User.Identity.Name);

        cn.Open();
        object data = cmd.ExecuteScalar();

        cn.Close();
        if (data == null)
        {
            return "";
        }
        else
        {
            string roles  =data.ToString();
            return roles;
        }


    }

</script>
