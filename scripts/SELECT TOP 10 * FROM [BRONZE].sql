SELECT TOP 10 * FROM [BRONZE].[AIRLINE_ACCIDENTS];
SELECT COUNT(*) FROM [BRONZE].[AIRLINE_ACCIDENTS];

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(Investigation_Type) NOT IN ( 'Accident' ,'Incident')
AND TRIM(Injury_Severity) LIKE 'Fatal%';


SELECT Event_ID, 
TRIM(Investigation_Type) as Investigation_Type,
TRIM(Accident_Number) as Accident_Number,
CAST(TRIM(Event_Date) AS DATE) as Event_Date,
*TRIM(REPLACE(Location_1,'"',''))+ ','+ TRIM(REPLACE(Location_2,'"','')) AS Location, 
TRIM(Country) as Country,
CAST(TRIM(Latitude) as float) as Latitude, 
CAST(TRIM(Longitude) as float) as Longitude, 
dbo.CleanAirportCode(AIRPORT_CODE) as Airport_Code_IATAorIACOorFAA, 
*airport_name,
CASE 
    WHEN ISNULL(NULLIF(UPPER(TRIM(SCHEDULE)),''),'UNKNOWN') = 'SCHD' THEN 'SCHEDULED' 
    WHEN ISNULL(NULLIF(UPPER(TRIM(SCHEDULE)),''),'UNKNOWN') = 'NSCH' THEN 'NOT SCHEDULED' 
    ELSE 'UNKNOWN' 
END AS SCHEDULE,
ISNULL(NULLIF(UPPER(TRIM(PURPOSE_OF_FLIGHT)),''),'UNKNOWN') AS PURPOSE_OF_FLIGHT
ISNULL(NULLIF(UPPER(TRIM(AIR_CARRIER)),''),'UNKNOWN') AS AIR_CARRIER,
CAST(COALESCE(TRIM(Total_Fatal_Injuries),0) AS INT) as Total_Fatal_Injuries,
CAST(COALESCE(TRIM(Total_Serious_Injuries),0) AS INT) as Total_Serious_Injuries, 
CAST(COALESCE(TRIM(Total_Minor_Injuries),0) AS INT) as Total_Minor_Injuries,
CAST(COALESCE(TRIM(Total_Uninjured),0) AS INT) as Total_Uninjured,
ISNULL(NULLIF(TRIM(BROAD_PHASE_OF_FLIGHT), ''), 'UNKNOWN') AS BROAD_PHASE_OF_FLIGHT,
CASE 
    WHEN UPPER(TRIM(WEATHER_CONDITION)) = 'IMC' THEN 'Instrument Meteorological Conditions'
    WHEN UPPER(TRIM(WEATHER_CONDITION)) = 'VMC' THEN 'Visual Meteorological Conditions'
ELSE 'UNKNOWN'
END AS WEATHER_CONDITION 
CAST(TRIM(Report_Publication_Date) AS DATE) as Report_Publication_Date
FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRY_CAST(TRIM(Event_Date) AS DATE) IS NOT NULL;


SELECT DISTINCT Location, Country from [BRONZE].[AIRLINE_ACCIDENTS]
where TRIM(Country) != 'United States';
and (Country is NULL or TRIM(Country) = '' or LOWER(Country) = 'unknown');

SELECT SUBSTRING(TRIM(' BAN XIENG, LAOS '), 1, CHARINDEX(',', TRIM(' BAN XIENG, LAOS '))-1);

SELECT RIGHT(TRIM(' BAN XIENG, LAOS '),LEN(TRIM(' BAN XIENG, LAOS '))-CHARINDEX(',', TRIM(' BAN XIENG, LAOS ')));

SELECT CASE 
    WHEN CHARINDEX(',','MNUS') = 0 THEN 4
    END AS CHECKING,
    CASE 
    WHEN CHARINDEX(',', TRIM(' BAN XIENG, LAOS ')) != 0 THEN CHARINDEX(',', TRIM(' BAN XIENG, LAOS ')) 
    end as heck;









SELECT DISTINCT Total_Fatal_Injuries FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) = 'Fatal(0)';


SELECT DISTINCT INJURY_SEVERITY FROM [BRONZE].[AIRLINE_ACCIDENTS];

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) NOT LIKE 'Fatal%'
AND Total_Fatal_Injuries > 0;

-- SHOULD BE CLASSED AS FATAL 

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE TRIM(INJURY_SEVERITY) LIKE 'Fatal%'
AND Total_Fatal_Injuries = 0;

-- Flights didnt occur ?

SELECT * FROM [BRONZE].[AIRLINE_ACCIDENTS]
WHERE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(REPLACE(TRIM(Report_Publication_Date),CHAR(127), ''), CHAR(160), ''),CHAR(9), ''),CHAR(0), ''), CHAR(10), '')
,CHAR(10), ''),  CHAR(13), '') = '' AND TRIM(Injury_Severity) NOT LIKE 'Fatal%';


-- SELECT distinct Injury_Severity FROM [BRONZE].[AIRLINE_ACCIDENTS]
-- WHERE cast(SUBSTRING(Injury_Severity, CHARINDEX('(', Injury_Severity) + 1,
--     (CHARINDEX(')', Injury_Severity) - CHARINDEX('(', Injury_Severity) - 1)
--   ) as int) ! = coalesce(cast(Total_Fatal_Injuries as int),0) or 
-- cast(SUBSTRING(Injury_Severity,
--     CHARINDEX('(', Injury_Severity) + 1,
--     (CHARINDEX(')', Injury_Severity) - CHARINDEX('(', Injury_Severity) - 1)
--   ) as int)  ! = 0 and 
-- TRIM(Injury_Severity) LIKE 'Fatal%';




SELECT REPLACE(UPPER(TRIM(AIR_CARRIER)),'','UNKNOWN') AS AIR_CARRIER FROM [BRONZE].[AIRLINE_ACCIDENTS]) AS T ;

SELECT DISTINCT schedule FROM [BRONZE].[AIRLINE_ACCIDENTS];


;
