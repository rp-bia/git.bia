/* Script which creates the lu_member_subscriber table containing PHI, source member and subscriber information and the PatientID from CCGroup.  
bia_membership_phi, bia_memberdecoder_phi and bia_subscriberdecoder_phi csvs need to be loaded to /var/lib/mysql-files/ first.  
NEEDS TO BE RUN AFTER TABLE MOVER.  */

CREATE TABLE hipa.bia_membership_phi (`MemberID` int, `SubscriberID` int, `RelationType` varchar(255), `MemberLastName` varchar(255), `MemberFirstName` varchar(255), `MemberMI` varchar(255), `MemberDOB` varchar(255), `MaritalStatus` varchar(255), `Gender` varchar(255), `MemberAddress` varchar(255), `MemberAddress2` varchar(255), `MemberCity` varchar(255), `MemberState` varchar(255), `MemberZip` varchar(255), `MemberPhone` varchar(255), `Region` varchar(255), `CoverageStartDate` varchar(255), `CoverageExitDate` varchar(255), `PCPName` varchar(255), `PCPPhone` varchar(255), `PCPID` int, `EligibilityCategory` varchar(255), `MedicareIndicator` varchar(255), `MedicareBeginDate` varchar(255), `MedicareEndDate` varchar(255), `WaiverStatus` varchar(255), `Carrier` varchar(255), `ReportedRAFScore` varchar(255), `CalculatedRAFScore` varchar(255), `Final` varchar(255));
LOAD DATA INFILE
'/var/lib/mysql-files/Bia-Membership_PHI.csv'
INTO TABLE hipa.bia_membership_phi
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

CREATE TABLE hipa.bia_memberdecoder_phi (`MemberID_SOURCE` int, `MemberID` int);
LOAD DATA INFILE
'/var/lib/mysql-files/Bia-MemberDecoder_PHI.csv'
INTO TABLE hipa.bia_memberdecoder_phi
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

CREATE TABLE hipa.bia_subscriberdecoder_phi (`SubscriberID_SOURCE` varchar(255), `SubscriberID` int);
LOAD DATA INFILE
'/var/lib/mysql-files/Bia-SubscriberDecoder_PHI.csv'
INTO TABLE hipa.bia_subscriberdecoder_phi
FIELDS TERMINATED BY ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

drop table hipa.lu_member_subscriber;
create table hipa.lu_member_subscriber as select distinct a.MemberID, a.SubscriberID, b.MemberID_SOURCE, c.SubscriberID_SOURCE, 
concat(a.subscriberid,':',a.memberid) as Patient, 
d.PatientId, a.MemberLastName, a.MemberFirstName, a.MemberMI, a.MemberDOB, a.Gender, a.MemberCity, a.MemberState, 
a.MemberZip, a.CalculatedRAFScore, a.ReportedRAFScore, tbl2.PCPID 
from (hipa.bia_membership_phi as a 
inner join bia_memberdecoder_phi as b on a.memberid=b.MemberID 
inner join bia_subscriberdecoder_phi as c on a.SubscriberID=c.SubscriberID  
inner join 
(select a.memberid, a.subscriberid, a.pcpid from bia_membership_phi as a inner join  (select distinct a.memberid, a.subscriberid, 
max(str_to_date(if(CoverageExitDate ='','01/01/2099',Coverageexitdate), '%m/%d/%Y')) as CoverageExitDate from hipa.bia_membership_phi as a group by a.memberid, a.subscriberid ) as tbl 
on a.memberid=tbl.memberid and a.subscriberid=tbl.subscriberid and str_to_date(if(a.CoverageExitDate ='','01/01/2099',a.Coverageexitdate), '%m/%d/%Y')=tbl.CoverageExitDate) as tbl2 on a.memberid=tbl2.memberid and a.subscriberid=tbl2.SubscriberID) 
left outer join CCGroup.PatientMapping as d on a.memberid=substring(d.patient,instr(d.patient,":")+1) and a.SubscriberID=substring(d.patient,1,instr(d.patient,":")-1);

CREATE UNIQUE INDEX `idx_lu_member_subscriber_MemberID_SubscriberID`  ON `hipa`.`lu_member_subscriber` (MemberID, SubscriberID) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;
CREATE INDEX `idx_lu_member_subscriber_PatientId`  ON `hipa`.`lu_member_subscriber` (PatientId) COMMENT '' ALGORITHM DEFAULT LOCK DEFAULT;

drop table hipa.bia_membership_phi;
drop table hipa.bia_memberdecoder_phi;
drop table hipa.bia_subscriberdecoder_phi;
 