TRUNCATE TABLE [BRONZE].[AIRLINE_ACCIDENTS];

BULK INSERT [BRONZE].[AIRLINE_ACCIDENTS]
FROM '/Users/olaogunade/Documents/Jobs/Projects_Practice/SQL_DWH/sql_dwh/datasets/aviation-accidents-and-incidents-ntsb-faa-waas/airline_accidents.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);