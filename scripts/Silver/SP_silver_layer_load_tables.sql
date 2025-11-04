/*
================================================================================================
Stored Procedure to load silver layer tables from cleaned bronze tables
================================================================================================

SCRIPT PURPOSE:
This script is a stored procedure that performs the following for each of the tables in the 'SILVER' schema within the 'DataWarehouse' database:
    - Truncates the tables if there is existing data
    - Reloads/loads the table with the data from the corresponding BRONZE layer table whilst cleaning, standardizing and enriching the data inherent

Parameters:
This stored procedure does not accept any arguments

Usage:
Ensure that you are in the correct database: 'DataWarehouse'
EXEC SILVER.LOAD_SILVER 

*NOTE THIS WILL IN ESSENSE OVERWRITE ANY DATA CURRENTLY STORED IN THESE TABLES 
*/


CREATE OR ALTER PROCEDURE SILVER.LOAD_SILVER AS
BEGIN
    DECLARE @starttime DATETIME, @endtime DATETIME;
    DECLARE @BATCHSTART DATETIME = GETDATE(), @BATCHEND DATETIME;
    BEGIN TRY

        PRINT 'TRUNCATING TABLE: [SILVER].[AIRLINE_ACCIDENTS]';

        TRUNCATE TABLE [SILVER].[AIRLINE_ACCIDENTS];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[SILVER].[AIRLINE_ACCIDENTS]';

        SET @starttime = GETDATE();

        INSERT INTO  [SILVER].[AIRLINE_ACCIDENTS] (Event_ID, 
        Investigation_Type,
        Accident_Number,
        Event_Date,
        Location, 
        Country,
        Latitude, 
        Longitude, 
        Airport_Code, 
        Airport_Name,
        Injury_Severity,
        Aircraft_Damage, 
        Aircraft_Category, 
        Registration_Number, 
        Make, 
        Model, 
        Amateur_Built, 
        Number_of_Engines, 
        Engine_Type,
        Far_Description,
        Schedule,
        Purpose_of_Flight,
        Air_Carrier,
        Total_Fatal_Injuries,
        Total_Serious_Injuries, 
        Total_Minor_Injuries,
        Total_Uninjured,
        Weather_Condition ,
        Broad_phase_of_Flight,
        Report_Publication_Date)

        SELECT Event_ID, 
        NULLIF(TRIM(Investigation_Type),'') as Investigation_Type,
        NULLIF(TRIM(Accident_Number),'') as Accident_Number,
        CAST(NULLIF(TRIM(Event_Date), '') AS DATE) AS Event_Date,
        CASE 
            WHEN UPPER(TRIM(Location)) IN ('', 'MISSING', 'UNKNOWN') 
                OR UPPER(TRIM(Location)) LIKE '%MISSING%' 
                OR UPPER(TRIM(Location)) LIKE '%UNKNOWN%' THEN NULL
            WHEN dbo.CleanNameV1(Location) like '%'+ dbo.CleanNameV1(COUNTRY)+'%' THEN replace(dbo.CleanNameV1(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOCATION,'I.','ISLAND '),'IS.','ISLAND '),'ISL.','ISLAND '),'E.','EAST '),'W.','WEST '),'INTL','INTERNATIONAL'),'INT''L','INTERNATIONAL'))),dbo.CleanNameV1(COUNTRY),'')
            ELSE dbo.CleanNameV1(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LOCATION),'I.','ISLAND '),'IS.','ISLAND '),'ISL.','ISLAND '),'E.','EAST '),'W.','WEST '),'INTL','INTERNATIONAL'),'INT''L','INTERNATIONAL')))
        END AS Location, 
        NULLIF(UPPER(TRIM(REPLACE(REPLACE(REPLACE(Country,',',' '),'.',' '),'  ',' '))),'') as Country,
        CAST(NULLIF(TRIM(Latitude),'') as float) as Latitude, 
        CAST(NULLIF(TRIM(Longitude),'') as float) as Longitude, 
        dbo.CleanAirportCode(AIRPORT_CODE) as Airport_Code, 
        NULLIF(dbo.CleanAirportName(dbo.CleanNameV1(airport_name)),'') AS Airport_Name,
        CASE 
            WHEN Injury_Severity LIKE '%FATAL(%' THEN 'FATAL'
            WHEN UPPER(TRIM(Injury_Severity)) IN ('UNAVAILABLE','') THEN NULL
            WHEN (Total_Fatal_Injuries > 0 AND TRIM(INJURY_SEVERITY) NOT LIKE 'Fatal%') THEN 'FATAL'
            ELSE UPPER(TRIM(Injury_Severity))
        END AS Injury_Severity,
        NULLIF(TRIM(Aircraft_Damage),'') AS Aircraft_Damage, 
        NULLIF(UPPER(TRIM(Aircraft_Category)),'') AS Aircraft_Category, 
        CASE
            WHEN TRIM(UPPER(Registration_Number)) LIKE '%UNK%' THEN NULL 
            ELSE TRIM(REPLACE(REPLACE(UPPER(Registration_Number),'*',' '),'  ',' '))
        END AS Registration_Number, 
        NULLIF(dbo.CleanNameV1(MAKE),'') AS Make, 
        replace(replace(replace(replace(dbo.CleanNameV1(model),'=',''),'^',''),':',''),'%','') as Model, 
        CASE 
        WHEN UPPER(TRIM(Amateur_Built)) = 'YES' THEN CAST(1 AS BIT)
        WHEN UPPER(TRIM(Amateur_Built)) = 'NO' THEN CAST(0 AS BIT)
        ELSE NULL
        END AS Amateur_Built, 
        CASE 
        WHEN TRIM(Number_of_Engines) IN ('0','1','2','3','4') THEN CAST(TRIM(Number_of_Engines) AS INT)
        ELSE NULL
        END AS Number_of_Engines, 
        CASE 
            WHEN PATINDEX('%REC%',UPPER(ENGINE_TYPE)) > 0 AND PATINDEX('%TJ%',UPPER(ENGINE_TYPE)) > 0 THEN 'RECIPROCATING AND TURBO JET'
            WHEN TRIM(UPPER(ENGINE_TYPE)) IN ('UNKNOWN','') THEN NULL
            ELSE TRIM(UPPER(ENGINE_TYPE))
        END AS Engine_Type,
        CASE 
            WHEN (LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%NONSCHEDULED%' THEN 'NOT SCHEDULED'
            WHEN (LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%SCHEDULED%' THEN 'SCHEDULED'
            WHEN (LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%GENERAL AVIATION%' THEN 'GENERAL AVIATION'
            ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NULLIF(NULLIF(UPPER((LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION))))),''),'UNKNOWN'),
            ',',' '),'.',' '),'-',' '),'  ',' '),'  ',' '),'U S','US'),' & ',' AND ') 
        END AS Far_Description,
        CASE 
            WHEN NULLIF(UPPER(TRIM(SCHEDULE)),'') = 'SCHD' THEN 'SCHEDULED' 
            WHEN NULLIF(UPPER(TRIM(SCHEDULE)),'') = 'NSCH' THEN 'NOT SCHEDULED' 
            ELSE NULL
        END AS Schedule,
        NULLIF(UPPER(TRIM(PURPOSE_OF_FLIGHT)),'') AS Purpose_of_Flight,
        NULLIF(UPPER(TRIM(AIR_CARRIER)),'') AS Air_Carrier,
        CAST(NULLIF(TRIM(Total_Fatal_Injuries),'') AS INT) as Total_Fatal_Injuries,
        CAST(NULLIF(TRIM(Total_Serious_Injuries),'') AS INT) as Total_Serious_Injuries, 
        CAST(NULLIF(TRIM(Total_Minor_Injuries),'') AS INT) as Total_Minor_Injuries,
        CAST(NULLIF(TRIM(Total_Uninjured),0) AS INT) as Total_Uninjured,
        CASE 
            WHEN UPPER(TRIM(WEATHER_CONDITION)) = 'IMC' THEN 'Instrument Meteorological Conditions'
            WHEN UPPER(TRIM(WEATHER_CONDITION)) = 'VMC' THEN 'Visual Meteorological Conditions'
        ELSE NULL
        END AS Weather_Condition ,
        NULLIF(TRIM(BROAD_PHASE_OF_FLIGHT), '') AS Broad_phase_of_Flight,
        CAST(NULLIF(TRIM(REPLACE(REPLACE(Report_Publication_Date, CHAR(9),''),CHAR(13),'')),'') AS DATE) as Report_Publication_Date 
        FROM [BRONZE].[AIRLINE_ACCIDENTS]
        WHERE TRY_CAST(TRIM(Event_Date) AS DATE) IS NOT NULL AND 
        EVENT_ID NOT IN 
        (SELECT EVENT_ID FROM [BRONZE].[AIRLINE_ACCIDENTS]
        WHERE TRIM(INJURY_SEVERITY) LIKE 'Fatal%'
        AND Total_Fatal_Injuries = 0);

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [SILVER].[FAA_INCIDENTS_DATA]';
        TRUNCATE TABLE [SILVER].[FAA_INCIDENTS_DATA];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[SILVER].[FAA_INCIDENTS_DATA]';
        SET @starttime = GETDATE();
        
        INSERT INTO [SILVER].[FAA_INCIDENTS_DATA] (AIDS_Report_Number, 
        Local_Event_Date,Event_City,Event_State,Event_Airport,Event_Type,Aircraft_Damage,Flight_Phase,Aircraft_Make,Aircraft_Model,Aircraft_Series,
        Operator,Primary_Flight_Type,Flight_Conduct_Code,Flight_Plan_Filed_Code,Aircraft_Registration_Nbr,Total_Fatalities,Total_Injuries,
        Aircraft_Engine_Make,Aircraft_Engine_Model,Engine_Group_Code,Nbr_of_Engines,PIC_Certificate_Type ,PIC_Flight_Time_Total_Hrs,
        PIC_Flight_Time_Total_Make_Model )


        SELECT AIDS_Report_Number, 
        CAST(Local_Event_Date AS DATE) as Local_Event_Date,
        REPLACE(REPLACE(EVENT_CITY,'.',' '),'  ',' ') as Event_City,
        CAST(Event_State AS NCHAR(2)) AS Event_State,
        dbo.CleanAirportName(dbo.CleanNameV1(Event_Airport)) as Event_Airport, 
        NULLIF(TRIM(Event_Type),'') as Event_Type,
        CASE 
            WHEN Aircraft_Damage in ('NONE','UNKNOWN') THEN NULL
            ELSE Aircraft_Damage
        END AS Aircraft_Damage,
        dbo.CleanNameV1(Flight_Phase) as Flight_Phase,
        Aircraft_Make,
        Aircraft_Model,
        CASE 
            WHEN Aircraft_Series LIKE '%UNDESIGNATED%' THEN NULL
            WHEN Aircraft_Series LIKE '%NO SERIES EXIST%' THEN NULL
            ELSE REPLACE(Aircraft_Series,' ','')
        END AS Aircraft_Series,
        NULLIF(dbo.CleanNameV1(OPERATOR),'NONE') as Operator,
        CASE 
            WHEN Primary_Flight_Type LIKE '%AIR TAXI%' THEN 'AIR TAXI' 
            WHEN Primary_Flight_Type LIKE '%SCHEDULED AIR CARRIER%' THEN 'SCHEDULED AIR CARRIER'
            ELSE REPLACE(REPLACE(REPLACE(REPLACE(PRIMARY_FLIGHT_TYPE,',',' '),'.',' '),'/',' '),' ',' ')
        END AS Primary_Flight_Type,
        replace(replace(Flight_Conduct_Code,'/',' '),'  ',' ') as Flight_Conduct_Code,
        CASE 
            WHEN Flight_Plan_Filed_Code in ('NONE','UNKNOWN') THEN NULL 
            ELSE Flight_Plan_Filed_Code
        end as Flight_Plan_Filed_Code, 
        CASE 
            WHEN Aircraft_Registration_Nbr IN ('NONE','UNKNO') THEN NULL 
            ELSE Aircraft_Registration_Nbr
        END AS Aircraft_Registration_Nbr,
        CAST(NULLIF(Total_Fatalities,'') AS INT) as Total_Fatalities,
        CAST(NULLIF(Total_Injuries,'') AS INT) as Total_Injuries,
        CASE 
            WHEN Aircraft_Engine_Make IN ('NONE','UNK') THEN NULL
            ELSE TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Aircraft_Engine_Make,'&',' '),'/',' '),'-',' '),'\',' '),'  ',' '),'  ',' '))
        END AS Aircraft_Engine_Make,
        CASE 
            WHEN Aircraft_Engine_Model LIKE '%UNKNOWN%' 
            OR Aircraft_Engine_Model = 'None' THEN NULL
        ELSE replace(dbo.CleanNameV1(Aircraft_Engine_Model),'*',' ')
        END AS Aircraft_Engine_Model,
        CASE 
            WHEN Engine_Group_Code LIKE '%UKN%'
            OR Engine_Group_Code LIKE '%UNK%'
            OR Engine_Group_Code LIKE 'NOT AP' THEN NULL
            ELSE NULLIF(replace(dbo.CleanNameV1(Engine_Group_Code),'*',''),'')
        END AS Engine_Group_Code,
        Cast(CAST(Nbr_of_Engines as float)as INT) as Nbr_of_Engines,
        case 
            when PIC_Certificate_Type LIKE '%UNKNOWN%' THEN NULL 
            WHEN PIC_Certificate_Type LIKE '%PRIVATE PILOT%' THEN 'PRIVATE PILOT'
            WHEN PIC_Certificate_Type LIKE '%COMMERCIAL PILOT%' THEN 'COMMERCIAL PILOT'
            WHEN PIC_Certificate_Type LIKE '%AIRLINE TRANSPORT%' THEN 'AIRLINE TRANSPORT'
            ELSE PIC_Certificate_Type 
        END AS PIC_Certificate_Type ,
        CAST(CAST(PIC_Flight_Time_Total_Hrs AS FLOAT) AS INT) as PIC_Flight_Time_Total_Hrs, 
        CAST(CAST(PIC_Flight_Time_Total_Make_Model AS FLOAT) AS INT) as PIC_Flight_Time_Total_Make_Model 
        FROM [BRONZE].[FAA_INCIDENTS_DATA] ;

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [SILVER].[NTSB_AVIATION_DATA]';

        TRUNCATE TABLE [SILVER].[NTSB_AVIATION_DATA];

        PRINT '==============================================';
        PRINT 'INSERTING INTO TABLE:[SILVER].[NTSB_AVIATION_DATA]';
        SET @starttime = GETDATE();
        
        INSERT INTO [SILVER].[NTSB_AVIATION_DATA] (NTSB_RPRT_NBR,ACFT_REGIST_NBR,ACFT_SERIAL_NBR,
        EV_TYPE_DESC,Event_LCL_Date,LOC_STATE_CODE_STD,ARPT_NAME_STD,FLTCNDCT_DESC,OPRTR_SCHED_DESC,
        OPRTR_NSDC_NAME_STD,ACFT_NSDC_MAKE_STD,ACFT_NSDC_MODEL_STD,ACFT_NSDC_SERIES_STD,REPORT_STATUS,INJURY_DESC,FLIGHT_PHASE_DESC)

        SELECT dbo.CleanNameV1(NTSB_RPRT_NBR) AS NTSB_RPRT_NBR, 
        replace(replace(replace(dbo.CleanNameV1(ACFT_REGIST_NBR),'*',''),'_',''),N'┬','') as ACFT_REGIST_NBR,
        replace(replace(replace(replace(dbo.CleanNameV1(ACFT_SERIAL_NBR),'*',''),'!',''),'`',''),'''','') as ACFT_SERIAL_NBR,
        CASE 
            WHEN EV_TYPE_DESC NOT IN ('INCIDENT','ACCIDENT') THEN NULL 
            ELSE EV_TYPE_DESC
        END AS EV_TYPE_DESC,
        CAST(EVENT_LCL_DATE AS DATE) as Event_LCL_Date,
        CAST(LOC_STATE_CODE_STD AS NCHAR(2)) as LOC_STATE_CODE_STD,
        dbo.CleanAirportName(dbo.CleanNameV1(ARPT_NAME_STD)) AS ARPT_NAME_STD,
        CASE
            WHEN (LTRIM(SUBSTRING(FLTCNDCT_DESC,CHARINDEX(':',FLTCNDCT_DESC)+1, LEN(FLTCNDCT_DESC)))) LIKE '%NONSCHEDULED%' THEN 'NOT SCHEDULED'
            WHEN (LTRIM(SUBSTRING(FLTCNDCT_DESC,CHARINDEX(':',FLTCNDCT_DESC)+1, LEN(FLTCNDCT_DESC)))) LIKE '%SCHEDULED%' THEN 'SCHEDULED'
            WHEN (LTRIM(SUBSTRING(FLTCNDCT_DESC,CHARINDEX(':',FLTCNDCT_DESC)+1, LEN(FLTCNDCT_DESC)))) LIKE '%GENERAL AVIATION%' THEN 'GENERAL AVIATION'
            ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NULLIF(NULLIF(UPPER((LTRIM(SUBSTRING(FLTCNDCT_DESC,CHARINDEX(':',FLTCNDCT_DESC)+1, LEN(FLTCNDCT_DESC))))),''),'UNKNOWN'),
            ',',' '),'.',' '),'-',' '),'  ',' '),'  ',' '),'U S','US'),' & ',' AND ') 
        END AS FLTCNDCT_DESC ,
        CASE WHEN 
        OPRTR_SCHED_DESC IN ('UNKNOWN') THEN NULL 
        ELSE REPLACE(REPLACE(OPRTR_SCHED_DESC,'-',' '),'  ',' ')
        END AS OPRTR_SCHED_DESC,
        REPLACE(replace(replace(replace(replace(replace(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OPRTR_NSDC_NAME_STD,',',' '),'.',' '),'-',' '),'''',' '),
        ' INC',' INCORPORATED'),' INC ',' INCORPORATED '),'(',' '),')',' '),'`',' '),'&',' '),'  ',' '),'INCORPORATEDORPORATED','INCORPORATED'),'  ',' ')
        AS OPRTR_NSDC_NAME_STD, 
        ACFT_NSDC_MAKE_STD,
        ACFT_NSDC_MODEL_STD,
        CASE 
        WHEN PATINDEX('%[^A-Z 0-9]%',ACFT_NSDC_series_STD) > 0 THEN 'UNDESIGNATED SERIES'
        WHEN ACFT_NSDC_SERIES_STD LIKE '%UNDES%'  OR REPLACE(ACFT_NSDC_SERIES_STD,' ','')= 'NOSERIESEXISTS' THEN 'UNDESIGNATED SERIES'
        ELSE ACFT_NSDC_SERIES_STD 
        END AS ACFT_NSDC_SERIES_STD,
        REPORT_STATUS,
        CASE 
        WHEN INJURY_DESC = 'NONE' THEN NULL
        ELSE INJURY_DESC
        END AS INJURY_DESC,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(FLIGHT_PHASE_DESC,'-',' '),
        '(S)','S'),')',' '),'(',' '),'/',' '),'  ',' '),'  ',' ') AS FLIGHT_PHASE_DESC
        FROM [BRONZE].[NTSB_AVIATION_DATA]
        WHERE TRY_CAST(EVENT_LCL_DATE AS DATE) IS NOT NULL

        UNION 

        SELECT NTSB_RPRT_NBR, 
        ACFT_REGIST_NBR, CASE 
        WHEN REPLACE(ACFT_SERIAL_NBR,'"','') = '' THEN REPLACE(EV_TYPE_DESC,'"','')
        ELSE REPLACE(ACFT_SERIAL_NBR,'"','')
        END AS ACFT_SERIAL_NBR, 
        EVENT_LCL_DATE AS EV_TYPE_DESC, 
        CAST(LOC_STATE_CODE_STD AS DATE) as Event_LCL_Date,
        CAST(ARPT_NAME_STD AS NCHAR(2)) as LOC_STATE_CODE_STD,
        FLTCNDCT_DESC AS APRT_NAME_STD,
        LTRIM(SUBSTRING(FLTCNDCT_DESC,CHARINDEX(':',OPRTR_SCHED_DESC)+1, LEN(OPRTR_SCHED_DESC))) AS FLTCNDCT_DESC, 
        OPRTR_NSDC_NAME_STD AS OPRTR_SCHED_DESC,
        REPLACE(ACFT_NSDC_MAKE_STD,' INC ',' INCORPORATED ') AS OPRTR_NSDC_NAME_STD,
        ACFT_NSDC_MODEL_STD AS ACFT_NSDC_MAKE_STD,
        ACFT_NSDC_SERIES_STD AS ACFT_NSDC_MODEL_STD,
        REPORT_STATUS AS ACFT_NSDC_SERIES_STD, 
        INJURY_DESC AS REPORT_STATUS,
        CASE WHEN FLIGHT_PHASE_DESC = 'NONE' THEN NULL 
        ELSE FLIGHT_PHASE_DESC END AS INJURY_DESC, 
        NULL AS FLIGHT_PHASE_DESC
        FROM [BRONZE].[NTSB_AVIATION_DATA]
        WHERE TRY_CAST(EVENT_LCL_DATE AS DATE) IS NULL;

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';
        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]';

        TRUNCATE TABLE [SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]';

        SET @starttime = GETDATE();

        INSERT INTO [SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY] (WAAS_Subset_Event_Id, 
        Local_Event_Date, Aircraft,Aircraft_Operator,Event_Location,Crew_Fatalities,
        Crew_Injured, Crew_Aboard, PAX_Fatalities, PAX_Injuries, PAX_Aboard)

        SELECT WAAS_Subset_Event_Id, 
        CAST(Local_Event_Date AS DATE) as Local_Event_Date,
        DBO.CleanNameV1(Aircraft) as Aircraft,
        DBO.CleanNameV1(Aircraft_Operator) as Aircraft_Operator,
        DBO.CleanNameV1(Event_Location) as Event_Location,
        CAST(Crew_Fatalities AS INT) AS Crew_Fatalities,
        CAST(Crew_Injured AS INT) AS Crew_Injured, 
        CAST(Crew_Aboard AS INT) AS Crew_Aboard, 
        CAST(PAX_Fatalities AS INT) AS PAX_Fatalities, 
        CAST(PAX_Injuries AS INT) AS  PAX_Injuries, 
        CAST(PAX_Aboard AS INT) AS PAX_Aboard
        FROM [BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY];


        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT'======================================================================================';
        SET @BATCHEND = GETDATE();

        PRINT 'TOTAL LOAD TIME: '+ CAST(DATEDIFF(SECOND, @BATCHSTART, @BATCHEND) AS VARCHAR) + ' SECONDS';
    
    END TRY

    BEGIN CATCH 
    PRINT '============================================================='
    PRINT 'ERROR WHILST LOADING THE SILVER LAYER';
    PRINT 'ERROR MESSAGE: '+ ERROR_MESSAGE();
    PRINT 'ERROR MESSAGE: '+ CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'ERROR MESSAGE: '+ CAST(ERROR_STATE() AS VARCHAR);
    PRINT '============================================================='
    END CATCH 

END 



