using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nce.adosql;
using System.Web.Services;
using System.Configuration;

public partial class Execute : System.Web.UI.Page
{
     public static Connection conn = null;
    public string Message = "";
    public Recordset Rs1 = null;
     static object StationID = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {        

    }

    [WebMethod]
    public static string ExecuteCoupon(string StationID, string Barcode, string CarPlate, string ProductType)
    //public static string ExecuteCoupon( string Barcode)
    {
         conn = new Connection();
         string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
         conn.Open(connectionstring); 
      	 Recordset Rs1 = null;
        Recordset Rs2 = null;
        Recordset Rs3 = null;
        Recordset Rs4 = null;
            
        object UserID = null;
        object SecLevel = null;
     


        object iMessage = null;
        string Message = "";
        object iCount = null;
        string Face_Value = "";
        string Coupon_Type = "";
        string Coupon_batch = "";
        string Coupon_Number = "";
        string Sql = "";
        object UnitPrice = null;
        string Sql1 = "";

        Rs1 = new Recordset();
        Rs2 = new Recordset();
        Rs3 = new Recordset();
        Rs4 = new Recordset();
        // Stationid = StationID;
        UserID = HttpContext.Current.Session["UserID"];
        SecLevel = HttpContext.Current.Session["SecLevel"];     
      
        iMessage = null;
       
         Rs1.Open(("Exec VerifyCoupon '" + Barcode + "','" + StationID + "','" + ProductType + "','" + CarPlate + "','" + UserID + "'"), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
        // Rs1.Open(("Exec VerifyCoupon '" + Barcode + "'"), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
        
        string result = Rs1.Fields["result"].Value.ToString();
        string coupon_number = "";
        string date = "";
	if(Rs1.Fields["coupon_number"] != null)
        {
          coupon_number = Rs1.Fields["coupon_number"].Value.ToString();
        }
         if (Rs1.Fields["Present_Date"] != null)
            {
                date = Rs1.Fields["Present_Date"].Value.ToString();
                //DateTime d1;
                //DateTime d = DateTime.TryParse(date,out d1);

                DateTime? d = null;
                DateTime d2;
                bool success = DateTime.TryParse(date, out d2);
                if (success) d = d2;
                date = d2.ToString("MM/dd/yyyy HH:mm:ss");
            }
        
        HttpContext.Current.Session.Add("SecLevel", SecLevel);
        HttpContext.Current.Session.Add("UserID", UserID);
        HttpContext.Current.Session.Add("StationID", StationID);
        // Response.Redirect("CouponVerification.aspx?Message=" + Message + "&Coupon_Number=" + Coupon_Number);
        return result + "@" + coupon_number + "@" + date;
    }
}