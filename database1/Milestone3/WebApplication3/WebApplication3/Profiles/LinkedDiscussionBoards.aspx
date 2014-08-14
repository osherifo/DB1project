<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LinkedDiscussionBoards.aspx.cs" Inherits="WebApplication3.Profiles.LinkedDiscussionBoards" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 409px">
    <form id="form1" runat="server">
    <div style="height: 378px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" OnClick="LogOutButton_Click" Text="Logout" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" Visible="False" />
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="subject,school,u_id" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="subject" HeaderText="subject" ReadOnly="True" SortExpression="subject" />
                <asp:BoundField DataField="username" HeaderText="school" SortExpression="username" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="ViewDBCommand" Text="View Discussion Board" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_linked_discussion_boards" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <br />
        <br />
        <br />
    
    </div>
    </form>
</body>
</html>
