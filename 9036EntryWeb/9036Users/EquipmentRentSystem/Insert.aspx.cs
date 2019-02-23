using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class EquipmentRentSystem_Insert : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FileUpload FileUpload1 = (FileUpload)FormView1.FindControl("FileUpload1");
        DropDownList DropDownList1 = (DropDownList)FormView1.FindControl("DropDownList1");
        DropDownList DropDownList2 = (DropDownList)FormView1.FindControl("DropDownList2");
        TextBox TextBox1 = (TextBox)FormView1.FindControl("Quantity_TextBox");
        using (SqlConnection cn = new SqlConnection(connectionString))
        {

            string sqlstring = "INSERT INTO Equipments (EquipmentTypeID,EquipmentName,EquipmentDescription,EquipmentLife,EquipmentImage) " +
               "VALUES(@EquipmentTypeID,@EquipmentName,@EquipmentDescription,@EquipmentLife,@EquipmentImage)";
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@EquipmentTypeID", e.Values[0]);
            cmd.Parameters.AddWithValue("EquipmentName", e.Values[1]);
            cmd.Parameters.AddWithValue("@EquipmentDescription", e.Values[2]);
            cmd.Parameters.AddWithValue("@EquipmentLife", DropDownList1.SelectedValue.ToString() + "," + DropDownList2.SelectedValue.ToString());
            cmd.Parameters.AddWithValue("@EquipmentImage", FileUpload1.FileBytes);
            cn.Open();
            for (int i = 0; i < int.Parse(TextBox1.Text); i++)
            {
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("~/EquipmentRentSystem/Condition.aspx");
        }



    }

    protected void FormView1_ItemCommand(object sender, FormViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            Response.Redirect("~/EquipmentRentSystem/Index.aspx");
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        TextBox TextBox1 = (TextBox)FormView1.FindControl("TextBox1");
        TextBox1.Text = "羅技滑鼠";
        TextBox TextBox2 = (TextBox)FormView1.FindControl("TextBox2");
        TextBox2.Text = "@羅技滑鼠@mx-master-2s";
        TextBox TextBox3 = (TextBox)FormView1.FindControl("Quantity_TextBox");
        TextBox3.Text = "2";
    }
}