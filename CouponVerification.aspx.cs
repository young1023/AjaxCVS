using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nce.adosql;
using System.Configuration;
using System.Net;
using System.Net.Sockets;
using System.Configuration;
public partial class CouponVerification : System.Web.UI.Page
{
    public Connection conn = null;
    public string UserIPAddress = "";
    public Recordset Rs1 = null;
    public string sql1 = "";
    public object StationID = null;
    public object UserID = null;
    public object SecLevel = null;
    public string CarPlate = "";
    public string ProductType = "";
    public string Message = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        conn = new Connection();
      
        string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
        conn.Open(connectionstring); 
        //For Demo
        UserIPAddress = GetIPAddress();
	//UserIPAddress = Request.ServerVariables["REMOTE_ADDR"];
        Rs1 = new Recordset();
        sql1 = "Select Station From Station Where IPAddress ='" + UserIPAddress + "'";
        Rs1 = conn.Execute(sql1);
        StationID = Rs1.Fields["Station"].Value;
        UserID = Session["UserID"];
        SecLevel = Session["SecLevel"];
        CarPlate = Request["CarPlate"];
        ProductType = Request["ProductType"];
        Message = "";
        if (Convert.ToString(SecLevel) == "")
        {
            Response.Redirect("Default.aspx"); 
        }
        Session.Add("SecLevel", SecLevel);
        Session.Add("UserID", UserID);
        Session.Add("StationID", StationID);
    }
	 protected string GetIPAddress()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

}