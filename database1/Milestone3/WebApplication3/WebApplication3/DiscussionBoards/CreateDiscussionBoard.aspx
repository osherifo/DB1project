<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateDiscussionBoard.aspx.cs" Inherits="WebApplication3.DiscussionBoards.CreateDiscussionBoard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 287px">
    <form id="form1" runat="server">
    <div style="height: 287px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
    
        <br />
        <br />
        <br />
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label1" runat="server" Text="Create Discussion Board"></asp:Label>
        <br />
        <br />
        <asp:Label ID="Label2" runat="server" Text="Subject:"></asp:Label>
&nbsp;
        <asp:TextBox ID="SubjectTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="subjectValidator" runat="server" ControlToValidate="SubjectTextBox" Enabled="False" ErrorMessage="subject required"></asp:RequiredFieldValidator>
        <br />
        <asp:Button ID="CreateButton" runat="server" OnClick="CreateButton_Click" Text="Create" />
    
    </div>
    </form>
</body>
</html>
