CREATE FUNCTION [dbo].[eliminapuntos]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%.%', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%.%', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaLetras]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('%[aA-zZ]%', @string)
     
    WHILE @IncorrectCharLoc > 0
    BEGIN
        
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('%[aA-zZ]%', @string)
        
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[eliminaespacios]
(
    @string VARCHAR(8000)
)
RETURNS VARCHAR(8000)
AS
BEGIN
    DECLARE @IncorrectCharLoc SMALLINT
    SET @IncorrectCharLoc = PATINDEX('% %', @string)
    WHILE @IncorrectCharLoc > 0
    BEGIN
        SET @string = STUFF(@string, @IncorrectCharLoc, 1, '')
        SET @IncorrectCharLoc = PATINDEX('% %', @string)
    END
    SET @string = @string
    RETURN @string
END


CREATE FUNCTION [dbo].[fn_CharLTrim]  ---drop function [dbo].[fn_CharLTrim] 
(
	@char       CHAR(1)
   ,@cadena     NVARCHAR(255)
)
RETURNS NVARCHAR(20)
AS
BEGIN
	DECLARE @posicion INTEGER
	SELECT  @posicion = PATINDEX('[' + @char + ']%' ,@cadena)
	WHILE   @posicion > 0
	BEGIN
	    SELECT @cadena = STUFF(@cadena,@posicion,1,'')
	    SELECT @posicion = PATINDEX('[' + @char + ']%' ,@cadena)
	END
	RETURN @cadena
END

--SELECT dbo.fn_CharLTrim('0','0000210215-152')








