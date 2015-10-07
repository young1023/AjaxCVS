<%@ Page language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Client.Default_aspx_cs" Debug="true"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

 <head runat="server">
    <title>
  - 驗證系統 -
</title>
      <link rel="stylesheet" type="text/css" media="all" href="include/publish.css" />
     <script src="include/js/JavaScript.js"></script>
     <script src="include/js/jquery-1.11.3.min.js"></script>
     <link href="include/css/bootstrap.min.css" rel="stylesheet" />
     <link href="include/css/publish.css" rel="stylesheet" />
</head>
<body style="background:#F7F7F7;" class="homepage" onload="document.fm1.UserID.focus();">
   <form name="fm1" method="post" action="">
<div class="container">
	<div class="row">

<h1 class="Title align-c"> - 驗證系統 -</h1>

<div class="col-md-4 col-md-offset-4">
			<div class="login-background mt10">
				<form>
					<div class="form-group">
                        <label>編號 : <%= StationID %> </label>      
       
	                 </div>
					<div class="form-group">
						<label>用戶編號</label>

            			<input class="form-control" name="UserID" type=text value="11" size="20" <%
                        if (Alert != "")
                        {
                    %>
                    Readonly<%
                        }
                    %>
                     autocomplete="off">
                        </div>
        <div class="form-group">
						<label>用戶密碼</label>

			<input name="Password" type=password value="11"  class="form-control" size="20" autocomplete="off" <%
    if (Alert != "")
    {
%>
Readonly<%
    }
%>
>

       </div>
   <input Type="Button" Name=" 確定 " value="   確定   " onClick="doLogin();" class="btn btn-default pull-right"input Type="Button" Name=" 確定 " value="   確定   " onClick="doLogin();" class="btn btn-default pull-right"<%
    if (Alert != "")
    {
%>
disabled<%
    }
%>
>

       <div class="clearfix"></div>
                    <br/>
                   
                    <div class="form-group text-center">
            <p>This is the testing server.</p>
             <p>Data are for testing purpose only.</p>

       </div>
				</form>
        
                       </div>
    <br/>
    <%
    if (Message == "Fail")
    {%>
		  <div class="alert alert-danger fade in" id="msgError" >  
                     <div class="Message1">
    <%     Response.Write("用戶編號或密碼不正確");%> 

                    </div>
           </div>
     <%  }
    else if (Alert != "")
    {%>
		  <div class="alert alert-danger fade in" id="msgError" >  
                     <div class="Message1">
    <%  Response.Write(Alert);   %>
                    </div>
        </div>
     <% 
    }
   
%>


    
</div>
       
        </div>
    </div>
   
</form>

    <script>
        $(function () {
            $("form input").keypress(function (e) {
                if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
                   
                    doLogin();
                    return false;
                } else {
                    return true;
                }
            });
        });
        </script>
</body>
</html>
