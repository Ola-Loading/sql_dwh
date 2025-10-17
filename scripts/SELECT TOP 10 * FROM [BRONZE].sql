SELECT TOP 10 * FROM [BRONZE].[AIRLINE_ACCIDENTS];
SELECT COUNT(*) FROM [BRONZE].[AIRLINE_ACCIDENTS];

SELECT COUNT(*) FROM (
SELECT Event_ID, 
NULLIF(TRIM(Investigation_Type),'') as Investigation_Type,
NULLIF(TRIM(Accident_Number),'') as Accident_Number,
CAST(NULLIF(TRIM(Event_Date), '') AS DATE) AS Event_Date,
 CASE 
    WHEN UPPER(TRIM(Location)) IN ('', 'MISSING', 'UNKNOWN') 
         OR UPPER(TRIM(Location)) LIKE '%MISSING%' 
         OR UPPER(TRIM(Location)) LIKE '%UNKNOWN%' THEN NULL
    WHEN dbo.CleanNameV2(Location) like '%'+ dbo.CleanNameV1(COUNTRY)+'%' THEN replace(dbo.CleanNameV2(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOCATION,'I.','ISLAND '),'IS.','ISLAND '),'ISL.','ISLAND '),'E.','EAST '),'W.','WEST '),'INTL','INTERNATIONAL'),'INT''L','INTERNATIONAL'))),dbo.CleanNameV1(COUNTRY),'')
    ELSE dbo.CleanNameV2(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LOCATION),'I.','ISLAND '),'IS.','ISLAND '),'ISL.','ISLAND '),'E.','EAST '),'W.','WEST '),'INTL','INTERNATIONAL'),'INT''L','INTERNATIONAL')))
END AS Location, 
NULLIF(UPPER(TRIM(Country)),'') as Country,
CAST(NULLIF(TRIM(Latitude),'') as float) as Latitude, 
CAST(NULLIF(TRIM(Longitude),'') as float) as Longitude, 
dbo.CleanAirportCode(AIRPORT_CODE) as Airport_Code_IATAorIACOorFAA, 
REPLACE(REPLACE(NULLIF(dbo.CleanNameV1(airport_name),''),'INTL','INTERNATIONAL'),'INT''L','INTERNATIONAL') AS Airport_Name,
CASE 
    WHEN Injury_Severity LIKE '%FATAL(%' THEN 'FATAL'
    WHEN UPPER(TRIM(Injury_Severity)) IN ('UNAVAILABLE','') THEN NULL
    ELSE UPPER(TRIM(Injury_Severity))
END AS Injury_Severity,
NULLIF(TRIM(Aircraft_Damage),'') AS Aircraft_Damage, 
NULLIF(UPPER(TRIM(Aircraft_Category)),'') AS Aircraft_Category, 
CASE
    WHEN TRIM(UPPER(Registration_Number)) LIKE '%UNK%' THEN NULL 
    ELSE REPLACE(TRIM(UPPER(Registration_Number)),'*','')
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
    WHEN dbo.CleanNameV1(LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%NONSCHEDULED%' THEN 'NOT SCHEDULED'
    WHEN dbo.CleanNameV1(LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%SCHEDULED%' THEN 'SCHEDULED'
    WHEN dbo.CleanNameV1(LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) LIKE '%GENERAL AVIATION%' THEN 'GENERAL AVIATION'
    ELSE dbo.CleanNameV1 (LTRIM(SUBSTRING(FAR_DESCRIPTION,CHARINDEX(':',FAR_DESCRIPTION)+1, LEN(FAR_DESCRIPTION)))) 
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
WHERE TRY_CAST(TRIM(Event_Date) AS DATE) IS NOT NULL) T;





SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) NOT LIKE 'Fatal%'
AND Total_Fatal_Injuries > 0;

-- SHOULD BE CLASSED AS FATAL 

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) LIKE 'Fatal%'
AND Total_Fatal_Injuries = 0;

-- Flights didnt occur ?

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
-- SELECT distinct Injury_Severity FROM [BRONZE].[AIRLINE_ACCIDENTS]
-- WHERE cast(SUBSTRING(Injury_Severity, CHARINDEX('(', Injury_Severity) + 1,
--     (CHARINDEX(')', Injury_Severity) - CHARINDEX('(', Injury_Severity) - 1)
--   ) as int) ! = coalesce(cast(Total_Fatal_Injuries as int),0) or 
-- cast(SUBSTRING(Injury_Severity,
--     CHARINDEX('(', Injury_Severity) + 1,
--     (CHARINDEX(')', Injury_Severity) - CHARINDEX('(', Injury_Severity) - 1)
--   ) as int)  ! = 0 and 
-- TRIM(Injury_Severity) LIKE 'Fatal%';







-- https://www.beliefmedia.com.au/blog/ntsb-api

