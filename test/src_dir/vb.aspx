<%@ Page Language="VB" %>
<html>
<script runat="server">
    Sub Button1_Click(ByVal sender As Object, _
        ByVal e As System.EventArgs)
        Label1.Text = "Welcome, " & TextBox1.Text
    End Sub
</script>
<head runat="server">
  <title>Basic ASP.NET Web Page</title>
</head>
<body>
  <form id="form1" runat="server">
    <h1>Welcome to ASP.NET</h1>
    <p>Type your name and click the button.</p>
    <p>
      <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
      <asp:Button ID="Button1" runat="server" 
        Text="Click" OnClick="Button1_Click" />
    </p>
    <p>
      <asp:Label ID="Label1" runat="server"></asp:Label>
    </p>
  </form>
</body>
</html>
