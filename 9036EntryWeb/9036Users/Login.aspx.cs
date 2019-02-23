using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString);
        //SqlCommand cmd = new SqlCommand("Select * From Employees Where EmployeeID=@UID And Password=@PWD", cn);
        SqlCommand cmd = cn.CreateCommand();
        SqlDataReader dr = null;
        //cmd.CommandText = "Select * From Employees Where EmployeeID=@UID And Password=@PWD";
        cmd.CommandText = "Select e1.*,e2.* From Employees e1 Join Roles e2 On e1.RoleID = e2.RoleID where e1.EmployeeID = @UID And e1.Password = @PWD";
        cmd.Parameters.AddWithValue("@UID", TextBox1.Text);
        cmd.Parameters.AddWithValue("@PWD", TextBox2.Text);
        cn.Open();
        dr = cmd.ExecuteReader();

        if (dr.Read())
        {
            Session["EID"] = dr[0];
            Session["ID"] = dr[0];
            Session["Level"] = dr[4];
            Session["RName"] = dr[18];
            Session["UID"] = dr[6];
            Session["Mail"] = dr[11];
            Session["Gender"] = dr[7];

            #region 亂數驗證

            if (TextBox3.Text.ToUpper().Trim() == Session["RenderText"].ToString().Trim() && Page.IsValid)
            {
                int Level = (int)Session["Level"];
                if (Level == 1)
                {
                    FormsAuthentication.SetAuthCookie(TextBox1.Text, false);
                    Response.Redirect("~/Joshua/Bulletin_MasterPage.aspx");
                }
                else
                {
                    FormsAuthentication.SetAuthCookie(TextBox1.Text, false);
                    Response.Redirect("~/Joshua/Bulletin_MasterPage_user.aspx");
                }
            }
            else
            {
                HiddenField1.Value = "2";
            }

            #endregion 亂數驗證
        }
        else
            HiddenField1.Value = "1";

        dr.Close();
        cn.Close();
    }
}