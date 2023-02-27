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
IF HOST_NAME() = SERVERPROPERTY('MachineName')
	EXEC sp_changedbowner 'sa'
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

IF 0 <> 0
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

CREATE TABLE [dbo].[Person](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[apiKey] [uniqueidentifier] NOT NULL UNIQUE DEFAULT newid(),
	[idNumber] [varchar](13) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[surname] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [CK_Person_ValidateId] CHECK (dbo.ValidateID(idNumber) = 1),
)
GO

CREATE TABLE [dbo].[Contact](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[apiKey] [uniqueidentifier] NOT NULL UNIQUE DEFAULT newid(),
	[phone] [varchar](max) NULL,
	[email] [nvarchar](max) NULL,
	CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED ([id] ASC),
)
GO

CREATE TABLE [dbo].[Patient](
	[id] [int] NOT NULL,
	[contactId] [int] NULL,
	[dateOfBirth] [datetime] NULL,
	CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_Patient_Person] FOREIGN KEY([id]) REFERENCES [Person]([id]),
	CONSTRAINT [FK_Patient_Contact] FOREIGN KEY([contactId]) REFERENCES [Contact]([id]),
	CONSTRAINT [CK_Patient_Birth] CHECK(dateOfBirth <= GETDATE()),
)
GO

CREATE TABLE [dbo].[Professional](
	[id] [int] NOT NULL,
	[contactId] [int] NULL,
	CONSTRAINT [PK_Professional] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_Professional_Person] FOREIGN KEY([id]) REFERENCES [Person]([id]),
	CONSTRAINT [FK_Professional_Contact] FOREIGN KEY([contactId]) REFERENCES [Contact]([id]),
)
GO

CREATE TABLE [dbo].[Dose](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](max) NOT NULL,
	[description] [varchar](max) NOT NULL,
 	CONSTRAINT [PK_Dose] PRIMARY KEY CLUSTERED ([id] ASC),
)
GO

CREATE TABLE [dbo].[Drug](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](max) NOT NULL,
	[name] [varchar](max) NOT NULL,
	[description] [varchar](max) NOT NULL,
	CONSTRAINT [PK_Medication] PRIMARY KEY CLUSTERED ([id] ASC),
)
GO

CREATE TABLE [dbo].[Prescription](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[apiKey] [uniqueidentifier] NOT NULL UNIQUE DEFAULT newid(),
	[patientId] [int] NOT NULL,
	[professionalId] [int] NOT NULL,
 	CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_Prescription_Patient] FOREIGN KEY([patientId]) REFERENCES [Patient]([id]),
	CONSTRAINT [FK_Prescription_Professional] FOREIGN KEY([professionalId]) REFERENCES [Professional]([id]),
	-- This is an auditing problem
	-- CONSTRAINT [CK_Prescription_patientProfessional] CHECK(patientId != professionalId),
)
GO

CREATE TABLE [dbo].[Medicine](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[prescriptionId] [int] NOT NULL,
	[drugId] [int] NOT NULL,
	[doseId] [int] NOT NULL,
	[startDate] [datetime] NOT NULL,
	[endDate] [datetime] NOT NULL,
	[cancelledDate] [datetime] NULL,
	CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_Medicine_Prescription] FOREIGN KEY([prescriptionId]) REFERENCES [Prescription]([id]),
	CONSTRAINT [FK_Medicine_Dose] FOREIGN KEY([doseId]) REFERENCES [Dose]([id]),
	CONSTRAINT [FK_Medicine_Drug] FOREIGN KEY([drugId]) REFERENCES [Drug]([id]),
	CONSTRAINT [CK_startEnd] CHECK (startDate <= endDate),
	CONSTRAINT [CK_startCancel] CHECK (startDate <= cancelledDate),
	CONSTRAINT [CK_cancelEnd] CHECK (cancelledDate <= endDate),
)
GO

CREATE TABLE [dbo].[ProcedureType](
	[id] [int] IDENTITY(1,1) NOT NULL,
    [code] [varchar](max) NOT NULL,
    [description] [varchar](max) NOT NULL,
	CONSTRAINT [PK_ProcedureType] PRIMARY KEY CLUSTERED ([id] ASC),
)
GO

CREATE TABLE [dbo].[Procedure](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[apiKey] [uniqueidentifier] NOT NULL UNIQUE DEFAULT newid(),
	[patientId] [int] NOT NULL,
	[professionalId] [int] NOT NULL,
	[typeId] [int] NOT NULL,
	[date] [datetime] NULL,
	CONSTRAINT [PK_Procedure] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_Procedure_ProcedureType] FOREIGN KEY([typeId]) REFERENCES [ProcedureType]([id]),
	CONSTRAINT [FK_Procedure_Patient] FOREIGN KEY([patientId]) REFERENCES [Patient]([id]),
	CONSTRAINT [FK_Procedure_Professional] FOREIGN KEY([professionalId]) REFERENCES [Professional]([id]),
	-- This is an auditing problem
	-- CONSTRAINT [CK_Procedure_patientProfessional] CHECK(patientId != professionalId),
)
GO

--INSERT NEW PRESCRIPTION--
CREATE OR ALTER PROCEDURE [dbo].[InsertNewPrescription]
	@patientId int,
	@professionalId int
AS
BEGIN
	INSERT INTO [dbo].[Prescription](patientId, professionalId)
	VALUES (@patientId, @professionalId);
END
GO

--SELECT PATIENT DETAILS--
CREATE OR ALTER PROCEDURE [dbo].[GetPatientDetailsAPI]
@apiKey uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON
	SELECT pa.id, pr.name, pr.surname, c.phone, c.email
	FROM Person pr
	INNER JOIN Patient pa ON pr.id = pa.id
	INNER JOIN Contact c ON pa.contactId = c.id
	WHERE pr.apiKey = @apiKey;
END
GO

--UPDATE CONTACT DETAILS--
CREATE OR ALTER PROCEDURE [dbo].[UpdatePatientContactByNationalID]
@idNumber varchar(13),
@phoneNo varchar(10),
@email nvarchar(255)
AS
BEGIN
	DECLARE @patientId int
	SELECT @patientid = pr.id
	FROM Person pr
	WHERE pr.idNumber = @idNumber;

	DECLARE @contactId int
	SELECT @contactId = pa.contactId
	FROM Patient pa
	WHERE pa.id = @patientId

	UPDATE Contact
	SET phone = @phoneNo, email = @email
	WHERE id = @contactId;
END
GO

--FULL PATIENT HISTORY VIEW--
CREATE OR ALTER VIEW [dbo].[Patient_Prescription_History]
AS
	SELECT pa.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email, m.name AS [Medication Name],
		d.description AS [Medication Doseage], md.startDate AS [Prescription Start Date], md.endDate AS [Prescription End Date], md.cancelledDate AS [Prescription Cancelled Date]
	FROM Patient pa
	INNER JOIN Person p ON pa.id = p.id
	INNER JOIN Contact c ON c.id = pa.contactId
	INNER JOIN Prescription pr ON pr.patientId = p.id
	INNER JOIN Medicine md ON md.prescriptionId = p.id
	INNER JOIN Drug m ON md.drugId = m.id
	INNER JOIN Dose d ON d.id = md.doseId
GO

--FULL PATIENT PROCEDURE HISTORY VIEW--
CREATE OR ALTER VIEW [dbo].[Patient_Procedure_History]
AS
	SELECT p.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email,
		prc.date AS [Procedure Date], prct.description AS [Procedure Type]
	FROM Patient pa
	INNER JOIN Person p ON pa.id = p.id
	INNER JOIN Contact c ON c.id = pa.contactId
	INNER JOIN [Procedure] prc ON prc.patientId = p.id
	INNER JOIN ProcedureType prct ON prct.id = prc.typeId;
GO

USE [master]
GO