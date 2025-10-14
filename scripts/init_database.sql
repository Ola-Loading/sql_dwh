/*
================================================================================================
Create Database and Schemas 
================================================================================================

SCRIPT PURPOSE:
This script creates the database 'DataWarehouse' after first checking whether it exists or not. 
If it exists it is first dropped and then recreated. Additionally three schemas ; 'Bronze', 'Silver'
and 'Gold' are created within this database. 

WARNING:
This script will delete the entire database 'Datawarehouse' if it already exists and all the data inherent. 
Exercise caution and ensure that backups are available before running this script
*/


USE master;

GO

-- Drop and recreate the database 'DataWarehouse'

DECLARE @SQL AS NVARCHAR (1000);

IF EXISTS (SELECT 1
           FROM sys.databases
           WHERE [name] = N'DataWarehouse')
    BEGIN
        SET @SQL = N'USE [DataWarehouse];

                 ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                 USE [master];

                 DROP DATABASE DataWarehouse;';
        EXECUTE (@SQL);
    END

GO
create database DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA BRONZE;
GO

CREATE SCHEMA SILVER;
GO

CREATE SCHEMA GOLD;

