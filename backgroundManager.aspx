<%@ Page Language="C#" AutoEventWireup="true" CodeFile="backgroundManager.aspx.cs" Inherits="backgroundManager" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div style="float:left"><asp:Button ID="Button1" runat="server" Text="创建菜单" OnClick="Button1_Click" /></div>
        <div>&nbsp;&nbsp;<asp:Label ID="Label1" runat="server" Text=""></asp:Label></div>
    </div>
    </form>
</body>
</html>
