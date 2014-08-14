<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PendingChildParentRequests.aspx.cs" Inherits="WebApplication3.Profiles.PendingChildParentRequests" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #form1 {
            height: 328px;
        }
    </style>
</head>
<body style="height: 338px">
    <form id="form1" runat="server">
    <div style="height: 285px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
            <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
            <br />
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button2" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="AcceptCommand" Text="Accept" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button3" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="RejectCommand" Text="Reject" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="status"></asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="pending_child_parent_requests" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
                <asp:QueryStringParameter Name="requestertype" QueryStringField="type" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
