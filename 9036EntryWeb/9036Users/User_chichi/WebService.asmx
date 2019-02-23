<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
[System.Web.Script.Services.ScriptService] //使用AJAX時，記得開啟
public class WebService : System.Web.Services.WebService
{
    private static string conn = ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString;

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    //傳給管理者chichi進行篩選的表格 抓取所有使用者
    [WebMethod]
    public List<PersonInfo> QueryPerson()
    {
        SqlDataAdapter da = new SqlDataAdapter(
        //"select Id,name,sex,height,birth,hobby from SignUp where 1=@unknown", conn);
        "select Id,name,sex,height,CONVERT(nvarchar(12),birth,111) birthWithoutTime ,hobby from SignUp where sex <> N'無';", conn);
        //ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        //da.SelectCommand.Parameters.AddWithValue("@unknown", 1);

        DataTable dt = new DataTable();
        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new PersonInfo()
                    {
                        Id = (int)row["Id"],
                        name = row["name"].ToString(),
                        sex = row["sex"].ToString(),
                        height = (int)row["height"],
                        birth = row["birthWithoutTime"].ToString(), //birth轉換成birthWithoutTime，將日期的 上午12:00消除
                        hobby = row["hobby"].ToString()

                    };

        return query.ToList();
    }

    [WebMethod] //管理者刪除不合規定的使用者
    public void DeletePerson(string Id)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("delete from SignUp where Id=@Id", cn);

        cmd.Parameters.AddWithValue("@Id", Id);       

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

       
    }


    //UpdateInformation.aspx 抓取某位使用者
    [WebMethod]
    public List<PersonInfo> QuerySignUpDetail(string id)
    {
        SqlDataAdapter da = new SqlDataAdapter(
            "select Id,pwd,name,sex,height,CONVERT(nvarchar(12),birth,111) birthWithoutTime,hobby,email from SignUp where Id=@Id", conn);
        //ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        da.SelectCommand.Parameters.AddWithValue("@Id", id);

        DataTable dt = new DataTable();
        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new PersonInfo()
                    {
                        Id = (int)row["Id"],
                        passwd = row["pwd"].ToString(),
                        name = row["name"].ToString(),
                        sex = row["sex"].ToString(),
                        height = (int)row["height"],
                        birth = row["birthWithoutTime"].ToString(),
                        hobby = row["hobby"].ToString(),
                        email = row["email"].ToString()
                    };

        return query.ToList();
    }

    //sortableForWoman.aspx
    [WebMethod]
    public List<ManAttend> QueryManInfo()
    {
        SqlDataAdapter da = new SqlDataAdapter("select MId,name,height,CONVERT(nvarchar(12),birth,111) birthWithoutTime,hobby from ManAttend", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new ManAttend()
                    {
                        MId = Convert.ToInt32(row["MId"]),
                        name = row["Name"].ToString(),
                        height = Convert.ToInt32(row["height"]),
                        birth = row["birthWithoutTime"].ToString(),
                        hobby = row["hobby"].ToString()
                    };
        return query.ToList();
    }

    //sortableForMan.aspx
    [WebMethod]
    public List<WomanAttend> QueryWomanInfo()
    {
        SqlDataAdapter da = new SqlDataAdapter("select WId,name,height,CONVERT(nvarchar(12),birth,111) birthWithoutTime,hobby from WomanAttend", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new WomanAttend()
                    {
                        WId = Convert.ToInt32(row["WId"]),
                        name = row["Name"].ToString(),
                        height = Convert.ToInt32(row["height"]),
                        birth = row["birthWithoutTime"].ToString(),
                        hobby = row["hobby"].ToString()
                    };
        return query.ToList();
    }

    //sortableForWoman.aspx 傳回信息
    [WebMethod]
    public string GetListFromWoman(string Id, string sort)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("insert into WomanSortable (WId,sort) values (@WId,@sort)", cn);

        cmd.Parameters.AddWithValue("@WId", Id);
        cmd.Parameters.AddWithValue("@sort", sort);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();


        //string[] array = key.Split(',');
        //return array[2];
        return Id + "@" + sort;
    }

    //sortableForMan.aspx 傳回信息
    [WebMethod]
    public string GetListFromMan(string Id, string sort)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("insert into ManSortable (MId,sort) values (@MId,@sort)", cn);

        cmd.Parameters.AddWithValue("@MId", Id);
        cmd.Parameters.AddWithValue("@sort", sort);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();


        //string[] array = key.Split(',');
        //return array[2];
        return Id + "@" + sort;
    }



    /*Gale-Shapley*/ /*組成 TotalSortable table*/
    [WebMethod]
    public int CombineTwoSortable()
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("insert into TotalSortable (Id,sort) select MId,sort from ManSortable", cn);
        SqlCommand cmd2 = new SqlCommand("update TotalSortable set sex=N'男' where sex is null", cn);
        SqlCommand cmd3 = new SqlCommand("insert into TotalSortable (Id,sort) select WId,sort from WomanSortable", cn);
        SqlCommand cmd4 = new SqlCommand("update TotalSortable set sex=N'女' where sex is null", cn);
        //計算總人數 (男+女)
        SqlCommand cmd5 = new SqlCommand("select count(*) from ManSortable ", cn);

        //cmd.Parameters.AddWithValue("@WId", Id);
        //cmd.Parameters.AddWithValue("@sort", sort);

        cn.Open();
        cmd.ExecuteNonQuery();
        cmd2.ExecuteNonQuery();
        cmd3.ExecuteNonQuery();
        cmd4.ExecuteNonQuery();
        int count = (int)cmd5.ExecuteScalar();
        cn.Close();

        return count * 2;//總人數=性別*2
    }


    [WebMethod]
    public string QueryMatch()
    //public List<StableMatch> QueryMatch()
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);
        SqlCommand cmd = new SqlCommand("Select Id,sort,sex from TotalSortable ", cn);


        List<Matched> matchResult = new List<Matched>();
        List<Man> men = new List<Man>();
        List<Woman> women = new List<Woman>();

        cn.Open();

        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.HasRows)
        {
            while (dr.Read())
            {
                if (dr["sex"].ToString() == "男")
                {
                    Man man = new Man((int)dr["Id"]); //Id
                    string s = dr["sort"].ToString();
                    string[] sort = s.Split(',');
                    man.StrSort = sort;
                    men.Add(man);
                }
                else if (dr["sex"].ToString() == "女")
                {
                    Woman woman = new Woman((int)dr["Id"]);
                    string s = dr["sort"].ToString();
                    string[] sort = s.Split(',');
                    woman.StrSort = sort;
                    women.Add(woman);
                }
            }
        }

        //將每位男性喜歡的女性排序放入Dictionary
        foreach (var man in men)
        {
            man.ManChoice = new Dictionary<int, Woman>();

            for (int i = 0; i < women.Count; i++)
            {
                man.ManChoice.Add(i + 1, (from member in women
                                          where member.Id.ToString() == man.StrSort[i]
                                          select member).FirstOrDefault());
            }
        }

        //將每位女性喜歡的男性排序放入Dictionary
        foreach (var woman in women)
        {
            woman.WomanChoice = new Dictionary<int, Man>();

            for (int i = 0; i < women.Count; i++)
            {
                woman.WomanChoice.Add(i + 1, (from member in men
                                              where member.Id.ToString() == woman.StrSort[i]
                                              select member).FirstOrDefault());
            }
        }



        dr.Close();

        while (true)
        {
            foreach (var man in men)
            {
                if (man.IsFree)
                {
                    for (int i = 1; i <= man.ManChoice.Count; i++)
                    {
                        Woman woman = man.ManChoice[i];
                        if (woman.IsFree)
                        {
                            Matched matched = new Matched(man, woman);
                            matchResult.Add(matched);

                            man.IsFree = false; //男性配對成功失去自由

                            woman.IsFree = false; //女性配對成功失去自由
                            break; //回到foreach (var man in menList)
                        }
                        else if (woman.IsFree == false)
                        {
                            var tempMatched = (from t in matchResult
                                               where t.Woman.Id == woman.Id
                                               select t).FirstOrDefault();

                            //新的嘗試配對之男性在此女的排序位置
                            var key1 = (from entry in woman.WomanChoice
                                        where entry.Value.Id == man.Id
                                        select entry.Key).FirstOrDefault();

                            //先前 Matched類配對成功的男性在此女的排序位置
                            var key2 = (from entry in woman.WomanChoice
                                        where entry.Value.Id == tempMatched.Man.Id
                                        select entry.Key).FirstOrDefault();

                            if (key1 < key2)
                            {
                                tempMatched.Man.IsFree = true;//男性被拋棄重新選擇下一順位
                                man.IsFree = false;
                                matchResult.Remove(tempMatched);

                                Matched matched = new Matched(man, woman);
                                matchResult.Add(matched);
                                break; //回到foreach (var man in menList)
                            }
                        }
                    }
                }

            }
            if (matchResult.Count == men.Count) break; //湊成對數=男性數目=女性數目
        }
        //dr.Close();

        //可行，但SqlDataReader必須先關閉重開，然後再關閉

        //SqlCommand cmd2 = new SqlCommand("insert into TestDataReader (Id,name) values (@Id,@name)", cn);
        //cmd2.Parameters.AddWithValue("@Id",87);
        //cmd2.Parameters.AddWithValue("@name","陳穎祺");

        //dr = cmd2.ExecuteReader();
        //dr.Close();

        //將List資料依序輸入進數據庫儲存
        SqlCommand cmd2 = new SqlCommand("insert into GaleShapley (MId,WId,status) values (@MId,@WId,N'待定')", cn);
        cmd2.Parameters.Add("@mid", SqlDbType.Int);
        cmd2.Parameters.Add("@wid", SqlDbType.Int);


        for (int i = 0; i < matchResult.Count; i++)
        {
            cmd2.Parameters["@mid"].Value = matchResult[i].Man.Id;
            cmd2.Parameters["@wid"].Value = matchResult[i].Woman.Id;
            cmd2.ExecuteNonQuery();
        }



        cn.Close();


        //return women[3].WomanChoice[1].Id + "," + women[3].WomanChoice[10].Id;//第四位女性喜歡的第1位及第10位男性
       // return matchResult[4].Man.Id + "," + matchResult[4].Woman.Id;
        return "已完成配對";

    }

    //DatingPlace.aspx 展示所有約會地點
    [WebMethod]
    public List<DatingPlace> QueryDatingPlace()
    {
        SqlDataAdapter da = new SqlDataAdapter("select PlaceId,place,description from DatingPlace", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new DatingPlace()
                    {
                        PlaceId = Convert.ToInt32(row["PlaceId"]),
                        name = row["place"].ToString(),
                        description = row["description"].ToString()
                    };
        return query.ToList();
    }

    //選取某個約會地點
    [WebMethod]
    public List<DatingPlace> QueryCertainDatingPlace(string Id)
    {
        SqlDataAdapter da = new SqlDataAdapter("select PlaceId,place,description from DatingPlace where PlaceId = @PlaceId", conn);
        da.SelectCommand.Parameters.AddWithValue("@PlaceId", Id);

        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new DatingPlace()
                    {
                        PlaceId = Convert.ToInt32(row["PlaceId"]),
                        name = row["place"].ToString(),
                        description = row["description"].ToString()
                    };
        return query.ToList();
    }

    //男方已寄出邀請給女生
    [WebMethod]
    public string ModifyGaleTable(string UserId, string PlaceId, string place, string description)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("UPDATE GaleShapley SET PlaceId=@PlaceId,place=@place,description=@description,status=N'男方已寄出邀請' where  MId=@MId ", cn);
        //SqlCommand cmd = new SqlCommand("UPDATE GaleShapley SET PlaceId=@PlaceId where  MId=@MId ", cn);

        cmd.Parameters.AddWithValue("@PlaceId", PlaceId);
        cmd.Parameters.AddWithValue("@place", place);
        cmd.Parameters.AddWithValue("@description", description);
        cmd.Parameters.AddWithValue("@MId", UserId);

        cn.Open();
        cmd.ExecuteNonQuery();

        cn.Close();

        return "GaleShapley Table 已更新";
    }

    //討論區
    [WebMethod]
    public List<Comment> QueryComment()
    {
        SqlDataAdapter da = new SqlDataAdapter("select sex,comment,CONVERT(nvarchar(12),nowTime,108) HMS from Forum;", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new Comment()
                    {
                        sex = row["sex"].ToString(),
                        comment = row["comment"].ToString(),
                        HMS = row["HMS"].ToString()
                    };
        return query.ToList();
    }

    [WebMethod]
    public string InsertComment(string sex, string comment)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("insert into Forum (sex,comment,nowTime) values (@sex,@comment,GETDATE())", cn);

        cmd.Parameters.AddWithValue("@sex", sex);
        cmd.Parameters.AddWithValue("@comment", comment);

        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

        return "已新增留言";
    }

    //管理員檢視約會情形 admin/CheckResult.aspx
    [WebMethod]
    public List<DatingStatus> QueryDatingResult()
    {
        SqlDataAdapter da = new SqlDataAdapter("select Id,MId,WId,PlaceId,place,status from GaleShapley;", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new DatingStatus()
                    {
                        Id = Convert.ToInt32(row["Id"]),
                        MId = Convert.ToInt32(row["MId"]),
                        WId = Convert.ToInt32(row["WId"]),
                        //PlaceId = Convert.ToInt32(row["PlaceId"]),
                        place = row["place"].ToString(),
                        status = row["status"].ToString()
                    };
        return query.ToList();
    }

    //彙整男女約會情形
    [WebMethod]
    public string ProduceStatistics()
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["SignUp"].ConnectionString);

        SqlCommand cmd = new SqlCommand("insert into Statistic (failure) select count(*) from GaleShapley where status=N'女方拒絕赴約';", cn);
        SqlCommand cmd2 = new SqlCommand("UPDATE Statistic SET success=(select count(*) from GaleShapley where status=N'女方答應赴約'),uncertainty=(select count(*) from GaleShapley where status=N'待定') where Id=(SELECT MAX(Id) from Statistic);", cn);

        cn.Open();
        cmd.ExecuteNonQuery();
        cmd2.ExecuteNonQuery();

        cn.Close();

        return "收集數據完成";//總人數=性別*2
    }

    //獲取統計資料
    [WebMethod]
    public List<Statistics> QueryStatistics()
    {
        SqlDataAdapter da = new SqlDataAdapter("select success,failure,uncertainty from Statistic;", conn);
        DataTable dt = new DataTable();

        da.Fill(dt);

        var query = from row in dt.AsEnumerable()
                    select new Statistics()
                    {
                        success = Convert.ToInt32(row["success"]),
                        failure = Convert.ToInt32(row["failure"]),
                        uncertainty = Convert.ToInt32(row["uncertainty"]),
                    };
        return query.ToList();
    }
}


public class Statistics
{
    public int success { get; set; }
    public int failure { get; set; }
    public int uncertainty { get; set; }
}

public class DatingStatus
{
    public int Id { get; set; }
    public int MId { get; set; }
    public int WId { get; set; }
    public int PlaceId { get; set; }
    public string place { get; set; }
    public string status { get; set; }
}


public class Comment
{
    public string sex { get; set; }
    public string comment { get; set; }
    public string HMS { get; set; } //時分秒
}

public class DatingPlace
{
    public int PlaceId { get; set; }
    public string name { get; set; }
    public string description { get; set; }
}


public class PersonInfo
{
    public int Id { get; set; }
    public string passwd { get; set; }
    public string name { get; set; }
    public string sex { get; set; }
    public int height { get; set; }
    public string birth { get; set; }
    public string hobby { get; set; }
    public string email { get; set; }
}

public class ManAttend
{
    public int MId { get; set; } //藉由MID抓取圖片
    public string name { get; set; }
    public int height { get; set; }
    public string birth { get; set; }
    public string hobby { get; set; }
}

public class WomanAttend
{
    public int WId { get; set; } //藉由WID抓取圖片
    public string name { get; set; }
    public int height { get; set; }
    public string birth { get; set; }
    public string hobby { get; set; }
}



/*Gale-Shapley*/
public class StableMatch
{
    public int MatchId { get; set; }
    public int MId { get; set; }
    public int WId { get; set; }
}

//配對類別
class Matched
{
    private Man man;
    private Woman woman;

    public Matched(Man man, Woman woman)
    {
        this.Man = man;
        this.Woman = woman;
    }

    public Man Man { get => man; set => man = value; }
    public Woman Woman { get => woman; set => woman = value; }
}

//男性用戶
class Man
{
    private int id;
    private string[] strSort;

    private bool isFree = true;

    /*manChoice 比如：
        1. 1, 106
        2. 2, 101
        3. 3, 109
             */

    private Dictionary<int, Woman> manChoice = null; //男性擇偶列表

    public Man(int id)
    {
        this.id = id;
    }


    public Dictionary<int, Woman> ManChoice { get => manChoice; set => manChoice = value; }
    public int Id { get => id; set => id = value; }
    public string[] StrSort { get => strSort; set => strSort = value; }
    public bool IsFree { get => isFree; set => isFree = value; }
}

//女性用戶
class Woman
{
    private int id;
    private string[] strSort;

    private bool isFree = true;
    private Dictionary<int, Man> womanChoice = null; //女性擇偶列表

    public Woman(int id)
    {
        this.id = id;
    }

    public Dictionary<int, Man> WomanChoice { get => womanChoice; set => womanChoice = value; }
    public int Id { get => id; set => id = value; }
    public string[] StrSort { get => strSort; set => strSort = value; }
    public bool IsFree { get => isFree; set => isFree = value; }

}