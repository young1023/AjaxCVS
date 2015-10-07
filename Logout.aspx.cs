using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        object StationID = null;

        Session.Add("SecLevel", "");
        Session.Add("UserID", "");
        Session.Add("StationID", StationID);
        Response.Redirect("Default.aspx");
    }
}