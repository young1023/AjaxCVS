using System;
using System.Collections.Generic;
using nce.adosql;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class DailyReport : System.Web.UI.Page
{
    public string pageid = "";
    public string Barcode = "";
    public string Face_Value = "";
    public string Coupon_Type = "";
    public string Coupon_batch = "";
    public string Coupon_Number = "";
    public object StationID = null;
    public string fsql = "";
    public object Search_Date = null;
    public object Search_NDate = null;
    public object SecLevel = null;
    public object UserID = null;
    public Recordset frs = null;
    public Connection conn = null;
    public int findrecord = 0;
    public int j = 0;
    public double i = 0;
    public object SDay = null;
    public int k = 0;
    public int l = 0;
    public object SMonth = null;
    public int m = 0;
    public object SYear = null;
    public object NDay = null;
    public object NMonth = null;
    public object NYear = null;
    public int Total = 0;
    public int flage = 0;
    public string mycolor = "";
    public object id = null;
    public int Year_starting = 0;
    public int Year_ending = 0;
    public string Message = "";
    public string Car_No = "";
    public string Period = "";
    public int iMonthNo = 0;
    public DateTime dtDate ;
    public string sMonthName = null;

    protected void Page_Load(object sender, EventArgs e)
    {
         conn = new Connection();
         string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
         conn.Open(connectionstring); 
        SecLevel = (Convert.ToString(Session["SecLevel"])).Trim();        
        UserID = (Convert.ToString(Session["UserID"])).Trim();
        StationID = (Convert.ToString(Session["StationID"])).Trim();

 	
        if (SecLevel == "")
        {
            Response.Redirect("Default.aspx");
        }
        Message = Request["Message"];
        Coupon_Number = Request["Coupon_Number"];
        Car_No = Request["Car_No"];
        Face_Value = Request["Face_Value"];
        Period = Request["Period"];
        //search by date
        if (Request["SDay"] != null)
        {
            SDay = Request["SDay"];
            SMonth = Request["SMonth"];
            SYear = Request["SYear"];
        }
        else
        {
            SDay = Convert.ToString(DateTime.Now.Day);
            SMonth = Convert.ToString(DateTime.Now.Month);
            SYear = Convert.ToString(DateTime.Now.Year);
        }
        if (Request["NDay"] != null)
        {
            NDay = Request["NDay"];
            NMonth = Request["NMonth"];
            NYear = Request["NYear"];
        }
        else
        {
            NDay = Convert.ToString(DateTime.Now.Day);
            NMonth = Convert.ToString(DateTime.Now.Month);
            NYear = Convert.ToString(DateTime.Now.Year);
        }
        //Search_Date = Formatdatetime(DateSerial(SYear, SMonth, SDay),2)
        //Search_NDate = Formatdatetime(DateSerial(NYear, NMonth, NDay),2)
        Search_Date = SDay + "/" + SMonth + "/" + SYear;
        Search_NDate = NDay + "/" + NMonth + "/" + NYear;
        //Response.write search_date
        //response.write SecLevel & "<br>"
        //response.write UserID

        if (Request.Form["pageid"] != null)
            pageid = (Request.Form["pageid"]).Trim();
        if (pageid == "")
        {
            pageid = "1";
        }
        if (Request.Form["Barcode"] != null)
        {
            Barcode = (Request.Form["Barcode"]).Trim().Replace("%", "％");
            Barcode = Barcode.Replace("'", "''");
            if (Barcode.Length == 15)
            {
                Face_Value = Barcode.Substring(0, 3);
                Coupon_Type = Barcode.Substring(5 - 1, 2);
                Coupon_batch = Barcode.Substring(7 - 1, 3);
                Coupon_Number = Barcode.Substring(10 - 1, 6);
            }
        }
        fsql = "select * from MasterCoupon where RequestedID = " + Convert.ToString(StationID);
        //Search Coupon Number
        //********************
        if (Barcode != "")
        {
            if (Barcode.Length == 15)
            {
                fsql = fsql + " and Coupon_Number = '" + Coupon_Number + "'";
                fsql = fsql + " and Face_Value = '" + Face_Value + "'";
                fsql = fsql + " and Coupon_Type = '" + Coupon_Type + "'";
                fsql = fsql + " and Coupon_Batch = '" + Coupon_batch + "'";
            }
            else
            {
                fsql = fsql + " and Coupon_Number LIKE '%" + Barcode + "%' ";
            }
        }
        fsql = fsql + " and  Present_Date >=   Convert(datetime, '" + Convert.ToString(Search_Date) + "', 105) ";
        fsql = fsql + " and  Present_Date < DATEADD(dd,DATEDIFF(dd,0, Convert(datetime, '" + Convert.ToString(Search_NDate) + "', 105)),0) + 1 ";
        //By UserID
        if (Convert.ToString(SecLevel).Trim() == "1")
        {
            fsql = fsql + " and Period = '" + Convert.ToString(UserID) + "' ";
        }
        fsql = fsql + " order by id desc";
        frs = new Recordset();
        frs.CursorType = (nce.adodb.CursorType)1;
        frs.LockType = (nce.adodb.LockType)1;
        frs.Open(fsql, conn);

        Session.Add("SecLevel", SecLevel);
        Session.Add("UserID", UserID);
        Session.Add("StationID", StationID);
    }

    public void countpage(int PageCount, string pageid)
    {
        Response.Write(Convert.ToString(PageCount) + "</font> Pages ");
        if (PageCount >= 1 && PageCount <= 10)
        {
            for (i = 1.0; i <= PageCount; i += 1)
            {
                if ((Convert.ToDouble(pageid) - i == 0.0))
                {
                    Response.Write("<font color=black> " + Convert.ToString(i) + "</font> ");
                }
                else
                {
                    Response.Write(" <a href=javascript:gtpage('" + Convert.ToString(i) + "') style='cursor:hand;text-decoration:underline;' >" + Convert.ToString(i) + "</a>");
                }
            }
        }
        else if (PageCount > 11)
        {
            if (String.Compare(pageid, "5") <= 0)
            {
                for (i = 1.0; i <= 10.0; i += 1)
                {
                    if ((Convert.ToDouble(pageid) - i == 0.0))
                    {
                        Response.Write("<font color=green> " + Convert.ToString(i) + "</font> ");
                    }
                    else
                    {
                        Response.Write(" <a href=javascript:gtpage('" + Convert.ToString(i) + "') style='cursor:hand' >" + Convert.ToString(i) + "</a>");
                    }
                }
            }
            else
            {
                for (i = (Convert.ToDouble(pageid) - 4.0); i <= (Convert.ToDouble(pageid) + 5.0); i += 1)
                {
                    if ((Convert.ToDouble(pageid) - i == 0.0))
                    {
                        Response.Write("<font color=green> " + Convert.ToString(i) + "</font> ");
                    }
                    else if (i != PageCount)
                    {
                        Response.Write(" <a href=javascript:gtpage('" + Convert.ToString(i) + "') style='cursor:hand' >" + Convert.ToString(i) + "</a>");
                    }
                }
            }
        }
    }
}