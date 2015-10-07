<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CouponCheck.aspx.cs" Inherits="CouponCheck" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>
 - 禮券驗證系統 (澳門) -
</title>
    <link rel="stylesheet" type="text/css" media="all" href="include/publish.css" />
<link rel="shortcut icon" href="images/favicon.ico" />
    <script src="include/JavaScript.js"></script>
</head>
<body class="homepage" onload="document.barCodeForm.Barcode.focus();">

<form name="barCodeForm" method="post" action="" onSubmit="javascript:return mod10CheckDigit();">

<div align="center">

<h1 class="Title">禮券驗證系統 (澳門)</h1>


<table width="60%" border="0" cellpadding="04" cellspacing="0" class="Report">

      <tr>

              <td>

                      <a href="DailyReport.aspx">驗證紀錄</a>                 

              </td>

               <td>

                      <a href="logout.aspx">登出</a>                 

              </td>

      </tr>

</table>

<br/>



<table width="60%" border="0"  cellpadding="04" cellspacing="2" class="Login">

        

    <tr>

	    <td width="23%">禮券號碼 

        </td> 

		<td width="37%">

					
<input name="Barcode" type="text" autocomplete="off" value="" size="20" maxlength="15" id="bc" ">


	<input type="Submit" Name="Button" value="確定">


        </td>

     </tr>


</table>

</div>

</form>

<div id="myDiv"></div>

</body>
</html>
