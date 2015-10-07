using nce.adosql;
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;
namespace Client {

  public partial class check_digit_aspx_cs : System.Web.UI.Page
  {
    public Connection conn = null;
    public Recordset Rs1 = null;
    public Recordset Rs2 = null;
    public Recordset Rs3 = null;
    public Recordset Rs4 = null;
    public string StationID = "";
    public object UserID = null;
    public object SecLevel = null;
    public string Barcode = "";
    public string ProductType = "";
    public string CarPlate = "";
    public object iMessage = null;
    public string Message = "";
    public object iCount = null;
    public object Coupon_Number = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        conn = new Connection();
       string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
            conn.Open(connectionstring); 
        Rs1 = new Recordset();
        Rs2 = new Recordset();
        Rs3 = new Recordset();
        Rs4 = new Recordset();
        StationID = Request["StationID"];
        UserID = Session["UserID"];
        SecLevel = Session["SecLevel"];
        Barcode = Request["Barcode"];
        ProductType = Request["ProductType"];
        CarPlate = Request["CarPlate"];
        Response.Write(StationID);
        Response.Write(UserID);
        Response.Write(SecLevel);
        Response.End();
        iMessage = null;
        Rs1.Open(("Exec Checkrange '" + Barcode + "'"), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
        //Response.write ("Exec Checkrange '"&Barcode&"'")
        //Response.end
        if (Rs1.Eof)
        {
            Message = "Check Range 驗證失敗 - 禮券無效!";
            Response.Redirect("CouponVerification.aspx?Message=" + Message);
        }
        else
        {
            if (Convert.ToDateTime(Rs1.Fields["Expiry_Date"].Value) < DateTime.Parse(Convert.ToString(DateTime.Now)))
            {
                Message = "驗證失敗 - 禮券過期!";
                Response.Redirect("CouponVerification.aspx?Message=" + Message);
            }
        }
        Rs1.Close();
        Rs1 = null;
        Rs2.Open(("Exec CheckCouponExist '" + Barcode + "'"), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
        //Response.write ("Exec CheckCouponExist '"&Barcode&"'")
        iCount = Rs2.Fields["iCount"].Value;
        Rs2.Close();
        Rs2 = null;
        if (Convert.ToInt32(iCount) > 0)
        {
            Message = "驗證失敗 - 重複使用!";
        }
        else
        {
            Session.Add("SecLevel", SecLevel);
            Session.Add("UserID", UserID);
            Session.Add("StationID", StationID);
            Response.Redirect("Insert.aspx?ProductType=" + ProductType + "&Barcode=" + Barcode + "&CarPlate=" + CarPlate);
        }
        Session.Add("SecLevel", SecLevel);
        Session.Add("UserID", UserID);
        Session.Add("StationID", StationID);
        Response.Redirect("CouponVerification.aspx?Message=" + Message + "&Coupon_Number=" + Convert.ToString(Coupon_Number));
    }

  }

} 
