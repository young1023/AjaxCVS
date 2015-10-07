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
using nce.adosql;
using System.Net;
using System.Net.Sockets;
using System.Configuration;

namespace Client
{

    public partial class Default_aspx_cs : System.Web.UI.Page
    {
        public Connection conn = null;
        public string Message = "";
        public Recordset Rs1 = null;
        public string sql1 = "";
        public Recordset Rs2 = null;
        public string sql2 = "";
        public object StationID = null;
        public string Alert = "";
        public string UserIPAddress = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                conn = new Connection();
                string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
                conn.Open(connectionstring);
                Message = Request["Message"];
               UserIPAddress = GetIPAddress();
                //For Demo            
                // UserIPAddress = "192.168.1.12";
                Rs1 = new Recordset();
                sql1 = "Select Station From Station Where IPAddress ='" + UserIPAddress + "'";
                Rs1 = conn.Execute(sql1);
                if (!(Rs1.Eof))
                {
                    StationID = Rs1.Fields["Station"].Value;
                    Session["StationID"] = StationID;
                    conn.Close();
                }
                else
                {
                    Alert = "編號未設置, 請提供此電腦的 IP 地址 [ " + UserIPAddress + " ] 給系統管理員";
                }
            }
            catch (Exception ex)
            {

            }
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

}
