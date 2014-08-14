<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DiscussionBoard.aspx.cs" Inherits="WebApplication3.DiscussionBoards.DiscussionBoard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="height: 415px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" style="height: 26px" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
    
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Discussion subject:"></asp:Label>
        <asp:Literal ID="dsubjectLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label2" runat="server" Text="School:"></asp:Label>
        <asp:Literal ID="schoolLiteral" runat="server"></asp:Literal>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="d_subject,school,th_id,u_id" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="d_subject" HeaderText="d_subject" ReadOnly="True" SortExpression="d_subject" />
                <asp:BoundField DataField="th_id" HeaderText="th_id" SortExpression="th_id" ReadOnly="True" />
                <asp:BoundField DataField="subject" HeaderText="subject" SortExpression="subject" />
                <asp:BoundField DataField="username" HeaderText="starter" SortExpression="username" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="VisitThreadCommand" Text="Visit Thread" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_threads" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="school" QueryStringField="sid" Type="Int32" />
                <asp:QueryStringParameter Name="subject" QueryStringField="subject" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <asp:Button ID="CreateThreadButton" runat="server" OnClick="CreateThreadButton_Click" Text="Create new Thread" />
    
    </div>
    </form>
</body>
</html>
