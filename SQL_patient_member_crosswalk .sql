/* WITH PatientMemberCrosswalk as 
  (SELECT PM.PatientID, PM.Patient,   
          SUBSTRING_INDEX(PM.Patient, ':', 1) as SubscriberID, 
          SUBSTRING_INDEX(PM.Patient, ':', -1) as MemberID 
   FROM CCGroup.PatientMapping PM)
SELECT * FROM hipa.bia_membership_nophi MBR LEFT JOIN PatientMemberCrosswalk 
ON ((MBR.MemberID=PatientMemberCrosswalk.MemberID) AND (MBR.SubscriberID=PatientMemberCrosswalk.SubscriberID));


DROP TABLE IF EXISTS hipa.patient_member_crosswalk;
CREATE TABLE hipa.patient_member_crosswalk
(WITH PatientMemberCrosswalk as 
  (SELECT distinct PM.PatientID, PM.Patient,   
          SUBSTRING_INDEX(PM.Patient, ':', 1) as SubID, 
          SUBSTRING_INDEX(PM.Patient, ':', -1) as MbrID 
   FROM CCGroup.PatientMapping PM where PM.Patient LIKE '50%'
)
SELECT MemberID, SubscriberID, Patient, PatientID
FROM hipa.bia_membership_nophi MBR 
LEFT JOIN PatientMemberCrosswalk 
ON ((MBR.MemberID=PatientMemberCrosswalk.MbrID) AND (MBR.SubscriberID=PatientMemberCrosswalk.SubID)
));
*/

DROP TABLE IF EXISTS hipa.patient_member_crosswalk;
CREATE TABLE hipa.patient_member_crosswalk AS
   SELECT PM.PatientID, PM.Patient,   
          SUBSTRING_INDEX(PM.Patient, ':', 1) as MemberID, 
          SUBSTRING_INDEX(PM.Patient, ':', -1) as SubscriberID 
   FROM CCGroup.PatientMapping PM
   where Patient like '50%';