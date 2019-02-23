using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MyEvent
/// </summary>
public class MyEvent
{
    public string title { get; set; }
    public string start { get; set; }
    public string end { get; set; }
    public string color { get; set; }
    public string id { get; set; }

}public class MyOrder
{
    public int SaleID { get; set; }
    public string SaleName { get; set; }
    public string OrderCounts { get; set; }
    public string Email { get; set; }
    public int OrderAmount { get; set; }

}
public class Progress
{
    public string CusName { get; set; }
    public string Development { get; set; }
    public string Step1 { get; set; }
    public string Step2 { get; set; }
    public string Step3 { get; set; }
    public string Step4 { get; set; }

}

