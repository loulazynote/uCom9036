using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Tanner_ShowDetails : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Image Image1 = (Image)FormView1.FindControl("Image1");
            SqlConnection cn = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand("Select ProfilePicture From Employees Where EmployeeID = @EmployeeID", cn);
            cmd.Parameters.AddWithValue("@EmployeeID", Session["EmployeeID"]);
            cn.Open();
            if (!(cmd.ExecuteScalar() is DBNull))
            {
                var data = (byte[])cmd.ExecuteScalar();
                Image1.ImageUrl = "data:image;base64," + Convert.ToBase64String(data);

            }
        }
    }

    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/Tanner/Index.aspx");
        }
    }

}