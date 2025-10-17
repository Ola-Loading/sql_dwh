/*
================================================================================================
Stored Procedure to load bronze layer tables from source system - static excel files 
================================================================================================

SCRIPT PURPOSE:
This script is a stored procedure that performs the following for each of the tables in the 'BRONZE' schema within the 'DataWarehouse' database:
    - Truncates the tables if there is existing data
    - Reloads/loads the table with the data from the corresponding source file 

Parameters:
This stored procedure does not accept any arguments

Usage:
Ensure that you are in the correct database: 'DataWarehouse'
EXEC BRONZE.LOAD_BRONZE 

*NOTE THIS WILL IN ESSENSE OVERWRITE ANY DATA CURRENTLY STORED IN THESE TABLES 
*/


CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS
BEGIN
    DECLARE @starttime DATETIME, @endtime DATETIME;
    DECLARE @BATCHSTART DATETIME = GETDATE(), @BATCHEND DATETIME;
    BEGIN TRY

        PRINT 'TRUNCATING TABLE: [BRONZE].[AIRLINE_ACCIDENTS]';

        TRUNCATE TABLE [BRONZE].[AIRLINE_ACCIDENTS];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[BRONZE].[AIRLINE_ACCIDENTS]';

        SET @starttime = GETDATE();

        BULK INSERT [BRONZE].[AIRLINE_ACCIDENTS]
        FROM '/datasets/aviation-accidents-and-incidents-ntsb-faa-waas/airline_accidents.tsv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '\t',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [BRONZE].[FAA_INCIDENTS_DATA]';
        TRUNCATE TABLE [BRONZE].[FAA_INCIDENTS_DATA];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[BRONZE].[FAA_INCIDENTS_DATA]';
        SET @starttime = GETDATE();
        BULK INSERT [BRONZE].[FAA_INCIDENTS_DATA]
        FROM '/datasets/aviation-accidents-and-incidents-ntsb-faa-waas/faa_incidents_data.tsv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '\t',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [BRONZE].[NTSB_AVIATION_DATA]';

        TRUNCATE TABLE [BRONZE].[NTSB_AVIATION_DATA];

        PRINT '==============================================';
        PRINT 'INSERTING INTO TABLE:[BRONZE].[NTSB_AVIATION_DATA]';
        SET @starttime = GETDATE();
        BULK INSERT [BRONZE].[NTSB_AVIATION_DATA]
        FROM '/datasets/aviation-accidents-and-incidents-ntsb-faa-waas/ntsb_aviation_data.tsv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '\t',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';
        PRINT '======================================================================================';

        PRINT 'TRUNCATING TABLE: [BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]';

        TRUNCATE TABLE [BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY];

        PRINT '==============================================';

        PRINT 'INSERTING INTO TABLE:[BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]';

        SET @starttime = GETDATE();
        BULK INSERT [BRONZE].[WORLD_AIRCRAFT_ACCIDENT_SUMMARY]
        FROM '/datasets/aviation-accidents-and-incidents-ntsb-faa-waas/world_aircraft_accident_summary.tsv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '\t',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @endtime = GETDATE();
        PRINT 'LOAD TIME: '+ CAST(DATEDIFF(SECOND, @starttime, @endtime) AS VARCHAR) + ' SECONDS';

        PRINT'======================================================================================';
        SET @BATCHEND = GETDATE();

        PRINT 'TOTAL LOAD TIME: '+ CAST(DATEDIFF(SECOND, @BATCHSTART, @BATCHEND) AS VARCHAR) + ' SECONDS';
    
    END TRY

    BEGIN CATCH 
    PRINT '============================================================='
    PRINT 'ERROR WHILST LOADING THE BRONZE LAYER';
    PRINT 'ERROR MESSAGE: '+ ERROR_MESSAGE();
    PRINT 'ERROR MESSAGE: '+ CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'ERROR MESSAGE: '+ CAST(ERROR_STATE() AS VARCHAR);
    PRINT '============================================================='
    END CATCH 

END 



