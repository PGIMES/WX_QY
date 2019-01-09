using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_Purchase_PR_Query : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string BindList(string prtype, string startdate, string enddate, int start, int itemsPerLoad)
    {
        IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式 
        iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
        string tempsql = @"select a.prno,b.wlh,b.wlmc,b.id,ROW_NUMBER() OVER (ORDER BY b.id desc) ROWNUM  
                    from PUR_PR_Main_Form a 
                        inner join PUR_PR_Dtl_Form b on a.prno=b.prno 
                    where 1=1";

        if (prtype!="")
        {
            tempsql = tempsql + " and a.prtype='" + prtype + "'";
        }
        if (startdate != "")
        {
            tempsql = tempsql + " and a.createdate>=convert(datetime,'" + startdate + "')";
        }
        if (enddate != "")
        {
            tempsql = tempsql + " and a.createdate<=convert(datetime,'" + enddate + "')";
        }

        string pageSql = @"SELECT * FROM ({0}) tt WHERE ROWNUM <= {4} and ROWNUM >= {3} order by {1} {2}";
        string sql = string.Format(pageSql, tempsql, "tt.prno", "desc", start + 1, start + itemsPerLoad);

        DataTable dt = DbHelperSQL.Query(sql).Tables[0];
        var json = JsonConvert.SerializeObject(dt, iso);
        return json;
    }

    [WebMethod]
    public static string BindListDetail(string id)
    {
        IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式 
        iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
        string tempsql = @"select b.*,a.createbyid,a.createbyName,a.createDate,a.prtype,a.prreason,a.applydept,a.deptname  
                    from PUR_PR_Main_Form a 
                        inner join PUR_PR_Dtl_Form b on a.prno=b.prno 
                     where b.id='" + id + "'";


        DataTable dt = DbHelperSQL.Query(tempsql).Tables[0];
        var json = JsonConvert.SerializeObject(dt, iso);
        return json;
    }
}