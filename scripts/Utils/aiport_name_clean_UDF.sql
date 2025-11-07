CREATE OR ALTER FUNCTION dbo.CleanAirportName
(
    @Code NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Cleaned NVARCHAR(100)

    -- Step 1: Basic cleanup and NULL handling
    IF @Code IS NULL
    BEGIN
        RETURN NULL
    END

    -- Step 2: Trim 
    SET @Cleaned = LTRIM(RTRIM(@Code))

    -- === INTERNATIONAL variants ===

    -- INT'L
    SET @Cleaned = REPLACE(@Cleaned, 'INT''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = 'INT''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + 'INTERNATIONAL';

    -- INTL
    SET @Cleaned = REPLACE(@Cleaned, 'INTL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 4) = 'INTL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 4) + 'INTERNATIONAL';

    -- INTERNATIOANL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATIOANL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 13) = 'INTERNATIOANL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 13) + 'INTERNATIONAL';

    -- INTNL
    SET @Cleaned = REPLACE(@Cleaned, 'INTNL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = 'INTNL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + 'INTERNATIONAL';

    -- INTERNATIONA
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATIONA ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 12) = 'INTERNATIONA'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 12) + 'INTERNATIONAL';

    -- INTERNA
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNA ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 7) = 'INTERNA'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 7) + 'INTERNATIONAL';

    -- INTERNAT
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNAT ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 8) = 'INTERNAT'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 8) + 'INTERNATIONAL';

    -- INTERNATION
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATION ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 11) = 'INTERNATION'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 11) + 'INTERNATIONAL';

    -- INTERNATIO
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATIO ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 10) = 'INTERNATIO'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 10) + 'INTERNATIONAL';

    -- INTER
    SET @Cleaned = REPLACE(@Cleaned, 'INTER ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = 'INTER'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + 'INTERNATIONAL';

    -- INTER'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTER''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 7) = 'INTER''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 7) + 'INTERNATIONAL';

    -- INTERNATIONL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATIONL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 12) = 'INTERNATIONL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 12) + 'INTERNATIONAL';

    -- INTN'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTN''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 6) = 'INTN''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 6) + 'INTERNATIONAL';

    -- INTER NAT'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTER NAT''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 11) = 'INTER NAT''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 11) + 'INTERNATIONAL';

    -- INT'N'L
    SET @Cleaned = REPLACE(@Cleaned, 'INT''N''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 7) = 'INT''N''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 7) + 'INTERNATIONAL';

    -- I'NTL
    SET @Cleaned = REPLACE(@Cleaned, 'I''NTL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = 'I''NTL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + 'INTERNATIONAL';

    -- INTERNATIOAL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATIOAL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 12) = 'INTERNATIOAL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 12) + 'INTERNATIONAL';

    -- INTERNAT'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNAT''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 10) = 'INTERNAT''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 10) + 'INTERNATIONAL';

      -- INT
    SET @Cleaned = REPLACE(@Cleaned, ' INT ', ' INTERNATIONAL ');
    IF RIGHT(@Cleaned, 4) = ' INT'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 4) + ' INTERNATIONAL';

     --INTERNATI 
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATI', 'INTERNATIONAL');
    IF RIGHT(@Cleaned, 9) = 'INTERNATI'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 9) + 'INTERNATIONAL';

     --INTERANTIONAL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERANTIONAL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 13) = 'INTERANTIONAL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 13) + 'INTERNATIONAL';

    --INTERN
    SET @Cleaned = REPLACE(@Cleaned, 'INTERN ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 7) = ' INTERN'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 7) + ' INTERNATIONAL';

    --INT'
    SET @Cleaned = REPLACE(@Cleaned, 'INT'' ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = ' INT'''
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + ' INTERNATIONAL';

    --INTNTL
    SET @Cleaned = REPLACE(@Cleaned, 'INTNTL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 6) = 'INTNTL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 6) + 'INTERNATIONAL';
    
    --INTERANTIONAL
    SET @Cleaned = REPLACE(@Cleaned, 'INTRANATIONAL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 13) = 'INTRANATIONAL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 13) + 'INTERNATIONAL';
    
    --INTERANTIONAL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERNATL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 9) = 'INTERNATL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 9) + 'INTERNATIONAL';
    
    --INTERN'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTERN''L ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 8) = 'INTERN''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 8) + 'INTERNATIONAL';

    --INTL'
    SET @Cleaned = REPLACE(@Cleaned, 'INTL'' ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 5) = 'INTL'''
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 5) + 'INTERNATIONAL';

    --INTERANNATIONAL
    SET @Cleaned = REPLACE(@Cleaned, 'INTERANNATIONAL ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 15) = 'INTERANNATIONAL'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 15) + 'INTERNATIONAL';

    --INTN'T
    SET @Cleaned = REPLACE(@Cleaned, 'INTN''T ', 'INTERNATIONAL ');
    IF RIGHT(@Cleaned, 6) = 'INTN''T'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 6) + 'INTERNATIONAL';

    

    -- === INTERCONTINENTAL variant ===

    SET @Cleaned = REPLACE(@Cleaned, 'INTERCONT ', 'INTERNCONTINENTAL ');
    IF RIGHT(@Cleaned, 9) = 'INTERCONT'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 9) + 'INTERNCONTINENTAL';

    -- INTERCONT'L
    SET @Cleaned = REPLACE(@Cleaned, 'INTERCONT''L ', 'INTERNCONTINENTAL ');
    IF RIGHT(@Cleaned, 11) = 'INTERCONT''L'
        SET @Cleaned = LEFT(@Cleaned, LEN(@Cleaned) - 11) + 'INTERNCONTINENTAL';


    RETURN @Cleaned
END


