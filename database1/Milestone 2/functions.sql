/* * * * * * * * *
 *   FUNCTIONS   *              
 * * * * * * * * */
CREATE FUNCTION get_age(@birth_date SMALLDATETIME) RETURNS INT
AS
BEGIN
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
RETURN @age
END

CREATE FUNCTION young_teenager(@birth_date SMALLDATETIME) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
IF(@age<12)
SET @return ='0'
ELSE
SET @return='1'
RETURN @return
END

GO

CREATE FUNCTION parent_of_child(@parent INT,@child INT) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM Child_of_Parent WHERE parent=@parent AND child = @child AND status='1'))
SET @return='1'
ELSE 
SET @return='0'
RETURN @return
END
GO
CREATE FUNCTION valid_age(@birth_date SMALLDATETIME) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @age  INT
SET @age =(YEAR(CURRENT_TIMESTAMP)- YEAR(@birth_date))
IF(@age<20 AND @age>3)
SET @return ='1'
ELSE
SET @return='0'
RETURN @return
END

GO
CREATE FUNCTION user_type(@u_id INT)RETURNS CHAR(1)
AS
BEGIN
DECLARE @return CHAR(1)
IF(EXISTS (SELECT * FROM Children c WHERE @u_id=c.u_id))
SET @return='C'
ELSE IF(EXISTS (SELECT * FROM Parents p WHERE @u_id=p.u_id))
SET @return='P'
ELSE IF(EXISTS (SELECT * FROM Schools s WHERE @u_id=s.u_id))
SET @return='S'
ELSE IF(EXISTS (SELECT * FROM Experts e WHERE @u_id=e.u_id))
SET @return='E'
RETURN @return
END
GO

CREATE FUNCTION user_linkedto_school(@u_id INT,@s_id INT) RETURNS BIT
AS
BEGIN
DECLARE @return BIT
DECLARE @type CHAR(1)
SET @type =	dbo.user_type(@u_id)
IF(@type='C')
IF(EXISTS(SELECT * FROM Children WHERE u_id=@u_id AND school_id=@s_id ))
SET @return ='1'
ELSE IF (@type='P')
IF(EXISTS(SELECT * FROM Children c INNER JOIN Child_of_Parent o ON c.c_id=o.child INNER JOIN Parents p ON o.parent=
p.p_id WHERE p.u_id = @u_id AND c.school_id=@s_id  ))
SET @return='1'
ELSE SET @return ='0'
RETURN @return
END
GO
CREATE FUNCTION advertiser_contracted_school(@a_id INT,@s_id INT) RETURNS BIT
AS 
BEGIN
DECLARE @return BIT
IF (EXISTS(SELECT * FROM Advertiser_incontract_School WHERE advertiser=@a_id AND school=@s_id))
SET @return='1'
ELSE SET @return='0'
RETURN @return
END
GO

CREATE FUNCTION valid_supervisor(@supervisor INT,@s_name VARCHAR(20),@club_id INT) RETURNS BIT
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
SET @return='1'
ELSE IF(@admin=@supervisor)
SET @return='1'
ELSE SET @return='0'
RETURN @return 
END
GO
CREATE FUNCTION are_friends(@user1 INT,@user2 INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS(SELECT * FROM User1_freq_User2 freq WHERE freq.status='1' AND ((freq.sender=@user1 AND freq.receiver=@user2)OR(
freq.sender=@user2 AND freq.receiver=@user1) )))
SET @return='1'
ELSE 
SET @return='0'
RETURN @return
END
GO
CREATE FUNCTION is_linked_to_school(@user INT,@school INT)
RETURN BIT
AS 
BEGIN
DECLARE @return BIT
IF(dbo.user_type(@user)='C')
BEGIN
DECLARE @school2 INT
SELECT @school2=c.school_id FROM Children c WHERE c.u_id=@user
IF(@school=@school2)
SET @return = '1'
END
ELSE IF (dbo.user_type(@user)='P')
IF (EXISTS (SELECT * FROM Parents p INNER JOIN Child_of_Parent cop ON p.u_id=cop.parent INNER JOIN Children c ON cop.child=c.u_id
WHERE c.school_id=@school))
SET @return='1'
ELSE IF (dbo.user_type(@user)='E' AND EXISTS(SELECT * FROM Expert_invited_by_School eis WHERE eis.school=@school AND
eis.expert=@user))
SET @return='1'
ELSE IF (dbo.user_type(@user)='S' AND @school=@user)
SET @return='1'
ELSE SET @return='0'
RETURN @return
END
GO
CREATE FUNCTION invited_to_event(@receiver INT,@creator INT,@e_name INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM User_invites_User_Event invite WHERE invite.receiver=@receiver AND invite.creator=@creator AND 
invite.e_name=@e_name ))
SET @return='1'
ELSE SET @return='0'
RETURN @return
END
GO
CREATE FUNCTION invited_to_route(@invited INT,@creator INT,@r_name INT)
RETURNS BIT
AS
BEGIN
DECLARE @return BIT
IF(EXISTS (SELECT * FROM  Route_invite_User1_User2 invite WHERE invite.invited=@receiver AND invite.creator=@creator AND 
invite.r_name=@r_name ))
SET @return='1'
ELSE SET @return='0'
RETURN @return
END
GO
CREATE FUNCTION thread_count (@school INT,@d_subject VARCHAR(20))
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
GO
CREATE FUNCTION reply_count (@school INT,@d_subject VARCHAR(20),@thread INT)
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
GO