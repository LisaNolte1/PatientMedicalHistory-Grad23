USE [MedicalHistory];
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
INSERT INTO [dbo].[Prescription](medicationId, patientId, professionalId, startdate, endate, doseId)
VALUES(@medicationId, @patientId, @professionalId, @startdate, @endate, @doseId);
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

EXEC  uspGetPatientDetailsByID 'EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65';
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

UPDATE [dbo].Contact
SET phone = @phoneNo, email = @email
WHERE id = @patientid;
END
GO


--FULL PATIENT HISTORY VIEW--
CREATE OR ALTER VIEW [Patient_Prescription_History]
AS
SELECT pa.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email, m.name AS [Medication Name],
	   d.description AS [Medication Doseage], pr.startdate AS [Prescription Start Date], pr.endate AS [Prescription End Date], pr.cancelledDate AS [Prescription Cancelled Date]
FROM Patient pa
INNER JOIN dbo.Person p ON pa.id = p.id
LEFT JOIN Contact c ON c.id = pa.contactId
LEFT JOIN Prescription pr ON pr.patientId = p.id
LEFT JOIN Medication m ON pr.medicationId = m.id
LEFT JOIN Dose d ON d.id = pr.doseId
GO

SELECT * FROM [Patient_Prescription_History];
GO

--FULL PATIENT PROCEDURE HISTORY VIEW--
CREATE OR ALTER VIEW [Patient_Procedure_History]
AS
SELECT p.id AS PatientID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email,
	   prc.date AS [Procedure Date], prct.description AS [Procedure Type]
FROM Patient pa
INNER JOIN dbo.Person p ON pa.id = p.id
LEFT JOIN Contact c ON c.id = pa.contactId
LEFT JOIN [Procedure] prc ON prc.patientId = p.id
LEFT JOIN ProcedureType prct ON prct.id = prc.typeId;
GO

SELECT * FROM [Patient_Procedure_History];
GO

