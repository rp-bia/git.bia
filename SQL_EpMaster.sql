DROP TABLE IF EXISTS hipa.EpMaster_Counts; 
CREATE TABLE hipa.EpMaster_Counts (
    Project INT,
    PatientId INT,
    EpisodeId INT,
    EpMCID INT, 
    EpSOI INT,
    EpCount INT
);
INSERT INTO hipa.EpMaster_Counts ( 
SELECT t1.Project, t1.PatientId, t1.EpisodeId, t1.EpMCID, t1.EpSOI, count(t1.EpisodeId) EpCount
FROM CCGroup.EpMaster t1
group by Project, PatientId, EpisodeId, EpMCID, EpSOI
order by Project, PatientId, EpisodeId, EpMCID, EpSOI); 

DROP TABLE IF EXISTS hipa.EpMaster_Top; 
CREATE TABLE hipa.EpMaster_Top (
    Project INT,
    EpisodeId INT,
    PatientId INT,
    EpMCID INT, 
    EpSOI INT,
    EpPartial INT,
    EpComorbid INT, 
    Duration INT, 
    EpCharges double,
	ProfCharges double,
    EpUtil double, 
    EpReserved1 varchar(255),
    EpReserved2 varchar(255)
);
INSERT INTO hipa.EpMaster_Top ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, t1.EpPartial, t1.EpComorbid, t1.Duration, t1.EpCharges, t1.ProfCharges,
       (t1.Ep_CatUtl1 + t1.Ep_CatUtl2 + t1.Ep_CatUtl3 + t1.Ep_CatUtl4 + t1.Ep_CatUtl5 + t1.Ep_CatUtl6 + t1.Ep_CatUtl7 + t1.Ep_CatUtl8 + t1.Ep_CatUtl9 + t1.Ep_CatUtl10 + t1.Ep_CatUtl11) EpUtil, 
       EpReserved1, EpReserved2
FROM CCGroup.EpMaster t1
order by Project, PatientId, EpMCID, EpSOI, EpisodeId
); 

DROP TABLE IF EXISTS hipa.EpMaster_Cat;
CREATE TABLE hipa.EpMaster_Cat (
    Project INT,
    EpisodeId INT,
    PatientId INT,
    EpMCID INT, 
    EpSOI INT,
    SvcCat_ID INT,
    Ep_CatChg DOUBLE,
    Ep_CatUtl DOUBLE
); 
INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   1 SvcCat_ID, t1.Ep_CatChg1 Ep_CatChg, t1.Ep_CatUtl1 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   2 SvcCat_ID, t1.Ep_CatChg2 Ep_CatChg, t1.Ep_CatUtl2 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   3 SvcCat_ID, t1.Ep_CatChg3 Ep_CatChg, t1.Ep_CatUtl3 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   4 SvcCat_ID, t1.Ep_CatChg4 Ep_CatChg, t1.Ep_CatUtl4 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   5 SvcCat_ID, t1.Ep_CatChg5 Ep_CatChg, t1.Ep_CatUtl5 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   6 SvcCat_ID, t1.Ep_CatChg6 Ep_CatChg, t1.Ep_CatUtl6 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   7 SvcCat_ID, t1.Ep_CatChg7 Ep_CatChg, t1.Ep_CatUtl7 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   8 SvcCat_ID, t1.Ep_CatChg8 Ep_CatChg, t1.Ep_CatUtl8 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   9 SvcCat_ID, t1.Ep_CatChg9 Ep_CatChg, t1.Ep_CatUtl9 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   10 SvcCat_ID, t1.Ep_CatChg10 Ep_CatChg, t1.Ep_CatUtl10 Ep_CatUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_Cat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   11 SvcCat_ID, t1.Ep_CatChg11 Ep_CatChg, t1.Ep_CatUtl11 Ep_CatUtl
FROM CCGroup.EpMaster t1);

DROP TABLE IF EXISTS hipa.EpMaster_SubCat;
CREATE TABLE hipa.EpMaster_SubCat (
    Project INT,
    EpisodeId INT,
    PatientId INT,
    EpMCID INT, 
    EpSOI INT,
    SvcSubCat_ID INT,
    Ep_SubChg DOUBLE,
    Ep_SubUtl DOUBLE
); 
INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   1 SvcSubCat_ID, t1.Ep_SubChg1 Ep_SubChg, t1.Ep_SubUtl1 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   2 SvcSubCat_ID, t1.Ep_SubChg2 Ep_SubChg, t1.Ep_SubUtl2 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   3 SvcSubCat_ID, t1.Ep_SubChg3 Ep_SubChg, t1.Ep_SubUtl3 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   4 SvcSubCat_ID, t1.Ep_SubChg4 Ep_SubChg, t1.Ep_SubUtl4 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   5 SvcSubCat_ID, t1.Ep_SubChg5 Ep_SubChg, t1.Ep_SubUtl5 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   6 SvcSubCat_ID, t1.Ep_SubChg6 Ep_SubChg, t1.Ep_SubUtl6 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   7 SvcSubCat_ID, t1.Ep_SubChg7 Ep_SubChg, t1.Ep_SubUtl7 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   8 SvcSubCat_ID, t1.Ep_SubChg8 Ep_SubChg, t1.Ep_SubUtl8 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   9 SvcSubCat_ID, t1.Ep_SubChg9 Ep_SubChg, t1.Ep_SubUtl9 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   10 SvcSubCat_ID, t1.Ep_SubChg10 Ep_SubChg, t1.Ep_SubUtl10 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   11 SvcSubCat_ID, t1.Ep_SubChg11 Ep_SubChg, t1.Ep_SubUtl11 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   12 SvcSubCat_ID, t1.Ep_SubChg12 Ep_SubChg, t1.Ep_SubUtl12 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   13 SvcSubCat_ID, t1.Ep_SubChg13 Ep_SubChg, t1.Ep_SubUtl13 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   14 SvcSubCat_ID, t1.Ep_SubChg14 Ep_SubChg, t1.Ep_SubUtl14 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   15 SvcSubCat_ID, t1.Ep_SubChg15 Ep_SubChg, t1.Ep_SubUtl15 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   16 SvcSubCat_ID, t1.Ep_SubChg16 Ep_SubChg, t1.Ep_SubUtl16 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   17 SvcSubCat_ID, t1.Ep_SubChg17 Ep_SubChg, t1.Ep_SubUtl17 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   18 SvcSubCat_ID, t1.Ep_SubChg18 Ep_SubChg, t1.Ep_SubUtl18 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   19 SvcSubCat_ID, t1.Ep_SubChg19 Ep_SubChg, t1.Ep_SubUtl19 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   20 SvcSubCat_ID, t1.Ep_SubChg20 Ep_SubChg, t1.Ep_SubUtl20 Ep_SubUtl
FROM CCGroup.EpMaster t1);

INSERT INTO hipa.EpMaster_SubCat ( 
SELECT t1.Project, t1.EpisodeId, t1.PatientId, t1.EpMCID, t1.EpSOI, 
	   21 SvcSubCat_ID, t1.Ep_SubChg21 Ep_SubChg, t1.Ep_SubUtl21 Ep_SubUtl
FROM CCGroup.EpMaster t1);
