USE [MedicalHistory];
GO

CREATE OR ALTER FUNCTION OnlyNums(@value varchar(MAX)) RETURNS bit
AS
BEGIN
	RETURN IIF(@value LIKE '%[^0-9]%', 0, 1)
END
GO

CREATE OR ALTER FUNCTION CalculateLuhn(@value varchar(MAX), @len int) RETURNS tinyint
AS
BEGIN
	DECLARE @checkdigit tinyint = null;

	IF LEN(@value) >= @len AND dbo.OnlyNums(@value) = 1
	BEGIN
		DECLARE @mult int = 2,
				@digit tinyint = 0,
				@digits int = 0,
				@checksum int = 0,
				@zero tinyint = ASCII('0'),
				@cnt int = 1;
		
		WHILE @cnt <= @len
		BEGIN
			SELECT	@mult = 3 - @mult,
					@digit = ASCII(SUBSTRING(@value, @cnt, 1)) - @zero,
					@digits = @digit * @mult,
					@checksum += @digits / 10 + @digits % 10,
					@cnt += 1
		END

		SET @checkdigit = (10 - (@checksum % 10)) % 10;
	END

	RETURN @checkdigit;
END
GO

CREATE OR ALTER FUNCTION CheckLuhn(@value varchar(MAX), @len int) RETURNS bit
AS
BEGIN
	DECLARE @zero tinyint = ASCII('0');
	DECLARE @digit int = ASCII(SUBSTRING(@value, @len+1, 1)) - @zero;
	DECLARE @luhn int = dbo.CalculateLuhn(@value, @len);

	RETURN IIF(@luhn = @digit AND LEN(@value) = @len+1, 1, 0);
END
GO

CREATE OR ALTER FUNCTION ValidateID(@id varchar(13)) RETURNS bit
AS 
BEGIN
	DECLARE @YYMMDD varchar(6) = SUBSTRING(@id, 1, 6);
	DECLARE @C varchar = SUBSTRING(@id, 11, 1);
	DECLARE @date datetime = TRY_CAST(@YYMMDD AS DATE);

	RETURN IIF(LEN(@id) = 13
		AND (@C = '0' OR @C = '1')
		AND dbo.CheckLuhn(@id, 12) = 1
		AND @date IS NOT NULL, 1, 0);
END
GO

SELECT id,
		dbo.CalculateLuhn(id, 12) AS [Luhn],
		dbo.CheckLuhn(id, 12) AS [Luhn Valid],
		dbo.ValidateID(id) AS [ID Valid]
	FROM (
	VALUES
		('YYMMDDSSSSCAZ'), -- Clearly not a valid ID, but nice to test.
		('7506200000189'),
		('8701110000184'),
		('8901030000187'),
		('0105020000185'),
		('0808290000187'),
		('7601220000184'),
		('7711170000181'),
		('2608080000183'),
		('8105080000184'),
		('1703040000182'),
		('0000000000000'),
		('1111111111112'))
	AS T(id)
