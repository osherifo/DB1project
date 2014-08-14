CREATE PROC delete_user @u_id INT
AS
BEGIN
DELETE FROM User1_freq_User2 WHERE User1_freq_User2.receiver=@u_id 
DELETE FROM Replies WHERE Reply.writer=@u_id
DELETE FROM Threads WHERE Threads.starter=@u_id
DELETE FROM Post_commented_User WHERE Post_commented_User.commenter=@u_id
DELETE FROM Picture_commented_User WHERE Picture_commented_User.commentor=@u_id
DELETE FROM Picture_tags_User1_User2 WHERE  Picture_tags_User1_User2.tagger=@u_id OR 
Picture_tags_User1_User2.tagged=@u_id 

DELETE FROM Pictures WHERE Pictures.posted_on_user=@u_id
DELETE FROM Posts WHERE Posts.posted_on_user=@u_id

EXECUTE delete_events_by_creator @u_id	
EXECUTE delete_routes_by_creator @u_id

DELETE FROM User_invites_User_Event WHERE User_invites_User_Event.receiver=@u_id
DELETE FROM Route_invite_User1_User2 WHERE Route_invite_User1_User2.invited=@u_id
DELETE FROM Club_joinedby_User WHERE Club_joinedby_User.joiner=@u_id
DELETE FROM Sports WHERE Sports.supervisor=@u_id

IF (dbo.user_type(@u_id)='C')
BEGIN
DELETE FROM Child_of_Parent WHERE Child_of_Parent.child=@u_id
DELETE FROM Child_infofrom_Parent WHERE Child_infofrom_Parent.child=@u_id/*CREATE DELETE FOR THIS TABLE*/
DELETE FROM Children WHERE  Children.child=@u_id
END

ELSE IF (dbo.user_type(@u_id)='E')
BEGIN
DELETE FROM Expert_invited_by_School WHERE Expert_invited_by_School.expert=@u_id
DELETE FROM Experts_taggedin_Threads WHERE Experts_taggedin_Threads.expert=@u_id
END
DELETE FROM Users WHERE Users.u_id=@u_id

END

CREATE PROC delete_event @creator INT,@e_name VARCHAR(20)
AS
BEGIN
DELETE FROM User_invites_User_Event  WHERE creator=@creator AND e_name=@e_name
DELETE FROM Events  WHERE creator=@creator AND e_name=@e_name  
END

CREATE PROC delete_route @creator INT,@r_name VARCHAR(20)
AS
BEGIN
DELETE FROM Route_invite_User1_User2 WHERE creator=@creator AND r_name=@r_name
DELETE FROM Routes  WHERE creator=@creator AND r_name=@r_name
END


CREATE PROC delete_events_by_creator @creator INT
AS
BEGIN
DELETE FROM User_invites_User_Event e WHERE e.creator=@creator 
DELETE FROM Events f WHERE f.creator=@creator   
END

CREATE PROC delete_routes_by_creator @creator INT
AS
BEGIN
DELETE FROM Route_invite_User1_User2 i WHERE i.creator=@creator
DELETE FROM Routes r WHERE r.creator=@creator 
END



/*all other deletions can be done manually*/


