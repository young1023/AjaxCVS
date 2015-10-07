using Microsoft.VisualBasic;
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
using System.Text.RegularExpressions;
using System.Configuration;
namespace Client {

  public partial class ConvertReport_aspx_cs : System.Web.UI.Page
  {
    public Connection conn = null;
    public string StrCnn = "";
    public string UserID = "";
    public string Level = "";
    public string StationID = "";
    public string SDay = "";
    public string SMonth = "";
    public string SYear = "";
    public string NDay = "";
    public string NMonth = "";
    public string NYear = "";
    public string Search_Date = "";
    public string Search_NDate = "";
    public string fsql = "";
    public string Today = "";
    //
    //EXAMPLE USAGE
    //
    //- Open a RECORDSET object (forward-only, read-only recommended)
    //- Send appropriate response headers
    //- Call the function
    //
    public Recordset RS1 = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            conn = new Connection();
           string connectionstring = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;
            conn.Open(connectionstring); 
            UserID = (Request["UserID"]).Trim();
            Level = (Request["SecLevel"]).Trim();
            StationID = (Request["StationID"]).Trim();
            UserID = (Request["UserID"]).TrimEnd();
            SDay = Request["SDay"];
            SMonth = Request["SMonth"];
            SYear = Request["SYear"];
            NDay = Request["NDay"];
            NMonth = Request["NMonth"];
            NYear = Request["NYear"];
            // Search_Date = Strings.FormatDateTime(new DateTime(Convert.ToInt32(SYear), Convert.ToInt32(SMonth), Convert.ToInt32(SDay)), (DateFormat)2);
            //Search_NDate = Strings.FormatDateTime(new DateTime(Convert.ToInt32(NYear), Convert.ToInt32(NMonth), Convert.ToInt32(NDay)), (DateFormat)2);

            Search_Date = SDay + "/" + SMonth + "/" + SYear;
            Search_NDate = NDay + "/" + NMonth + "/" + NYear;
            fsql = "select * from MasterCoupon where RequestedID = " + StationID +
                " and  Present_Date >=   Convert(datetime, '" + Search_Date + "', 105) " +
                " and  Present_Date < DATEADD(dd,DATEDIFF(dd,0, Convert(datetime, '" + Search_NDate + "', 105)),0) + 1 " +
                " order by id desc";
            //response.write fsql
            //response.end
            RS1 = conn.Execute(fsql);
            Response.ContentType = "text/csv";
            //Today = Strings.FormatDateTime(DateTime.Now, (DateFormat)2);
            Today = DateTime.Now.ToString("dd-MM-yyyy");
            Response.AddHeader("Content-Disposition", "attachment;filename=Â§¨é¬ö¿ı(" + Today + ").csv");
            Write_CSV_From_Recordset(RS1);
        }
        catch (Exception ex)
        { 
        }
    }

    public void Write_CSV_From_Recordset(Recordset RS) 
    {
        Regex RX = null;
        object i = null;
        object Field = null;
        string Separator = "";
        if (RS.Eof)
        {
            //
            //There is no data to be written
            //
            return ;
        }
        //RX = new System.Text.RegularExpressions.Regex();
        //RX.Pattern = "\\r|\\n|,|\"";
        //
        //Writing the header row (header row contains field names)
        //
        Separator = ",";
        Response.Write("Present Date and Time");
        Response.Write(Separator);
        Response.Write("Period");
        Response.Write(Separator);
        Response.Write("Number");
        Response.Write(Separator);
        Response.Write("Type");
        Response.Write(Separator);
        Response.Write("Product");
        Response.Write(Separator);
        Response.Write("Litre");
        Response.Write(Separator);
        Response.Write("Amount");
        Response.Write(Separator);
        Response.Write("Car");
        Response.Write("\r\n");
        //
        //Writing the data rows
        //
        while(!(RS.Eof))
        {
            Response.Write(RS.Fields["Present_Date"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["Period"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["Coupon_Number"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["Coupon_Type"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["Product_Type"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["SaleLitre"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["SaleAmount"].Value);
            Response.Write(Separator);
            Response.Write(RS.Fields["Car_ID"].Value);
            Response.Write("\r\n");
            RS.MoveNext();
        }
    }


  }

} 
