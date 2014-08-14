<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Thread.aspx.cs" Inherits="WebApplication3.DiscussionBoards.Thread" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 582px">
    <form id="form1" runat="server">
    <div style="height: 585px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" style="height: 26px" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
    
        <br />
        <br />
        <asp:Button ID="DiscussionBoardReturnButton" runat="server" OnClick="DiscussionBoardReturnButton_Click" Text="Return to Discussion Board" />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Subject:"></asp:Label>
        <asp:Literal ID="thSubjectLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label2" runat="server" Text="Topic:"></asp:Label>
        <asp:Literal ID="thTopicLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Replies:"></asp:Label>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="school,d_subject,thread,r_id,u_id" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="d_subject" HeaderText="d_subject" ReadOnly="True" SortExpression="d_subject" />
                <asp:BoundField DataField="thread" HeaderText="thread" ReadOnly="True" SortExpression="thread" />
                <asp:BoundField DataField="r_id" HeaderText="r_id" SortExpression="r_id" ReadOnly="True" />
                <asp:BoundField DataField="reply" HeaderText="reply" SortExpression="reply" />
                <asp:BoundField DataField="date" HeaderText="date" SortExpression="date" />
                <asp:BoundField DataField="username" HeaderText="writer" SortExpression="username" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_replies" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="school" QueryStringField="sid" Type="Int32" />
                <asp:QueryStringParameter Name="dsubject" QueryStringField="subject" Type="String" />
                <asp:QueryStringParameter Name="thid" QueryStringField="thid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
        <asp:TextBox ID="ReplyTextBox" runat="server" Height="104px" TextMode="MultiLine" Width="168px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="replyValidator" runat="server" Enabled="False" ErrorMessage="reply required" ControlToValidate="ReplyTextBox"></asp:RequiredFieldValidator>
        <br />
        <asp:Button ID="ReplyButton" runat="server" OnClick="ReplyButton_Click" Text="Write Reply" />
        <br />
    
    </div>
    </form>
</body>
</html>
