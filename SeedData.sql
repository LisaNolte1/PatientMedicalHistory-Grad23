USE MedicalHistory;
GO

--SEED PERSON DETAILS
INSERT INTO Person(id, idNumber, name, surname)
VALUES
('fa1f3fd8-737e-428b-a0e9-c74a98a007df','7506200000189','Jane','Chimes'),
('13001006-7ec9-42ac-ba8f-4fc9ca40ebb0','8701110000184','Jane','Doe'),
('c4f1ea98-62bc-49eb-a233-191052fa481d','8901030000187','Jane','Doe'),
('237dbc51-6140-4909-adff-799e16461f52','0105020000185','Jane','Doe'),
('78e38eee-c61d-476a-8f1b-34227659ef2a','0808290000187','Jane','Doe'),
('b23613d3-e17b-46e4-9c4e-15708320c58e','7601220000184','Jane','Doe'),
('35a58b89-30d2-4a15-822a-62716fe101cb','7711170000181','Jane','Doe'),
('ff443614-2a18-4218-8e51-4140f632bec2','2608080000183','Jane','Doe'),
('94641e75-74f7-4ac3-bb87-8d7f85fb91b1','8105080000184','Jane','Doe'),
('cae5a6c2-a5c2-46ba-becd-2bddaa653724','1703040000182','Jane','Doe');
GO

--SELECT * FROM Person
--GO

--SEED CONTACT DETAILS--
INSERT INTO Contact(id, phone, email) 
VALUES 
('6B3C90AB-ECE5-4F28-83B2-0120989B92DA','0869862728', 'nchimes0@guardian.co.uk'),
('EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65','0639945174', 'dbiggerstaff1@prweb.com'),
('65B686F3-5F62-4273-978E-4185BB8BEFD2','0926739297', 'bbourbon2@nsw.gov.au'),
('8963797D-E847-4675-B718-53662D6DADE3','0308388514', 'mbraunton3@umn.edu'),
('9646D7A8-1939-4995-8368-6EE085A3A2D8','0565574911', 'rwilsee4@nydailynews.com'),
('E89D40B8-9DAD-496E-AD90-855B33510C44','0623857870', 'rparadin5@about.com'),
('359EA2F9-A4AE-46B4-9C76-BC695CC34987','0971234930', 'groose6@addtoany.com'),
('4355E260-7FBD-4595-BF28-CAE8F2E7BD2B','0361640389', 'kskingley7@domainmarket.com'),
('9188CC74-B23A-45B2-9AC0-CBED75817196','0069301287', 'hnorcott8@home.pl'),
('FC190D94-A53F-40CC-81D2-E83FF0FBC8F0','0911426468', 'aharfoot9@fda.gov')
GO

--SELECT * FROM Contact;
--GO

----ENSURE COLUMNS MATCH--
--SELECT p.id, p.name, p.surname, c.phone,c.email
--FROM Person P
--INNER JOIN Contact c ON c.id = p.id;
--GO

--SEED PATIENT DETAILS--
INSERT INTO Patient(id, contactId)
VALUES
('fa1f3fd8-737e-428b-a0e9-c74a98a007df','6B3C90AB-ECE5-4F28-83B2-0120989B92DA'),
('13001006-7ec9-42ac-ba8f-4fc9ca40ebb0','EB42BD4C-CF4E-4971-9E9D-13E0B8CBEC65'),
('c4f1ea98-62bc-49eb-a233-191052fa481d','65B686F3-5F62-4273-978E-4185BB8BEFD2'),
('237dbc51-6140-4909-adff-799e16461f52','8963797D-E847-4675-B718-53662D6DADE3'),
('78e38eee-c61d-476a-8f1b-34227659ef2a','9646D7A8-1939-4995-8368-6EE085A3A2D8'),
('b23613d3-e17b-46e4-9c4e-15708320c58e','E89D40B8-9DAD-496E-AD90-855B33510C44'),
('35a58b89-30d2-4a15-822a-62716fe101cb','359EA2F9-A4AE-46B4-9C76-BC695CC34987'),
('ff443614-2a18-4218-8e51-4140f632bec2','4355E260-7FBD-4595-BF28-CAE8F2E7BD2B'),
('94641e75-74f7-4ac3-bb87-8d7f85fb91b1','9188CC74-B23A-45B2-9AC0-CBED75817196'),
('cae5a6c2-a5c2-46ba-becd-2bddaa653724','FC190D94-A53F-40CC-81D2-E83FF0FBC8F0')

GO

--SELECT * FROM PATIENT;
--GO

--SEED PROFESSIONAL DETAILS--
INSERT INTO Professional(id, contactId)
VALUES
('ff443614-2a18-4218-8e51-4140f632bec2','4355E260-7FBD-4595-BF28-CAE8F2E7BD2B'),
('94641e75-74f7-4ac3-bb87-8d7f85fb91b1','9188CC74-B23A-45B2-9AC0-CBED75817196'),
('cae5a6c2-a5c2-46ba-becd-2bddaa653724','FC190D94-A53F-40CC-81D2-E83FF0FBC8F0')
GO

--SELECT * FROM Professional;
--GO

--SEED Medication--
INSERT Medication(id, name)
VALUES
('73e65e87-6f83-43e9-9de8-5312e251c28c', 'Allergex'),
('b2d9c44a-af32-42ed-bced-661e94d0848d', 'Prednisone'),
('040d4ae9-d6b4-48de-8f1a-89234d62ce29', 'Panado');
GO

--SEED Dose--
INSERT [dbo].[Dose] ([id], [description]) VALUES ('eee374e0-8f3b-4e34-b8b1-09263365b6b7', '2X A DAY')
INSERT [dbo].[Dose] ([id], [description]) VALUES ('fc5a7dbe-dd86-4187-8fef-12d5b09784d3', '1X A DAY')
INSERT [dbo].[Dose] ([id], [description]) VALUES ('eb87c2b9-b0bc-46c8-a066-41f815eec939', '3X A DAY')


--SEED PROCEDURE TYPE--
INSERT [dbo].[ProcedureType] ([id], [description]) 
VALUES (N'faf86416-a34b-48ec-a070-67faf6bd5691', N'X-Ray')
GO
INSERT [dbo].[ProcedureType] ([id], [description]) VALUES (N'92fa5a6e-385d-4aa3-b0a2-8791e59d8d3f', N'Blood Test')
GO
INSERT [dbo].[ProcedureType] ([id], [description]) VALUES (N'fcbf1757-9410-4a29-a3d9-8bb8580e310f', N'CAT Scan')
GO
INSERT [dbo].[ProcedureType] ([id], [description]) VALUES (N'04102b99-b0a8-4201-8dbe-c1c1df116e6c', N'Check Up')
GO


--SEED Prescription--
USE [MedicalHistory]
GO
INSERT [dbo].[Prescription] ([id], [medicationId], [doseId], [patientId], [professionalId], [startdate], [endate], [cancelledDate]) VALUES (N'17198429-f2c8-4c81-a003-231bb0e1fa13', N'b2d9c44a-af32-42ed-bced-661e94d0848d', N'fc5a7dbe-dd86-4187-8fef-12d5b09784d3', N'ff443614-2a18-4218-8e51-4140f632bec2', N'ff443614-2a18-4218-8e51-4140f632bec2', CAST(N'2022-02-10T00:00:00.000' AS DateTime), CAST(N'2023-03-01T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Prescription] ([id], [medicationId], [doseId], [patientId], [professionalId], [startdate], [endate], [cancelledDate]) VALUES (N'f195d261-18a7-4f13-8e6f-7543bcefe278', N'73e65e87-6f83-43e9-9de8-5312e251c28c', N'fc5a7dbe-dd86-4187-8fef-12d5b09784d3', N'fa1f3fd8-737e-428b-a0e9-c74a98a007df', N'ff443614-2a18-4218-8e51-4140f632bec2', CAST(N'2022-02-12T00:00:00.000' AS DateTime), CAST(N'2022-07-12T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Prescription] ([id], [medicationId], [doseId], [patientId], [professionalId], [startdate], [endate], [cancelledDate]) VALUES (N'6caa1475-60f2-4438-9237-8c52105605e9', N'040d4ae9-d6b4-48de-8f1a-89234d62ce29', N'fc5a7dbe-dd86-4187-8fef-12d5b09784d3', N'13001006-7ec9-42ac-ba8f-4fc9ca40ebb0', N'ff443614-2a18-4218-8e51-4140f632bec2', CAST(N'2022-06-01T00:00:00.000' AS DateTime), CAST(N'2022-09-12T00:00:00.000' AS DateTime), NULL)
GO


--SELECT * FROM Prescription;
--GO

--SEED PROCEDURE--
USE [MedicalHistory]
GO
INSERT [dbo].[Procedure] ([id], [patientId], [professionalId], [typeId], [date]) VALUES (N'75250882-e0a2-4bac-9cf1-40a18ffa11fd', N'78e38eee-c61d-476a-8f1b-34227659ef2a', N'94641e75-74f7-4ac3-bb87-8d7f85fb91b1', N'04102b99-b0a8-4201-8dbe-c1c1df116e6c', CAST(N'2023-03-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Procedure] ([id], [patientId], [professionalId], [typeId], [date]) VALUES (N'3a832fe4-3f58-4797-a6df-6e7f24cf1577', N'c4f1ea98-62bc-49eb-a233-191052fa481d', N'94641e75-74f7-4ac3-bb87-8d7f85fb91b1', N'faf86416-a34b-48ec-a070-67faf6bd5691', CAST(N'2022-07-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Procedure] ([id], [patientId], [professionalId], [typeId], [date]) VALUES (N'3f9e86f6-769d-4c73-8105-a7f6b4ba46fe', N'237dbc51-6140-4909-adff-799e16461f52', N'94641e75-74f7-4ac3-bb87-8d7f85fb91b1', N'fcbf1757-9410-4a29-a3d9-8bb8580e310f', CAST(N'2022-09-12T00:00:00.000' AS DateTime))
GO


--SELECT * FROM [Procedure];
--GO