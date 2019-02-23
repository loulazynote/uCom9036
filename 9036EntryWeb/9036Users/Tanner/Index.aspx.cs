using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Tanner_Index : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //role
            if (Session["Level"].ToString() != "1")
            {
                Button_Insert.Visible = false;
                Button2.Visible = true;
            }
            //Databind
            ViewState["SortExpression"] = string.Empty;
            ViewState["SortDirection"] = string.Empty;
            ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
            ListView1.DataBind();
            ShowPics();
        }

    }
    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //set current page startindex, max rows and rebind to false
        lvDataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        //rebind List View
        ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
        ListView1.DataBind();
        ShowPics();
    }
    protected void ListView1_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "ShowDetails")
        {
            //將EmployeeID存入Session
            Session["EmployeeID"] = e.CommandArgument.ToString();
            Response.Redirect("~/Tanner/ShowDetails.aspx");
        }
        if (e.CommandName == "Edit")
        {
            //將EmployeeID存入Session
            Session["EmployeeID"] = e.CommandArgument.ToString();
            Response.Redirect("~/Tanner/Edit.aspx");
        }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        //Query
        HiddenField_DataSource.Value = DropDownList1.SelectedValue;
        ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
        ListView1.DataBind();
        ShowPics();
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //清空TextBox
        TextBox1.Text = "";
        switch (DropDownList1.SelectedValue)
        {

            case "Position":
            case "Name":
            case "MobilePhoneNumber":
            case "ExtensionNumber":
            case "Email":
                TextBox1.Visible = true;
                DropDownList_Gender.Visible = false;
                DropDownList_Department.Visible = false;
                break;
            case "DepartmentID":
                TextBox1.Visible = false;
                DropDownList_Gender.Visible = false;
                DropDownList_Department.Visible = true;
                break;
            case "Gender":
                TextBox1.Visible = false;
                DropDownList_Gender.Visible = true;
                DropDownList_Department.Visible = false;
                break;
            default:
                break;
        }
    }

    protected void Button_CanelQuery_Click(object sender, EventArgs e)
    {
        HiddenField_DataSource.Value = "";
        ViewState["SortExpression"] = string.Empty;
        ViewState["SortDirection"] = string.Empty;
        ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
        ListView1.DataBind();
        ShowPics();
    }

    private void ShowPics()
    {
        foreach (var item in ListView1.Items)
        {
            Image Image1 = (Image)item.FindControl("Image1");
            Button Button_Edit = (Button)item.FindControl("EditButton");
            if (Session["Level"].ToString() != "1")
            {
                Button_Edit.Visible = false;
            }

            HiddenField hiddenField1 = (HiddenField)item.FindControl("HiddenField1");

            SqlConnection cn = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand("Select ProfilePicture From Employees Where EmployeeID = @EmployeeID", cn);
            cmd.Parameters.AddWithValue("@EmployeeID", hiddenField1.Value);
            cn.Open();
            if (!(cmd.ExecuteScalar() is DBNull))
            {
                var data = (byte[])cmd.ExecuteScalar();
                Image1.ImageUrl = "data:image;base64," + Convert.ToBase64String(data);

            }
        }
    }

    private class EwithD
    {
        public string EmployeeID { get; set; }
        public string Password { get; set; }
        public Nullable<int> DepartmentID { get; set; }
        public string Position { get; set; }
        public Nullable<int> RoleID { get; set; }
        public string identifier { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public Nullable<System.DateTime> DateOfBirth { get; set; }
        public string MobilePhoneNumber { get; set; }
        public string ExtensionNumber { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public byte[] ProfilePicture { get; set; }
        public string Introduction { get; set; }
        public Nullable<System.DateTime> DutyDate { get; set; }
        public int State { get; set; }
        public string DepartmentName { get; set; }
    }
    private IQueryable<EwithD> Query()
    {
        Entry9036Entities db = new Entry9036Entities();
        var query = db.Employees.Join(db.Departments, s => s.DepartmentID, n => n.DepartmentID,
            (s, n) => new EwithD
            {
                EmployeeID = s.EmployeeID,
                DepartmentID = s.DepartmentID,
                DepartmentName = n.DepartmentName,
                Position = s.Position,
                Name = s.Name,
                Gender = s.Gender,
                DateOfBirth = s.DateOfBirth,
                MobilePhoneNumber = s.MobilePhoneNumber,
                ExtensionNumber = s.ExtensionNumber,
                Email = s.Email,
            });
        return query;
    }
    private List<EwithD> DataList(string data, string SortExpression, string SortDirection)
    {
        ////List<EwithD> DataSource;
        IQueryable<EwithD> query;
        switch (data)
        {
            case "DepartmentID":
                query = Query().Where(p => p.DepartmentID.ToString() == DropDownList_Department.SelectedValue);
                break;
            case "Position":
                query = Query().Where(p => p.Position.ToString().Contains(TextBox1.Text));
                break;
            case "Name":
                query = Query().Where(p => p.Name.ToString().Contains(TextBox1.Text));
                break;
            case "Gender":
                query = Query().Where(p => p.Gender.ToString() == DropDownList_Gender.SelectedValue);
                break;
            case "MobilePhoneNumber":
                query = Query().Where(p => p.MobilePhoneNumber.ToString().Contains(TextBox1.Text));
                break;
            case "ExtensionNumber":
                query = Query().Where(p => p.ExtensionNumber.ToString().Contains(TextBox1.Text));
                break;
            case "Email":
                query = Query().Where(p => p.Email.ToString().Contains(TextBox1.Text));
                break;
            default:
                query = Query();
                break;
        }
        if (SortDirection == "Ascending")
        {
            switch (SortExpression)
            {
                case "DepartmentName":
                    query = query.OrderBy(e => e.DepartmentName);
                    break;
                case "Position":
                    query = query.OrderBy(e => e.Position);
                    break;
                case "Name":
                    query = query.OrderBy(e => e.Name);
                    break;
                case "Gender":
                    query = query.OrderBy(e => e.Gender);
                    break;
                case "DateOfBirth":
                    query = query.OrderBy(e => e.DateOfBirth);
                    break;
                case "MobilePhoneNumber":
                    query = query.OrderBy(e => e.MobilePhoneNumber);
                    break;
                case "ExtensionNumber":
                    query = query.OrderBy(e => e.ExtensionNumber);
                    break;
                case "Email":
                    query = query.OrderBy(e => e.Email);
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (SortExpression)
            {
                case "DepartmentName":
                    query = query.OrderByDescending(e => e.DepartmentName);
                    break;
                case "Position":
                    query = query.OrderByDescending(e => e.Position);
                    break;
                case "Name":
                    query = query.OrderByDescending(e => e.Name);
                    break;
                case "Gender":
                    query = query.OrderByDescending(e => e.Gender);
                    break;
                case "DateOfBirth":
                    query = query.OrderByDescending(e => e.DateOfBirth);
                    break;
                case "MobilePhoneNumber":
                    query = query.OrderByDescending(e => e.MobilePhoneNumber);
                    break;
                case "ExtensionNumber":
                    query = query.OrderByDescending(e => e.ExtensionNumber);
                    break;
                case "Email":
                    query = query.OrderByDescending(e => e.Email);
                    break;
                default:
                    break;
            }
        }
        return query.ToList();
    }

    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        lvDataPager1.PageSize = int.Parse(DropDownList2.SelectedValue);
        ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
        ListView1.DataBind();
        ShowPics();
    }

    protected void Button_Insert_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Tanner/Insert.aspx");
    }

    protected void ListView1_Sorting(object sender, ListViewSortEventArgs e)
    {
        if (ViewState["SortExpression"].ToString() != e.SortExpression.ToString())
        {
            ViewState["SortExpression"] = e.SortExpression;
            ViewState["SortDirection"] = e.SortDirection;
        }
        else
        {
            ViewState["SortDirection"] = ViewState["SortDirection"].ToString() == SortDirection.Ascending.ToString() ? SortDirection.Descending : SortDirection.Ascending;
        }

        ListView1.DataSource = DataList(HiddenField_DataSource.Value, ViewState["SortExpression"].ToString(), ViewState["SortDirection"].ToString());
        ListView1.DataBind();
        ShowPics();
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        Session["EmployeeID"] = Session["EID"];
        Response.Redirect("~/Tanner/Edit.aspx");
    }
}