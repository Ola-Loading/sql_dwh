CREATE OR ALTER FUNCTION dbo.CleanNameV1
( 
    @Code NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Cleaned NVARCHAR(100)

    -- Step 1: Basic cleanup and NULL handling
    IF @Code IS NULL OR 
       UPPER(LTRIM(RTRIM(@Code))) IN ('N/A', '', '---', 'NONE','UNKNOWN')
    BEGIN
        RETURN NULL
    END

    -- Step 2: Trim and remove special symbols
    SET @Cleaned  = REPLACE(@Code,' " ','')
    SET @Cleaned  = REPLACE(@Cleaned,'"','')
    SET @Cleaned = TRIM(@Cleaned)
    SET @Cleaned = REPLACE(@Cleaned, ' - ', ' ')
    SET @Cleaned = REPLACE(@Cleaned, '-', ' ')
    SET @Cleaned = REPLACE(@Cleaned, ' ; ', '')
    SET @Cleaned = REPLACE(@Cleaned, ';', '')
    SET @Cleaned = REPLACE(@Cleaned, '/', ' ')
    SET @Cleaned = REPLACE(@Cleaned, '\', ' ')
    SET @Cleaned = REPLACE(@Cleaned, ' & ', ' AND ')
    SET @Cleaned = REPLACE(@Cleaned, '&', ' AND ')
    SET @Cleaned = REPLACE(@Cleaned, '.', '')
    SET @Cleaned = REPLACE(@Cleaned, ',', '')
    SET @Cleaned = REPLACE(@Cleaned,N'├╢','O')
    SET @Cleaned = REPLACE(@Cleaned,'+','')
    SET @Cleaned = REPLACE(@Cleaned,')','')
    SET @Cleaned = REPLACE(@Cleaned,'(','')
    SET @Cleaned = REPLACE(@Cleaned,' # ',' ')
    SET @Cleaned = REPLACE(@Cleaned,'#','')
    SET @Cleaned = REPLACE(@Cleaned,']','')
    SET @Cleaned = REPLACE(@Cleaned,'[','')
    SET @Cleaned = REPLACE(@Cleaned, '  ', ' ')
    SET @Cleaned = TRIM(@Cleaned)

    -- Step 3: Handle scientific format like 1.00E+02
    IF @Cleaned LIKE '%00E+%'
    BEGIN
        SET @Cleaned = LEFT(@Cleaned, 1) + 'E' + RIGHT(@Cleaned, 1)
    END

    -- Step 4: Remove common non-printable characters
    SET @Cleaned = REPLACE(@Cleaned, CHAR(127), '')
    SET @Cleaned = REPLACE(@Cleaned, CHAR(160), '')
    SET @Cleaned = REPLACE(@Cleaned, CHAR(9), '')
    SET @Cleaned = REPLACE(@Cleaned, CHAR(0), '')
    SET @Cleaned = REPLACE(@Cleaned, CHAR(10), '')
    SET @Cleaned = REPLACE(@Cleaned, CHAR(13), '')

    RETURN UPPER(@Cleaned)
END

