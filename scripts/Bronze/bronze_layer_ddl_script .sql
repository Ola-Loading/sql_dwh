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
Event_ID VARCHAR(80),
Investigation_Type	VARCHAR(80),
Accident_Number	VARCHAR(80),
Event_Date	VARCHAR(80),
Location_1 VARCHAR(80),
Location_2 VARCHAR(80),
Country	VARCHAR(80),
Latitude	VARCHAR(80),
Longitude	VARCHAR(80),
Airport_Code	VARCHAR(80),
Airport_Name	VARCHAR(80),
Injury_Severity	VARCHAR(80),
Aircraft_Damage	VARCHAR(80),
Aircraft_Category	VARCHAR(80),
Registration_Number	VARCHAR(80),
Make	VARCHAR(80),
Model	VARCHAR(80),
Amateur_Built	VARCHAR(80),
Number_of_Engines	VARCHAR(80),
Engine_Type	VARCHAR(80),
FAR_Description	VARCHAR(80),
Schedule	VARCHAR(80),
Purpose_of_Flight	VARCHAR(80),
Air_Carrier	VARCHAR(80),
Total_Fatal_Injuries	VARCHAR(80),
Total_Serious_Injuries	VARCHAR(80),
Total_Minor_Injuries	VARCHAR(80),
Total_Uninjured	VARCHAR(80),
Weather_Condition	VARCHAR(80),
Broad_Phase_of_Flight	VARCHAR(80),
Report_Publication_Date	   VARCHAR(80)
);

IF OBJECT_ID('BRONZE.FAA_INCIDENTS_DATA','U') IS NOT NULL
    DROP TABLE BRONZE.FAA_INCIDENTS_DATA;

CREATE TABLE BRONZE.FAA_INCIDENTS_DATA (
    AIDS_Report_Number VARCHAR(80), 
    Local_Event_Date VARCHAR(80), 
    Event_City VARCHAR(80),	
    Event_State VARCHAR(80),
    Event_Airport VARCHAR(80),
    Event_Type VARCHAR(80), 
    Aircraft_Damage VARCHAR(80),	
    Flight_Phase VARCHAR(80),
    Aircraft_Make	VARCHAR(80),
    Aircraft_Model	VARCHAR(80),
    Aircraft_Series	VARCHAR(80),
    Operator	VARCHAR(80),
    Primary_Flight_Type	VARCHAR(80),
    Flight_Conduct_Code	VARCHAR(80),
    Flight_Plan_Filed_Code	VARCHAR(80),
    Aircraft_Registration_Nbr	VARCHAR(80),
    Total_Fatalities	VARCHAR(80),
    Total_Injuries	VARCHAR(80),
    Aircraft_Engine_Make	VARCHAR(80),
    Aircraft_Engine_Model VARCHAR(80),	
    Engine_Group_Code	VARCHAR(80),
    Nbr_of_Engines	VARCHAR(80),
    PIC_Certificate_Type VARCHAR(80),	
    PIC_Flight_Time_Total_Hrs VARCHAR(80),
    PIC_Flight_Time_Total_Make_Model VARCHAR(80), 
    Unknown_a VARCHAR(80),
    Unknown_b VARCHAR(80)

);

IF OBJECT_ID('BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY','U') IS NOT NULL
    DROP TABLE BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY;

CREATE TABLE BRONZE.WORLD_AIRCRAFT_ACCIDENT_SUMMARY (
 WAAS_Subset_Event_Id VARCHAR(80),
 Local_Event_Date VARCHAR(80), 	
 Aircraft	VARCHAR(80),
 Aircraft_Operator	VARCHAR(80),
 Event_Location	VARCHAR(80),
 Crew_Fatalities VARCHAR(80),	
 Crew_Injured	VARCHAR(80),
 Crew_Aboard	VARCHAR(80),
 PAX_Fatalities	VARCHAR(80),
 PAX_Injuries	VARCHAR(80),
 PAX_Aboard   VARCHAR(80)
);

IF OBJECT_ID('BRONZE.NTSB_AVIATION_DATA','U') IS NOT NULL
    DROP TABLE BRONZE.NTSB_AVIATION_DATA;
CREATE TABLE BRONZE.NTSB_AVIATION_DATA (
NTSB_RPRT_NBR VARCHAR(80),
ACFT_REGIST_NBR VARCHAR(80),
ACFT_SERIAL_NBR	VARCHAR(80),
EV_TYPE_DESC VARCHAR(80),	
EVENT_LCL_DATE	VARCHAR(80),
LOC_STATE_CODE_STD	VARCHAR(80),
ARPT_NAME_STD VARCHAR(80),
FLTCNDCT_DESC VARCHAR(80),
OPRTR_SCHED_DESC VARCHAR(80),	
OPRTR_NSDC_NAME_STD VARCHAR(80),	
ACFT_NSDC_MAKE_STD	VARCHAR(80),
ACFT_NSDC_MODEL_STD	VARCHAR(80),
ACFT_NSDC_SERIES_STD VARCHAR(80),
REPORT_STATUS VARCHAR(80), 
INJURY_DESC	VARCHAR(80),
FLIGHT_PHASE_DESC VARCHAR(80)

)