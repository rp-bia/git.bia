SET GLOBAL innodb_buffer_pool_size=4026531840;
SELECT @@innodb_buffer_pool_size/1024/1024/1024; 
    
DROP TABLE hipa.PVScreen;
CREATE TABLE hipa.PVScreen
LIKE CCGroup.PVScreen;
INSERT hipa.PVScreen
SELECT *
FROM CCGroup.PVScreen;

DROP TABLE IF EXISTS hipa.BIA_PVScreen_Act;
CREATE TABLE hipa.BIA_PVScreen_Act AS
	select	t1.Project Project, 
			max(t2.DataRun) DataRun,
            max(t2.RecentYear) RecentYear,
			max(t2.ChargeVarID) ChargeVarID,
            t1.PatientId PatientId, 
            sum(t1.Charge) Charge
	from hipa.Cli_Core t1
    join hipa.Project t2
        on (t1.Project = t2.Project)
	where t1.Project LIKE '2021%' /* and t1.PatientId=222019 */
	group by t1.Project, t1.PatientId;
        
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Pred;
CREATE TABLE hipa.BIA_PVScreen_Pred AS
	select	t1.Project Project, 
			max(t2.DataRun) DataRun,
            max(t2.RecentYear-1) RecentYear,
			max(t2.ChargeVarID) ChargeVarID,       
			t1.PatientId PatientId, 
            sum(t1.PredictedCharge) PredictedCharge, 
			sum(t1.PredictiveScore) PredictiveScore 
		from hipa.PVScreen t1
        join hipa.Project t2
			on  (t1.Project = t2.Project) 
		where t1.Project LIKE '2021%' 
		group by t1.Project, t1.PatientId;
ALTER TABLE hipa.BIA_PVScreen_Pred ADD Charge double after PatientID;
        
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Temp;
CREATE TABLE hipa.BIA_PVScreen_Temp AS
Select t2.Project,
    t2.DataRun,
    t2.RecentYear,
    t2.ChargeVarID,
	t2.PatientId,
    t1.Charge,
    t2.PredictedCharge,
    t2.PredictiveScore 
from hipa.BIA_PVScreen_Act t1
join hipa.BIA_PVScreen_Pred t2
  on (t1.PatientId = t2.PatientId) and (t1.DataRun = t2.DataRun) and (t1.RecentYear = t2.RecentYear) and (t1.ChargeVarID = t2.ChargeVarID)
;

DROP TABLE IF EXISTS hipa.BIA_PVScreen_Future;
CREATE TABLE hipa.BIA_PVScreen_Future AS
Select *
from hipa.BIA_PVScreen_Pred where RecentYear=0;
/* ALTER TABLE hipa.BIA_PVScreeBIA_PVScreen_Futuren_Future ADD Charge double after PatientID; */

DROP TABLE IF EXISTS hipa.BIA_PVScreen_Future2;
CREATE TABLE hipa.BIA_PVScreen_Future2 AS
Select t2.* 
from hipa.BIA_PVScreen_Future t2 
join hipa.BIA_PVScreen_Act t1
        on (t1.Project = t2.Project) and (t1.PatientId = t2.PatientId);

DROP TABLE IF EXISTS hipa.BIA_PVScreen_Full;
CREATE TABLE hipa.BIA_PVScreen_Full AS
Select * from hipa.BIA_PVScreen_Temp 
union 
Select * from hipa.BIA_PVScreen_Future2;

DROP TABLE IF EXISTS hipa.BIA_PVScreen;
CREATE TABLE hipa.BIA_PVScreen AS
Select Project,
    DataRun,
    RecentYear,
    ChargeVarID,
	PatientId,
    Charge,
    PredictedCharge,
    PredictiveScore,
	CASE  
		WHEN (RecentYear = 0) THEN null
        WHEN (Charge is null) THEN 0 - PredictedCharge
		ELSE PredictedCharge - Charge
	END Err,
	CASE  
		WHEN (RecentYear = 0) THEN null
		WHEN (((Charge = 0) OR (Charge is null)) and (PredictedCharge = 0)) THEN 0
		WHEN (((Charge = 0) OR (Charge is null)) and (PredictedCharge > 0)) THEN -10
		ELSE GREATEST(LEAST(((PredictedCharge-Charge)/Charge), 10), -10)
	END ErrPct,  
	CASE  
		WHEN ((PredictiveScore <= 0.2 or PredictiveScore is null)) THEN 0
		when (PredictiveScore < 0.5) THEN 1
		WHEN (PredictiveScore < 0.7) THEN 2
		WHEN (PredictiveScore < 1.0) THEN 3
		WHEN (PredictiveScore < 1.2) THEN 4
		WHEN (PredictiveScore < 1.4) THEN 5
		ELSE 6
	END PredictiveScoreBucket_ID, 
	CASE  
		WHEN (RecentYear = 0) THEN null
		WHEN ((Charge = 0 or Charge is null)) THEN 0
		when (Charge < 2000) THEN 1
		WHEN (Charge < 5000) THEN 2
		WHEN (Charge < 40000) THEN 3
		WHEN (Charge < 70000) THEN 4
		WHEN (Charge < 100000) THEN 5
		ELSE 6
	END ActChargeBucket_ID, 
   CASE  
		WHEN ((PredictedCharge = 0 or PredictedCharge is null)) THEN 0
		when (PredictedCharge < 2000) THEN 1
		WHEN (PredictedCharge < 5000) THEN 2
		WHEN (PredictedCharge < 40000) THEN 3
		WHEN (PredictedCharge < 70000) THEN 4
		WHEN (PredictedCharge < 100000) THEN 5
		ELSE 6
	END PredChargeBucket_ID 
from hipa.BIA_PVScreen_Full;

DROP TABLE IF EXISTS hipa.BIA_PVScreen_Pred;
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Act;
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Temp;
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Future;
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Future2;
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Full;

/*
DROP TABLE IF EXISTS hipa.BIA_PVScreen_Pred;
CREATE TABLE hipa.BIA_PVScreen_Pred AS
	select	Project Project, 
			PatientId PatientId, 
			max(t3.MemberID) MemberID, 
			max(t3.SubscriberID) SubscriberID, 
			max(t3.Patient) Patient, 
            max(DataRun) DataRun,
            max(t2.RecentYear-1) RecentYear,
			max(t2.ChargeVarID) ChargeVarID,       
			max(PredictedCharge) PredictedCharge, 
			max(t1.PredictiveScore) PredictiveScore 
		from CCGroup.PVScreen t1, hipa.Project t2
		join hipa.patient_member_crosswalk t3	
		  on (t1.PatientId = t3.PatientID) and (t1.PatientId = t2.PatientID) and (t1.Project = t2.Project)
		where t1.Project LIKE '%2021%' 
		group by PatientId, Project

			max(t3.MemberID) MemberID, 
			max(t3.SubscriberID) SubscriberID, 
			max(t3.Patient) Patient, 
	join hipa.patient_member_crosswalk t3	
		  on (t1.PatientId = t3.PatientID) 


*/
