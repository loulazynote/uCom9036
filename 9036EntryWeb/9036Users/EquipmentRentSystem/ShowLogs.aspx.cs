using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class EquipmentRentSystem_ShowLogs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Level"].ToString() != "1")
            {
                HyperLink3.Visible = false;
                HyperLink4.Visible = false;
                HyperLink5.Visible = false;
            }
            
        }
    }
}