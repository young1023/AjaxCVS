<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="CouponVerification.aspx.cs" Inherits="CouponVerification" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>
 - 驗證系統 -
</title>
    <script src="include/js/JavaScript.js" charset="utf-8"></script>
     <link href="include/css/bootstrap.min.css" rel="stylesheet" />
     <link href="include/css/publish.css" rel="stylesheet" />
</head>
<%
    if (ProductType == "")
    {
%>


<body class="homepage" onload="document.barCodeForm.CarPlate.focus();">
<%
    }
    else
    {
%>

<body class="homepage" onload="document.barCodeForm.Barcode.focus();">
<%
    }
%>
   
<!--#include file="include/header.inc"-->
    <div class="container">
	<div class="row">
		<h1 class="Title align-c">驗證系統</h1>
		<div class="col-md-4 col-md-offset-4">
			<div class="pull-left mt10 mb10">

                      <a href="DailyReport.aspx">驗證紀錄</a>                 
            </div>
			<div class="pull-right mt10 mb10">

                      <a href="logout.aspx">登出</a>                 
            </div>
			<div class="clearfix"></div>
			<div class="login-background">
				 <form name="barCodeForm" method="post" id="barCodeForm" >
					<div class="form-group">
                        <label>車牌</label>
                        <input name="CarPlate" id="CarPlate" type=text value="<%= CarPlate %>" class="form-control" size="20" Maxlength = "20" autocomplete="off" onkeypress="return CommonKeyPressIsAlpha();">
                            <span id="report"></span>
                    </div>
					<div class="form-group">
						
                        <label>產品類型</label>
                    <select class="form-control" name="ProductType" id="ProductType">

                    <option value="53" <%
    if (ProductType == "53")
    {
%>
Selected<%
    }
%>
>無鉛</option>

                    <option value="52" <%
    if (ProductType == "52")
    {
%>
Selected<%
    }
%>
>油渣</option>

                    <option value="54" <%
    if (ProductType == "54")
    {
%>
Selected<%
    }
%>
>V 能量</option>

                    <option value="CS" <%
    if (ProductType == "CS")
    {
%>
Selected<%
    }
%>
>CS</option>

                    </select>
					</div>
                <div class="form-group">
						<label>禮券號碼 </label>
					
<input name="Barcode" class="form-control" type="text" autocomplete="off" value="" size="20" maxlength="15" id="bc" onkeypress="return numbersonly(event)">

<input name="StationID" id="StationID" type="hidden" value="<%= StationID %>">
            </div>
	            <input type="button"  class="btn btn-default text-right pull-right" onclick="CheckCoupon();" Name="Button" value="確定">

            <div id="msg" class="pull-left" style="padding-top: 6px;color: red;"></div>
                    
                     <div class="clearfix"></div>
                     <br/>
                    <div class="alert alert-success fade in" id="msgSuccess" style="display :none">       
                    </div>
                     <div class="alert alert-danger fade in" id="msgError" style="display :none">       
                    </div>
       </form>
			</div>
		</div>
	</div>
      
<div class="MessageDisplay">

</div>
          </div>

</body>
   <script src="include/js/jquery-1.11.3.min.js"></script>
<script type = "text/javascript">
    $('#msgSuccess').hide();
    $('#msgError').hide();

    $(function () {
        $("form input").keypress(function (e) {
            if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {

                CheckCoupon();
                return false;
            } else {
                return true;
            }
        });
    });
    function CheckCoupon() {
        $("#msg").html('');
       // alert($("#barCodeForm").serialize());
        //var data = $("#barCodeForm").serialize();
        var StationID = $("#StationID").val();
        var Barcode = $("#bc").val();
        var CarPlate = $("#CarPlate").val();
        var ProductType = $("#ProductType").val();


        if (mod10CheckDigit()) {
            $.ajax({
                type: "POST",
                url: "Execute.aspx/ExecuteCoupon",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ StationID: StationID, Barcode: Barcode, CarPlate: CarPlate, ProductType: ProductType }),
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                   // alert(response.d);
                }
            });
        }
    }
    function OnSuccess(response) {
        //  alert(response.d);
        var response = response.d;
        var arrayOfStrings = response.split('@'); 
        if (arrayOfStrings[0] == "驗證成功") {
            var date = new Date(arrayOfStrings[2]);
            
            var e = formatDate(date);
            $('#msgSuccess').show();
            $('#msgError').hide();

            var body = "驗證成功!<br/> <br/>" + "禮券編號: " + arrayOfStrings[1] + "<br/>驗證時間: " + e;
            $('#msgSuccess').html(body);
            $("#msg").html(response.d).css("color", "green");
$('#bc').val("");
                $('#bc').focus();
        }
        else {
            if (arrayOfStrings[0] == "驗證失敗 – 重複使用") {
                var date = new Date(arrayOfStrings[2]);                
                var e = formatDate(date);
                $('#msgSuccess').hide();
                $('#msgError').show();
                var body = "驗證失敗 – 重複使用!<br/> <br/>" + "禮券編號:: " + arrayOfStrings[1] + "<br/>已在 " + e + " 驗證!";
                $('#msgError').html(body);
                $('#bc').val("");
                $('#bc').focus();
            }
            else {
                $('#msgSuccess').hide();                
                $('#msgError').show();
                var body = arrayOfStrings[0];
                $('#msgError').html(body);
                $('#bc').val("");
                $('#bc').focus();
            }
        }
    }
</script>
    <script type="text/javascript">
        function numbersonly(e) {
            var unicode = e.charCode ? e.charCode : e.keyCode
            if (unicode != 8) { //if the key isn't the backspace key (which we should allow)
                if (unicode < 48 || unicode > 57) //if not a number
                    return false //disable key press
            }
        }
        function CommonKeyPressIsAlpha(e) {
            e = e || event;
            if (e.keyCode != 13) {
                var keypressed = String.fromCharCode(e.keyCode || e.which);
                var matched = (/^[0-9a-zA-Z\n]+$/).test(keypressed);

                document.getElementById('report').innerHTML =
                    matched ? "" : "Invalid character [<b>" +
                                     (keypressed || "unknown") +
                                   "</b>]. Valid input here: 'a-z' and/or 'A-Z' and/or '0-9'"

                return matched;
            }
            else {
                return true;
            }
        }
        function formatDate(date) {

            var my_month = new Date()
            var month_name = new Array(12);
            month_name[0] = "1";
            month_name[1] = "2";
            month_name[2] = "3";
            month_name[3] = "4";
            month_name[4] = "5";
            month_name[5] = "6";
            month_name[6] = "7";
            month_name[7] = "8";
            month_name[8] = "9";
            month_name[9] = "10";
            month_name[10] = "11";
            month_name[11] = "12";

            var hours = date.getHours();
            var minutes = date.getMinutes();
            var ampm = hours >= 12 ? '下午' : '上午';
            hours = hours % 12;
            hours = hours ? hours : 12; // the hour '0' should be '12'
            minutes = minutes < 10 ? '0' + minutes : minutes;
            var strTime = ampm + ' ' + hours + ':' + minutes;
            var month = date.getMonth();
            return  date.getFullYear() + "年" + month_name[month] + "月" + date.getDate() + "日" + strTime;
        }
</script>
</html>


