USE tempdb;

GO

DECLARE @SQL AS NVARCHAR (1000);

IF EXISTS (SELECT 1
           FROM sys.databases
           WHERE [name] = N'Library')
    BEGIN
        SET @SQL = N'USE [Library];

                 ALTER DATABASE Library SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                 USE [tempdb];

                 DROP DATABASE Library;';
        EXECUTE (@SQL);
    END

-- to delete database, replace Library with the name of the database