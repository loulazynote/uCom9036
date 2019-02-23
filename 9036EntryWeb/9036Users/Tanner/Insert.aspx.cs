using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class Tanner_Insert : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Entry9036Entities db = new Entry9036Entities();
            FormView1.DataSource = db.Employees.Select(a => a).ToList();
            FormView1.DataBind();
        }
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            FileUpload FileUpload1 = (FileUpload)FormView1.FindControl("FileUpload1");
            string sqlstring = "";
            if (FileUpload1.HasFiles)
            {
                sqlstring = "INSERT INTO Employees (EmployeeID,Password,DepartmentID,Position,RoleID,identifier,Name,Gender,DateOfBirth,MobilePhoneNumber,ExtensionNumber,Email,Address,ProfilePicture,Introduction,DutyDate) " +
                "VALUES(@EmployeeID,@Password,@DepartmentID,@Position,@RoleID,@identifier,@Name,@Gender,@DateOfBirth,@MobilePhoneNumber,@ExtensionNumber,@Email,@Address,@ProfilePicture,@Introduction,@DutyDate)";
            }
            else
            {
                sqlstring = "INSERT INTO Employees (EmployeeID,Password,DepartmentID,Position,RoleID,identifier,Name,Gender,DateOfBirth,MobilePhoneNumber,ExtensionNumber,Email,Address,Introduction,DutyDate) " +
                               "VALUES(@EmployeeID,@Password,@DepartmentID,@Position,@RoleID,@identifier,@Name,@Gender,@DateOfBirth,@MobilePhoneNumber,@ExtensionNumber,@Email,@Address,@Introduction,@DutyDate)";
            }
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@EmployeeID", e.Values[0]);
            cmd.Parameters.AddWithValue("@Password", e.Values[1]);
            cmd.Parameters.AddWithValue("@DepartmentID", e.Values[2]);
            cmd.Parameters.AddWithValue("@Position", e.Values[3]);
            cmd.Parameters.AddWithValue("@RoleID", e.Values[4]);
            cmd.Parameters.AddWithValue("@identifier", e.Values[5]);
            cmd.Parameters.AddWithValue("@Name", e.Values[6]);
            cmd.Parameters.AddWithValue("@Gender", e.Values[7]);
            cmd.Parameters.AddWithValue("@DateOfBirth", e.Values[8]);
            cmd.Parameters.AddWithValue("@MobilePhoneNumber", e.Values[9]);
            cmd.Parameters.AddWithValue("@ExtensionNumber", e.Values[10]);
            cmd.Parameters.AddWithValue("@Email", e.Values[11]);
            cmd.Parameters.AddWithValue("@Address", e.Values[12]);
            if (FileUpload1.HasFiles)
            {
                cmd.Parameters.AddWithValue("@ProfilePicture", FileUpload1.FileBytes);
            }
            cmd.Parameters.AddWithValue("@Introduction", e.Values[13]);
            cmd.Parameters.AddWithValue("@DutyDate", e.Values[14]);
            cn.Open();
            cmd.ExecuteNonQuery();
            Response.Redirect("~/Tanner/Index.aspx");
        }
        //FileUpload FileUpload1 = (FileUpload)FormView1.FindControl("FileUpload1");

        //Entry9036Entities db = new Entry9036Entities();

        //Employee employee = new Employee()
        //{
        //    EmployeeID = e.Values[0].ToString(),
        //    Password = e.Values[1].ToString(),
        //    DepartmentID = Convert.ToInt32(e.Values[2]),
        //    Position = e.Values[3].ToString(),
        //    RoleID = Convert.ToInt32(e.Values[4]),
        //    identifier = e.Values[5].ToString(),
        //    Name = e.Values[6].ToString(),
        //    Gender = e.Values[7].ToString(),
        //    DateOfBirth = Convert.ToDateTime(e.Values[8]),
        //    MobilePhoneNumber = e.Values[9].ToString(),
        //    ExtensionNumber = e.Values[10].ToString(),
        //    Email = e.Values[11].ToString(),
        //    Address = e.Values[12].ToString(),
        //    //ProfilePicture = 13
        //    ProfilePicture = FileUpload1.FileBytes,
        //    Introduction = e.Values[13].ToString(),
        //    DutyDate = Convert.ToDateTime(e.Values[14])
        //};

        //db.Employees.Add(employee);
        //try
        //{
        //    db.SaveChanges();
        //}
        //catch (DbEntityValidationException ex)
        //{
        //    var entityError = ex.EntityValidationErrors.SelectMany(x => x.ValidationErrors).Select(x => x.ErrorMessage);
        //    var getFullMessage = string.Join("; ", entityError);
        //    var exceptionMessage = string.Concat(ex.Message, "errors are: ", getFullMessage);
        //}
        //Response.Redirect("~/default.aspx");
    }


    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/Tanner/Index.aspx");
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        TextBox TextBox1 = (TextBox)FormView1.FindControl("EmployeeIDLabel1");
        TextBox1.Text = "Demo001";
        DropDownList department = (DropDownList)FormView1.FindControl("DropDownList1");
        department.SelectedIndex = 2;
        TextBox TextBox2 = (TextBox)FormView1.FindControl("PositionTextBox");
        TextBox2.Text = "檢測員";
        DropDownList DropDownList_Role = (DropDownList)FormView1.FindControl("DropDownList_Role");
        DropDownList_Role.SelectedIndex = 3;
        TextBox TextBox3 = (TextBox)FormView1.FindControl("TextBox3");
        TextBox3.Text = "E126589761";
        TextBox NameTextBox = (TextBox)FormView1.FindControl("NameTextBox");
        NameTextBox.Text = "彭祥深";
        DropDownList DropDownList_Gender = (DropDownList)FormView1.FindControl("DropDownList_Gender");
        DropDownList_Gender.SelectedIndex = 1;
        TextBox TextBox4 = (TextBox)FormView1.FindControl("TextBox4");
        TextBox4.Text = "1983-05-26";
        TextBox TextBox5 = (TextBox)FormView1.FindControl("TextBox5");
        TextBox5.Text = "0929833888";
        TextBox TextBox6 = (TextBox)FormView1.FindControl("TextBox6");
        TextBox6.Text = "5252";
        TextBox TextBox7 = (TextBox)FormView1.FindControl("TextBox7");
        TextBox7.Text = "handi83111@gmail.com";
        TextBox TextBox8 = (TextBox)FormView1.FindControl("TextBox8");
        TextBox8.Text = "雲林縣斗六市";
        TextBox TextBox9 = (TextBox)FormView1.FindControl("TextBox9");
        TextBox9.Text = "大家好!";
        TextBox TextBox10 = (TextBox)FormView1.FindControl("TextBox10");
        TextBox10.Text = "2019-02-21";
        
    }
}