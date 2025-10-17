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

IF OBJECT_ID('BRONZE.AIRLINE_ACCIDENTS','U') IS NOT NULL
    DROP TABLE BRONZE.AIRLINE_ACCIDENTS;

create table BRONZE.AIRLINE_ACCIDENTS (
Event_ID NVARCHAR(80),
Investigation_Type	NVARCHAR(80),
Accident_Number	NVARCHAR(80),
Event_Date	NVARCHAR(80),
Location NVARCHAR(80),
Country	NVARCHAR(80),
Latitude	NVARCHAR(80),
Longitude	NVARCHAR(80),
Airport_Code	NVARCHAR(80),
Airport_Name	NVARCHAR(80),
Injury_Severity	NVARCHAR(80),
Aircraft_Damage	NVARCHAR(80),
Aircraft_Category	NVARCHAR(80),
Registration_Number	NVARCHAR(80),
Make	NVARCHAR(80),
Model	NVARCHAR(80),
Amateur_Built	NVARCHAR(80),
Number_of_Engines	NVARCHAR(80),
Engine_Type	NVARCHAR(80),
FAR_Description	NVARCHAR(80),
Schedule	NVARCHAR(80),
Purpose_of_Flight	NVARCHAR(80),
Air_Carrier	NVARCHAR(80),
Total_Fatal_Injuries	NVARCHAR(80),
Total_Serious_Injuries	NVARCHAR(80),
Total_Minor_Injuries	NVARCHAR(80),
Total_Uninjured	NVARCHAR(80),
Weather_Condition	NVARCHAR(80),
Broad_Phase_of_Flight	NVARCHAR(80),
Report_Publication_Date	   NVARCHAR(80)
);

IF OBJECT_ID('BRONZE.FAA_INCIDENTS_DATA','U') IS NOT NULL
    DROP TABLE BRONZE.FAA_INCIDENTS_DATA;

CREATE TABLE BRONZE.FAA_INCIDENTS_DATA (
    AIDS_Report_Number NVARCHAR(80), 
    Local_Event_Date NVARCHAR(80), 
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
    Total_Fatalities	NVARCHAR(80),
    Total_Injuries	NVARCHAR(80),
    Aircraft_Engine_Make	NVARCHAR(80),
    Aircraft_Engine_Model NVARCHAR(80),	
    Engine_Group_Code	NVARCHAR(80),
    Nbr_of_Engines	NVARCHAR(80),
    PIC_Certificate_Type NVARCHAR(80),	
    PIC_Flight_Time_Total_Hrs NVARCHAR(80),
    PIC_Flight_Time_Total_Make_Model NVARCHAR(80), 
    Unknown_a NVARCHAR(80),
    Unknown_b NVARCHAR(80)

);

IF OBJECT_ID('BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY','U') IS NOT NULL
    DROP TABLE BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY;

CREATE TABLE BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY (
 WAAS_Subset_Event_Id NVARCHAR(80),
 Local_Event_Date NVARCHAR(80), 	
 Aircraft	NVARCHAR(80),
 Aircraft_Operator	NVARCHAR(80),
 Event_Location	NVARCHAR(80),
 Crew_Fatalities NVARCHAR(80),	
 Crew_Injured	NVARCHAR(80),
 Crew_Aboard	NVARCHAR(80),
 PAX_Fatalities	NVARCHAR(80),
 PAX_Injuries	NVARCHAR(80),
 PAX_Aboard   NVARCHAR(80)
);

IF OBJECT_ID('BRONZE.NTSB_AVIATION_DATA','U') IS NOT NULL
    DROP TABLE BRONZE.NTSB_AVIATION_DATA;
CREATE TABLE BRONZE.NTSB_AVIATION_DATA (
NTSB_RPRT_NBR NVARCHAR(80),
ACFT_REGIST_NBR NVARCHAR(80),
ACFT_SERIAL_NBR	NVARCHAR(80),
EV_TYPE_DESC NVARCHAR(80),	
EVENT_LCL_DATE	NVARCHAR(80),
LOC_STATE_CODE_STD	NVARCHAR(80),
ARPT_NAME_STD NVARCHAR(80),
FLTCNDCT_DESC NVARCHAR(80),
OPRTR_SCHED_DESC NVARCHAR(80),	
OPRTR_NSDC_NAME_STD NVARCHAR(80),	
ACFT_NSDC_MAKE_STD	NVARCHAR(80),
ACFT_NSDC_MODEL_STD	NVARCHAR(80),
ACFT_NSDC_SERIES_STD NVARCHAR(80),
REPORT_STATUS NVARCHAR(80), 
INJURY_DESC	NVARCHAR(80),
FLIGHT_PHASE_DESC NVARCHAR(80)

)