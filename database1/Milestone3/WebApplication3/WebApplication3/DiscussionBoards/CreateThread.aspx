<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateThread.aspx.cs" Inherits="WebApplication3.DiscussionBoards.CreateThread" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 374px">
    <form id="form1" runat="server">
    <div style="height: 368px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
    
        <br />
        <br />
        <br />
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label1" runat="server" Text="Create Thread"></asp:Label>
        <br />
        <asp:Label ID="Label4" runat="server" Text="Discussion Board:"></asp:Label>
        <br />
        <asp:Label ID="Label5" runat="server" Text="School:"></asp:Label>
        <asp:Literal ID="StarterSchoolLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label6" runat="server" Text="DiscussionBoard Subject:"></asp:Label>
        <asp:Literal ID="dsubjectLiteral" runat="server"></asp:Literal>
        <br />
        <br />
        <asp:Label ID="ThreadSubjectLabel" runat="server" Text="Thread Subject:"></asp:Label>
&nbsp;<asp:TextBox ID="ThreadSubjectTextBox" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="subjectValidator" runat="server" ControlToValidate="ThreadSubjectTextBox" Enabled="False" ErrorMessage="subject required"></asp:RequiredFieldValidator>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Topic:"></asp:Label>
&nbsp;&nbsp;
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="TopicTextBox" runat="server" Height="95px" TextMode="MultiLine"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="CreateButton" runat="server" OnClick="CreateButton_Click" Text="Create" />
    
    </div>
    </form>
</body>
</html>
