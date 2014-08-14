/* * * * * * * * *
 *   PROCEDURES  *              
 * * * * * * * * */



/* members */

CREATE PROC Friendship_request @user1 INT,@user2 INT
AS
BEGIN
INSERT INTO User1_freq_User2 VALUES (@user1,@user2,NULL)
END
go
CREATE PROC find_friend @user INT,@friend VARCHAR(20)
AS
BEGIN
SELECT u.u_id,u.username FROM Users u WHERE dbo.are_friends(@user,u.u_id)='1' AND u.username=@friend
END
go
CREATE PROC pending_req @user INT
AS
BEGIN
SELECT u.u_id,u.username
FROM User1_freq_User2 freq 
INNER JOIN Users u ON freq.sender=u.u_id
WHERE receiver = @user AND status = NULL
END
go
CREATE PROC accept_reject_fr @sender INT,@receiver INT,@status BIT
AS
BEGIN
UPDATE User1_freq_User2	
SET status=@status
WHERE sender=@sender AND receiver = @receiver
END

CREATE PROC start_thread @starter INT,@school INT,@d_subject VARCHAR(20),@subject VARCHAR(20),@topic VARCHAR(2000)
AS
BEGIN
IF(dbo.is_linked_to_school(@starter,@school)='1')
BEGIN
DECLARE @thread INT
SELECT @thread = dbo.thread_count(@school,@d_subject)
INSERT INTO Threads (d_subject,th_id,school,subject,topic,
starter) VALUES (@d_subject,@school,@thread,@subject,@topic,@starter)
END
END
go

CREATE PROC tag_expert_in_thread @expert INT,@school INT,@d_subject VARCHAR(20),@thread INT
AS
BEGIN
INSERT INTO Experts_taggedin_Threads (expert,school,d_subject,thread) VALUES (@expert,@school,@d_subject,@thread)
END
go
CREATE PROC reply_to_thread @replier INT,@school INT,@d_subject VARCHAR(20),@thread INT,@reply VARCHAR(2000)
AS
BEGIN
IF(dbo.is_linked_to_school(@replier,@school)='1' AND EXISTS (SELECT * FROM Threads t WHERE t.school=@school AND 
t.d_subject=@d_subject AND t.thread=@thread ))
BEGIN
DECLARE @r_id INT
SELECT @r_id=dbo.reply_count()
INSERT INTO Replies (school, d_subject,thread,reply,date,writer) VALUES (@school,@d_subject,@thread,@reply,CURRENT_TIMESTAMP
,@replier)
END
END
go


CREATE PROC create_event @creator INT, @e_name VARCHAR (50), @date_time SMALLDATETIME, @dsc VARCHAR(500),@type VARCHAR(20),@purpose VARCHAR (500), 
@house_number INT,@st_name VARCHAR(20),@area VARCHAR(20),@country VARCHAR(20),@organizer INT 
AS
BEGIN
INSERT INTO Events VALUES(@creator,@e_name,@date_time,@dsc,@type,@purpose, 
@house_number,@st_name,@area,@country,@organizer)
END
go
CREATE PROC invite_to_event @sender INT , @receiver INT ,@creator INT,@e_name VARCHAR (50)
AS
BEGIN
IF(@sender=@creator OR dbo.invited_to_event(@sender,@creator,@e_name)='1')
INSERT INTO Event_invites_User VALUES (@sender,@receiver,@creator,@e_name,NULL)
END
go

CREATE PROC accept_reject_event @sender INT , @receiver INT ,@creator INT, @e_name VARCHAR(50) , @status BIT
AS
BEGIN
UPDATE Event_invites_User 
SET status= @status
WHERE sender=@sender AND receiver=@receiver AND creator=@creator AND e_name=@e_name
END
go
CREATE PROC view_profile @user INT
AS
BEGIN
IF(dbo.user_type(@user)='C')
EXECUTE view_profile_child @user
ELSE IF (dbo.user_type(@user)='E')
EXECUTE view_profile_expert @user
ELSE IF (dbo.user_type(@user)='P')
EXECUTE view_profile_parent @user
ELSE IF (dbo.user_type(@user)='S')
EXECUTE view_profile_school @user
END

go

CREATE PROC view_profile_child @user INT
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
WHERE c.u_id=@user AND freq1.status='1' AND
freq2.status='1' AND e.status='1' AND cop.status='1'
END
go

CREATE PROC view_profile_parent @user INT
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
WHERE u.u_id=@user AND freq1.status='1' AND
freq2.status='1' AND e.status='1' AND cop.status='1' AND invitedroutes.status='1'
END
go

CREATE PROC view_profile_expert @user INT
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
WHERE u.u_id=@user AND freq1.status='1' AND
freq2.status='1' 
END
go

CREATE PROC view_profile_school @user INT
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
WHERE u.u_id=@user AND freq1.status='1' AND
freq2.status='1' AND c.school_status='1'
END
go

CREATE PROC club_profile @clubid INT
AS
BEGIN
SELECT * FROM Clubs clubs 
INNER JOIN Club_activities activities ON  clubs.club_id=activities.club_id
INNER JOIN Club_joinedby_User members ON members.club_id=clubs.club_id
INNER JOIN Users membernames ON members.joiner=membernames.u_id
INNER JOIN Sports sports ON sports.club_id=clubs.club_id 
WHERE clubs.club_id=@clubid
END
go

CREATE PROC add_photo_on_user @uploader INT,@photo VARCHAR(50),@user INT
AS
BEGIN
INSERT INTO Pictures VALUES(CURRENT_TIMESTAMP,@uploader,@photo,NULL,NULL,@user)
END
go
CREATE PROC add_posts_on_user @poster INT,@words VARCHAR(200),@user INT
AS
BEGIN
INSERT INTO Posts VALUES(CURRENT_TIMESTAMP,@poster,@words,@user)
END
go
CREATE PROC supply_date_photo @date_time SMALLDATETIME,@uploader INT,@date_taken SMALLDATETIME
AS
BEGIN
UPDATE Pictures 
SET date_taken=@date_taken
WHERE date_time=@date_time AND uploader=@uploader
END
go
CREATE PROC supply_description_photo @date_time SMALLDATETIME,@uploader INT,@words VARCHAR(200)
AS
BEGIN
UPDATE Pictures 
SET words=@words
WHERE date_time=@date_time AND uploader=@uploader
END
go
CREATE PROC supply_tag_photo @date_time SMALLDATETIME,@uploader INT,@tag VARCHAR(50)
AS
BEGIN
INSERT INTO Photo_tags VALUES(@date_time,@uploader,@tag)
END
go
CREATE PROC tag_user_in_photo @tagger INT,@date_time SMALLDATETIME,@uploader INT,@tagged INT
AS
BEGIN
INSERT INTO Picture_tags_User1_User2 VALUES (@tagger,@tagged,@date_time,@uploader)
END
go

CREATE PROC comment_on_post @commenter INT, @date_time SMALLDATETIME, @poster INT, 
@words VARCHAR(500)
AS
BEGIN
INSERT INTO Post_commented_User VALUES (@commenter,@date_time,@poster,@words)
END
go

CREATE PROC comment_on_picture @commenter INT, @date_time SMALLDATETIME, @uploader INT, 
@words VARCHAR(500)
AS
BEGIN
INSERT INTO Picture_commented_User VALUES (@commenter,@date_time,@uploader,@words)
END
go
CREATE PROC user_join_club @user INT,@club_id INT,@user_club_id INT
AS
BEGIN
INSERT INTO Club_joinedby_User VALUES (@user,@club_id,@user_club_id)
END
go
/*parents*/

CREATE PROC create_parent @username VARCHAR(20),@password VARCHAR(20),@email VARCHAR(50),@job VARCHAR(20),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20),@phone INT
AS
BEGIN
INSERT INTO Users VALUES (@username,@password)
DECLARE @u_id INT
SELECT @u_id=u.u_id FROM Users u WHERE u.username=@username 
INSERT INTO Parents VALUES (@u_id,@email,@job,@house_number,@st_name,@area,@country)
INSERT INTO Parent_Phones VALUES (@u_id,@phone)
END
go
CREATE PROC add_parent_phone @id INT,@phone INT
AS
BEGIN
INSERT INTO Parent_Phones VALUES (@id,@phone)
END
go


CREATE PROC create_route(@id INT,@r_name VARCHAR(20))
AS
BEGIN 
INSERT INTO Routes (r_name,creator)VALUES (@r_name,@id)
END 
go
CREATE PROC specify_start_end_route(@id INT,@r_name VARCHAR(20),@start VARCHAR(100),@end VARCHAR(100))
AS 
BEGIN
UPDATE Routes SET start_location=@start,end_location=@end WHERE r_name=@r_name AND creator=@id
END
go

CREATE PROC specify_frequency_max(@id INT,@r_name VARCHAR(20),@frequency VARCHAR(50),@max INT)
AS 
BEGIN
UPDATE Routes SET frequency=@frequency,max_number=@max WHERE r_name=@r_name AND creator=@id
END
go

CREATE PROC invite_to_carpool(@invitor INT,@creator INT,@route VARCHAR(20),@invited INT)
AS 
BEGIN
IF (@invitor=@creator OR dbo.invited_to_route(@invitor,@creator,@route)='1')
INSERT INTO Route_invite_User1_User2 VALUES (@invitor,@invited,@route,@creator,NULL)
END
go
CREATE PROC create_route_stops(@id INT,@r_name VARCHAR(20),@stops VARCHAR(50) )
AS 
BEGIN
INSERT INTO Route_stops VALUES (@r_name,@id,@stops)
END

go
CREATE PROC accept_reject_carpool @invited INT,@creator INT,@route INT,@status INT
AS 
BEGIN
UPDATE Route_invite_User1_User2
SET status=@status WHERE  @invited=invited AND @creator=creator AND @route=r_name
END
go
CREATE PROC provide_info_for_child @parent INT,@child INT,@birthdate SMALLDATETIME,@hobby VARCHAR(15),@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Child_infofrom_Parent VALUES (@parent,@child,@birthdate,NULL)
IF(@hobby IS NOT NULL)
INSERT INTO Provided_Hobbies VALUES(@parent,@child,@hobby)
IF (@interest IS NOT NULL)
INSERT INTO Provided_Interests VALUES (@parent,@child,@interest)
END
go
CREATE PROC provide_hobbies @parent INT,@child INT,@hobby VARCHAR(15)
AS
BEGIN
INSERT INTO Provided_Hobbies VALUES (@parent,@child,@hobby)
END
go
CREATE PROC provide_interests @parent INT,@child INT,@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Provided_Interests VALUES (@parent,@child,@interest)
END
go
CREATE PROC create_event @creator INT, @e_name VARCHAR (50), @date_time SMALLDATETIME, @dsc VARCHAR(500), @e_type VARCHAR(20),
@purpose VARCHAR (500),@house_number INT,@st_name VARCHAR(20),@area VARCHAR(20),@country VARCHAR(20),@organizer INT
AS 
BEGIN
INSERT INTO Events VALUES(@creator,@e_name,@date_time,@dsc,@e_type,@purpose,@house_number,@st_name,@area,@country,@organizer)
END
go
CREATE PROC invite_to_event @sender INT,@receiver INT,@creator INT,@event VARCHAR(50)
AS
BEGIN
IF(@sender=@creator OR dbo.invited_to_event(@sender,@creator,@event)='1')
INSERT INTO User_invites_User_Event VALUES (@sender,@receiver,@creator,@event,NULL)
END
go
/* children */

CREATE PROC create_child @username VARCHAR(20),@password VARCHAR(20),@schoolname VARCHAR(20),@birthdate SMALLDATETIME
AS
BEGIN
INSERT INTO Users VALUES (@username,@password)
DECLARE @id INT
DECLARE @schoolid INT 
SELECT @id=u.u_id FROM Users u WHERE @username=u.username
SELECT @schoolid=s.u_id FROM Users s WHERE s.username=@schoolname AND EXISTS(SELECT * FROM Schools s2 WHERE s2.u_id=s.u_id )
INSERT INTO Children (u_id,birth_date,school_id,school_status)VALUES (@id,@birthdate,@schoolid,NULL)
END
go
CREATE PROC enter_hobbies @id INT,@hobby VARCHAR(15)
AS
BEGIN
INSERT INTO Child_Hobbies VALUES (@id,@hobby)
END
go
CREATE PROC enter_interests @id INT,@interest VARCHAR(15)
AS
BEGIN
INSERT INTO Child_Interests VALUES (@id,@interest)
END
go
CREATE PROC approve_provided_info @child INT,@parent INT,@status BIT
AS
BEGIN
DECLARE @young BIT
SELECT @young=c.y_t FROM Children c WHERE c.u_id=@child
IF(@young='0')
BEGIN
UPDATE Child_infofrom_Parent 
SET status=@status 
WHERE child=@child AND parent=@parent
END
END
go

CREATE PROC take_quiz @id INT,@quiz VARCHAR(20)
AS
BEGIN
DECLARE @age INT 
SELECT @age=c.age FROM Children c WHERE c.u_id=@id
SELECT * FROM
Questions qs 
WHERE qs.quiz_name=@quiz AND @age>=qs.min_age AND @age<=qs.max_age
END
go
CREATE PROC answer_question @answerer INT,@quiz VARCHAR(20),@question VARCHAR(20),@answer VARCHAR(1000)
AS
BEGIN
INSERT INTO Question_answered_by_User VALUES (@answerer,@quiz,@question,@answer)
END
go
/* schools */
CREATE PROC create_school @username VARCHAR(20),@password VARCHAR(20),@ed_system VARCHAR(20),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20)
AS
BEGIN
INSERT INTO Users VALUES(@username,@password)
DECLARE @id INT
SELECT @id=u.u_id FROM Users u WHERE u.username=@username
INSERT INTO Schools VALUES (@id,@ed_system,@house_number,@st_name,@area,@country)
END
go
CREATE PROC create_discussion_board @school INT,@d_subject VARCHAR(20)
AS
BEGIN 
INSERT INTO Discussion_boards VALUES (@d_subject,@school)
END
go
CREATE PROC accept_reject_child @child INT,@status BIT
AS
BEGIN
UPDATE Children
SET school_status=@status
WHERE u_id=@child
END
go
CREATE PROC invite_expert @expert INT,@school INT
AS 
BEGIN
INSERT INTO Expert_invited_by_School VALUES (@expert,@school)
END
go

/*club principal*/
CREATE PROC create_club @club_name VARCHAR(20),@house_number INT,@st_name VARCHAR(20),@area VARCHAR(20),
@country VARCHAR(20),@opening_time SMALLDATETIME,@closing_time SMALLDATETIME,@fees INT,@admin INT
AS
BEGIN
INSERT INTO Clubs VALUES(@club_name,@house_number,@st_name,@area,@country,@opening_time,@closing_time,@fees,@admin)
END
go
/*advertiser*/

CREATE PROC show_ad_to_school @advertiser INT,@advertisment INT,@school INT
AS
BEGIN
IF(EXISTS(SELECT * FROM Advertiser_incontract_School acs WHERE acs.advertiser=@advertiser AND acs.school=@school))
INSERT INTO Advertisment_shownby_School VALUES (@advertisment,@advertiser,@school)
END
go
/*admin*/
CREATE PROC add_advertiser @a_name VARCHAR(15),@field VARCHAR(15),@house_number INT,@st_name VARCHAR(20),
@area VARCHAR(20),@country VARCHAR(20),@phone INT
AS
BEGIN
INSERT INTO Advertisers  VALUES (@a_name,@field,@house_number,@st_name,@area,@country)
DECLARE @aid INT
SELECT @aid=a.a_id FROM Advertisers a WHERE a.a_name=@a_name
INSERT INTO Advertiser_Phones VALUES (@aid,@phone)
END
go
CREATE PROC add_advertiser_phone @aid INT,@phone INT
AS
BEGIN
INSERT INTO Advertiser_Phones VALUES (@aid,@phone)
END
go
CREATE PROC link_advertiser_to_school @advertiser INT,@school INT
AS
BEGIN
INSERT INTO Advertiser_incontract_School VALUES (@advertiser,@school)
END
go
CREATE PROC create_quiz @quiz VARCHAR(20)
AS
BEGIN 
INSERT INTO Quizzes VALUES (@quiz)
END
go
CREATE PROC create_question @quiz VARCHAR(20),@question_name VARCHAR(20),@question VARCHAR(2000),@answer VARCHAR(1000),
@min_age INT,@max_age INT
AS
BEGIN
INSERT INTO Questions VALUES(@quiz,@question_name,@question,@answer,@min_age,@max_age)
END

go