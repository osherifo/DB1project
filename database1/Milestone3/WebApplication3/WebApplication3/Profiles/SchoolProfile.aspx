<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SchoolProfile.aspx.cs" Inherits="WebApplication3.Profiles.SchoolProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        #form1 {
            width: 837px;
            height: 660px;
        }
    </style>
</head>
<body style="width: 302px">
    <form id="form1" runat="server">
    <div style="height: 574px; margin-top: 0px;float:left; margin-right: 10px;">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" OnClick="LogOutButton_Click" Text="Log Out" />
        <asp:Button ID="ReturnButton" runat="server" OnClick="ReturnButton_Click" Text="Return To Profile" />
        <br />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="School Name:"></asp:Label>
        <asp:Literal ID="SchoolNameLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label2" runat="server" Text="Educational System:"></asp:Label>
        <asp:Literal ID="EdSystemLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="Label3" runat="server" Text="Address:"></asp:Label>
        <asp:Literal ID="AddressLiteral" runat="server"></asp:Literal>
        <br />
        <br />
        <br />
        <br />
    
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="date_time,poster,u_id" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="poster" SortExpression="username" />
                <asp:BoundField DataField="date_time" HeaderText="date_time" ReadOnly="True" SortExpression="date_time" />
                <asp:BoundField DataField="words" HeaderText="Post" SortExpression="words" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="ViewPostCommand" Text="View Post" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <asp:TextBox ID="PostTextBox" runat="server" Height="114px" TextMode="MultiLine" Width="209px"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="PostButton" runat="server" OnClick="PostButton_Click" Text="Post" />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_posts" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="" Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    
    </div>
          <div style="float:right;
    margin-right:5px; height: 376px; margin-left: 137px;">
            <p >
                <asp:Button ID="ViewUsersButton" runat="server" OnClick="ViewUsersButton_Click" Text="View Users" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="PendingfrButton" runat="server" OnClick="PendingfrButton_Click" Text="Pending friendship requests" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="CreateDBButton" runat="server" Text="Create Discussion Board" Visible="False" OnClick="CreateDBButton_Click" />
             </p>
              <p >
                 <asp:Button ID="PendingcrButton" runat="server" OnClick="PendingcrButton_Click" Text="Pending child requests" Visible="False" />
             </p>
              <p >
                  <asp:Button ID="ViewLDBButton" runat="server" OnClick="ViewLDBButton_Click" Text="View Linked Discussion Board" Visible="False" />
             </p>
              <p >
                 <asp:Button ID="FriendsButton" runat="server" OnClick="FriendsButton_Click" Text="Friends" Visible="False" />
             </p>
              <p >
                 <asp:TextBox ID="SearchTextBox" runat="server" Visible="False"></asp:TextBox>
                 <asp:Button ID="SearchButton" runat="server" OnClick="SearchButton_Click" Text="Search" Visible="False" />
             </p>
              <p >
                  &nbsp;</p>

        </div>
    </form>
</body>
</html>
