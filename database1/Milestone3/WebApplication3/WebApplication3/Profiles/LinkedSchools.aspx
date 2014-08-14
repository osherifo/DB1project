<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LinkedSchools.aspx.cs" Inherits="WebApplication3.Profiles.LinkedSchools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="height: 339px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" OnClick="LogOutButton_Click" Text="Logout" />
        <asp:Button ID="ReturnProfileButton" runat="server" OnClick="ReturnProfileButton_Click" Text="Return to Profile" />
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="VisitProfileCommand" Text="Visit Profile" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_linked_schools" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
