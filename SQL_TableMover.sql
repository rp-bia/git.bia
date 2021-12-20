DROP TABLE IF EXISTS hipa.Project;
CREATE TABLE hipa.Project
LIKE CCGroup.Project;
ALTER TABLE hipa.Project ADD COLUMN DataRun INT;
ALTER TABLE hipa.Project ADD COLUMN RecentYear INT;
ALTER TABLE hipa.Project ADD COLUMN ChargeVarId INT;
INSERT hipa.Project
SELECT *, 
if(t1.ProjectId>99999 , CONVERT(SUBSTRING(CONVERT(t1.ProjectId, CHAR), 1, 6), UNSIGNED), -1) DataRun, 
if(t1.ProjectId>99999999 , CONVERT(SUBSTRING(CONVERT(t1.ProjectId, CHAR), 9, 1), UNSIGNED), -1) RecentYear,
if(t1.ProjectId>999999999 , CONVERT(SUBSTRING(CONVERT(t1.ProjectId, CHAR), 10, 1), UNSIGNED), 0) ChargeVarId
FROM CCGroup.Project t1;
ALTER TABLE hipa.Project CHANGE ProjectId Project INT;

/* DROP TABLE IF EXISTS hipa.LU_MktBasket;
CREATE TABLE hipa.LU_MktBasket AS
	SELECT t1.Project, t2.MktBasket, t2.MBName FROM hipa.Project t1
	join	hipa.MktBasketMapping t2
		  on 	(t1.SystemTblId = t2.SystemTblId); */
          
DROP TABLE IF EXISTS hipa.LU_MarketBasket;
CREATE TABLE hipa.LU_MarketBasket AS
	SELECT MktBasket, MBName MktBasket_DESC FROM hipa.MktBasketMapping where SystemTblId=92101;

DROP TABLE IF EXISTS hipa.LU_MktBasket;
CREATE TABLE hipa.LU_MktBasket AS
	SELECT 	t1.MktBasket, t4.MBName, t1.MCID, t1.SOI, t1.MCOrder, t1.Weight, t3.Active, t3.PMCId, t3.PMCIndex, t3.MCName, t3.LongName, 
			t3.EpisodeCategory, t3.WindowPeriod, t3.NumSeverities, RankBucket, t2.Includes, t2.Excludes 
            FROM hipa.MBConditions t1
	left join hipa.MedCondDefinition as t2
		on (t1.SystemTblId=t2.SystemTblId) and (t1.MCID=t2.MCID) and (t1.SOI=t2.SOI)
	left join hipa.MedCondMapping as t3
		on (t1.MCID=t3.MCID)
	left join hipa.MktBasketMapping as t4
		on (t1.SystemTblId=t4.SystemTblId) and (t1.MktBasket=t4.MktBasket)
	where t1.SystemTblId=92101;

DROP TABLE IF EXISTS hipa.Detail;
CREATE TABLE hipa.Detail
LIKE CCGroup.Detail;
INSERT hipa.Detail
SELECT *
FROM CCGroup.Detail;

DROP TABLE IF EXISTS hipa.EpMaster;
CREATE TABLE hipa.EpMaster
LIKE CCGroup.EpMaster;
INSERT hipa.EpMaster
SELECT *
FROM CCGroup.EpMaster;

DROP TABLE IF EXISTS hipa.PvPatientDemographics;
CREATE TABLE hipa.PvPatientDemographics
LIKE CCGroup.PvPatientDemographics;
INSERT hipa.PvPatientDemographics
SELECT *
FROM CCGroup.PvPatientDemographics;

DROP TABLE IF EXISTS hipa.w_PvEpisodes;
CREATE TABLE hipa.w_PvEpisodes
LIKE CCGroup.w_PvEpisodes;
INSERT hipa.w_PvEpisodes
SELECT *
FROM CCGroup.w_PvEpisodes;
/* ALTER TABLE hipa.w_PvEpisodes CHANGE Project ProjectId INT; */

DROP TABLE IF EXISTS hipa.w_PvGaps;
CREATE TABLE hipa.w_PvGaps
LIKE CCGroup.w_PvGaps;
INSERT hipa.w_PvGaps
SELECT *
FROM CCGroup.w_PvGaps;
/* ALTER TABLE hipa.w_PvGaps CHANGE Project ProjectId INT; */

DROP TABLE IF EXISTS hipa.w_PatientStats;
CREATE TABLE hipa.w_PatientStats
LIKE CCGroup.w_PatientStats;
INSERT hipa.w_PatientStats
SELECT *
FROM CCGroup.w_PatientStats;
/* ALTER TABLE hipa.w_PatientStats CHANGE Project ProjectId INT; */

DROP TABLE IF EXISTS hipa.Cli_Core;
CREATE TABLE hipa.Cli_Core
LIKE CCGroup.Cli_Core;
INSERT hipa.Cli_Core
SELECT *
FROM CCGroup.Cli_Core;

DROP TABLE IF EXISTS hipa.MeasureDef;
CREATE TABLE hipa.MeasureDef
LIKE CCGroup.MeasureDef;
INSERT hipa.MeasureDef
SELECT *
FROM CCGroup.MeasureDef;

DROP TABLE IF EXISTS hipa.CondMeasure;
CREATE TABLE hipa.CondMeasure
LIKE CCGroup.CondMeasure;
INSERT hipa.CondMeasure
SELECT *
FROM CCGroup.CondMeasure /*
where SystemTblId=921703 */;

DROP TABLE IF EXISTS hipa.MedCondDefinition;
CREATE TABLE hipa.MedCondDefinition
LIKE CCGroup.MedCondDefinition;
INSERT hipa.MedCondDefinition
SELECT *
FROM CCGroup.MedCondDefinition ;

DROP TABLE IF EXISTS hipa.MedCondMapping;
CREATE TABLE hipa.MedCondMapping
LIKE CCGroup.MedCondMapping;
INSERT hipa.MedCondMapping
SELECT *
FROM CCGroup.MedCondMapping;

DROP TABLE IF EXISTS hipa.PVMeasures;
CREATE TABLE hipa.PVMeasures
LIKE CCGroup.PVMeasures;
INSERT hipa.PVMeasures
SELECT *
FROM CCGroup.PVMeasures
where Project like "202%";

DROP TABLE IF EXISTS hipa.PVPredictiveVars;
CREATE TABLE hipa.PVPredictiveVars
LIKE CCGroup.PVPredictiveVars;
INSERT hipa.PVPredictiveVars
SELECT *
FROM CCGroup.PVPredictiveVars;

DROP TABLE IF EXISTS hipa.PRVMapping;
CREATE TABLE hipa.PRVMapping
LIKE CCGroup.PRVMapping;
INSERT hipa.PRVMapping
SELECT *
FROM CCGroup.PRVMapping;

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

drop table hipa.bia_membership_phi;
drop table hipa.bia_memberdecoder_phi;
drop table hipa.bia_subscriberdecoder_phi;
 