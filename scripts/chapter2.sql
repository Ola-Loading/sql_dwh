SELECT TOP 10 * FROM [BRONZE].[FAA_INCIDENTS_DATA];
SELECT COUNT(*) FROM [BRONZE].[FAA_INCIDENTS_DATA];


-- QUERYY
-- SELECT COUNT(*) FROM (
SELECT AIDS_Report_Number, 
CAST(Local_Event_Date AS DATE) as Event_Date,
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

-- ) as T;



SELECT * FROM [SILVER].[FAA_INCIDENTS_DATA] ;

TRUNCATE TABLE [SILVER].[FAA_INCIDENTS_DATA];