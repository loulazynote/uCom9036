using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UID"]==null|| Session["RName"]==null||Session["ID"]==null||Session["RName"]==null|| Session["Level"]==null|| Session["Gender"]==null)
        {
            Response.Redirect("~/Login.aspx");
        }
        Label1.Text = Session["UID"].ToString();
        Label2.Text = Session["RName"].ToString();
        HiddenField1.Value = Session["Level"].ToString();
        HiddenField2.Value = Session["Gender"].ToString();
        HiddenField3.Value = Session["EID"].ToString();
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
        Session["UID"] = null;
        FormsAuthentication.SignOut();
        Response.Redirect("~/Login.aspx");
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("#");
    }

    public class Userbox
    {
        public int RoleID { get; set; }
        public string RoleName { get; set; }
    }
}