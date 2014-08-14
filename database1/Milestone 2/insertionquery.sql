INSERT INTO Users VALUES ('omar','12345')
INSERT INTO Users VALUES ('sherif','12345')
INSERT INTO Users VALUES ('essam','12345')
INSERT INTO Users VALUES ('azzam','12345')
INSERT INTO Users VALUES ('mohamed','12345')
INSERT INTO Users VALUES ('zayan','12345')
INSERT INTO Users VALUES ('osamaexpert','12345')  
INSERT INTO Users VALUES ('fls','12345')
INSERT INTO Users VALUES ('sfs','12345')
INSERT INTO Users VALUES ('cbs','12345') 

INSERT INTO Schools VALUES ('8','language','31','somestreet','somearea','egypt')
INSERT INTO Schools VALUES ('9','american','45','somestreet','somearea','egypt')
INSERT INTO Schools VALUES ('10','international','101','somestreet','somearea','egypt')


INSERT INTO Children VALUES ('1','1/19/2000','8','1')
INSERT INTO Children VALUES ('3','11/25/2000','9','1')
INSERT INTO Children VALUES ('5','4/29/2000','10','1')

INSERT INTO Child_Hobbies VALUES ('1','reading')
INSERT INTO Child_Hobbies VALUES ('3','music')
INSERT INTO Child_Hobbies VALUES ('5','drawing')


INSERT INTO Child_Interests VALUES ('3','studying')
INSERT INTO Child_Interests VALUES ('3','sports')
INSERT INTO Child_Interests VALUES ('5','watching tv')

INSERT INTO Parents VALUES ('2','somar@hotmail.com','doctor','31','samir','nasr-city','egypt')
INSERT INTO Parents VALUES ('4','azzam@hotmail.com','doctor','21','nagaty serag','nasr-city','egypt')
INSERT INTO Parents VALUES ('6','zayan@hotmail.com','engineer','31','ibrahim','nozha','egypt')

INSERT INTO Parent_Phones VALUES('2','0100')
INSERT INTO Parent_Phones VALUES ('2','0122')

INSERT INTO Child_of_Parent VALUES ('2','1','1')
INSERT INTO Child_of_Parent VALUES ('4','3','1')
INSERT INTO Child_of_Parent VALUES ('6','5','1')

INSERT INTO Child_infofrom_Parent VALUES ('2','1','1/1/1993','1')
INSERT INTO Child_infofrom_Parent VALUES ('6','5','2/1/1992','1')

INSERT INTO Provided_Hobbies VALUES ('2','1','sailing')
INSERT INTO Provided_Interests VALUES ('6','5','football')
INSERT INTO Provided_Interests VALUES ('6','5','dancing')


INSERT INTO Experts VALUES ('7','osama@osama.com','healthcare','bachelor')
INSERT INTO Expert_invited_by_School VALUES('7','8')


INSERT INTO User1_freq_User2 VALUES ('1','3','1')
INSERT INTO User1_freq_User2 VALUES ('1','5','1')
INSERT INTO User1_freq_User2 VALUES ('3','5','1')
INSERT INTO User1_freq_User2 VALUES ('1','2','1')
INSERT INTO User1_freq_User2 VALUES ('3','4','1')
INSERT INTO User1_freq_User2 VALUES ('5','6','1')
INSERT INTO User1_freq_User2 VALUES ('1','4','1')
INSERT INTO User1_freq_User2 VALUES ('1','6',NULL)



/***********************************************************************************************************************
 *     ADS       *                
 * * * * * * * * */
INSERT INTO Advertisers VALUES ('pepsi','soda','1','street','area','us')
INSERT INTO Avertiser_Phones VALUES('1','0200')
INSERT INTO Avertiser_Phones VALUES ('1','0100')
INSERT INTO Avertiser_Phones VALUES('1','0300')
INSERT INTO Advertiser_incontract_School VALUES('1','8')
INSERT INTO Advertisments VALUES('1','Vodafone ad')
INSERT INTO Advertisment_Pictures VALUES('1','1','URL1')
INSERT INTO Advertisment_shownby_School VALUES('1','1','8')

INSERT INTO Advertisers VALUES ('COLA','soda','1','street','area','us')
INSERT INTO Avertiser_Phones VALUES('2','0200')
INSERT INTO Avertiser_Phones VALUES ('2','0100') 
INSERT INTO Avertiser_Phones VALUES('2','0300')
INSERT INTO Advertiser_incontract_School VALUES('2','9')
INSERT INTO Advertisments VALUES('2','Vodafone ad')
INSERT INTO Advertisment_Pictures VALUES('2','2','URL2')
INSERT INTO Advertisment_shownby_School VALUES('2','2','9')


/***********************************************************************************************************************
 *DISCUSSION BOARDS*                
 * * * * * * * * * */


INSERT INTO Discussion_Boards VALUES('parents meeting','9')
INSERT INTO Discussion_Boards VALUES('football team','10')
INSERT INTO Threads VALUES('parents meeting','9','1','timing','when',   
'9')
INSERT INTO Threads VALUES('football team','10','1','question','why',   
'4')

INSERT INTO Replies VALUES('9', 'parents meeting','1','1','then',CURRENT_TIMESTAMP,'2')


INSERT INTO Experts_taggedin_Threads VALUES('7','10','football team','2')
INSERT INTO Replies VALUES('10', 'football team','1','1','because',CURRENT_TIMESTAMP,'7') 




/***********************************************************************************************************************
 *UPLOADED CONTENT *                
 * * * * * * * * * */
/* Photo */
INSERT INTO Pictures VALUES ('2/2/2012','1','photo.com','old photo','1/1/2000','3')
INSERT INTO Pictures VALUES ('2/2/2002','2','photo2.com','aphoto','1/1/2001','2')
INSERT INTO Pictures VALUES ('2/2/2001','3','photo3.com','thephoto','3/1/2010','1')

INSERT INTO Photo_tags VALUES('2/2/2012','1','old')
INSERT INTO Photo_tags VALUES('2/2/2012','1','gold')
INSERT INTO Photo_tags VALUES('2/2/2012','1','hold')

INSERT INTO Posts VALUES ('4/4/2004','5','hi','3')
INSERT INTO Posts VALUES ('4/4/2001','2','hey','1')

INSERT INTO Post_commented_User VALUES('3','4/4/2004','5', 
'bye')
INSERT INTO Post_commented_User VALUES('2','4/4/2004','5', 
'1')
INSERT INTO Post_commented_User VALUES('1','4/4/2004','5', 
'two')


 
INSERT INTO Picture_commented_User VALUES ('2','2/2/2012', 
'1','wow')

INSERT INTO Picture_commented_User VALUES ('3','2/2/2012', 
'1','ha')

INSERT INTO Picture_commented_User VALUES ('4','2/2/2012', 
'1','ho')

INSERT INTO Picture_tags_User1_User2 VALUES('1','2','2/2/2012',
'1')

INSERT INTO Picture_tags_User1_User2 VALUES('2','3','2/2/2012',
'1')
INSERT INTO Picture_tags_User1_User2 VALUES('3','4','2/2/2012',
'1')

/***********************************************************************************************************************
 *EVENT*                
 * * * */
INSERT INTO Events VALUES ('6','thevent', '1/1/2014','small event','gathering',
'gather','1','homestreet','area','eg','4')
INSERT INTO Events VALUES ('2','anevent', '1/2/2014','big event','birthday party',
'celebrate','3','astreet','anarea','eg','7')

INSERT INTO User_invites_User_Event VALUES('6','2','6','thevent',NULL)
INSERT INTO User_invites_User_Event VALUES('2','4','2','anevent','1')
INSERT INTO User_invites_User_Event VALUES('4','6','2','anevent',NULL)

/***********************************************************************************************************************
 *ROUTE            *                
 * * * * * * * * * */

INSERT INTO Routes VALUES ('morningschoolroute','2','here','there','daily','15')
INSERT INTO Routes VALUES ('theroute','4','start','end','daily','20')
INSERT INTO Route_stops VALUES('morningschoolroute','2','halfway')

INSERT INTO Route_invite_User1_User2 VALUES ('2','4','morningschoolroute','2',
'1')

INSERT INTO Route_invite_User1_User2 VALUES ('4','6','morningschoolroute','2',
NULL)


/***********************************************************************************************************************
 *CLUB             *                
 * * * * * * * * * */

INSERT INTO Clubs VALUES('water club','1','thestreet','area','egypt','8:00','19:00','260','9')
INSERT INTO Clubs VALUES('boxing club','6','street','thearea','nl','11:00','16:00','30','6')
INSERT INTO Clubs VALUES('detective club','22','Bstreet','area','uk','8:00','16:00','200','2')


INSERT INTO Club_activities VALUES ('1','swimming')
INSERT INTO Club_activities VALUES ('2','BOXING')
INSERT INTO Club_activities VALUES ('3','detecting')

INSERT INTO Club_joinedby_User VALUES ('1','3','1926')
INSERT INTO Club_joinedby_User VALUES ('3','2','7610')
INSERT INTO Club_joinedby_User VALUES ('5','1','0422')

INSERT INTO Sports VALUES('waterpolo','1','2','st','area','egypt','9')
INSERT INTO Sports VALUES('fencing','2','31','somestreet','somearea','egypt','8')

/***********************************************************************************************************************
 *GAMES/QUIZZES    *                
 * * * * * * * * * */
INSERT INTO Quizzes VALUES ('trivia')
INSERT INTO Questions VALUES('trivia','q1','what?','yes','4','20')
INSERT INTO Questions VALUES('trivia','q2','where?','here','4','20')
INSERT INTO Questions VALUES('trivia','q3','?','!','20','100')

INSERT INTO Question_answered_by_User VALUES('1','trivia','q1','no')
INSERT INTO Question_answered_by_User VALUES('3','trivia','q2','there')  

