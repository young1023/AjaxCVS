<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DailyReport.aspx.cs" Inherits="DailyReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>
    --  驗證系統  -- 
</title>
   
</head>
    <style>
        table.table.table-bordered.DailyReport {
    padding: 10px;
    margin: 0;
}
        </style>
<body class="homepage" onload="document.fm1.Barcode.focus();">
<!--#include file="include/header.inc"-->
    <link href="include/css/publish.css" rel="stylesheet" />
<link href="include/css/bootstrap.min.css" rel="stylesheet" />

<form name="fm1" method="post" action="">

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
<h1 class="Title text-center">禮券驗證系統</h1>

<span class="noprint noborder">
    <div class="row">
        <div class="col-md-6 col-sm-6 text-center">        
             <a href="CouponVerification.aspx">驗證</a> 
        </div>
        <div class="col-md-6 col-sm-6 text-center">        
             <a href="logout.aspx">登出</a>
        </div>
        <div class="clearfix"></div>
    </div>
</span>
 <table cellpadding="04" cellspacing="2" class="table table-bordered noborder">
			  <tr>
                                <td height="28"> 

<span class="noprint noborder">
<%
        //response.end
    if (frs.RecordCount == 0)
    {
        Response.Write("<font color=red>No Record</font>");
        //response.end
    }
    else
    {
        findrecord = frs.RecordCount;
        Response.Write("Total <font color=red>" + Convert.ToString(findrecord) + "</font> Records ;");
        frs.PageSize = 100;
        countpage(frs.PageCount, pageid);
    }
%>

	     &nbsp;&nbsp;<input type="text" name="Barcode" size="15" maxlength=15 value="<%= Barcode %>">
		 &nbsp;&nbsp;<input type="button" value="禮券編號" onClick="findenum();">
</span>	   </td>
                              </tr>
                              <tr> 
                                <td valign="top" height="28"> 
   <table border="0" align=center cellpadding="4" cellspacing="1" class="table table-bordered DailyReport" width="100%" height="100%">
<tr bgcolor="#DFDFDF">
          <td colspan="7" align="right">油站</td>
          <td align="center"><%= StationID %></td>
      </tr>
    <tr> 
			<td colspan="3"> 日期:
			 
			<select name="SDay" class="common">

<%
    j = 1;
    for(i = 1.0; i <= 31.0; i += 1)
    {
%>


	<option value="<%= j %>" <%
        if (Convert.ToString(SDay).Trim() == Convert.ToString(j).Trim())
        {
            Response.Write("selected");
        }
%>
><%= j %></option>		
<%
        j = j + 1;
    }
%>

			</select>
			<select name="SMonth" class="common">  
<%
    k = 1;
    for(l = 1; l <= 12; l += 1)
    {
        iMonthNo = l;
        dtDate = new DateTime(2000, iMonthNo, 1);
        sMonthName = dtDate.ToString("MMM");
%>
          	
    <option value="<%= k %>" <%
        if (Convert.ToString(SMonth).Trim() == Convert.ToString(k).Trim())
        {
            Response.Write("selected");
        }
%>
><%= sMonthName %></option>
<%
        k = k + 1;
    }
%>

</select>
                			<select name="SYear" class="common">   
<%
    //Year_starting = DateAndTime.DateAdd("yyyy", -1.0, DateTime.Now).Year;
    Year_starting = DateTime.Now.AddYears(-1).Year;
    Year_ending = DateTime.Now.Year;
    for(m = Year_starting; m <= Year_ending; m += 1)
    {
%>
			         
			<option value="<%= m %>" <%
        if (Convert.ToInt64(m) == Convert.ToInt64(SYear))
        {
            Response.Write("selected");
        }
%>
><%= m %></option>
<%
    }
%>


			</select> 
			</td>
	<td colspan="4">			 
			<select name="NDay" class="common">
<%
    j = 1;
    for(i = 1.0; i <= 31.0; i += 1)
    {
%>

	<option value="<%= j %>" <%
        if (Convert.ToString(NDay).Trim() == Convert.ToString(j).Trim())
        {
            Response.Write("selected");
        }
%>
><%= j %></option>		
<%
        j = j + 1;
    }
%>
		
			</select>
			<select name="NMonth" class="common">  
<%
    k = 1;
    for(l = 1; l <= 12; l += 1)
    {
        iMonthNo = l;
        dtDate = new DateTime(2000, iMonthNo, 1);
        sMonthName = dtDate.ToString("MMM");
%>
          	
    <option value="<%= k %>" <%
        if (NMonth.ToString().Trim() == Convert.ToString(k).Trim())
        {
            Response.Write("selected");
        }
%>
><%= 
    
 (sMonthName)
    %></option>
<%
        k = k + 1;
    }
%>

</select>
			<select name="NYear" class="common">   
<%
    //Year_starting = DateAndTime.DateAdd("yyyy", -1.0, DateTime.Now).Year;
    Year_starting = DateTime.Now.AddYears(-1).Year;
    for(i = Year_starting; i <= DateTime.Now.Year; i += 1)
    {
%>
			         
			<option value="<%= i %>" <%
        if (Convert.ToInt64(i) == Convert.ToInt64(NYear))
        {
            Response.Write("selected");
        }
%>
><%= i %></option>
<%
    }
%>

			</select> 
			</td>
	<td width="21%" ><input type="button" value="更結報告" onClick="Report();" class="noborder">
	</td>    
</tr> 
   <tr bgcolor="#DFDFDF">

<td width="15%">日期 / 時間</td>
<td width="10%">更期</td>
<td width="15%">禮券編號</td>
<td width="10%">類型</td>
<td width="10%">產品</td>
<td width="10%">升數</td>
<td>銀碼</td>
<td>車牌</td>
</tr>
<%
    Total = 0;
    i = 0.0;
    if (frs.RecordCount > 0)
    {
        frs.AbsolutePage = Convert.ToInt32(pageid);
        while(Convert.ToBoolean((frs.PageSize - i)))
        {
            if (frs.Eof)
            {
                break;
            }
            i = i + 1.0;
            if (Convert.ToBoolean(flage))
            {
                mycolor = "#ffffff";
            }
            else
            {
                mycolor = "#efefef";
            }
%>

   <tr>
<%
            id = frs.Fields["id"].Value;
%>

<td width="30%">
<%= frs.Fields["Present_Date"].Value %>
</td>
<td>
<%
            if (Convert.ToInt32(frs.Fields["Period"].Value) == 11)
            {
                Response.Write("早");
            }
            else if( Convert.ToInt32(frs.Fields["Period"].Value) == 12)
            {
                Response.Write("中");
            }
            else if( Convert.ToInt32(frs.Fields["Period"].Value) == 13)
            {
                Response.Write("晚");
            }
%>

</td>
<td><%= frs.Fields["Coupon_Number"].Value %></td>
<td> <%= frs.Fields["Coupon_type"].Value %></td>
<td><%= frs.Fields["Product_Type"].Value %></td>
<td><%= String.Format("{0:0.00}", frs.Fields["SaleLitre"].Value)  %></td>
<td>
<%= frs.Fields["SaleAmount"].Value %>
<%
            Total = Total + Convert.ToInt32(frs.Fields["SaleAmount"].Value);
%>
   
</td>
<td><%= frs.Fields["Car_ID"].Value %></td>
</tr>
<%
            flage = ~flage;
            frs.MoveNext();
        }
    }
%>

<tr>
<td colspan = "6" align="right">Total:</td>
<td colspan= "2" align="left"><%= Total %></td>
</tr>                     </table>
                                </td>
                              </tr>
                              <tr class="noprint noborder"> 
                                <td align="right" height="28" > 
<span class="noprint noborder">
<%
    if (frs.RecordCount > 0)
    {
        countpage(frs.PageCount, pageid);
        Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        if (Convert.ToInt64(pageid) != 1)
        {
            Response.Write(" <a href=javascript:gtpage('1') style='cursor:hand' >First</a> ");
            Response.Write(" <a href=javascript:gtpage('" + Convert.ToString((Convert.ToDouble(pageid) - 1.0)) + "') style='cursor:hand' >Previous</a> ");
        }
        else
        {
            Response.Write(" First ");
            Response.Write(" Previous ");
        }
        if (Convert.ToInt64(pageid) != Convert.ToInt64(frs.PageCount))
        {
            Response.Write(" <a href=javascript:gtpage('" + Convert.ToString((Convert.ToDouble(pageid) + 1.0)) + "') style='cursor:hand' >Next</a> ");
            Response.Write(" <a href=javascript:gtpage('" + Convert.ToString(frs.PageCount) + "') style='cursor:hand' >Last</a> ");
        }
        else
        {
            Response.Write(" Next ");
            Response.Write(" Last ");
        }
        Response.Write("&nbsp;&nbsp;");
    }
%>

</span>
                                </td>
                              </tr>
                              <tr  class="noprint noborder"> 
                                <td height="28" align="center">
<span class="noprint noborder"> 
<input type="button" value="   打印   "  onClick="window.print();" class='common'>
<%
    if (Convert.ToInt32(SecLevel) > 1)
    {
%>

<input type="button" value="   CSV   "  onClick="window.doConvert();" class='common'>
<%
    }
%>

</span>
<%
    Response.Write("<input type=hidden value=" + pageid + " name=pageid>");
    frs.Close();
    frs = null;
  
%>

                                </td>
                              </tr>
                            </table>
            </div></div></div>
                          </form>     
    <script>
        function Report() {
            document.fm1.action = "DailyReport.aspx"
            document.fm1.submit();
        }
        function gtpage(what) {
            document.fm1.pageid.value = what;
            document.fm1.action = "DailyReport.aspx"
            document.fm1.submit();
        }

        function findenum() {
            document.fm1.action = "DailyReport.aspx"
            document.fm1.submit();
        }
        function doConvert() {
            window.open("ConvertReport.aspx?StationID=<%=StationID%>&SecLevel=<%=SecLevel%>&Sday=<%=SDay%>&SMonth=<%=SMonth%>&SYear=<%=SYear%>&NDay=<%=NDay%>&NMonth=<%=NMonth%>&NYear=<%=NYear%>&UserID=<%=UserID%>");

        }
        </script>


</html>
