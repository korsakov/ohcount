<%@ Page Language="C#" %>
<html>
<script runat="server">
void Button1_Click(object sender, System.EventArgs e)
{
    Label1.Text = ("Welcome, " + TextBox1.Text);
}
</script>
<head runat="server">
  <title>Basic ASP.NET Web Page</title>
</head>
<body>
  <%if( ViewData["Message"] != null ){ %>
    <h3 style="color:Red"><%=ViewData["Message"]%></h3><br />
  <% } %>
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
