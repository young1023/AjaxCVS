using nce.adosql;
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

  public partial class Login_aspx_cs : System.Web.UI.Page
  {
    public Connection conn = null;
    public string UserID = "";
    public string Password = "";
    public string StationID = "";
    public Recordset Rs1 = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        conn = new Connection();
         string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
         conn.Open(connectionstring); 
	UserID = Request["UserID"];
        Password = Request["Password"];
        if (Session["StationID"] != null)
        {
            StationID = Session["StationID"].ToString();
        }
        Rs1 = new Recordset();
        Rs1.Open(("Exec CheckLoginPwd '" + UserID + "', '" + Password + "' "), conn, (nce.adodb.CursorType)3, (nce.adodb.LockType)1);
        if (!(Rs1.Eof))
        {
            Session.Add("SecLevel", Rs1.Fields["SecLevel"].Value);
            Session.Add("UserID", UserID);
            Session.Add("StationID", StationID);
            Response.Redirect("CouponVerification.aspx");
        }
        else
        {
            Response.Redirect("Default.aspx?Message=Fail");
        }
    }
  }

} 
