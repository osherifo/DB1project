
CREATE DATABASE MySchoolCommunity

/* * * * * * * * *
 *     USERS     *                
 * * * * * * * * */
/* users */
CREATE TABLE Users(u_id INT PRIMARY KEY IDENTITY,username VARCHAR(20)UNIQUE,password VARCHAR(20))

CREATE TABLE User1_freq_User2(sender INT,receiver INT,status BIT,PRIMARY KEY(sender,receiver),
CHECK (sender<>receiver),
FOREIGN KEY (sender) REFERENCES Users
ON DELETE CASCADE,
FOREIGN KEY (receiver) REFERENCES Users)
/* schools */
CREATE TABLE Schools(u_id INT PRIMARY KEY,ed_system VARCHAR(20),house_number INT,st_name VARCHAR(20),
area VARCHAR(20),country VARCHAR(20),
FOREIGN KEY (u_id) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE)


/* children */
CREATE TABLE Children(u_id INT PRIMARY KEY,
birth_date SMALLDATETIME,age AS(dbo.get_age(birth_date)),
y_t  AS (dbo.young_teenager(birth_date)),school_id INT,
school_status BIT,
FOREIGN KEY(school_id) REFERENCES Schools
ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (u_id) REFERENCES Users, 
CHECK (dbo.valid_age(birth_date)='1'))

CREATE TABLE Child_Hobbies (u_id INT,hobby VARCHAR(15),PRIMARY KEY(u_id,hobby),
FOREIGN KEY (u_id) REFERENCES Children
ON DELETE CASCADE    ON UPDATE CASCADE)

CREATE TABLE Child_Interests (u_id INT,interest VARCHAR(15),PRIMARY KEY(u_id,interest),
FOREIGN KEY (u_id) REFERENCES Children
ON DELETE CASCADE ON UPDATE CASCADE)

/* parents */
CREATE TABLE Parents(u_id INT PRIMARY KEY,email VARCHAR(50),job VARCHAR(20),house_number INT,st_name VARCHAR(20),
area VARCHAR(20),country VARCHAR(20),
FOREIGN KEY (u_id) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Parent_Phones(parent INT,phone INT,PRIMARY KEY(parent,phone),
FOREIGN KEY (parent) REFERENCES Parents
ON DELETE CASCADE ON UPDATE CASCADE)

/* child-parent relations */
CREATE TABLE Child_of_Parent (parent INT DEFAULT 'NOT LISTED',child INT DEFAULT 'NOT LISTED',status BIT,PRIMARY KEY(parent,child),
FOREIGN KEY (parent) REFERENCES Parents
ON DELETE CASCADE  ON UPDATE SET DEFAULT,
FOREIGN KEY (child) REFERENCES Children)

CREATE TABLE  Child_infofrom_Parent(parent INT,child INT,birthdate SMALLDATETIME,status BIT,PRIMARY KEY(parent,child),
FOREIGN KEY (parent) REFERENCES Parents
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (child) REFERENCES Children,
CHECK ( (dbo.parent_of_child(parent,child)='1')))

CREATE TABLE  Provided_Hobbies(parent INT,child INT,hobby VARCHAR(15),PRIMARY KEY(parent,child,hobby),
FOREIGN KEY (parent,child) REFERENCES Child_infofrom_Parent
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE  Provided_Interests(parent INT,child INT,interest VARCHAR(15),PRIMARY KEY(parent,child,interest),
FOREIGN KEY (parent,child) REFERENCES Child_infofrom_Parent
ON DELETE CASCADE ON UPDATE CASCADE)




/* experts */
CREATE TABLE Experts(u_id INT PRIMARY KEY,email VARCHAR(50),field VARCHAR(15),degree VARCHAR(15)
,FOREIGN KEY(u_id) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Expert_invited_by_School (expert INT,school INT,PRIMARY KEY(expert,school),
FOREIGN KEY (expert) REFERENCES Experts,
FOREIGN KEY (school) REFERENCES Schools
ON DELETE CASCADE ON UPDATE CASCADE)



/***********************************************************************************************************************
 *     ADS       *                
 * * * * * * * * */

CREATE TABLE Advertisers(a_id INT PRIMARY KEY IDENTITY,a_name VARCHAR(15) UNIQUE,field VARCHAR(15),house_number INT,st_name VARCHAR(20),
area VARCHAR(20),country VARCHAR(20))

CREATE TABLE Avertiser_Phones(a_id INT,phone INT,PRIMARY KEY(a_id,phone),
FOREIGN KEY (a_id) REFERENCES Advertisers
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Advertiser_incontract_School(advertiser INT,school INT,PRIMARY KEY(advertiser,school),
FOREIGN KEY (advertiser) REFERENCES Advertisers
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (school) REFERENCES Schools
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Advertisments(ad_id INT IDENTITY,a_id INT,ad VARCHAR(2000),PRIMARY KEY(ad_id,a_id),
FOREIGN KEY (a_id) REFERENCES Advertisers
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Advertisment_Pictures(ad_id INT,a_id INT,photo VARCHAR(60),PRIMARY KEY(ad_id,a_id,photo),
FOREIGN KEY(ad_id,a_id) REFERENCES Advertisments
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Advertisment_shownby_School(advertisment INT,advertiser INT,school INT,PRIMARY KEY(advertisment,advertiser,school),
FOREIGN KEY(advertisment,advertiser) REFERENCES Advertisments
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(school) REFERENCES Schools
ON DELETE CASCADE ON UPDATE CASCADE)


/***********************************************************************************************************************
 *DISCUSSION BOARDS*                
 * * * * * * * * * */

CREATE TABLE Discussion_Boards(subject VARCHAR(20),school INT,PRIMARY KEY(subject,school),
FOREIGN KEY (school) REFERENCES Schools
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Threads(d_subject VARCHAR(20),school INT,th_id INT,subject VARCHAR(20),topic VARCHAR(2000),
starter INT NOT NULL,PRIMARY KEY(d_subject,school,th_id),
FOREIGN KEY (d_subject,school) REFERENCES Discussion_Boards
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(starter) REFERENCES Users 
)

CREATE TABLE Replies(school INT , d_subject VARCHAR(20),thread INT, r_id INT, reply VARCHAR (2000),date SMALLDATETIME,
writer INT NOT NULL , PRIMARY KEY(school,d_subject,thread,r_id), 
FOREIGN KEY (d_subject,school,thread) REFERENCES Threads
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (writer) REFERENCES Users
)

CREATE TABLE Experts_taggedin_Threads (expert INT,school INT,d_subject VARCHAR(20),thread INT, 
PRIMARY KEY(expert,school,d_subject,thread), 
FOREIGN KEY (expert) REFERENCES Experts, 
FOREIGN KEY (d_subject,school,thread) REFERENCES Threads
ON DELETE CASCADE ON UPDATE CASCADE)


/***********************************************************************************************************************
 *UPLOADED CONTENT *                
 * * * * * * * * * */
/* Photo */
CREATE TABLE Pictures (date_time SMALLDATETIME , uploader INT, photo VARCHAR (50), 
words VARCHAR (200),date_taken SMALLDATETIME,posted_on_user INT, PRIMARY KEY (date_time,uploader),
FOREIGN KEY (uploader) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (posted_on_user) REFERENCES Users)

CREATE TABLE Photo_tags(date_time SMALLDATETIME ,uploader INT, tag VARCHAR (50), PRIMARY KEY (date_time,uploader,tag),
FOREIGN KEY (date_time,uploader) REFERENCES Pictures
ON DELETE CASCADE ON UPDATE CASCADE)


CREATE TABLE Posts (date_time SMALLDATETIME , poster INT, words VARCHAR (200),
posted_on_user INT, 
PRIMARY KEY (date_time,poster),
FOREIGN KEY (poster) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(posted_on_user) REFERENCES Users)


CREATE TABLE Post_commented_User (commenter INT, date_time SMALLDATETIME, poster INT, 
words VARCHAR(500), PRIMARY KEY (commenter,date_time,poster), 
FOREIGN KEY (commenter) REFERENCES Users ,
FOREIGN KEY(date_time,poster) REFERENCES Posts
ON DELETE CASCADE ON UPDATE CASCADE)


 
CREATE TABLE Picture_commented_User (commenter INT, date_time SMALLDATETIME, 
uploader INT, words VARCHAR(500), PRIMARY KEY (commenter,date_time,uploader),
FOREIGN KEY (commenter) REFERENCES Users,
FOREIGN KEY(date_time,uploader) REFERENCES Pictures
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Picture_tags_User1_User2(tagger INT,tagged INT,date_time SMALLDATETIME,
uploader INT, PRIMARY KEY (tagger,tagged,date_time,uploader),
FOREIGN KEY (tagger) REFERENCES Users,
FOREIGN KEY (tagged) REFERENCES Users,
FOREIGN KEY(date_time,uploader) REFERENCES Pictures
ON DELETE CASCADE ON UPDATE CASCADE ,
UNIQUE(tagged,date_time,uploader),
CHECK (tagger<>tagged))



/***********************************************************************************************************************
 *EVENT            *                
 * * * * * * * * * */
CREATE TABLE Events (creator INT, e_name VARCHAR (50), date_time SMALLDATETIME, dsc VARCHAR(500), e_type VARCHAR(20),
purpose VARCHAR (500),house_number INT,st_name VARCHAR(20),area VARCHAR(20),country VARCHAR(20),organizer INT, 
PRIMARY KEY(creator,e_name),
FOREIGN KEY(creator) REFERENCES Users,
FOREIGN KEY (organizer) REFERENCES Users
ON DELETE SET NULL ON UPDATE CASCADE)

CREATE TABLE User_invites_User_Event (sender INT,receiver INT, creator INT, e_name VARCHAR(50), status BIT, 
PRIMARY KEY (sender,receiver,creator,e_name),
FOREIGN KEY (sender) REFERENCES Users
ON DELETE  CASCADE ON UPDATE CASCADE,
FOREIGN KEY(receiver) REFERENCES Users,
FOREIGN KEY(creator,e_name)REFERENCES Events,
CHECK (dbo.user_type(sender)='P' AND sender<>receiver))

/***********************************************************************************************************************
 *ROUTE            *                
 * * * * * * * * * */

CREATE TABLE Routes(r_name VARCHAR(20),creator INT,start_location VARCHAR(100),end_location VARCHAR(100),
frequency VARCHAR(50),max_number INT,PRIMARY KEY(r_name,creator),
FOREIGN KEY (creator) REFERENCES Parents
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Route_stops(r_name VARCHAR(20),creator INT,stop VARCHAR(50),PRIMARY KEY(r_name,creator,stop),
FOREIGN KEY(r_name,creator) REFERENCES Routes
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Route_invite_User1_User2(invitor INT,invited INT,r_name VARCHAR(20),creator INT,
status BIT,PRIMARY KEY(invitor,invited,r_name,creator),
FOREIGN KEY (invitor) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(invited) REFERENCES Users,
FOREIGN KEY(r_name,creator) REFERENCES Routes,
UNIQUE(invited,r_name,creator),
CHECK (dbo.user_type(invitor)='P' AND invited<>invitor))

 
/***********************************************************************************************************************
 *CLUB             *                
 * * * * * * * * * */

CREATE TABLE Clubs(club_id INT PRIMARY KEY IDENTITY,club_name VARCHAR(20),house_number INT,st_name VARCHAR(20),area VARCHAR(20),
country VARCHAR(20),opening_time SMALLDATETIME,closing_time SMALLDATETIME,fees INT,
admin INT,
FOREIGN KEY(admin) REFERENCES Users
ON DELETE SET NULL ON UPDATE CASCADE)


CREATE TABLE Club_activities(club_id INT,activity VARCHAR(50),PRIMARY KEY(club_id,activity),
FOREIGN KEY(club_id)REFERENCES Clubs
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Club_joinedby_User(joiner INT,club_id INT,user_club_id INT UNIQUE,PRIMARY KEY(joiner,club_id),
FOREIGN KEY(joiner) REFERENCES Users,
FOREIGN KEY (club_id) REFERENCES Clubs
ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE Sports(s_name VARCHAR(20),club_id INT,house_number INT,st_name VARCHAR(20),area VARCHAR(20),
country VARCHAR(20),supervisor INT,PRIMARY KEY (s_name,club_id),
FOREIGN KEY (club_id) REFERENCES Clubs
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(supervisor) REFERENCES Users,
CHECK (dbo.valid_supervisor(supervisor,s_name,club_id)='1') )

/***********************************************************************************************************************
 *GAMES/QUIZZES    *                
 * * * * * * * * * */
CREATE TABLE Quizzes (quiz_name VARCHAR(20) PRIMARY KEY)

CREATE TABLE Questions(quiz_name VARCHAR(20),question_name VARCHAR(20),question VARCHAR(2000),answer VARCHAR(1000),min_age INT,
max_age INT,
PRIMARY KEY(quiz_name,question_name),
FOREIGN KEY(quiz_name)REFERENCES Quizzes
ON DELETE CASCADE ON UPDATE CASCADE)
/*
CREATE TABLE Quiz_offered_to_User (id INT,quiz VARCHAR(20),
PRIMARY KEY (id,quiz),
FOREIGN KEY (id) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (quiz) REFERENCES Quizzes
ON DELETE CASCADE ON UPDATE CASCADE)*/

CREATE TABLE Question_answered_by_User (answerer INT,quiz VARCHAR(20),question VARCHAR(20),answer VARCHAR(1000),
PRIMARY KEY(answerer,quiz,question),
FOREIGN KEY (answerer) REFERENCES Users
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (quiz,question) REFERENCES Questions
ON DELETE CASCADE ON UPDATE CASCADE)  
