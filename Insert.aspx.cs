using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nce.adosql;
using System.Configuration;
public partial class Insert : System.Web.UI.Page
{
    public Connection conn = null;
    public string Message = "";
    protected void Page_Load(object sender, EventArgs e)
    {
	conn = new Connection();
        string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
        conn.Open(connectionstring); 
        Recordset Rs1 = null;
    object StationID = null;
    object UserID = null;
    object SecLevel = null;
    string Barcode = "";
    string ProductType = "";
    string CarPlate = "";
    string Message = "";

    Rs1 = new Recordset();
    StationID = Session["StationID"];
    UserID = Session["UserID"];
    SecLevel = Session["SecLevel"];
    Barcode = Request["Barcode"];
    ProductType = Request["ProductType"];
    CarPlate = Request["CarPlate"];
    Message = "ÅçÃÒ¦¨¥\\!";
    Rs1.Open(("Exec InsertCoupon '" + Barcode + "', '" + Convert.ToString(StationID) + "','" + ProductType + "','" + CarPlate + "','" + Convert.ToString(UserID) + "' "), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
    Session.Add("SecLevel", SecLevel);
    Session.Add("UserID", UserID);
    Session.Add("StationID", StationID);
    Response.Redirect("CouponVerification.aspx?Message=" + Message + "&CarPlate=" + CarPlate + "&ProductType=" + ProductType);
    }
}