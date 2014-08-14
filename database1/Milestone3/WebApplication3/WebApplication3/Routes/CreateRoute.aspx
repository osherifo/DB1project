<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateRoute.aspx.cs" Inherits="WebApplication3.Routes.CreateRoute" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #form1 {
            height: 364px;
        }
    </style>
</head>
<body style="height: 270px">
    <form id="form1" runat="server">
    <div>
    
    </div>
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
        <br />
        <br />
        <br />
        <asp:Label ID="CreateRouteLabel" runat="server" style="margin-left: 364px" Text="Create Route" Width="107px"></asp:Label>
        <br />
        <asp:Label ID="RouteLabel" runat="server" Text="Route Name:"></asp:Label>
&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="RouteNameTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="RouteNameTextBox" ErrorMessage="Route Name Required"></asp:RequiredFieldValidator>
        <br />
        <asp:Label ID="StartLabel" runat="server" Text="Start Location:"></asp:Label>
&nbsp;
        <asp:TextBox ID="StartTextBox" runat="server"></asp:TextBox>
        <br />
        <asp:Label ID="EndLabel" runat="server" Text="End Location:"></asp:Label>
&nbsp;&nbsp;
        <asp:TextBox ID="EndTextBox" runat="server"></asp:TextBox>
        <br />
        <asp:Label ID="MaxNumberLabel" runat="server" Text="Max Number:"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="MaxNumberTextBox" runat="server"></asp:TextBox>
        <br />
        <asp:Label ID="FrequencyLabel" runat="server" Text="Frequency:"></asp:Label>
&nbsp;&nbsp;
        <asp:DropDownList ID="FrequencyDropDownList" runat="server">
            <asp:ListItem>Daily</asp:ListItem>
            <asp:ListItem>Monthly</asp:ListItem>
            <asp:ListItem>Weekly</asp:ListItem>
        </asp:DropDownList>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="CreateButton" runat="server" OnClick="CreateButton_Click" Text="CREATE" />
    </form>
</body>
</html>
