USE MedicalHistory;
GO

--SEED CONTACT DETAILS--
insert into Contact(id, phone, email) values ('6B3C90AB-ECE5-4F28-83B2-0120989B92DA','0869862728', 'nchimes0@guardian.co.uk');
insert into Contact(id, phone, email) values ('EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65','0639945174', 'dbiggerstaff1@prweb.com');
insert into Contact(id, phone, email) values ('65B686F3-5F62-4273-978E-4185BB8BEFD2','0926739297', 'bbourbon2@nsw.gov.au');
insert into Contact(id, phone, email) values ('8963797D-E847-4675-B718-53662D6DADE3','0308388514', 'mbraunton3@umn.edu');
insert into Contact(id, phone, email) values ('9646D7A8-1939-4995-8368-6EE085A3A2D8','0565574911', 'rwilsee4@nydailynews.com');
insert into Contact(id, phone, email) values ('E89D40B8-9DAD-496E-AD90-855B33510C44','0623857870', 'rparadin5@about.com');
insert into Contact(id, phone, email) values ('359EA2F9-A4AE-46B4-9C76-BC695CC34987','0971234930', 'groose6@addtoany.com');
insert into Contact(id, phone, email) values ('4355E260-7FBD-4595-BF28-CAE8F2E7BD2B','0361640389', 'kskingley7@domainmarket.com');
insert into Contact(id, phone, email) values ('9188CC74-B23A-45B2-9AC0-CBED75817196','0069301287', 'hnorcott8@home.pl');
insert into Contact(id, phone, email) values ('FC190D94-A53F-40CC-81D2-E83FF0FBC8F0','0911426468', 'aharfoot9@fda.gov');

--SELECT * FROM Contact;
--GO

----ENSURE COLUMNS MATCH--
--SELECT p.id, p.name, p.surname, c.phone,c.email
--FROM Person P
--INNER JOIN Contact c ON c.id = p.id;
--GO

--SEED PATIENT DETAILS--
INSERT INTO Patient(id, contactId)
SELECT TOP 4 p.id, c.id FROM Person p 
INNER JOIN Contact c ON c.id = p.id;
GO

--SELECT * FROM PATIENT;
--GO

--SEED POFESSIONAL DETAILS--
INSERT INTO Professional(id, contactId)
SELECT p.id, c.id FROM Person p 
INNER JOIN Contact c ON c.id = p.id
WHERE p.id NOT IN (SELECT id FROM Patient);
GO

--SELECT * FROM Professional;
--GO

--SEED Medication--
INSERT Medication(name)
VALUES('Panado'),('Allergex'),('Prednisone');
GO

--SEED Dose--
INSERT DOSE(description)
VALUES ('1X A DAY'),('2X A DAY'),('3X A DAY');
GO

--SEED PROCEDURE TYPE--
INSERT ProcedureType(description)
VALUES('Check Up'),('Blood Test'),('X-Ray'), ('CAT Scan');
GO

--SEED Prescription--
INSERT Prescription (medicationId, doseId,patientId,professionalId,startdate,endate)
VALUES
((SELECT id FROM Medication m WHERE m.name='Allergex'),(SELECT d.id FROM Dose d WHERE d.description LIKE '%1X%'),
'6B3C90AB-ECE5-4F28-83B2-0120989B92DA','9646D7A8-1939-4995-8368-6EE085A3A2D8',CAST('02-12-2022' AS datetime),CAST('07-12-2022' AS datetime)),
((SELECT id FROM Medication m WHERE m.name='Panado'),(SELECT d.id FROM Dose d WHERE d.description LIKE '%1X%'),
'65B686F3-5F62-4273-978E-4185BB8BEFD2','359EA2F9-A4AE-46B4-9C76-BC695CC34987',CAST('06-01-2022' AS datetime),CAST('09-12-2022' AS datetime)),
((SELECT id FROM Medication m WHERE m.name='Prednisone'),(SELECT d.id FROM Dose d WHERE d.description LIKE '%1X%'),
'EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65','9188CC74-B23A-45B2-9AC0-CBED75817196',CAST('02-10-2022' AS datetime),CAST('03-01-2023' AS datetime));
GO

--SELECT * FROM Prescription;
--GO

--SEED PROCEDURE--
INSERT [Procedure](patientId,professionalId,typeid,[date])
VALUES
('6B3C90AB-ECE5-4F28-83B2-0120989B92DA','9646D7A8-1939-4995-8368-6EE085A3A2D8',(SELECT t.id FROM ProcedureType t WHERE t.description='X-RAY'),CAST('07-12-2022' AS datetime)),
('65B686F3-5F62-4273-978E-4185BB8BEFD2','359EA2F9-A4AE-46B4-9C76-BC695CC34987',(SELECT t.id FROM ProcedureType t WHERE t.description='CAT Scan'),CAST('09-12-2022' AS datetime)),
('EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65','9188CC74-B23A-45B2-9AC0-CBED75817196',(SELECT t.id FROM ProcedureType t WHERE t.description='Check Up'),CAST('03-01-2023' AS datetime));
GO

--SELECT * FROM [Procedure];
--GO