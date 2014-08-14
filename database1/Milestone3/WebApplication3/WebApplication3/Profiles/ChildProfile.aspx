<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChildProfile.aspx.cs" Inherits="WebApplication3.Profiles.ChildProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    
    <style type="text/css">
        #form1 {
            height: 1219px;
        }
    </style>
</head>
<body style="height: 1224px">
    <form id="form1" runat="server">
    <div style="height: 1169px; width: 379px;  margin-top: 0px;float:left;margin-right: 10px;">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" Text="Log Out" OnClick="LogOutButton_Click" />
        <asp:Button ID="ReturnProfileButton" runat="server" OnClick="ReturnProfileButton_Click" Text="Return to Profile" Visible="False" />
        <br />
        <br />
        <br />
        <asp:Label ID="ChildNameLabel" runat="server" Text="Name:"></asp:Label>
        <asp:Literal ID="ChildNameLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="AgeLabel" runat="server" Text="Age:"></asp:Label>
        <asp:Literal ID="AgeLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="SchoolLabel" runat="server" Text="School:" Visible="False"></asp:Label>
        <asp:Literal ID="SchoolLiteral" runat="server" Visible="False"></asp:Literal>
        <br />
        <asp:Panel ID="ParentPanel" runat="server" Height="43px" ScrollBars="Vertical" Width="223px">
        </asp:Panel>
        <br />
        <br />
        <br />
    
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="date_time,poster,u_id" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="date_time" HeaderText="date_time" ReadOnly="True" SortExpression="date_time" />
                <asp:BoundField DataField="words" HeaderText="Post" SortExpression="words" />
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
            </Columns>
        </asp:GridView>
        <asp:TextBox ID="PostTextBox" runat="server" Height="87px" TextMode="MultiLine" Width="204px"></asp:TextBox>
        <br />
        <asp:Button ID="PostButton" runat="server" OnClick="PostButton_Click" Text="Post" />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_posts" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    
        <br />
        <br />
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2">
            <Columns>
                <asp:BoundField DataField="hobby" HeaderText="hobbies" SortExpression="hobby" />
            </Columns>
        </asp:GridView>
        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource3">
            <Columns>
                <asp:BoundField DataField="interest" HeaderText="interest" SortExpression="interest" />
            </Columns>
        </asp:GridView>
        <asp:TextBox ID="HobbyTextBox" runat="server" Visible="False"></asp:TextBox>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="SELECT [interest] FROM [Child_Interests] WHERE ([u_id] = @u_id)">
            <SelectParameters>
                <asp:QueryStringParameter Name="u_id" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Button ID="HobbyButton" runat="server" OnClick="HobbyButton_Click" Text="insert hobby" Visible="False" />
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="SELECT [hobby] FROM [Child_Hobbies] WHERE ([u_id] = @u_id)">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="" Name="u_id" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:TextBox ID="interestTextBox" runat="server" Visible="False"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="interestButton" runat="server" OnClick="interestButton_Click" Text="insert interest" Visible="False" />
    
    </div>
         <div style="float:right;
    margin-right:5px; height: 277px; margin-left: 137px; width: 299px; ">
                <asp:Button ID="ViewUsersButton" runat="server" OnClick="ViewUsersButton_Click" Text="View Users" Visible="False" />
                 <asp:Button ID="PendingfrButton" runat="server" OnClick="PendingfrButton_Click" Text="Pending friendship requests" Visible="False" />
                 <br />
                 <asp:Button ID="FriendsButton" runat="server" OnClick="FriendsButton_Click" Text="Friends" Visible="False" />
             <br />
                 <asp:Button ID="ViewParentsButton" runat="server" Text="View Parents" Visible="False" OnCommand="ViewParentsButton_Command" />
             <br />
                 <asp:TextBox ID="SearchTextBox" runat="server" Visible="False"></asp:TextBox>
                 <asp:Button ID="SearchButton" runat="server" OnClick="SearchButton_Click" Text="Search" Visible="False" />
             <asp:Button ID="ViewLDBButton" runat="server" OnClick="ViewLDBButton_Click" Text="View Linked Discussion Board" Visible="False" />
                <br />
                <asp:Button ID="PPButton" runat="server" OnClick="PPButton_Click" Text="Pending Parent Requests" Visible="False" />
                <br />
                <asp:Button ID="VLSButton" runat="server" OnClick="VLSButton_Click" Text="View Linked Schools" Visible="False" />
        </div>
    </form>
</body>
</html>
