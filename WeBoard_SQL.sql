CREATE TABLE BBS
(BBSID NUMBER(20) NOT NULL PRIMARY KEY,
USRID VARCHAR2(15) NOT NULL,
bbsTITLE VARCHAR2(75) NOT NULL,
bbsDate TIMESTAMP NOT NULL,
READCOUNT NUMBER DEFAULT 0,
REF NUMBER(20) NOT NULL,
RE_STEP NUMBER(10) NOT NULL,
RE_LEVEL NUMBER(10) NOT NULL,
bbsCONTENT VARCHAR2(3000) NOT NULL,
notice number(2) NOT NULL,
filename VARCHAR2(75));

drop table bbs;
select * from bbs;


CREATE TABLE USR
(
usrId VARCHAR(20) PRIMARY KEY,
usrPasswd VARCHAR2(20),
usrName VARCHAR2(20),
usrGender VARCHAR2(20),
usrEmail VARCHAR2(20),
usrDelete NUMBER(2),
delDate TIMESTAMP);

drop table usr;
select * from usr;


commit;
