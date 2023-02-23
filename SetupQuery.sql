USE [master]
GO

-- Don't touch this
DECLARE @verysafesafetynet bit = 0;
IF @verysafesafetynet = 1
	DROP DATABASE IF EXISTS [MedicalHistory]
GO

CREATE DATABASE [MedicalHistory]
GO

USE [MedicalHistory]
GO

/* So that Database Diagrams works in SSMS */
--EXEC sp_changedbowner 'sa'
--GO

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

--SELECT id,
--		dbo.CalculateLuhn(id, 12) AS [Luhn],
--		dbo.CheckLuhn(id, 12) AS [Luhn Valid],
--		dbo.ValidateID(id) AS [ID Valid]
--	FROM (
--	VALUES
--		('YYMMDDSSSSCAZ'), -- Clearly not a valid ID, but nice to test.
--		('7506200000189'),
--		('8701110000184'),
--		('8901030000187'),
--		('0105020000185'),
--		('0808290000187'),
--		('7601220000184'),
--		('7711170000181'),
--		('2608080000183'),
--		('8105080000184'),
--		('1703040000182'),
--		('0000000000000'),
--		('1111111111112'))
--	AS T(id)

CREATE TABLE [dbo].[Person](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[idNumber] [varchar](13) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[surname] [nvarchar](255) NOT NULL,
	CHECK (dbo.ValidateID(idNumber) = 1),
)
GO

CREATE TABLE [dbo].[Contact](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[phone] [varchar](10) NULL,
	[email] [nvarchar](255) NULL,
)
GO

CREATE TABLE [dbo].[Patient](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[contactId] [uniqueidentifier] NULL,
	CONSTRAINT [FK_Patient_Person] FOREIGN KEY([id]) REFERENCES [Person]([id]),
	CONSTRAINT [FK_Patient_Contact] FOREIGN KEY([contactId]) REFERENCES [Contact]([id]),
)
GO

CREATE TABLE [dbo].[Professional](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[contactId] [uniqueidentifier] NULL,
	CONSTRAINT [FK_Professional_Person] FOREIGN KEY([id]) REFERENCES [Person]([id]),
	CONSTRAINT [FK_Professional_Contact] FOREIGN KEY([contactId]) REFERENCES [Contact]([id]),
)
GO

CREATE TABLE [dbo].[Dose](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[description] [varchar](255) NOT NULL,
)
GO

CREATE TABLE [dbo].[Medication](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[name] [nvarchar](255) NOT NULL,
)
GO

CREATE TABLE [dbo].[Prescription](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[doseId] [uniqueidentifier] NOT NULL,
	[medicationId] [uniqueidentifier] NOT NULL,
	[patientId] [uniqueidentifier] NOT NULL,
	[professionalId] [uniqueidentifier] NOT NULL,
	[startdate] [datetime] NOT NULL,
	[endate] [datetime] NOT NULL, -- endDate :)
	[cancelledDate] [datetime] NULL,
	CONSTRAINT [FK_Prescription_Dose] FOREIGN KEY([doseId]) REFERENCES [Dose]([id]),
	CONSTRAINT [FK_Prescription_Medication] FOREIGN KEY([medicationId]) REFERENCES [Medication]([id]),
	CONSTRAINT [FK_Prescription_Patient] FOREIGN KEY([patientId]) REFERENCES [Patient]([id]),
	CONSTRAINT [FK_Prescription_Professional] FOREIGN KEY([professionalId]) REFERENCES [Professional]([id]),
	CHECK (startdate <= endate),
	CHECK (startdate <= cancelledDate),
	CHECK (cancelledDate <= endate)
	-- This is an auditing problem :)
	-- CHECK(patientId != professionalId)
)
GO

CREATE TABLE [dbo].[ProcedureType](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[description] [varchar](255) NOT NULL,
)
GO

CREATE TABLE [dbo].[Procedure](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[patientId] [uniqueidentifier] NOT NULL,
	[professionalId] [uniqueidentifier] NOT NULL,
	[typeId] [uniqueidentifier] NOT NULL,
	[date] [datetime] NULL,
	CONSTRAINT [FK_Procedure_ProcedureType] FOREIGN KEY([typeId]) REFERENCES [ProcedureType]([id]),
	CONSTRAINT [FK_Procedure_Patient] FOREIGN KEY([patientId]) REFERENCES [Patient]([id]),
	CONSTRAINT [FK_Procedure_Professional] FOREIGN KEY([professionalId]) REFERENCES [Professional]([id]),
	-- This is an auditing problem :)
	-- CHECK(patientId != professionalId)
)
GO

--INSERT NEW PRESCRIPTION--
CREATE OR ALTER PROCEDURE [dbo].[uspInsertNewPrescription]
	@medicationId uniqueidentifier,
	@patientId uniqueidentifier,
	@professionalId uniqueidentifier,
	@startdate date,
	@endate date,
	@doseId uniqueidentifier
AS
BEGIN
	INSERT INTO [dbo].[Prescription](medicationId, patientId, professionalId, startdate, endate, doseId)
	VALUES(@medicationId, @patientId, @professionalId, @startdate, @endate, @doseId);
END
GO

--SELECT PATIENT DETAILS--
CREATE OR ALTER PROCEDURE [dbo].[uspGetPatientDetailsByID]
@patientId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON
	SELECT p.id, pr.name, pr.surname, c.phone, c.email
	FROM Patient p
	INNER JOIN Person pr ON pr.id = p.id
	INNER JOIN Contact c ON c.id = p.contactId
	WHERE p.id = @patientId;
END
GO

--UPDATE CONTACT DETAILS--
CREATE OR ALTER PROCEDURE [dbo].[uspUpdateContactDetailsByIDNumber]
@idNumber varchar(13),
@phoneNo varchar(10),
@email nvarchar(255)
AS
BEGIN
	DECLARE @patientid uniqueidentifier

	SELECT @patientid = p.id FROM Person p
	WHERE p.idNumber = @idNumber;

	UPDATE Contact
	SET phone = @phoneNo, email = @email
	WHERE id = @patientid;
END
GO

--FULL PATIENT HISTORY VIEW--
CREATE OR ALTER VIEW [dbo].[Patient_Prescription_History]
AS
	SELECT pa.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email, m.name AS [Medication Name],
		d.description AS [Medication Doseage], pr.startdate AS [Prescription Start Date], pr.endate AS [Prescription End Date], pr.cancelledDate AS [Prescription Cancelled Date]
	FROM Patient pa
	INNER JOIN dbo.Person p ON pa.id = p.id
	LEFT JOIN Contact c ON c.id = pa.contactId
	INNER JOIN Prescription pr ON pr.patientId = p.id
	LEFT JOIN Medication m ON pr.medicationId = m.id
	LEFT JOIN Dose d ON d.id = pr.doseId
GO

--FULL PATIENT PROCEDURE HISTORY VIEW--
CREATE OR ALTER VIEW [dbo].[Patient_Procedure_History]
AS
	SELECT p.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email,
		prc.date AS [Procedure Date], prct.description AS [Procedure Type]
	FROM Patient pa
	INNER JOIN dbo.Person p ON pa.id = p.id
	LEFT JOIN Contact c ON c.id = pa.contactId
	INNER JOIN [Procedure] prc ON prc.patientId = p.id
	LEFT JOIN ProcedureType prct ON prct.id = prc.typeId;
GO

USE [master]
GO
