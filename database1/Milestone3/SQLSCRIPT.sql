SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[advertiser_contracted_school]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[advertiser_contracted_school](@a_id INT,@s_id INT) RETURNS BIT
AS 
BEGIN
DECLARE @return BIT
IF (EXISTS(SELECT * FROM Advertiser_incontract_School WHERE advertiser=@a_id AND school=@s_id))
SET @return=''1''
ELSE SET @return=''0''
RETURN @return
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[valid_supervisor]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[valid_supervisor](@supervisor INT,@s_name VARCHAR(20),@club_id INT) RETURNS BIT
AS 
BEGIN
DECLARE @return BIT
DECLARE @house_number INT
DECLARE @st_name VARCHAR(20)
DECLARE @area VARCHAR(20)
DECLARE @country VARCHAR(20)
DECLARE @admin INT
SELECT @admin=c.admin FROM Clubs c WHERE c.club_id=@club_id
SELECT @house_number=s.house_number,@st_name=s.st_name,@area=s.area,@country=s.country FROM Sports s
WHERE s.s_name=@s_name AND s.club_id=@club_id
IF (EXISTS(SELECT * FROM Schools school WHERE school.house_number=@house_number AND school.st_name=@st_name AND
school.area=@area AND school.country=@country AND school.u_id=@supervisor))
SET @return=''1''
ELSE IF(@admin=@supervisor)
SET @return=''1''
ELSE SET @return=''0''
RETURN @return 
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[are_friends]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[are_friends](@user1 INT,@user2 INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS(SELECT * FROM User1_freq_User2 freq WHERE freq.status=''1'' AND ((freq.sender=@user1 AND freq.receiver=@user2)OR(
freq.sender=@user2 AND freq.receiver=@user1) )))
SET @return=''1''
ELSE 
SET @return=''0''
RETURN @return
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invited_to_event]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[invited_to_event](@receiver INT,@creator INT,@e_name INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM User_invites_User_Event invite WHERE invite.receiver=@receiver AND invite.creator=@creator AND 
invite.e_name=@e_name ))
SET @return=''1''
ELSE SET @return=''0''
RETURN @return
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[thread_count]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[thread_count] (@school INT,@d_subject VARCHAR(20))
RETURNS INT 
AS
BEGIN
DECLARE @count INT
SELECT @count=COUNT(*)
FROM Threads t 
WHERE 
t.school=@school AND t.d_subject=@d_subject
RETURN @count+1
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reply_count]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[reply_count] (@school INT,@d_subject VARCHAR(20),@thread INT)
RETURNS INT 
AS
BEGIN
DECLARE @count INT
SELECT @count=COUNT(*)
FROM Replies r 
WHERE 
r.school=@school AND r.d_subject=@d_subject AND r.thread=@thread
RETURN @count+1
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[u_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](20) NULL,
	[password] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Quizzes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Quizzes](
	[quiz_name] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[quiz_name] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_profile_school]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[view_profile_school] @user INT
AS 
BEGIN
SELECT * 
FROM Users u 
INNER JOIN Schools s ON u.u_id=s.u_id 
INNER JOIN Children c ON u.u_id=c.school_id 
INNER JOIN Pictures pics ON u.u_id=pics.posted_on_user
INNER JOIN Photo_tags phototags ON pics.date_time=phototags.date_time AND pics.uploader=phototags.uploader
INNER JOIN Picture_commented_User piccomments ON pics.date_time=piccomments.date_time AND pics.uploader=piccomments.uploader
INNER JOIN Picture_tags_User1_User2 taggedpics ON  taggedpics.tagged = u.u_id
INNER JOIN Photo_tags phototags2 ON taggedpics.date_time=phototags2.date_time AND taggedpics.uploader=phototags2.uploader
INNER JOIN Picture_commented_User piccomments2 ON taggedpics.date_time=piccomments2.date_time AND taggedpics.uploader=piccomments2.uploader   
INNER JOIN Posts p ON u.u_id=p.posted_on_user 
INNER JOIN Post_commented_User postcomments ON p.date_time=postcomments.date_time AND p.poster=postcomments.poster
INNER JOIN User1_freq_User2 freq1 ON (u.u_id=freq1.sender) 
INNER JOIN User1_freq_User2 freq2 ON (u.u_id=freq2.receiver)
INNER JOIN Discussion_boards d ON u.u_id=d.school
INNER JOIN Sports sports ON u.u_id=sports.supervisor
INNER JOIN Advertisment_shownby_School ashowns ON ashowns.school=u.u_id
INNER JOIN Advertiments ads ON ashowns.advertiser=ads.a_id AND ashowns.advertisment=ads.ad_id
INNER JOIN Advertisment_Pictures adpics ON adpics.ad_id=ads.ad_id AND adpics.a_id=adpics.a_id 
WHERE u.u_id=@user AND freq1.status=''1'' AND
freq2.status=''1'' AND c.school_status=''1''
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Advertisers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Advertisers](
	[a_id] [int] IDENTITY(1,1) NOT NULL,
	[a_name] [varchar](15) NULL,
	[field] [varchar](15) NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[a_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[a_name] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_advertiser_phone]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[add_advertiser_phone] @aid INT,@phone INT
AS
BEGIN
INSERT INTO Advertiser_Phones VALUES (@aid,@phone)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accept_reject_event]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[accept_reject_event] @sender INT , @receiver INT ,@creator INT, @e_name VARCHAR(50) , @status BIT
AS
BEGIN
UPDATE Event_invites_User 
SET status= @status
WHERE sender=@sender AND receiver=@receiver AND creator=@creator AND e_name=@e_name
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_age]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[get_age](@birth_date SMALLDATETIME) RETURNS INT
AS
BEGIN
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
RETURN @age
END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[young_teenager]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[young_teenager](@birth_date SMALLDATETIME) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
IF(@age<12)
SET @return =''0''
ELSE
SET @return=''1''
RETURN @return
END

' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parent_of_child]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[parent_of_child](@parent INT,@child INT) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM Child_of_Parent WHERE parent=@parent AND child = @child AND status=''1''))
SET @return=''1''
ELSE 
SET @return=''0''
RETURN @return
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[valid_age]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[valid_age](@birth_date SMALLDATETIME) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
IF(@age<20 AND @age>3)
SET @return =''1''
ELSE
SET @return=''0''
RETURN @return
END

' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_type]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[user_type](@u_id INT)RETURNS CHAR(1)
AS
BEGIN
DECLARE @return CHAR(1)
IF(EXISTS (SELECT * FROM Children c WHERE @u_id=c.u_id))
SET @return=''C''
ELSE IF(EXISTS (SELECT * FROM Parents p WHERE @u_id=p.u_id))
SET @return=''P''
ELSE IF(EXISTS (SELECT * FROM Schools s WHERE @u_id=s.u_id))
SET @return=''S''
ELSE IF(EXISTS (SELECT * FROM Experts e WHERE @u_id=e.u_id))
SET @return=''E''
RETURN @return
END
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Route_stops]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Route_stops](
	[r_name] [varchar](20) NOT NULL,
	[creator] [int] NOT NULL,
	[stop] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[r_name] ASC,
	[creator] ASC,
	[stop] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clubs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Clubs](
	[club_id] [int] IDENTITY(1,1) NOT NULL,
	[club_name] [varchar](20) NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
	[opening_time] [smalldatetime] NULL,
	[closing_time] [smalldatetime] NULL,
	[fees] [int] NULL,
	[admin] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User1_freq_User2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User1_freq_User2](
	[sender] [int] NOT NULL,
	[receiver] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[sender] ASC,
	[receiver] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Parents](
	[u_id] [int] NOT NULL,
	[email] [varchar](50) NULL,
	[job] [varchar](20) NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Question_answered_by_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Question_answered_by_User](
	[answerer] [int] NOT NULL,
	[quiz] [varchar](20) NOT NULL,
	[question] [varchar](20) NOT NULL,
	[answer] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[answerer] ASC,
	[quiz] ASC,
	[question] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Schools]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Schools](
	[u_id] [int] NOT NULL,
	[ed_system] [varchar](20) NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Club_joinedby_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Club_joinedby_User](
	[joiner] [int] NOT NULL,
	[club_id] [int] NOT NULL,
	[user_club_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[joiner] ASC,
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_club_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Experts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Experts](
	[u_id] [int] NOT NULL,
	[email] [varchar](50) NULL,
	[field] [varchar](15) NULL,
	[degree] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Threads]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Threads](
	[d_subject] [varchar](20) NOT NULL,
	[school] [int] NOT NULL,
	[th_id] [int] NOT NULL,
	[subject] [varchar](20) NULL,
	[topic] [varchar](2000) NULL,
	[starter] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[d_subject] ASC,
	[school] ASC,
	[th_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Events]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Events](
	[creator] [int] NOT NULL,
	[e_name] [varchar](50) NOT NULL,
	[date_time] [smalldatetime] NULL,
	[dsc] [varchar](500) NULL,
	[e_type] [varchar](20) NULL,
	[purpose] [varchar](500) NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
	[organizer] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[creator] ASC,
	[e_name] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Picture_commented_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Picture_commented_User](
	[commenter] [int] NOT NULL,
	[date_time] [smalldatetime] NOT NULL,
	[uploader] [int] NOT NULL,
	[words] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[commenter] ASC,
	[date_time] ASC,
	[uploader] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Picture_tags_User1_User2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Picture_tags_User1_User2](
	[tagger] [int] NOT NULL,
	[tagged] [int] NOT NULL,
	[date_time] [smalldatetime] NOT NULL,
	[uploader] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tagger] ASC,
	[tagged] ASC,
	[date_time] ASC,
	[uploader] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[tagged] ASC,
	[date_time] ASC,
	[uploader] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Replies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Replies](
	[school] [int] NOT NULL,
	[d_subject] [varchar](20) NOT NULL,
	[thread] [int] NOT NULL,
	[r_id] [int] NOT NULL,
	[reply] [varchar](2000) NULL,
	[date] [smalldatetime] NULL,
	[writer] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[school] ASC,
	[d_subject] ASC,
	[thread] ASC,
	[r_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pictures]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Pictures](
	[date_time] [smalldatetime] NOT NULL,
	[uploader] [int] NOT NULL,
	[photo] [varchar](50) NULL,
	[words] [varchar](200) NULL,
	[date_taken] [smalldatetime] NULL,
	[posted_on_user] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[date_time] ASC,
	[uploader] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Posts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Posts](
	[date_time] [smalldatetime] NOT NULL,
	[poster] [int] NOT NULL,
	[words] [varchar](200) NULL,
	[posted_on_user] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[date_time] ASC,
	[poster] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Post_commented_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Post_commented_User](
	[commenter] [int] NOT NULL,
	[date_time] [smalldatetime] NOT NULL,
	[poster] [int] NOT NULL,
	[words] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[commenter] ASC,
	[date_time] ASC,
	[poster] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Club_activities]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Club_activities](
	[club_id] [int] NOT NULL,
	[activity] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[club_id] ASC,
	[activity] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Expert_invited_by_School]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Expert_invited_by_School](
	[expert] [int] NOT NULL,
	[school] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[expert] ASC,
	[school] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Discussion_Boards]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Discussion_Boards](
	[subject] [varchar](20) NOT NULL,
	[school] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[subject] ASC,
	[school] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Advertiser_incontract_School]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Advertiser_incontract_School](
	[advertiser] [int] NOT NULL,
	[school] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[advertiser] ASC,
	[school] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Advertisment_shownby_School]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Advertisment_shownby_School](
	[advertisment] [int] NOT NULL,
	[advertiser] [int] NOT NULL,
	[school] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[advertisment] ASC,
	[advertiser] ASC,
	[school] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Child_of_Parent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Child_of_Parent](
	[parent] [int] NOT NULL DEFAULT ('NOT LISTED'),
	[child] [int] NOT NULL DEFAULT ('NOT LISTED'),
	[status] [bit] NULL,
	[sender] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[parent] ASC,
	[child] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Child_Interests]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Child_Interests](
	[u_id] [int] NOT NULL,
	[interest] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC,
	[interest] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Child_Hobbies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Child_Hobbies](
	[u_id] [int] NOT NULL,
	[hobby] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC,
	[hobby] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Questions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Questions](
	[quiz_name] [varchar](20) NOT NULL,
	[question_name] [varchar](20) NOT NULL,
	[question] [varchar](2000) NULL,
	[answer] [varchar](1000) NULL,
	[min_age] [int] NULL,
	[max_age] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[quiz_name] ASC,
	[question_name] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parent_Phones]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Parent_Phones](
	[parent] [int] NOT NULL,
	[phone] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[parent] ASC,
	[phone] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Routes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Routes](
	[r_name] [varchar](20) NOT NULL,
	[creator] [int] NOT NULL,
	[start_location] [varchar](100) NULL,
	[end_location] [varchar](100) NULL,
	[frequency] [varchar](50) NULL,
	[max_number] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[r_name] ASC,
	[creator] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provided_Hobbies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Provided_Hobbies](
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[hobby] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[parent] ASC,
	[child] ASC,
	[hobby] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provided_Interests]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Provided_Interests](
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[interest] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[parent] ASC,
	[child] ASC,
	[interest] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Experts_taggedin_Threads]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Experts_taggedin_Threads](
	[expert] [int] NOT NULL,
	[school] [int] NOT NULL,
	[d_subject] [varchar](20) NOT NULL,
	[thread] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[expert] ASC,
	[school] ASC,
	[d_subject] ASC,
	[thread] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Advertisments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Advertisments](
	[ad_id] [int] IDENTITY(1,1) NOT NULL,
	[a_id] [int] NOT NULL,
	[ad] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[ad_id] ASC,
	[a_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Avertiser_Phones]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Avertiser_Phones](
	[a_id] [int] NOT NULL,
	[phone] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[a_id] ASC,
	[phone] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Advertisment_Pictures]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Advertisment_Pictures](
	[ad_id] [int] NOT NULL,
	[a_id] [int] NOT NULL,
	[photo] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ad_id] ASC,
	[a_id] ASC,
	[photo] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Photo_tags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Photo_tags](
	[date_time] [smalldatetime] NOT NULL,
	[uploader] [int] NOT NULL,
	[tag] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[date_time] ASC,
	[uploader] ASC,
	[tag] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_created_routes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[view_created_routes] @uid int
as
select r_name from routes where creator=@uid' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_route]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROC [dbo].[create_route](@id INT,@r_name VARCHAR(20))
AS
BEGIN 
INSERT INTO Routes (r_name,creator)VALUES (@r_name,@id)
END 
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[specify_start_end_route]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[specify_start_end_route](@id INT,@r_name VARCHAR(20),@start VARCHAR(100),@end VARCHAR(100))
AS 
BEGIN
UPDATE Routes SET start_location=@start,end_location=@end WHERE r_name=@r_name AND creator=@id
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[specify_frequency_max]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[specify_frequency_max](@id INT,@r_name VARCHAR(20),@frequency VARCHAR(50),@max INT)
AS 
BEGIN
UPDATE Routes SET frequency=@frequency,max_number=@max WHERE r_name=@r_name AND creator=@id
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Route_invite_User1_User2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Route_invite_User1_User2](
	[invitor] [int] NOT NULL,
	[invited] [int] NOT NULL,
	[r_name] [varchar](20) NOT NULL,
	[creator] [int] NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[invitor] ASC,
	[invited] ASC,
	[r_name] ASC,
	[creator] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[invited] ASC,
	[r_name] ASC,
	[creator] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sports]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Sports](
	[s_name] [varchar](20) NOT NULL,
	[club_id] [int] NOT NULL,
	[house_number] [int] NULL,
	[st_name] [varchar](20) NULL,
	[area] [varchar](20) NULL,
	[country] [varchar](20) NULL,
	[supervisor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[s_name] ASC,
	[club_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[find_friend]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[find_friend] @user INT,@friend VARCHAR(20)
AS
BEGIN
SELECT u.u_id,u.username FROM Users u WHERE dbo.are_friends(@user,u.u_id)=''1'' AND u.username=@friend
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_route_stops]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[create_route_stops](@id INT,@r_name VARCHAR(20),@stops VARCHAR(50) )
AS 
BEGIN
INSERT INTO Route_stops VALUES (@r_name,@id,@stops)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_school]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/* schools */
CREATE PROC [dbo].[create_school] @username VARCHAR(20),@password VARCHAR(20),@ed_system VARCHAR(20),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20)
AS
BEGIN
INSERT INTO Users VALUES(@username,@password)
DECLARE @id INT
SELECT @id=u.u_id FROM Users u WHERE u.username=@username
INSERT INTO Schools VALUES (@id,@ed_system,@house_number,@st_name,@area,@country)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pending_req]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[pending_req] @user INT
AS
BEGIN
SELECT u.u_id,u.username
FROM User1_freq_User2 freq 
INNER JOIN Users u ON freq.sender=u.u_id
WHERE freq.receiver = @user AND freq.status is NULL
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_parent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*parents*/

CREATE PROC [dbo].[create_parent] @username VARCHAR(20),@password VARCHAR(20),@email VARCHAR(50),@job VARCHAR(20),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20),@phone INT
AS
BEGIN
INSERT INTO Users VALUES (@username,@password)
DECLARE @u_id INT
SELECT @u_id=u.u_id FROM Users u WHERE u.username=@username 
INSERT INTO Parents VALUES (@u_id,@email,@job,@house_number,@st_name,@area,@country)
INSERT INTO Parent_Phones VALUES (@u_id,@phone)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Children]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Children](
	[u_id] [int] NOT NULL,
	[birth_date] [smalldatetime] NULL,
	[age]  AS ([dbo].[get_age]([birth_date])),
	[y_t]  AS ([dbo].[young_teenager]([birth_date])),
	[school_id] [int] NULL,
	[school_status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[u_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pending_child_parent_requests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[pending_child_parent_requests] @uid int,@requestertype VARCHAR(1)
as
if(@requestertype=''c'')
begin
select u.username
from child_of_parent cop
inner join users u on
cop.parent=u.u_id 
where cop.child=@uid 
and cop.sender=''p''
end
else if(@requestertype=''p'')
begin
select u.username 
from child_of_parent cop
inner join users u
on cop.child=u.u_id
where cop.parent=@uid
and cop.sender=''c''
end' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_threads]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[get_threads] @school int,@subject varchar(20)
as
select * 
from threads t inner join users u 
on t.starter=u.u_id 
where t.school=@school and t.d_subject=@subject' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_replies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[get_replies] @school int,@dsubject varchar(20),@thid int
as
select * 
from replies r inner join users u on r.writer=u.u_id
where 
r.school=@school and r.d_subject=@dsubject and r.thread=@thid' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[search_by_name]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[search_by_name] @name varchar(15)
as
select username 
from users
where
username like ''%''+@name+''%''' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_posts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[get_posts] @uid int
as
select * 
from posts p 
inner join users u
on p.poster=u.u_id
where p.posted_on_user=@uid' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_post_comments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[get_post_comments] @poster int,@dt smalldatetime
as
select * 
from post_commented_user c
inner join users u on
c.commenter=u.u_id
where c.poster = @poster 
and c.date_time=@dt' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_friends]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[get_friends] @uid int
as
select * 
from users u 
where exists(select * from user1_freq_user2 f where ((@uid=f.sender and u.u_id=f.receiver ) or 
(@uid=f.receiver and u.u_id=sender))
and f.status=''1'')  ' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[retrieve_name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[retrieve_name] (@uid INT)
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @return VARCHAR(20)
SELECT @return=u.username
FROM Users u
WHERE u.u_id=@uid
RETURN @return
END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[all_users]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[all_users]
AS
SELECT u.username,u.password FROM USERS U
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_profile_expert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[view_profile_expert] @user INT
AS 
BEGIN
SELECT * 
FROM Users u 
INNER JOIN Experts e ON u.u_id=e.u_id 
INNER JOIN Pictures pics ON u.u_id=pics.posted_on_user 
INNER JOIN Photo_tags phototags ON pics.date_time=phototags.date_time AND pics.uploader=phototags.uploader
INNER JOIN Picture_commented_User piccomments ON pics.date_time=piccomments.date_time AND pics.uploader=piccomments.uploader 
INNER JOIN Posts p ON u.u_id=p.posted_on_user 
INNER JOIN Post_commented_User postcomments ON p.date_time=postcomments.date_time AND p.poster=postcomments.poster
INNER JOIN Picture_tags_User1_User2 taggedpics ON  taggedpics.tagged = u.u_id
INNER JOIN Photo_tags phototags2 ON taggedpics.date_time=phototags2.date_time AND taggedpics.uploader=phototags2.uploader
INNER JOIN Picture_commented_User piccomments2 ON taggedpics.date_time=piccomments2.date_time AND taggedpics.uploader=piccomments2.uploader 
INNER JOIN User1_freq_User2 freq1 ON (u.u_id=freq1.sender) 
INNER JOIN User1_freq_User2 freq2 ON (u.u_id=freq2.receiver)
INNER JOIN Threads t ON u.u_id=t.starter
INNER JOIN Replies r ON u.u_id=r.writer
INNER JOIN Experts_taggedin_Threads taggedthread ON u.u_id=taggedthread.expert 
WHERE u.u_id=@user AND freq1.status=''1'' AND
freq2.status=''1'' 
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_invites_User_Event]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User_invites_User_Event](
	[sender] [int] NOT NULL,
	[receiver] [int] NOT NULL,
	[creator] [int] NOT NULL,
	[e_name] [varchar](50) NOT NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[sender] ASC,
	[receiver] ASC,
	[creator] ASC,
	[e_name] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_club]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*club principal*/
CREATE PROC [dbo].[create_club] @club_name VARCHAR(20),@house_number INT,@st_name VARCHAR(20),@area VARCHAR(20),
@country VARCHAR(20),@opening_time SMALLDATETIME,@closing_time SMALLDATETIME,@fees INT,@admin INT
AS
BEGIN
INSERT INTO Clubs VALUES(@club_name,@house_number,@st_name,@area,@country,@opening_time,@closing_time,@fees,@admin)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Friendship_request]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[Friendship_request] @user1 INT,@user2 INT
AS
BEGIN
INSERT INTO User1_freq_User2 VALUES (@user1,@user2,NULL)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accept_reject_fr]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[accept_reject_fr] @sender INT,@receiver INT,@status BIT
AS
BEGIN
UPDATE User1_freq_User2	
SET status=@status
WHERE sender=@sender AND receiver = @receiver
END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_join_club]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[user_join_club] @user INT,@club_id INT,@user_club_id INT
AS
BEGIN
INSERT INTO Club_joinedby_User VALUES (@user,@club_id,@user_club_id)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Child_infofrom_Parent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Child_infofrom_Parent](
	[parent] [int] NOT NULL,
	[child] [int] NOT NULL,
	[birthdate] [smalldatetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[parent] ASC,
	[child] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[enter_hobbies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[enter_hobbies] @id INT,@hobby VARCHAR(15)
AS
BEGIN
INSERT INTO Child_Hobbies VALUES (@id,@hobby)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_quiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[create_quiz] @quiz VARCHAR(20)
AS
BEGIN 
INSERT INTO Quizzes VALUES (@quiz)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[enter_interests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[enter_interests] @id INT,@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Child_Interests VALUES (@id,@interest)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_question]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[create_question] @quiz VARCHAR(20),@question_name VARCHAR(20),@question VARCHAR(2000),@answer VARCHAR(1000),
@min_age INT,@max_age INT
AS
BEGIN
INSERT INTO Questions VALUES(@quiz,@question_name,@question,@answer,@min_age,@max_age)
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[answer_question]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[answer_question] @answerer INT,@quiz VARCHAR(20),@question VARCHAR(20),@answer VARCHAR(1000)
AS
BEGIN
INSERT INTO Question_answered_by_User VALUES (@answerer,@quiz,@question,@answer)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_parent_phone]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[add_parent_phone] @id INT,@phone INT
AS
BEGIN
INSERT INTO Parent_Phones VALUES (@id,@phone)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[approve_reject_child_parent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[approve_reject_child_parent] @child int,@parent int,@status bit
as 
update Child_of_Parent 
set status=@status
where child=@child
and parent=@parent' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parent_child_request]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[parent_child_request] @child int,@parent int,@sender varchar(1)
as
if(NOT EXISTS(select * from child_of_parent where parent=@parent and child=@child))
insert into Child_of_parent values(@parent,@child,NULL,@sender)' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[provide_hobbies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[provide_hobbies] @parent INT,@child INT,@hobby VARCHAR(15)
AS
BEGIN
INSERT INTO Provided_Hobbies VALUES (@parent,@child,@hobby)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[provide_interests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[provide_interests] @parent INT,@child INT,@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Provided_Interests VALUES (@parent,@child,@interest)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invite_expert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[invite_expert] @expert INT,@school INT
AS 
BEGIN
INSERT INTO Expert_invited_by_School VALUES (@expert,@school)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_advertiser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[add_advertiser] @a_name VARCHAR(15),@field VARCHAR(15),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20),@phone INT
AS
BEGIN
INSERT INTO Advertisers  VALUES (@a_name,@field,@house_number,@st_name,@area,@country)
DECLARE @aid INT
SELECT @aid=a.a_id FROM Advertisers a WHERE a.a_name=@a_name
INSERT INTO Advertiser_Phones VALUES (@aid,@phone)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[show_ad_to_school]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*advertiser*/

CREATE PROC [dbo].[show_ad_to_school] @advertiser INT,@advertisment INT,@school INT
AS
BEGIN
IF(EXISTS(SELECT * FROM Advertiser_incontract_School acs WHERE acs.advertiser=@advertiser AND acs.school=@school))
INSERT INTO Advertisment_shownby_School VALUES (@advertisment,@advertiser,@school)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[link_advertiser_to_school]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[link_advertiser_to_school] @advertiser INT,@school INT
AS
BEGIN
INSERT INTO Advertiser_incontract_School VALUES (@advertiser,@school)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_discussion_board]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[create_discussion_board] @school INT,@d_subject VARCHAR(20)
AS
BEGIN 
INSERT INTO Discussion_boards VALUES (@d_subject,@school)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tag_expert_in_thread]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[tag_expert_in_thread] @expert INT,@school INT,@d_subject VARCHAR(20),@thread INT
AS
BEGIN
INSERT INTO Experts_taggedin_Threads (expert,school,d_subject,thread) VALUES (@expert,@school,@d_subject,@thread)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[supply_date_photo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[supply_date_photo] @date_time SMALLDATETIME,@uploader INT,@date_taken SMALLDATETIME
AS
BEGIN
UPDATE Pictures 
SET date_taken=@date_taken
WHERE date_time=@date_time AND uploader=@uploader
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[supply_description_photo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[supply_description_photo] @date_time SMALLDATETIME,@uploader INT,@words VARCHAR(200)
AS
BEGIN
UPDATE Pictures 
SET words=@words
WHERE date_time=@date_time AND uploader=@uploader
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_photo_on_user]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[add_photo_on_user] @uploader INT,@photo VARCHAR(50),@user INT
AS
BEGIN
INSERT INTO Pictures VALUES(CURRENT_TIMESTAMP,@uploader,@photo,NULL,NULL,@user)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[supply_tag_photo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[supply_tag_photo] @date_time SMALLDATETIME,@uploader INT,@tag VARCHAR(50)
AS
BEGIN
INSERT INTO Photo_tags VALUES(@date_time,@uploader,@tag)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_posts_on_user]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[add_posts_on_user] @poster INT,@words VARCHAR(200),@user INT
AS
BEGIN
INSERT INTO Posts VALUES(CURRENT_TIMESTAMP,@poster,@words,@user)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[comment_on_post]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[comment_on_post] @commenter INT, @date_time SMALLDATETIME, @poster INT, 
@words VARCHAR(500)
AS
BEGIN
INSERT INTO Post_commented_User VALUES (@commenter,@date_time,@poster,@words)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[comment_on_picture]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[comment_on_picture] @commenter INT, @date_time SMALLDATETIME, @uploader INT, 
@words VARCHAR(500)
AS
BEGIN
INSERT INTO Picture_commented_User VALUES (@commenter,@date_time,@uploader,@words)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tag_user_in_photo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[tag_user_in_photo] @tagger INT,@date_time SMALLDATETIME,@uploader INT,@tagged INT
AS
BEGIN
INSERT INTO Picture_tags_User1_User2 VALUES (@tagger,@tagged,@date_time,@uploader)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_event]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[create_event] @creator INT, @e_name VARCHAR (50), @date_time SMALLDATETIME, @dsc VARCHAR(500), @e_type VARCHAR(20),
@purpose VARCHAR (500),@house_number INT,@st_name VARCHAR(20),@area VARCHAR(20),@country VARCHAR(20),@organizer INT
AS 
BEGIN
INSERT INTO Events VALUES(@creator,@e_name,@date_time,@dsc,@e_type,@purpose,@house_number,@st_name,@area,@country,@organizer)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_profile_parent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[view_profile_parent] @user INT
AS 
BEGIN
SELECT * 
FROM Users u 
INNER JOIN Parents p ON u.u_id=p.u_id 
INNER JOIN Parent_Phones phones ON u.u_id=phones.parent
INNER JOIN Child_of_parent cop ON u.u_id=cop.parent 
INNER JOIN Pictures pics ON u.u_id=pics.posted_on_user
INNER JOIN Photo_tags phototags ON pics.date_time=phototags.date_time AND pics.uploader=phototags.uploader
INNER JOIN Picture_commented_User piccomments ON pics.date_time=piccomments.date_time AND pics.uploader=piccomments.uploader  
INNER JOIN Posts posts ON u.u_id=posts.posted_on_user
INNER JOIN Post_commented_User postcomments ON posts.date_time=postcomments.date_time AND posts.poster=postcomments.poster
INNER JOIN Picture_tags_User1_User2 taggedpics ON  taggedpics.tagged = u.u_id
INNER JOIN Photo_tags phototags2 ON taggedpics.date_time=phototags2.date_time AND taggedpics.uploader=phototags2.uploader
INNER JOIN Picture_commented_User piccomments2 ON taggedpics.date_time=piccomments2.date_time AND taggedpics.uploader=piccomments2.uploader 
INNER JOIN User1_freq_User2 freq1 ON (u.u_id=freq1.sender)
INNER JOIN User1_freq_User2 freq2 ON (u.u_id=freq2.receiver)
INNER JOIN User_invites_User_Event e ON u.u_id = e.receiver
INNER JOIN Events createdevents ON u.u_id=createdevents.creator
INNER JOIN Events organizedevents ON u.u_id=organizedevents.organizer 
INNER JOIN Club_joinedby_User clubsj ON u.u_id=clubsj.joiner
INNER JOIN Clubs clubsjoined ON clubsj.club_id=clubsj.club_id
INNER JOIN Clubs clubs ON u.u_id=clubs.admin
INNER JOIN Sports sports ON u.u_id=sports.supervisor
INNER JOIN Routes routes ON u.u_id=routes.creator
INNER JOIN Route_invite_User1_User2 invitedroutes ON u.u_id = invitedroutes.invited
INNER JOIN Threads t ON u.u_id=t.starter
INNER JOIN Replies r ON u.u_id=r.writer
WHERE u.u_id=@user AND freq1.status=''1'' AND
freq2.status=''1'' AND e.status=''1'' AND cop.status=''1'' AND invitedroutes.status=''1''
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eligable_for_invitation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[eligable_for_invitation] @rname VARCHAR(20),@creator int
as
select * from users u1 
where dbo.are_friends(@creator,u1.u_id)=''1'' 
except(select u2.u_id,u2.username,u2.password from users 
u2 inner join route_invite_user1_user2 r on r.invited=u2.u_id where r.r_name=@rname and r.creator=@creator  )
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invite_to_event]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[invite_to_event] @sender INT,@receiver INT,@creator INT,@event VARCHAR(50)
AS
BEGIN
IF(@sender=@creator OR dbo.invited_to_event(@sender,@creator,@event)=''1'')
INSERT INTO User_invites_User_Event VALUES (@sender,@receiver,@creator,@event,NULL)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accept_reject_carpool]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[accept_reject_carpool] @invited INT,@creator INT,@route varchar(20),@status bit
AS 
BEGIN
UPDATE Route_invite_User1_User2
SET status=@status WHERE  @invited=invited AND @creator=creator AND @route=r_name
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invite_to_carpool]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[invite_to_carpool](@invitor INT,@creator INT,@route VARCHAR(20),@invited INT)
AS 
BEGIN
IF (@invitor=@creator OR dbo.invited_to_route(@invitor,@creator,@route)=''1'')
INSERT INTO Route_invite_User1_User2 VALUES (@invitor,@invited,@route,@creator,NULL)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invited_to_route]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[invited_to_route](@invited INT,@creator INT,@r_name INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM  Route_invite_User1_User2 invite WHERE invite.invited=@invited AND invite.creator=@creator AND 
invite.r_name=@r_name ))
SET @return=''1''
ELSE SET @return=''0''
RETURN @return
END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_pending_route_requests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[view_pending_route_requests] @uid int
as select u.username,r.r_name from route_invite_user1_user2 r
inner join users u on u.u_id=r.creator
where invited=@uid and status is null
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_accepted_route_requests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[view_accepted_route_requests] @uid int
as select u.username,r.r_name from route_invite_user1_user2 r
inner join users u on u.u_id=r.creator
where invited=@uid and status =''1''' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_parents_children]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[view_parents_children] @type varchar(1)
as
if (@type =''c'')
select u.username from parents p 
inner join users u
on p.u_id=u.u_id
else if (@type=''p'')
select u.username from children c 
inner join users u
on c.u_id=u.u_id' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_children]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[get_children] @sid int
as
select * 
from users u 
where exists
     (select * from children c where c.school_id=@sid and c.school_status is null and c.u_id=u.u_id )' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_childreq]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[get_childreq] @sid int
as
select * 
from users u 
where exists
     (select * from children c where c.school_id=@sid and c.school_status is null and c.u_id=u.u_id )' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[club_profile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[club_profile] @clubid INT
AS
BEGIN
SELECT * FROM Clubs clubs 
INNER JOIN Club_activities activities ON  clubs.club_id=activities.club_id
INNER JOIN Club_joinedby_User members ON members.club_id=clubs.club_id
INNER JOIN Users membernames ON members.joiner=membernames.u_id
INNER JOIN Sports sports ON sports.club_id=clubs.club_id 
WHERE clubs.club_id=@clubid
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_profile_child]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[view_profile_child] @user INT
AS 
BEGIN
SELECT * 
FROM Users u 
INNER JOIN Children c ON u.u_id=c.u_id 
INNER JOIN Child_Hobbies hobbies ON u.u_id=hobbies.u_id
INNER JOIN Child_Interests interests ON u.u_id=interests.u_id 
INNER JOIN Child_of_parent cop ON c.u_id=cop.child 
/* wall pics/posts*/
INNER JOIN Pictures pics ON c.u_id=pics.posted_on_user 
INNER JOIN Photo_tags phototags ON pics.date_time=phototags.date_time AND pics.uploader=phototags.uploader
INNER JOIN Picture_commented_User piccomments ON pics.date_time=piccomments.date_time AND pics.uploader=piccomments.uploader 	
INNER JOIN Posts p ON c.u_id=p.posted_on_user
INNER JOIN Post_commented_User postcomments ON p.date_time=postcomments.date_time AND p.poster=postcomments.poster
/* tagged pics */
INNER JOIN Picture_tags_User1_User2 taggedpics ON  taggedpics.tagged = u.u_id
INNER JOIN Photo_tags phototags2 ON taggedpics.date_time=phototags2.date_time AND taggedpics.uploader=phototags2.uploader
INNER JOIN Picture_commented_User piccomments2 ON taggedpics.date_time=piccomments2.date_time AND taggedpics.uploader=piccomments2.uploader 
INNER JOIN User1_freq_User2 freq1 ON (c.u_id=freq1.sender) 
INNER JOIN User1_freq_User2 freq2 ON (c.u_id=freq2.receiver)
INNER JOIN User_invites_User_Event e ON c.u_id = e.receiver 
INNER JOIN Club_joinedby_User clubsj ON c.u_id=clubsj.joiner
INNER JOIN Clubs clubs ON clubs.club_id=clubsj.club_id
INNER JOIN Threads t ON c.u_id=t.starter
INNER JOIN Replies r ON c.u_id=r.writer
WHERE c.u_id=@user AND freq1.status=''1'' AND
freq2.status=''1'' AND e.status=''1'' AND cop.status=''1''
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[create_child]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/* children */

CREATE PROC [dbo].[create_child] @username VARCHAR(20),@password VARCHAR(20),@schoolname VARCHAR(20),@birthdate SMALLDATETIME
AS
BEGIN
INSERT INTO Users VALUES (@username,@password)
DECLARE @id INT
DECLARE @schoolid INT 
SELECT @id=u.u_id FROM Users u WHERE @username=u.username
SELECT @schoolid=s.u_id FROM Users s WHERE s.username=@schoolname AND EXISTS(SELECT * FROM Schools s2 WHERE s2.u_id=s.u_id )
INSERT INTO Children (u_id,birth_date,school_id,school_status)VALUES (@id,@birthdate,@schoolid,NULL)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[approve_provided_info]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[approve_provided_info] @child INT,@parent INT,@status BIT
AS
BEGIN
DECLARE @young BIT
SELECT @young=c.y_t FROM Children c WHERE c.u_id=@child
IF(@young=''0'')
BEGIN
UPDATE Child_infofrom_Parent 
SET status=@status 
WHERE child=@child AND parent=@parent
END
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[accept_reject_child]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[accept_reject_child] @child INT,@status BIT
AS
BEGIN
UPDATE Children
SET school_status=@status
WHERE u_id=@child
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user_linkedto_school]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[user_linkedto_school](@u_id INT,@s_id INT) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @type CHAR(1)
SET @type =	dbo.user_type(@u_id)
IF(@type=''C'')
begin
IF(EXISTS(SELECT * FROM Children c WHERE c.u_id=@u_id AND c.school_id=@s_id ))
SET @return =''1''
end
ELSE IF (@type=''P'')
begin
IF(EXISTS(SELECT * FROM Children c INNER JOIN Child_of_Parent o ON c.u_id=o.child INNER JOIN Parents p ON o.parent=
p.u_id WHERE p.u_id = @u_id AND c.school_id=@s_id  ))
SET @return=''1''
end
ELSE IF (@type=''S'')
begin
IF(@s_id=@u_id)
SET @return=''1''
ELSE
SET @return =''0''
end
RETURN @return

END

' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[take_quiz]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[take_quiz] @id INT,@quiz VARCHAR(20)
AS
BEGIN
DECLARE @age INT 
SELECT @age=c.age FROM Children c WHERE c.u_id=@id
SELECT * FROM
Questions qs 
WHERE qs.quiz_name=@quiz AND @age>=qs.min_age AND @age<=qs.max_age
END' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[provide_info_for_child]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[provide_info_for_child] @parent INT,@child INT,@birthdate SMALLDATETIME,@hobby VARCHAR(15),@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Child_infofrom_Parent VALUES (@parent,@child,@birthdate,NULL)
IF(@hobby IS NOT NULL)
INSERT INTO Provided_Hobbies VALUES(@parent,@child,@hobby)
IF (@interest IS NOT NULL)
INSERT INTO Provided_Interests VALUES (@parent,@child,@interest)
END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[start_thread]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[start_thread] @starter INT,@school INT,@d_subject VARCHAR(20),@subject VARCHAR(20),@topic VARCHAR(2000)
AS
BEGIN
IF(dbo.user_linkedto_school(@starter,@school)=''1'')
BEGIN
DECLARE @thread INT
SELECT @thread = dbo.thread_count(@school,@d_subject)
INSERT INTO Threads (d_subject,th_id,school,subject,topic,
starter) VALUES (@d_subject,@thread,@school,@subject,@topic,@starter)
END
END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reply_to_thread]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROC [dbo].[reply_to_thread] @replier INT,@school INT,@d_subject VARCHAR(20),@thread INT,@reply VARCHAR(2000)
AS
BEGIN
IF(dbo.user_linkedto_school(@replier,@school)=''1'' AND EXISTS (SELECT * FROM Threads t WHERE t.school=@school AND 
t.d_subject=@d_subject AND t.th_id=@thread ))
BEGIN
DECLARE @r_id INT
SELECT @r_id=dbo.reply_count(@school,@d_subject,@thread)
INSERT INTO Replies (r_id,school, d_subject,thread,reply,date,writer) VALUES (@r_id,@school,@d_subject,@thread,@reply,CURRENT_TIMESTAMP
,@replier)
END
END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_linked_discussion_boards]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE proc [dbo].[get_linked_discussion_boards] @uid int
as
select * from discussion_boards d
inner join users u on u.u_id=d.school
where dbo.user_linkedto_school(@uid,d.school)=''1''' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[get_linked_schools]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create proc [dbo].[get_linked_schools] @uid int
as
select s.username from users s
where dbo.user_linkedto_school(@uid,s.u_id)=''1''' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[view_profile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[view_profile] @user INT
AS
BEGIN
IF(dbo.user_type(@user)=''C'')
EXECUTE view_profile_child @user
ELSE IF (dbo.user_type(@user)=''E'')
EXECUTE view_profile_expert @user
ELSE IF (dbo.user_type(@user)=''P'')
EXECUTE view_profile_parent @user
ELSE IF (dbo.user_type(@user)=''S'')
EXECUTE view_profile_school @user
END

' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Route_stops__05D8E0BE]') AND parent_object_id = OBJECT_ID(N'[dbo].[Route_stops]'))
ALTER TABLE [dbo].[Route_stops]  WITH CHECK ADD FOREIGN KEY([r_name], [creator])
REFERENCES [dbo].[Routes] ([r_name], [creator])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Clubs__admin__0F624AF8]') AND parent_object_id = OBJECT_ID(N'[dbo].[Clubs]'))
ALTER TABLE [dbo].[Clubs]  WITH CHECK ADD FOREIGN KEY([admin])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__User1_fre__recei__1273C1CD]') AND parent_object_id = OBJECT_ID(N'[dbo].[User1_freq_User2]'))
ALTER TABLE [dbo].[User1_freq_User2]  WITH CHECK ADD FOREIGN KEY([receiver])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__User1_fre__sende__117F9D94]') AND parent_object_id = OBJECT_ID(N'[dbo].[User1_freq_User2]'))
ALTER TABLE [dbo].[User1_freq_User2]  WITH CHECK ADD FOREIGN KEY([sender])
REFERENCES [dbo].[Users] ([u_id])
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__User1_freq_User2__108B795B]') AND parent_object_id = OBJECT_ID(N'[dbo].[User1_freq_User2]'))
ALTER TABLE [dbo].[User1_freq_User2]  WITH CHECK ADD CHECK  (([sender]<>[receiver]))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Parents__u_id__22AA2996]') AND parent_object_id = OBJECT_ID(N'[dbo].[Parents]'))
ALTER TABLE [dbo].[Parents]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Question___answe__236943A5]') AND parent_object_id = OBJECT_ID(N'[dbo].[Question_answered_by_User]'))
ALTER TABLE [dbo].[Question_answered_by_User]  WITH CHECK ADD FOREIGN KEY([answerer])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Question_answere__245D67DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[Question_answered_by_User]'))
ALTER TABLE [dbo].[Question_answered_by_User]  WITH CHECK ADD FOREIGN KEY([quiz], [question])
REFERENCES [dbo].[Questions] ([quiz_name], [question_name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Schools__u_id__15502E78]') AND parent_object_id = OBJECT_ID(N'[dbo].[Schools]'))
ALTER TABLE [dbo].[Schools]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Club_join__club___17036CC0]') AND parent_object_id = OBJECT_ID(N'[dbo].[Club_joinedby_User]'))
ALTER TABLE [dbo].[Club_joinedby_User]  WITH CHECK ADD FOREIGN KEY([club_id])
REFERENCES [dbo].[Clubs] ([club_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Club_join__joine__160F4887]') AND parent_object_id = OBJECT_ID(N'[dbo].[Club_joinedby_User]'))
ALTER TABLE [dbo].[Club_joinedby_User]  WITH CHECK ADD FOREIGN KEY([joiner])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Experts__u_id__38996AB5]') AND parent_object_id = OBJECT_ID(N'[dbo].[Experts]'))
ALTER TABLE [dbo].[Experts]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Threads__5535A963]') AND parent_object_id = OBJECT_ID(N'[dbo].[Threads]'))
ALTER TABLE [dbo].[Threads]  WITH CHECK ADD FOREIGN KEY([d_subject], [school])
REFERENCES [dbo].[Discussion_Boards] ([subject], [school])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Threads__starter__5629CD9C]') AND parent_object_id = OBJECT_ID(N'[dbo].[Threads]'))
ALTER TABLE [dbo].[Threads]  WITH CHECK ADD FOREIGN KEY([starter])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Events__creator__797309D9]') AND parent_object_id = OBJECT_ID(N'[dbo].[Events]'))
ALTER TABLE [dbo].[Events]  WITH CHECK ADD FOREIGN KEY([creator])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Events__organize__7A672E12]') AND parent_object_id = OBJECT_ID(N'[dbo].[Events]'))
ALTER TABLE [dbo].[Events]  WITH CHECK ADD FOREIGN KEY([organizer])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Picture_c__comme__6EF57B66]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_commented_User]'))
ALTER TABLE [dbo].[Picture_commented_User]  WITH CHECK ADD FOREIGN KEY([commenter])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Picture_commente__6FE99F9F]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_commented_User]'))
ALTER TABLE [dbo].[Picture_commented_User]  WITH CHECK ADD FOREIGN KEY([date_time], [uploader])
REFERENCES [dbo].[Pictures] ([date_time], [uploader])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Picture_t__tagge__73BA3083]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_tags_User1_User2]'))
ALTER TABLE [dbo].[Picture_tags_User1_User2]  WITH CHECK ADD FOREIGN KEY([tagger])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Picture_t__tagge__74AE54BC]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_tags_User1_User2]'))
ALTER TABLE [dbo].[Picture_tags_User1_User2]  WITH CHECK ADD FOREIGN KEY([tagged])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Picture_tags_Use__75A278F5]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_tags_User1_User2]'))
ALTER TABLE [dbo].[Picture_tags_User1_User2]  WITH CHECK ADD FOREIGN KEY([date_time], [uploader])
REFERENCES [dbo].[Pictures] ([date_time], [uploader])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Picture_tags_Use__76969D2E]') AND parent_object_id = OBJECT_ID(N'[dbo].[Picture_tags_User1_User2]'))
ALTER TABLE [dbo].[Picture_tags_User1_User2]  WITH CHECK ADD CHECK  (([tagger]<>[tagged]))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Replies__59063A47]') AND parent_object_id = OBJECT_ID(N'[dbo].[Replies]'))
ALTER TABLE [dbo].[Replies]  WITH CHECK ADD FOREIGN KEY([d_subject], [school], [thread])
REFERENCES [dbo].[Threads] ([d_subject], [school], [th_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Replies__writer__59FA5E80]') AND parent_object_id = OBJECT_ID(N'[dbo].[Replies]'))
ALTER TABLE [dbo].[Replies]  WITH CHECK ADD FOREIGN KEY([writer])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Pictures__posted__619B8048]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pictures]'))
ALTER TABLE [dbo].[Pictures]  WITH CHECK ADD FOREIGN KEY([posted_on_user])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Pictures__upload__60A75C0F]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pictures]'))
ALTER TABLE [dbo].[Pictures]  WITH CHECK ADD FOREIGN KEY([uploader])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Posts__posted_on__68487DD7]') AND parent_object_id = OBJECT_ID(N'[dbo].[Posts]'))
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD FOREIGN KEY([posted_on_user])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Posts__poster__6754599E]') AND parent_object_id = OBJECT_ID(N'[dbo].[Posts]'))
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD FOREIGN KEY([poster])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Post_comm__comme__6B24EA82]') AND parent_object_id = OBJECT_ID(N'[dbo].[Post_commented_User]'))
ALTER TABLE [dbo].[Post_commented_User]  WITH CHECK ADD FOREIGN KEY([commenter])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Post_commented_U__6C190EBB]') AND parent_object_id = OBJECT_ID(N'[dbo].[Post_commented_User]'))
ALTER TABLE [dbo].[Post_commented_User]  WITH CHECK ADD FOREIGN KEY([date_time], [poster])
REFERENCES [dbo].[Posts] ([date_time], [poster])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Club_acti__club___123EB7A3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Club_activities]'))
ALTER TABLE [dbo].[Club_activities]  WITH CHECK ADD FOREIGN KEY([club_id])
REFERENCES [dbo].[Clubs] ([club_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Expert_in__exper__3B75D760]') AND parent_object_id = OBJECT_ID(N'[dbo].[Expert_invited_by_School]'))
ALTER TABLE [dbo].[Expert_invited_by_School]  WITH CHECK ADD FOREIGN KEY([expert])
REFERENCES [dbo].[Experts] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Expert_in__schoo__3C69FB99]') AND parent_object_id = OBJECT_ID(N'[dbo].[Expert_invited_by_School]'))
ALTER TABLE [dbo].[Expert_invited_by_School]  WITH CHECK ADD FOREIGN KEY([school])
REFERENCES [dbo].[Schools] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Discussio__schoo__52593CB8]') AND parent_object_id = OBJECT_ID(N'[dbo].[Discussion_Boards]'))
ALTER TABLE [dbo].[Discussion_Boards]  WITH CHECK ADD FOREIGN KEY([school])
REFERENCES [dbo].[Schools] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertise__adver__44FF419A]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertiser_incontract_School]'))
ALTER TABLE [dbo].[Advertiser_incontract_School]  WITH CHECK ADD FOREIGN KEY([advertiser])
REFERENCES [dbo].[Advertisers] ([a_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertise__schoo__45F365D3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertiser_incontract_School]'))
ALTER TABLE [dbo].[Advertiser_incontract_School]  WITH CHECK ADD FOREIGN KEY([school])
REFERENCES [dbo].[Schools] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertism__schoo__4F7CD00D]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertisment_shownby_School]'))
ALTER TABLE [dbo].[Advertisment_shownby_School]  WITH CHECK ADD FOREIGN KEY([school])
REFERENCES [dbo].[Schools] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertisment_sho__4E88ABD4]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertisment_shownby_School]'))
ALTER TABLE [dbo].[Advertisment_shownby_School]  WITH CHECK ADD FOREIGN KEY([advertisment], [advertiser])
REFERENCES [dbo].[Advertisments] ([ad_id], [a_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_of___child__2B3F6F97]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_of_Parent]'))
ALTER TABLE [dbo].[Child_of_Parent]  WITH CHECK ADD FOREIGN KEY([child])
REFERENCES [dbo].[Children] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_of___paren__2A4B4B5E]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_of_Parent]'))
ALTER TABLE [dbo].[Child_of_Parent]  WITH CHECK ADD FOREIGN KEY([parent])
REFERENCES [dbo].[Parents] ([u_id])
ON UPDATE SET DEFAULT
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_Inte__u_id__1FCDBCEB]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_Interests]'))
ALTER TABLE [dbo].[Child_Interests]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Children] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_Hobb__u_id__1CF15040]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_Hobbies]'))
ALTER TABLE [dbo].[Child_Hobbies]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Children] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Questions__quiz___208CD6FA]') AND parent_object_id = OBJECT_ID(N'[dbo].[Questions]'))
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD FOREIGN KEY([quiz_name])
REFERENCES [dbo].[Quizzes] ([quiz_name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Parent_Ph__paren__25869641]') AND parent_object_id = OBJECT_ID(N'[dbo].[Parent_Phones]'))
ALTER TABLE [dbo].[Parent_Phones]  WITH CHECK ADD FOREIGN KEY([parent])
REFERENCES [dbo].[Parents] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Routes__creator__02FC7413]') AND parent_object_id = OBJECT_ID(N'[dbo].[Routes]'))
ALTER TABLE [dbo].[Routes]  WITH CHECK ADD FOREIGN KEY([creator])
REFERENCES [dbo].[Parents] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Provided_Hobbies__32E0915F]') AND parent_object_id = OBJECT_ID(N'[dbo].[Provided_Hobbies]'))
ALTER TABLE [dbo].[Provided_Hobbies]  WITH CHECK ADD FOREIGN KEY([parent], [child])
REFERENCES [dbo].[Child_infofrom_Parent] ([parent], [child])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Provided_Interes__35BCFE0A]') AND parent_object_id = OBJECT_ID(N'[dbo].[Provided_Interests]'))
ALTER TABLE [dbo].[Provided_Interests]  WITH CHECK ADD FOREIGN KEY([parent], [child])
REFERENCES [dbo].[Child_infofrom_Parent] ([parent], [child])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Experts_t__exper__5CD6CB2B]') AND parent_object_id = OBJECT_ID(N'[dbo].[Experts_taggedin_Threads]'))
ALTER TABLE [dbo].[Experts_taggedin_Threads]  WITH CHECK ADD FOREIGN KEY([expert])
REFERENCES [dbo].[Experts] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Experts_taggedin__5DCAEF64]') AND parent_object_id = OBJECT_ID(N'[dbo].[Experts_taggedin_Threads]'))
ALTER TABLE [dbo].[Experts_taggedin_Threads]  WITH CHECK ADD FOREIGN KEY([d_subject], [school], [thread])
REFERENCES [dbo].[Threads] ([d_subject], [school], [th_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertisme__a_id__48CFD27E]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertisments]'))
ALTER TABLE [dbo].[Advertisments]  WITH CHECK ADD FOREIGN KEY([a_id])
REFERENCES [dbo].[Advertisers] ([a_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Avertiser___a_id__4222D4EF]') AND parent_object_id = OBJECT_ID(N'[dbo].[Avertiser_Phones]'))
ALTER TABLE [dbo].[Avertiser_Phones]  WITH CHECK ADD FOREIGN KEY([a_id])
REFERENCES [dbo].[Advertisers] ([a_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Advertisment_Pic__4BAC3F29]') AND parent_object_id = OBJECT_ID(N'[dbo].[Advertisment_Pictures]'))
ALTER TABLE [dbo].[Advertisment_Pictures]  WITH CHECK ADD FOREIGN KEY([ad_id], [a_id])
REFERENCES [dbo].[Advertisments] ([ad_id], [a_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Photo_tags__6477ECF3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Photo_tags]'))
ALTER TABLE [dbo].[Photo_tags]  WITH CHECK ADD FOREIGN KEY([date_time], [uploader])
REFERENCES [dbo].[Pictures] ([date_time], [uploader])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Route_inv__invit__09A971A2]') AND parent_object_id = OBJECT_ID(N'[dbo].[Route_invite_User1_User2]'))
ALTER TABLE [dbo].[Route_invite_User1_User2]  WITH CHECK ADD FOREIGN KEY([invitor])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Route_inv__invit__0A9D95DB]') AND parent_object_id = OBJECT_ID(N'[dbo].[Route_invite_User1_User2]'))
ALTER TABLE [dbo].[Route_invite_User1_User2]  WITH CHECK ADD FOREIGN KEY([invited])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Route_invite_Use__0B91BA14]') AND parent_object_id = OBJECT_ID(N'[dbo].[Route_invite_User1_User2]'))
ALTER TABLE [dbo].[Route_invite_User1_User2]  WITH CHECK ADD FOREIGN KEY([r_name], [creator])
REFERENCES [dbo].[Routes] ([r_name], [creator])
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Route_invite_Use__0C85DE4D]') AND parent_object_id = OBJECT_ID(N'[dbo].[Route_invite_User1_User2]'))
ALTER TABLE [dbo].[Route_invite_User1_User2]  WITH CHECK ADD CHECK  (([dbo].[user_type]([invitor])='P' AND [invited]<>[invitor]))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Sports__club_id__19DFD96B]') AND parent_object_id = OBJECT_ID(N'[dbo].[Sports]'))
ALTER TABLE [dbo].[Sports]  WITH CHECK ADD FOREIGN KEY([club_id])
REFERENCES [dbo].[Clubs] ([club_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Sports__supervis__1AD3FDA4]') AND parent_object_id = OBJECT_ID(N'[dbo].[Sports]'))
ALTER TABLE [dbo].[Sports]  WITH CHECK ADD FOREIGN KEY([supervisor])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Sports__1BC821DD]') AND parent_object_id = OBJECT_ID(N'[dbo].[Sports]'))
ALTER TABLE [dbo].[Sports]  WITH CHECK ADD CHECK  (([dbo].[valid_supervisor]([supervisor],[s_name],[club_id])='1'))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Children__school__182C9B23]') AND parent_object_id = OBJECT_ID(N'[dbo].[Children]'))
ALTER TABLE [dbo].[Children]  WITH CHECK ADD FOREIGN KEY([school_id])
REFERENCES [dbo].[Schools] ([u_id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Children__u_id__1920BF5C]') AND parent_object_id = OBJECT_ID(N'[dbo].[Children]'))
ALTER TABLE [dbo].[Children]  WITH CHECK ADD FOREIGN KEY([u_id])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Children__birth___1A14E395]') AND parent_object_id = OBJECT_ID(N'[dbo].[Children]'))
ALTER TABLE [dbo].[Children]  WITH CHECK ADD CHECK  (([dbo].[valid_age]([birth_date])='1'))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__User_invi__recei__7E37BEF6]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_invites_User_Event]'))
ALTER TABLE [dbo].[User_invites_User_Event]  WITH CHECK ADD FOREIGN KEY([receiver])
REFERENCES [dbo].[Users] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__User_invi__sende__7D439ABD]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_invites_User_Event]'))
ALTER TABLE [dbo].[User_invites_User_Event]  WITH CHECK ADD FOREIGN KEY([sender])
REFERENCES [dbo].[Users] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__User_invites_Use__7F2BE32F]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_invites_User_Event]'))
ALTER TABLE [dbo].[User_invites_User_Event]  WITH CHECK ADD FOREIGN KEY([creator], [e_name])
REFERENCES [dbo].[Events] ([creator], [e_name])
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__User_invites_Use__00200768]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_invites_User_Event]'))
ALTER TABLE [dbo].[User_invites_User_Event]  WITH CHECK ADD CHECK  (([dbo].[user_type]([sender])='P' AND [sender]<>[receiver]))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_inf__child__2F10007B]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_infofrom_Parent]'))
ALTER TABLE [dbo].[Child_infofrom_Parent]  WITH CHECK ADD FOREIGN KEY([child])
REFERENCES [dbo].[Children] ([u_id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Child_inf__paren__2E1BDC42]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_infofrom_Parent]'))
ALTER TABLE [dbo].[Child_infofrom_Parent]  WITH CHECK ADD FOREIGN KEY([parent])
REFERENCES [dbo].[Parents] ([u_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__Child_infofrom_P__300424B4]') AND parent_object_id = OBJECT_ID(N'[dbo].[Child_infofrom_Parent]'))
ALTER TABLE [dbo].[Child_infofrom_Parent]  WITH CHECK ADD CHECK  (([dbo].[parent_of_child]([parent],[child])='1'))
