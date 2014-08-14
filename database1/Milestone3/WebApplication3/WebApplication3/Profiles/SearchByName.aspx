<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchByName.aspx.cs" Inherits="WebApplication3.Profiles.SearchByName" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 291px">
    <form id="form1" runat="server">
    <div style="height: 385px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
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
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="SendRequestButton" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="SendRequestCommand" Text="Send Request" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="status"></asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="search_by_name" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="name" QueryStringField="name" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
