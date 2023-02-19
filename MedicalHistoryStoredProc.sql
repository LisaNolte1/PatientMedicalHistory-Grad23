USE MedicalHistory;
GO


--INSERT NEW PRESCRIPTION--
CREATE PROCEDURE [dbo].[uspInsertNewPrescription]
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
CREATE PROCEDURE [dbo].[uspGetPatientDetailsByID]
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

EXEC uspGetPatientDetailsByID 'B551F2C8-8380-491B-A51F-436E51CDD08F';
GO

USE MedicalHistory;
GO

--FULL PATIENT HISTORY VIEW--
--Patient detials [id,name, surname,idnum,contact,prescriptions,procedure,doctor]--
CREATE VIEW [Full_Patient_History]
AS
SELECT p.id, p.name, p.surname, p.idNumber, c.phone, c.email, m.name AS Medication,
	   d.description AS Doseage, pr.startdate, pr.endate, pr.cancelledDate, prct.description AS PateintProcedure, prc.date AS ProcedureDate
FROM dbo.Person p
FULL OUTER JOIN Contact c ON c.id = p.id
FULL OUTER JOIN Prescription pr ON pr.patientId = p.id
FULL OUTER JOIN Medication m ON pr.medicationId = m.id
FULL OUTER JOIN Dose d ON d.id =pr.doseId
FULL OUTER JOIN PatientProcedure prc ON prc.patientId = p.id
FULL OUTER JOIN ProcedureType prct ON prct.id = prc.typeId;
GO

SELECT * FROM [Full_Patient_History];
GO
