<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Posts.aspx.cs" Inherits="WebApplication3.Profiles.Posts" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="height: 474px">
    <form id="form1" runat="server">
    <div style="height: 468px">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogoutButton" runat="server" OnClick="LogoutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
        <br />
        <asp:Button ID="Return2Button" runat="server" OnClick="Return2Button_Click" Text="Return to posted on profile" />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Poster"></asp:Label>
        <asp:Literal ID="PosterLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label2" runat="server" Text="Date-time"></asp:Label>
        <asp:Literal ID="DateTimeLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Post"></asp:Label>
        <asp:Literal ID="PostLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label4" runat="server" Text="Posted on:"></asp:Label>
        <asp:Literal ID="PostedOnLiteral" runat="server"></asp:Literal>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="commenter,date_time,poster,u_id" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="words" HeaderText="comment" SortExpression="words" />
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
            </Columns>
        </asp:GridView>
        <asp:TextBox ID="CommentTextBox" runat="server" Height="96px" TextMode="MultiLine"></asp:TextBox>
        <br />
        <asp:Button ID="AddCommentButton" runat="server" OnClick="AddCommentButton_Click" Text="Add Comment" />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_post_comments" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="poster" QueryStringField="poster" Type="Int32" />
                <asp:QueryStringParameter Name="dt" QueryStringField="dt" Type="DateTime" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
    </form>
</body>
</html>
