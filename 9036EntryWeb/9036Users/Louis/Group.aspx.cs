using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Louis_Group : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Label1.Text = Session["UID"].ToString();

        if (!Page.IsPostBack)
        {
            DataBindEF();
        }
    }

    protected void button_Click(object sender, EventArgs e)
    {
        string name = Session["UID"].ToString();
        string content = HiddenField1.Value;
        string time = DateTime.Now.ToString();
        using (var db = new Entry9036Entities())
        {
            var block = db.Set<Community>();
            block.Add(new Community { Name = name, Content = content, Datetime = time, Press = 0 });
            db.SaveChanges();
        }
        DataBindEF();
    }

    public void DataBindEF()
    {
        Entry9036Entities db = new Entry9036Entities();
        var query = from c in db.Communities
                    orderby c.Id descending
                    select new
                    {
                        ID = c.Id,
                        name = c.Name,
                        content = c.Content,
                        time = c.Datetime,
                        press = c.Press
                    };
        var result = query.ToList();
        Repeater1.ItemDataBound += new RepeaterItemEventHandler(Repeater1_ItemDataBound);
        Repeater1.DataSource = result;
        Repeater1.DataBind();
    }

    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        Entry9036Entities db = new Entry9036Entities();
        int CID = ((dynamic)e.Item.DataItem).ID;
        var query = from m in db.Messages
                    join c in db.Communities on m.Id equals c.Id
                    where m.Id == CID
                    orderby m.MId descending
                    select new
                    {
                        m.MId,
                        m.Name,
                        m.message1,
                        m.Id,
                        m.Datetime
                    };

        var result = query.ToList();
        var a = e.Item.FindControl("Repeater2") as Repeater;
        a.DataSource = result;
        a.DataBind();
    }
}