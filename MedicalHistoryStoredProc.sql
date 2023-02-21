USE [MedicalHistory];
GO

--INSERT NEW PRESCRIPTION--
CREATE OR ALTER PROCEDURE [dbo].[uspInsertNewPrescription]
@medicationId uniqueidentifier,
@patientId uniqueidentifier,
@professionalId uniqueidentifier,
@startdate date,
@endate date,
@cancelledDate datetime,
@doseId uniqueidentifier
AS
INSERT INTO [dbo].[Prescription](medicationId, patientId, professionalId, startdate, endate, cancelledDate, doseId)
VALUES(@medicationId, @patientId, @professionalId, @startdate, @endate, @cancelledDate, @doseId);
GO

--SELECT PATIENT DETAILS--
CREATE OR ALTER PROCEDURE [dbo].[uspGetPatientDetailsByID]
@patientId uniqueidentifier
AS
BEGIN
SELECT p.id, pr.name, pr.surname, c.phone, c.email
FROM Patient p
INNER JOIN Person pr ON pr.id = p.id
INNER JOIN Contact c ON c.id = p.contactId
WHERE p.id = @patientId;
END
GO

--FULL PATIENT HISTORY VIEW--
CREATE OR ALTER VIEW [Patient_Prescription_History]
AS
SELECT p.id AS PersonID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email, m.name AS [Medication Name],
	   d.description AS [Medication Doseage], pr.startdate AS [Prescription Start Date], pr.endate AS [Prescription End Date], pr.cancelledDate AS [Prescription Cancelled Date]
FROM Person p
LEFT JOIN dbo.Patient pa ON pa.id = p.id
LEFT JOIN Contact c ON c.id = pa.contactId
LEFT JOIN Prescription pr ON pr.patientId = p.id
LEFT JOIN Medication m ON pr.medicationId = m.id
LEFT JOIN Dose d ON d.id = pr.doseId
GO

SELECT * FROM [Patient_Prescription_History];
GO

CREATE OR ALTER VIEW [Patient_Procedure_History]
AS
SELECT p.id AS PersonID, p.name AS Name, p.surname as Surname, p.idNumber AS IDNumber, c.phone AS PhoneNumber, c.email AS Email, prc.date AS [Procedure Date], prct.description AS [Procedure Type]
FROM Person p
LEFT JOIN dbo.Patient pa ON pa.id = p.id
LEFT JOIN Contact c ON c.id = pa.contactId
LEFT JOIN [Procedure] prc ON prc.patientId = p.id
LEFT JOIN ProcedureType prct ON prct.id = prc.typeId;
GO

SELECT * FROM [Patient_Procedure_History];
GO
