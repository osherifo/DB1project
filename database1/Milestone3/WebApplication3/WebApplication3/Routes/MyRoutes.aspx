<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyRoutes.aspx.cs" Inherits="WebApplication3.Routes.MyRoutes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 1002px">
    <form id="form1" runat="server">
    <div style="height: 990px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" OnClick="LogOutButton_Click" Text="Logout" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Pending"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <br />
        <asp:GridView ID="PendingGridView" runat="server" AutoGenerateColumns="False" DataSourceID="PendingSqlDataSource" OnRowCommand="PendingGridView_RowCommand">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
                <asp:BoundField DataField="r_name" HeaderText="r_name" SortExpression="r_name" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="AcceptCommand" Text="Accept" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button2" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="RejectCommand" Text="Reject" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="status"></asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="PendingSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="view_pending_route_requests" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <br />
        <asp:Label ID="Label2" runat="server" Text="created"></asp:Label>
        <br />
        <asp:GridView ID="CreatorGridView" runat="server" AutoGenerateColumns="False" DataSourceID="CreatedSqlDataSource" OnRowCommand="CreatorGridView_RowCommand">
            <Columns>
                <asp:BoundField DataField="r_name" HeaderText="r_name" SortExpression="r_name" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button3" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="ViewRouteCommand" Text="View Route" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="CreatedSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="view_created_routes" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <br />
&nbsp;&nbsp;
        <asp:Label ID="Label3" runat="server" Text="Invited"></asp:Label>
        <br />
        <asp:GridView ID="InvitedGridView" runat="server" AutoGenerateColumns="False" DataSourceID="InvitedSqlDataSource" OnRowCommand="InvitedGridView_RowCommand">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="creator" SortExpression="username" />
                <asp:BoundField DataField="r_name" HeaderText="r_name" SortExpression="r_name" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button4" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="ViewRouteCommand" Text="View Route" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="InvitedSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="view_accepted_route_requests" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
