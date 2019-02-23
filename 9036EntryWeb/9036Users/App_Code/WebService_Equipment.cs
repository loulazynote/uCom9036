using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;


/// <summary>
/// Summary description for WebService_Equipment
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService_Equipment : System.Web.Services.WebService
{
    string connectionString = ConfigurationManager.ConnectionStrings["Entry9036"].ConnectionString;
    public WebService_Equipment()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public List<EquipmentCondition> GetEquipmentCondition()
    {
        Entry9036Entities db = new Entry9036Entities();
        var query = db.Equipments.Join(db.EquipmentTypes, s => s.EquipmentTypeID, n => n.EquipmentTypeID,
    (s, n) => new EquipmentCondition
    {
        EquipmentID = s.EquipmentID,
        EquipmentName = s.EquipmentName,
        EquipmentTypeName = n.EquipmentTypeName,
        EquipmentDescription = s.EquipmentDescription,
        Reason = s.Reason,
        State = s.State,
        EquipmentLife = s.EquipmentLife

    });

        return query.ToList();
    }
    [WebMethod]
    //刪除Logs
    public void DeleteLogs(string logid)
    {
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM EquipmentRentLogs WHERE (LogsId = @LogsId)", cn);
            cmd.Parameters.AddWithValue("@LogsId", logid);
            cn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    [WebMethod]
    //日期更改
    public void ChangeDate(string sd, string ed, string logid)
    {
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            string sqlstring = "UPDATE EquipmentRentLogs SET StartDate =@StartDate,EndDate=@EndDate" +
               " WHERE LogsId = @LogsId";
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@StartDate", sd);
            cmd.Parameters.AddWithValue("@EndDate", ed);
            cmd.Parameters.AddWithValue("@LogsId", logid);
            cn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    [WebMethod]
    //報銷狀態更改
    public void ChangeState(string id,string r)
    {
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            string sqlstring = "UPDATE Equipments SET State =@State,Reason=@Reason" +
               " WHERE EquipmentID = @EquipmentID";
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@EquipmentID", id);
            cmd.Parameters.AddWithValue("@State", 1);
            cmd.Parameters.AddWithValue("@Reason", r);
            cn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    [WebMethod]
    //租借器材
    public void Rented(string StartDate, string EndDate, string EquipmentID, string EmployeeID,string EquipmentName)
    {
        Entry9036Entities db = new Entry9036Entities();
        string email = db.Employees.Where(p => p.EmployeeID == EmployeeID).Select(p => p.Email).ToList()[0].ToString();
        string title = $"您在租借管理系統租借了-{EquipmentName}({EquipmentID})";
        string msgBody = $"您在器材租借管理系統租借了-{EquipmentName}({EquipmentID})-租借期限為{StartDate}至{EndDate}-,請於期限內歸還。";
        using (SqlConnection cn = new SqlConnection(connectionString))
        {
            string sqlstring = "INSERT INTO EquipmentRentLogs (EquipmentID,StartDate,EndDate,EmployeeID) " +
               "VALUES(@EquipmentID,@StartDate,@EndDate,@EmployeeID)";
            SqlCommand cmd = new SqlCommand(sqlstring, cn);
            cmd.Parameters.AddWithValue("@EquipmentID", EquipmentID);
            cmd.Parameters.AddWithValue("@StartDate", StartDate);
            cmd.Parameters.AddWithValue("@EndDate", EndDate);
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID);
            cn.Open();
            cmd.ExecuteNonQuery();
        }
        var MailAlert = new MailAlert();
        MailAlert.SendMail(email, title, msgBody);


    }

    [WebMethod]
    public List<EquipmentByTypeID> GetEquipmentByTypeID(int typeid)
    {
        Entry9036Entities db = new Entry9036Entities();


        if (typeid == 0)
        {
            var query = db.Equipments.Select(p => new EquipmentByTypeID()
            {
                EquipmentName = p.EquipmentName,
                EquipmentID = p.EquipmentID,
                State = p.State
            });
            return query.ToList();
        }
        else
        {
            var query = db.Equipments.
                Where(p => p.EquipmentTypeID == typeid).
                Select(p => new EquipmentByTypeID()
                {
                    EquipmentName = p.EquipmentName,
                    EquipmentID = p.EquipmentID,
                    State = p.State
                });
            return query.ToList();
        }

    }

    [WebMethod]
    public List<EquipmentInfoByID> GetEquipmentinfoByID(int EquipID)
    {
        Entry9036Entities db = new Entry9036Entities();
        var query1 = db.Equipments.Where(p => p.EquipmentID == EquipID).ToList();
        if (query1[0].State == 1)
        {
            var query2 = query1.Select(p => new EquipmentInfoByID()
            {
                EquipmentID = p.EquipmentID,
                EquipmentName = p.EquipmentName,
                EquipmentDescription = p.EquipmentDescription,
                DepartmentName = "",
                Reason = p.Reason,
                RentedState = 0,
                State = 1,
                EmployeeID = "",
                ImageUrl = "data:image;base64," + Convert.ToBase64String(p.EquipmentImage)
            });
            return query2.ToList();
        }
        else
        {
            int RentedState = 0;
            string EmployeeID = "";
            string DepartmentName = "";
            //判斷是否被租借
            var query2 = db.EquipmentRentLogs.Where(p => p.EquipmentID == EquipID).ToList();
            foreach (var item in query2)
            {
                var StartDate = item.StartDate;
                var EndDate = item.EndDate;
                var NowDate = DateTime.Now;
                if (DateTime.Compare(StartDate, NowDate) < 0 && DateTime.Compare(EndDate, NowDate) > 0)
                {
                    RentedState = 1;
                    EmployeeID = item.EmployeeID;
                    var query3 = db.Employees.Where(p => p.EmployeeID == EmployeeID).Join(db.Departments, e => e.DepartmentID, d => d.DepartmentID, (e, d) => new
                    {
                        DepartmentName = d.DepartmentName
                    }).ToList();
                    DepartmentName = query3[0].DepartmentName;
                }
            }
            var query4 = query1.Select(p => new EquipmentInfoByID()
            {
                EquipmentID = p.EquipmentID,
                EquipmentName = p.EquipmentName,
                EquipmentDescription = p.EquipmentDescription,
                DepartmentName = DepartmentName,
                Reason = p.Reason,
                RentedState = RentedState,
                State = 0,
                ImageUrl = "data:image;base64," + Convert.ToBase64String(p.EquipmentImage),
                EmployeeID = EmployeeID
            });
            return query4.ToList();
        }
    }
    [WebMethod]
    public List<EventLogs> GetEvent(int EquipmentID)
    {
        Entry9036Entities db = new Entry9036Entities();
        var query1 = db.EquipmentRentLogs.Where(p => p.EquipmentID == EquipmentID).Join(db.Employees, l => l.EmployeeID, emp => emp.EmployeeID, (l, emp) => new { l, emp }).
                Join(db.Departments, combinedEntry => combinedEntry.emp.DepartmentID, d => d.DepartmentID, (combinedEntry, d) => new { combinedEntry, d }).
                Join(db.Equipments, combinedEntry => combinedEntry.combinedEntry.l.EquipmentID, equip => equip.EquipmentID, (combinedEntry, equip) => new
                {
                    EventID = combinedEntry.combinedEntry.l.LogsId,
                    Name = combinedEntry.combinedEntry.emp.Name,
                    DepartmentName = combinedEntry.d.DepartmentName,
                    StartDate = combinedEntry.combinedEntry.l.StartDate,
                    EndDate = combinedEntry.combinedEntry.l.EndDate,
                    EquipmentName = equip.EquipmentName,
                    EquipmentID = combinedEntry.combinedEntry.l.EquipmentID,
                    EquipmentDescription = equip.EquipmentDescription
                }).ToList();
        var query2 = query1.Select(p => new EventLogs
        {
            EventID = p.EventID,
            Name = p.Name,
            DepartmentName = p.DepartmentName,
            StartDate = p.StartDate.ToString("yyyy-MM-dd"),
            EndDate = p.EndDate.ToString("yyyy-MM-dd"),
            EquipmentID = p.EquipmentID,
            EquipmentName = p.EquipmentName,
            EquipmentDescription = p.EquipmentDescription
        });
        return query2.ToList();
    }
    [WebMethod]
    public List<EventLogs> GetAllEvent()
    {
        Entry9036Entities db = new Entry9036Entities();
        var query1 = db.EquipmentRentLogs.Join(db.Employees, l => l.EmployeeID, emp => emp.EmployeeID, (l, emp) => new { l, emp }).
                Join(db.Departments, combinedEntry => combinedEntry.emp.DepartmentID, d => d.DepartmentID, (combinedEntry, d) => new { combinedEntry, d }).
                Join(db.Equipments, combinedEntry => combinedEntry.combinedEntry.l.EquipmentID, equip => equip.EquipmentID, (combinedEntry, equip) => new
                {
                    EventID = combinedEntry.combinedEntry.l.LogsId,
                    Name = combinedEntry.combinedEntry.emp.Name,
                    DepartmentName = combinedEntry.d.DepartmentName,
                    StartDate = combinedEntry.combinedEntry.l.StartDate,
                    EndDate = combinedEntry.combinedEntry.l.EndDate,
                    EquipmentName = equip.EquipmentName,
                    EquipmentID = combinedEntry.combinedEntry.l.EquipmentID,
                    EquipmentDescription = equip.EquipmentDescription
                }).ToList();
        var query2 = query1.Select(p => new EventLogs
        {
            EventID = p.EventID,
            Name = p.Name,
            DepartmentName = p.DepartmentName,
            StartDate = p.StartDate.ToString("yyyy-MM-dd"),
            EndDate = p.EndDate.ToString("yyyy-MM-dd"),
            EquipmentID = p.EquipmentID,
            EquipmentName = p.EquipmentName,
            EquipmentDescription = p.EquipmentDescription
        });
        return query2.ToList();
    }
    [WebMethod]
    public List<string> getDepartmentName()
    {
        Entry9036Entities db = new Entry9036Entities();
        var query = db.Departments.Select(p => p.DepartmentName).ToList();
        return query;
    }
    [WebMethod]
    public List<int> getLogsGroupbydepartment()
    {
        Entry9036Entities db = new Entry9036Entities();
        List<int> mylist = new List<int>();
        var query = db.Departments.Select(p => p.DepartmentName).ToList();
        foreach (var item in query)
        {
            mylist.Add(db.EquipmentRentLogs.Join(db.Employees, l => l.EmployeeID, emp => emp.EmployeeID, (l, emp) => new { l, emp }).
                Join(db.Departments, combinedEntry => combinedEntry.emp.DepartmentID, d => d.DepartmentID, (combinedEntry, d) => new
                {
                    LogIds = combinedEntry.l.LogsId,
                    DepartmentName = d.DepartmentName
                }).Count(p => p.DepartmentName == item));
        }
        return mylist;
    }
    public class EventLogs
    {
        public int EventID { get; set; }
        public string Name { get; set; }
        public string DepartmentName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string EquipmentName { get; set; }
        public int EquipmentID { get; set; }
        public string EquipmentDescription { get; set; }
    }
    public class EquipmentInfoByID
    {
        public int EquipmentID { get; set; }
        public string EquipmentName { get; set; }
        public string EquipmentDescription { get; set; }
        public int RentedState { get; set; }
        public int State { get; set; }
        public string Reason { get; set; }
        public string DepartmentName { get; set; }
        public string ImageUrl { get; set; }
        public string EmployeeID { get; set; }

    }


    public class EquipmentByTypeID
    {
        public int EquipmentID { get; set; }
        public string EquipmentName { get; set; }
        public int State { get; set; }
    }
    public class EquipmentCondition
    {
        public int EquipmentID { get; set; }
        public string EquipmentName { get; set; }
        public string EquipmentTypeName { get; set; }
        public string EquipmentDescription { get; set; }
        public string Reason { get; set; }
        public string EquipmentLife { get; set; }
        public int State { get; set; }
    }
}