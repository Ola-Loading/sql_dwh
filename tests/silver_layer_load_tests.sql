/*
================================================================================================
Quality checks
================================================================================================

SCRIPT PURPOSE:
This script performs various quality checks for data consistency, accuracy and standardisation 
across the "silver" schema. It includes checks for 

    - null or duplicates in the primary key column(s)
    - Data standardisation in string fields
    - Invalid data entries
    - Failure of loading from "bronze" schema


Usage:
Ensure that you are in the correct database: 'DataWarehouse'
    - run these checks after loading the Silver layer and check for unexpected results
    - investigate and resolve any discrepencies found during the checks 


*/

-- CHECKING [SILVER].[AIRLINE_ACCIDENTS]

-- EXPECTATION: 0 ROWS RETURNED 
SELECT * FROM [SILVER].[AIRLINE_ACCIDENTS]
WHERE EVENT_ID IS NULL;

-- CHECK THAT ALL RELEVANT EVENTS ARE CLASSED AS FATAL 
-- EXPECTATION: 0 ROWS RETURNED 
SELECT * FROM [SILVER].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) NOT LIKE 'Fatal%'
AND Total_Fatal_Injuries > 0;

-- CHECK THAT ALL RELEVANT EVENTS CLASSED AS FATAL ACTUALLY HAVE FATALITIES
-- EXPECTATION: 0 ROWS RETURNED 
SELECT * FROM [SILVER].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) LIKE 'Fatal%'
AND Total_Fatal_Injuries = 0;


-- CHECKING [SILVER].[FAA_INCIDENTS_DATA];

--primary key duplicates
-- EXPECTATION: 0 ROWS RETURNED 
SELECT AIDS_Report_Number FROM 
[BRONZE].[FAA_INCIDENTS_DATA]
GROUP BY AIDS_Report_Number
HAVING COUNT(*) > 1;

--primary key null counts 
-- EXPECTATION: 0 ROWS RETURNED 
SELECT * FROM  [BRONZE].[FAA_INCIDENTS_DATA]
WHERE AIDS_Report_Number IS NULL;

---manually inspect to check no examples of int that should have been converted to international 
SELECT DISTINCT EVENT_AIRPORT FROM [SILVER].[FAA_INCIDENTS_DATA]
WHERE Event_Airport LIKE '%INT%' AND Event_Airport NOT LIKE '%INTERNATIONAL%';


-- CHECKING [BRONZE].[NTSB_AVIATION_DATA]

-- CHECKING FOR INVALID DATA FORMATS 
-- EXPECTATION: 0 ROWS RETURNED
SELECT * FROM [SILVER].[NTSB_AVIATION_DATA]
WHERE TRY_CAST(EVENT_LCL_DATE AS DATE) IS NULL;

-- DATA STANDARDISATION AND CONSISTENCY
-- EXPECTATION: 0 ROWS RETURNED

SELECT DISTINCT OPRTR_NSDC_NAME_STD FROM [SILVER].[NTSB_AVIATION_DATA]
WHERE PATINDEX('INCORPORATEDORPORATED', OPRTR_NSDC_NAME_STD) > 0;


---manually inspect to check no examples of int that should have been converted to international 
SELECT DISTINCT ARPT_NAME_STD FROM [SILVER].[NTSB_AVIATION_DATA]
WHERE ARPT_NAME_STD LIKE '%INT%' AND ARPT_NAME_STD NOT LIKE '%INTERNATIONAL%';




----[SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]

--primary key duplicates and null check 
-- EXPECTATION: 0 ROWS RETURNED
SELECT WAAS_Subset_Event_Id FROM [SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]
GROUP BY WAAS_Subset_Event_Id
HAVING COUNT(*) > 1 OR WAAS_Subset_Event_Id IS NULL;

--CHECK ALL DATES AND DATE RANGE OF RAW TABLE COVERED
-- EXPECTATION: 0 ROWS RETURNED
SELECT * FROM [SILVER].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY] SILVER 
RIGHT JOIN  (SELECT CAST(Local_Event_Date AS DATE) as Local_Event_Date
FROM [BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]) AS BRONZE
ON BRONZE.Local_Event_Date = SILVER.Local_Event_Date
WHERE SILVER.Local_Event_Date IS NULL ;