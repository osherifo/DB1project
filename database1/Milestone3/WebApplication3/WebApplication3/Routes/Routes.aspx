<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Routes.aspx.cs" Inherits="WebApplication3.Routes.Routes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 291px">
    <form id="form1" runat="server">
    <div style="height: 279px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
        <br />
        <br />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Route Name:"></asp:Label>
        <asp:Literal ID="RouteNameLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label2" runat="server" Text="Creator:"></asp:Label>
        <asp:Literal ID="CreatorLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Start Location:"></asp:Label>
        <asp:Literal ID="StartLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label4" runat="server" Text="End Location:"></asp:Label>
        <asp:Literal ID="EndLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label5" runat="server" Text="Frequency:"></asp:Label>
        <asp:Literal ID="FrequencyLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label6" runat="server" Text="Max Number:"></asp:Label>
        <asp:Literal ID="MaxNumberLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label7" runat="server" Text="Free slots:"></asp:Label>
        <asp:Literal ID="FreeSlotsLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="InviteButton" runat="server" Text="Invite Friends" OnClick="InviteButton_Click" Visible="False" />
        <asp:Literal ID="NoSpaceLiteral" runat="server" Text="Sorry But this Route is already full" Visible="False"></asp:Literal>
        <br />
    
    </div>
    </form>
</body>
</html>
