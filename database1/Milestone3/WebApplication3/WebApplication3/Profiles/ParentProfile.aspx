<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ParentProfile.aspx.cs" Inherits="WebApplication3.Profiles.ParentProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    	<link type="text/css" rel="stylesheet" href="stylesheet1.css"/>
    <title>

    </title>
    <style type="text/css">
        #form1 {
            height: 879px;
            }
    </style>
</head>
<body style="height: 882px">
    <form id="form1" runat="server">
    <div style="height: 369px; margin-top: 0px;float:left">
    
        <asp:Literal ID="LoggedinLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Button ID="LogOutButton" runat="server" OnClick="LogOutButton_Click" Text="Logout" />
        <asp:Button ID="ReturnProfileButton" runat="server" OnClick="ReturnProfileButton_Click" Text="Return to Profile" Visible="False" />
        <br />
        <br />
        <asp:Label ID="nameLabel" runat="server" Text="Name:"></asp:Label>
        <asp:Literal ID="NameLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="nameLabel0" runat="server" Text="Job:"></asp:Label>
        <asp:Literal ID="JobLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="nameLabel1" runat="server" Text="Email:"></asp:Label>
        <asp:Literal ID="EmailLiteral" runat="server"></asp:Literal>
        <br />
        <asp:Label ID="nameLabel2" runat="server" Text="Address:"></asp:Label>
        <asp:Literal ID="AdressLiteral" runat="server"></asp:Literal>
        <br />
       
  
        <br />
        <br />
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" Height="86px">
            <Columns>
                <asp:BoundField DataField="phone" HeaderText="phone" SortExpression="phone" />
            </Columns>
        </asp:GridView>
        <asp:TextBox ID="PhoneTextBox" runat="server" Visible="False"></asp:TextBox>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="SELECT [phone] FROM [Parent_Phones] WHERE ([parent] = @parent)">
            <SelectParameters>
                <asp:QueryStringParameter Name="parent" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Button ID="PhoneButton" runat="server" OnClick="PhoneButton_Click" Text="Enter Phone" Visible="False" />
        <br />
        <br />
        <br />
        <br />
        <br />
       
  
    </div>
         <div style="float:right;
    margin-right:5px; height: 545px; margin-left: 137px;">
            <p >
                <asp:Button ID="ViewUsersButton" runat="server" OnClick="ViewUsersButton_Click" Text="View Users" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="PendingfrButton" runat="server" OnClick="PendingfrButton_Click" Text="Pending friendship requests" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="PendingriButton" runat="server" OnClick="PendingfrButton_Click" Text="Pending Route Invitations" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="CreateRouteButton" runat="server" OnClick="CreateRouteButton_Click" Text="Create Route" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="MyRoutesButton" runat="server" Text="My Routes" Visible="False" OnClick="MyRoutesButton_Click" />
             </p>
             <p >
                 <asp:Button ID="FriendsButton" runat="server" OnClick="FriendsButton_Click" Text="Friends" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="ViewChildrenButton" runat="server" OnClick="ViewChildrenButton_Click" Text="View Children" Visible="False" />
             </p>
             <p >
                 <asp:TextBox ID="SearchTextBox" runat="server" Visible="False"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <asp:Button ID="SearchButton" runat="server" OnClick="SearchButton_Click" Text="Search" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="ViewLDBButton" runat="server" OnClick="ViewLDBButton_Click" Text="View Linked Discussion Board" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="PCHRButton" runat="server" OnClick="PCHRButton_Click" Text="Pending Child Requests" Visible="False" />
             </p>
             <p >
                 <asp:Button ID="VLSButton" runat="server" OnClick="VLSButton_Click" Text="View Linked Schools" Visible="False" />
             </p>

        </div>
       
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="date_time,poster,u_id" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand" style="margin-top: 111px">
            <Columns>
                <asp:BoundField DataField="username" HeaderText="Poster" SortExpression="username" />
                <asp:BoundField DataField="date_time" HeaderText="date_time" ReadOnly="True" SortExpression="date_time" />
                <asp:BoundField DataField="words" HeaderText="Post" SortExpression="words" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="Button1" runat="server" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" CommandName="ViewPostCommand" Text="View Post" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:TextBox ID="PostTextBox" runat="server" Height="96px" TextMode="MultiLine"></asp:TextBox>
        <br />
        <asp:Button ID="PostButton" runat="server" OnClick="PostButton_Click" Text="Post" />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySchoolCommunityConnectionString %>" SelectCommand="get_posts" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="uid" QueryStringField="uid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
       
    </form> 
</body>
</html>
