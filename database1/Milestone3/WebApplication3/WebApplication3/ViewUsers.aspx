<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewUsers.aspx.cs" Inherits="WebApplication3.ViewUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #form1 {
            height: 332px;
        }
    </style>
</head>
<body style="height: 322px">
    
        <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="SELECT [username] FROM [Users]"></asp:SqlDataSource>
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
            <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
            <br />
            <br />
    
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand" Width="131px">
                <Columns>
                    <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="AddButton" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="AddFriend" Text="Add" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="status"></asp:TemplateField>
                </Columns>
            </asp:GridView>
        </form>
    
</body>
</html>
