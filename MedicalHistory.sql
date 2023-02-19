USE [master]
GO

/*
DROP DATABASE IF EXISTS [MedicalHistory]
GO
*/

CREATE DATABASE [MedicalHistory]
GO

USE [MedicalHistory]
GO

/* So that Database Diagrams works in SSMS */
EXEC sp_changedbowner 'sa'
GO

CREATE TABLE [dbo].[Person](
	[id] [uniqueidentifier] PRIMARY KEY DEFAULT (newid()),
	[idNumber] [varchar](13) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[surname] [nvarchar](255) NOT NULL,
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
	[medicationId] [uniqueidentifier] NOT NULL,
	[doseId] [uniqueidentifier] NOT NULL,
	[patientId] [uniqueidentifier] NOT NULL,
	[professionalId] [uniqueidentifier] NOT NULL,
	[startdate] [datetime] NOT NULL,
	[endate] [datetime] NOT NULL,
	[cancelledDate] [datetime] NULL,
	CONSTRAINT [FK_Prescription_Dose] FOREIGN KEY([doseId]) REFERENCES [Dose]([id]),
	CONSTRAINT [FK_Prescription_Medication] FOREIGN KEY([medicationId]) REFERENCES [Medication]([id]),
	CONSTRAINT [FK_Prescription_Patient] FOREIGN KEY([patientId]) REFERENCES [Patient]([id]),
	CONSTRAINT [FK_Prescription_Professional] FOREIGN KEY([professionalId]) REFERENCES [Professional]([id]),
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
)
GO

USE [master]
GO

