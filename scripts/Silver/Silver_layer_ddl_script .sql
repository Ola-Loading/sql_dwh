/*
================================================================================================
Sql statements that create Bronze layer table definitions
================================================================================================

SCRIPT PURPOSE:
This script contains a series of statements that will first check for the presence of tables within the database 'DataWarehouse'
if found these tables will first be dropped and then recreated with the table definitions shown. This script should be run before the 
SP_bronze_layer_load_tables.sql script.

Extension: 
-- AUTOMATE SCRIPT GENERATION WITH .PY FILE AS REPEATED LOGIC 
*/

USE DataWarehouse;

IF OBJECT_ID('SILVER.AIRLINE_ACCIDENTS','U') IS NOT NULL
    DROP TABLE SILVER.AIRLINE_ACCIDENTS;

create table SILVER.AIRLINE_ACCIDENTS (
Event_ID NVARCHAR(80),
Investigation_Type	NVARCHAR(80),
Accident_Number	NVARCHAR(80),
Event_Date	DATE,
Location NVARCHAR(80),
Country	NVARCHAR(80),
Latitude	FLOAT,
Longitude	FLOAT,
Airport_Code	NVARCHAR(80),
Airport_Name	NVARCHAR(80),
Injury_Severity	NVARCHAR(80),
Aircraft_Damage	NVARCHAR(80),
Aircraft_Category	NVARCHAR(80),
Registration_Number	NVARCHAR(80),
Make	NVARCHAR(80),
Model	NVARCHAR(80),
Amateur_Built	BIT,
Number_of_Engines	INT,
Engine_Type	NVARCHAR(80),
FAR_Description	NVARCHAR(80),
Schedule	NVARCHAR(80),
Purpose_of_Flight	NVARCHAR(80),
Air_Carrier	NVARCHAR(80),
Total_Fatal_Injuries	INT,
Total_Serious_Injuries	INT,
Total_Minor_Injuries	INT,
Total_Uninjured	INT,
Weather_Condition	NVARCHAR(80),
Broad_Phase_of_Flight	NVARCHAR(80),
Report_Publication_Date	  DATE, 
DWH_LOAD_DATE DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('SILVER.FAA_INCIDENTS_DATA','U') IS NOT NULL
    DROP TABLE SILVER.FAA_INCIDENTS_DATA;

CREATE TABLE SILVER.FAA_INCIDENTS_DATA (
    AIDS_Report_Number NVARCHAR(80), 
    Local_Event_Date DATE, 
    Event_City NVARCHAR(80),	
    Event_State NVARCHAR(80),
    Event_Airport NVARCHAR(80),
    Event_Type NVARCHAR(80), 
    Aircraft_Damage NVARCHAR(80),	
    Flight_Phase NVARCHAR(80),
    Aircraft_Make	NVARCHAR(80),
    Aircraft_Model	NVARCHAR(80),
    Aircraft_Series	NVARCHAR(80),
    Operator	NVARCHAR(80),
    Primary_Flight_Type	NVARCHAR(80),
    Flight_Conduct_Code	NVARCHAR(80),
    Flight_Plan_Filed_Code	NVARCHAR(80),
    Aircraft_Registration_Nbr	NVARCHAR(80),
    Total_Fatalities	INT,
    Total_Injuries	INT,
    Aircraft_Engine_Make	NVARCHAR(80),
    Aircraft_Engine_Model NVARCHAR(80),	
    Engine_Group_Code	NVARCHAR(80),
    Nbr_of_Engines	NVARCHAR(80),
    PIC_Certificate_Type NVARCHAR(80),	
    PIC_Flight_Time_Total_Hrs INT,
    PIC_Flight_Time_Total_Make_Model INT, 
    DWH_LOAD_DATE DATETIME DEFAULT GETDATE()

);

IF OBJECT_ID('SILVER.WORLD_AIRCRAFT_ACCIDENT_SUMMARY','U') IS NOT NULL
    DROP TABLE SILVER.WORLD_AIRCRAFT_ACCIDENT_SUMMARY;

CREATE TABLE SILVER.WORLD_AIRCRAFT_ACCIDENT_SUMMARY (
 WAAS_Subset_Event_Id NVARCHAR(80),
 Local_Event_Date DATE, 	
 Aircraft	NVARCHAR(80),
 Aircraft_Operator	NVARCHAR(80),
 Event_Location	NVARCHAR(80),
 Crew_Fatalities INT,	
 Crew_Injured	 INT,
 Crew_Aboard	 INT,
 PAX_Fatalities	 INT,
 PAX_Injuries	 INT,
 PAX_Aboard    INT,
 DWH_LOAD_DATE DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('SILVER.NTSB_AVIATION_DATA','U') IS NOT NULL
    DROP TABLE SILVER.NTSB_AVIATION_DATA;
CREATE TABLE SILVER.NTSB_AVIATION_DATA (
NTSB_RPRT_NBR NVARCHAR(80),
ACFT_REGIST_NBR NVARCHAR(80),
ACFT_SERIAL_NBR	NVARCHAR(80),
EV_TYPE_DESC NVARCHAR(80),	
EVENT_LCL_DATE	DATE,
LOC_STATE_CODE_STD	NCHAR(2),
ARPT_NAME_STD NVARCHAR(80),
FLTCNDCT_DESC NVARCHAR(80),
OPRTR_SCHED_DESC NVARCHAR(80),	
OPRTR_NSDC_NAME_STD NVARCHAR(80),	
ACFT_NSDC_MAKE_STD	NVARCHAR(80),
ACFT_NSDC_MODEL_STD	NVARCHAR(80),
ACFT_NSDC_SERIES_STD NVARCHAR(80),
REPORT_STATUS NVARCHAR(80), 
INJURY_DESC	NVARCHAR(80),
FLIGHT_PHASE_DESC NVARCHAR(80),
DWH_LOAD_DATE DATETIME DEFAULT GETDATE()

)