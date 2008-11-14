visualbasic	code	<%@ Page Language="VB" %>
html	code	<html>
html	code	<script runat="server">
visualbasic	code	    Sub Button1_Click(ByVal sender As Object, _
visualbasic	code	        ByVal e As System.EventArgs)
visualbasic	code	        Label1.Text = "Welcome, " & TextBox1.Text
visualbasic	code	    End Sub
html	code	</script>
html	code	<head runat="server">
html	code	  <title>Basic ASP.NET Web Page</title>
html	code	</head>
html	code	<body>
html	code	  <form id="form1" runat="server">
html	code	    <h1>Welcome to ASP.NET</h1>
html	code	    <p>Type your name and click the button.</p>
html	code	    <p>
html	code	      <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
html	code	      <asp:Button ID="Button1" runat="server" 
html	code	        Text="Click" OnClick="Button1_Click" />
html	code	    </p>
html	code	    <p>
html	code	      <asp:Label ID="Label1" runat="server"></asp:Label>
html	code	    </p>
html	code	  </form>
html	code	</body>
html	code	</html>
