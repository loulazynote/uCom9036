using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Tanner_Edit : System.Web.UI.Page
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

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            FileUpload FileUpload1 = (FileUpload)FormView1.FindControl("FileUpload1");
            string sqlstring = "";
            if (FileUpload1.HasFiles)
            {
                sqlstring = "UPDATE Employees SET Password =@Password ,DepartmentID = @DepartmentID," +
                "Position=@Position, RoleID=@RoleID ,identifier=@identifier,Name=@Name," +
                "Gender=@Gender,DateOfBirth=@DateOfBirth,MobilePhoneNumber=@MobilePhoneNumber," +
                "ExtensionNumber=@ExtensionNumber,Email=@Email,Address=@Address," +
                "ProfilePicture=@ProfilePicture,Introduction=@Introduction,DutyDate=@DutyDate" +
                " WHERE EmployeeID = @EmployeeID";
            }
            else
            {
                sqlstring = "UPDATE Employees SET Password =@Password ,DepartmentID = @DepartmentID," +
                "Position=@Position, RoleID=@RoleID ,identifier=@identifier,Name=@Name," +
                "Gender=@Gender,DateOfBirth=@DateOfBirth,MobilePhoneNumber=@MobilePhoneNumber," +
                "ExtensionNumber=@ExtensionNumber,Email=@Email,Address=@Address," +
                "Introduction=@Introduction,DutyDate=@DutyDate" +
                " WHERE EmployeeID = @EmployeeID";
            }
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@EmployeeID", e.Keys[0]);
            cmd.Parameters.AddWithValue("@Password", e.NewValues[0]);
            cmd.Parameters.AddWithValue("@DepartmentID", e.NewValues[1]);
            cmd.Parameters.AddWithValue("@Position", e.NewValues[2]);
            cmd.Parameters.AddWithValue("@RoleID", e.NewValues[3]);
            cmd.Parameters.AddWithValue("@identifier", e.NewValues[4]);
            cmd.Parameters.AddWithValue("@Name", e.NewValues[5]);
            cmd.Parameters.AddWithValue("@Gender", e.NewValues[6]);
            cmd.Parameters.AddWithValue("@DateOfBirth", e.NewValues[7]);
            cmd.Parameters.AddWithValue("@MobilePhoneNumber", e.NewValues[8]);
            cmd.Parameters.AddWithValue("@ExtensionNumber", e.NewValues[9]);
            cmd.Parameters.AddWithValue("@Email", e.NewValues[10]);
            cmd.Parameters.AddWithValue("@Address", e.NewValues[11]);
            if (FileUpload1.HasFiles)
            {
                cmd.Parameters.AddWithValue("@ProfilePicture", FileUpload1.FileBytes);
            }
            cmd.Parameters.AddWithValue("@Introduction", e.NewValues[12]);
            cmd.Parameters.AddWithValue("@DutyDate", e.NewValues[13]);
            cn.Open();
            cmd.ExecuteNonQuery();
            Response.Redirect("~/Tanner/Index.aspx");
        }
    }

    protected void FormView1_ItemDeleting(object sender, FormViewDeleteEventArgs e)
    {
        Response.Write(e.Keys[0]);
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM Employees WHERE (EmployeeID = @EmployeeID)", cn);
            cmd.Parameters.AddWithValue("@EmployeeID", e.Keys[0]);
            cn.Open();
            cmd.ExecuteNonQuery();
            Response.Redirect("~/Tanner/Index.aspx");
        }
    }
}