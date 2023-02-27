USE MedicalHistory;
GO

-- Seed Person
INSERT INTO Person(idNumber, name, surname)
VALUES
('7506200000189', 'Jane', 'Chimes'),
('8701110000184', 'Jane', 'Doe'),
('8901030000187', 'Jane', 'Doe'),
('0105020000185', 'Jane', 'Doe'),
('0808290000187', 'Jane', 'Doe'),
('7601220000184', 'Jane', 'Doe'),
('7711170000181', 'Jane', 'Doe'),
('2608080000183', 'Jane', 'Doe'),
('8105080000184', 'Jane', 'Doe'),
('1703040000182', 'Jane', 'Doe');
GO

-- Seed Contact
INSERT INTO Contact(phone, email) 
VALUES 
('0869862728', 'jane01@test.co.za'),
('0639945174', 'jane02@test.co.za'),
('0926739297', 'jane03@test.co.za'),
('0308388514', 'jane04@test.co.za'),
('0565574911', 'jane05@test.co.za'),
('0623857870', 'jane06@test.co.za'),
('0971234930', 'jane07@test.co.za'),
('0361640389', 'jane08@test.co.za'),
('0069301287', 'jane09@test.co.za'),
('0911426468', 'jane10@test.co.za')
GO

-- Seed Patient
INSERT INTO Patient(id, contactId)
VALUES
( 1,  1),
( 2,  2),
( 3,  3),
( 4,  4),
( 5,  5),
( 6,  6),
( 7,  7),
( 8,  8),
( 9,  9),
(10, 10)

GO

-- Seed Professional
INSERT INTO Professional(id, contactId)
VALUES
( 8,  8),
( 9,  9),
(10, 10)
GO

-- Seed Drug
INSERT INTO Drug([code], [name], [description])
VALUES
('ALLR', 'Allergex',   'For alergies'),
('PRED', 'Prednisone', 'For when someone is prednant'),
('PANA', 'Panado',     'For pandas');
GO

-- Seed Dose
INSERT [dbo].[Dose] ([code], [description])
VALUES
('1X1D', '1X A DAY'),
('2X1D', '2X A DAY'),
('3X1D', '3X A DAY')

-- Seed ProcedureType
INSERT [dbo].[ProcedureType] ([code], [description]) 
VALUES
('XRAY',  'X-Ray'),
('BLOOD', 'Blood Test'),
('CAT',   'CAT Scan'),
('CHCK',  'Check Up')
GO

-- Seed Prescription
INSERT [dbo].[Prescription] ([patientId], [professionalId]) VALUES 
(1,  8),
(2,  9),
(10, 10)
GO

-- Seed Medicine
INSERT [dbo].[Medicine] ([prescriptionId], [drugId], [doseId], [startDate], [endDate]) VALUES
(1, 1, 1, GETDATE(), GETDATE() + 500),
(2, 2, 2, GETDATE(), GETDATE() + 500),
(3, 1, 3, GETDATE(), GETDATE() + 500),
(3, 2, 3, GETDATE(), GETDATE() + 500),
(3, 3, 3, GETDATE(), GETDATE() + 500)
GO

-- Seed Procedure
INSERT [dbo].[Procedure] ([patientId], [professionalId], [typeId], [date]) VALUES 
( 1,  8, 1, GETDATE()),
( 2,  9, 2, GETDATE()),
(10, 10, 1, GETDATE()),
(10, 10, 2, GETDATE()),
(10, 10, 3, GETDATE())
GO

USE [master]
GO
